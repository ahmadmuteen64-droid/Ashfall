// AshFall — Voxel Lab: cellular simulation core.
// A 3D grid of cells. Each cell = material index into DB.materials (-1 = air) + temperature + burn timer.
// Tick pipeline: heat diffusion → fire → phase changes → reactions → movement (gravity / flow / rise).

const AIR = -1;
const AIR_CONDUCTIVITY = 0.015;  // how well air couples heat to solids (low: air is a poor conductor)
const DIFFUSION_RATE = 0.12;     // per-neighbor transfer factor (6 × max avg 1.0 × 0.12 < 1 → stable)
const RADIATIVE_PULL = 0.002;    // slow drift of every cell toward ambient
const BURN_TEMP = 750;           // temperature a burning cell is held at
const MAX_N = 24;

class VoxelSim {
  constructor(n = 16) {
    this.n = n;
    const cap = n * n * n;
    this.mat = new Int16Array(cap).fill(AIR);
    this.temp = new Float32Array(cap);
    this.burn = new Uint16Array(cap);
    this._tempNext = new Float32Array(cap);
    this._flag = new Uint8Array(cap);      // per-tick "already transformed/moved" marker
    this.ambient = 20;
    this.tickCount = 0;
    this.temp.fill(this.ambient);
  }

  idx(x, y, z) { return (y * this.n + z) * this.n + x; }
  inBounds(x, y, z) { return x >= 0 && y >= 0 && z >= 0 && x < this.n && y < this.n && z < this.n; }

  get(x, y, z) { return this.inBounds(x, y, z) ? this.mat[this.idx(x, y, z)] : AIR; }

  setCell(x, y, z, matId) {
    if (!this.inBounds(x, y, z)) return;
    const i = this.idx(x, y, z);
    if (matId === '' || matId == null) {
      this.mat[i] = AIR; this.temp[i] = this.ambient; this.burn[i] = 0;
      return;
    }
    const mi = DB.indexOf(matId);
    if (mi < 0) return;
    this.mat[i] = mi;
    this.temp[i] = DB.materials[mi].defaultTemp;
    this.burn[i] = 0;
  }

  clear() {
    this.mat.fill(AIR);
    this.temp.fill(this.ambient);
    this.burn.fill(0);
    this.tickCount = 0;
  }

  resetTemps() {
    for (let i = 0; i < this.mat.length; i++) {
      this.temp[i] = this.mat[i] === AIR ? this.ambient : DB.materials[this.mat[i]].defaultTemp;
      this.burn[i] = 0;
    }
  }

  // Wipe cells whose material was deleted from the DB
  purgeMaterialIndex(mi) {
    for (let i = 0; i < this.mat.length; i++) {
      if (this.mat[i] === mi) { this.mat[i] = AIR; this.temp[i] = this.ambient; this.burn[i] = 0; }
    }
  }

  cellInfo(x, y, z) {
    if (!this.inBounds(x, y, z)) return null;
    const i = this.idx(x, y, z);
    const mi = this.mat[i];
    if (mi === AIR) return { x, y, z, air: true, temp: this.ambient };
    const m = DB.materials[mi];
    return { x, y, z, air: false, mat: m, temp: this.temp[i], phase: getPhaseAt(m, this.temp[i]), burning: this.burn[i] > 0 };
  }

  // ── The heartbeat ─────────────────────────────────────────────
  tick() {
    const n = this.n, mat = this.mat, temp = this.temp, burn = this.burn;
    const M = DB.materials, amb = this.ambient;
    const next = this._tempNext, flag = this._flag;
    flag.fill(0);

    // Burning cells radiate: hold them at combustion temperature before diffusing.
    for (let i = 0; i < mat.length; i++) {
      if (burn[i] > 0 && temp[i] < BURN_TEMP) temp[i] = BURN_TEMP;
    }

    // 1. Heat diffusion (6-neighborhood, pair conductivity = geometric mean so bedrock truly insulates)
    for (let y = 0; y < n; y++) for (let z = 0; z < n; z++) for (let x = 0; x < n; x++) {
      const i = this.idx(x, y, z);
      const mi = mat[i];
      if (mi === AIR) { next[i] = amb; continue; }   // open air is an infinite ambient reservoir
      const m = M[mi];
      const t0 = temp[i];
      let dt = 0;
      for (let d = 0; d < 6; d++) {
        const nx = x + DX[d], ny = y + DY[d], nz = z + DZ[d];
        let ct, tt;
        if (!this.inBounds(nx, ny, nz)) { ct = AIR_CONDUCTIVITY; tt = amb; }
        else {
          const j = this.idx(nx, ny, nz);
          if (mat[j] === AIR) { ct = AIR_CONDUCTIVITY; tt = amb; }
          else { ct = M[mat[j]].conductivity; tt = temp[j]; }
        }
        dt += Math.sqrt(m.conductivity * ct) * DIFFUSION_RATE * (tt - t0);
      }
      dt += (amb - t0) * RADIATIVE_PULL;
      // Thermal inertia: dense materials (lava, stone) change temperature slowly
      const inertia = Math.min(Math.max(m.density, 1), 4);
      next[i] = t0 + dt / inertia;
    }
    this._tempNext = this.temp; this.temp = next;
    const T = this.temp;

    // 2. Fire: ignition, spread, extinguishing, burnout
    for (let y = 0; y < n; y++) for (let z = 0; z < n; z++) for (let x = 0; x < n; x++) {
      const i = this.idx(x, y, z);
      const mi = mat[i];
      if (mi === AIR) continue;
      const m = M[mi];

      if (burn[i] === 0 && m.flammable) {
        let neighborFire = false;
        for (let d = 0; d < 6; d++) {
          const j = this.neighborIdx(x, y, z, d);
          if (j >= 0 && burn[j] > 0) { neighborFire = true; break; }
        }
        if (T[i] >= m.ignition || (neighborFire && Math.random() < 0.12)) burn[i] = 1;
      }

      if (burn[i] > 0) {
        // Adjacent water quenches the fire (and gets a heat kick toward boiling)
        let quenched = false;
        for (let d = 0; d < 6; d++) {
          const j = this.neighborIdx(x, y, z, d);
          if (j >= 0 && mat[j] !== AIR && M[mat[j]].id === 'water') {
            quenched = true;
            T[j] = Math.max(T[j], 90);
            break;
          }
        }
        if (quenched) {
          burn[i] = 0;
          T[i] = Math.min(T[i], 100);
        } else {
          burn[i]++;
          if (burn[i] > m.burnLife) {
            const ri = m.burnResult ? DB.indexOf(m.burnResult) : AIR;
            mat[i] = ri >= 0 ? ri : AIR;
            burn[i] = 0;
            T[i] = mat[i] === AIR ? amb : 400;   // embers stay warm
          }
        }
      }
    }

    // 3. Reactions (contact + heat) — run BEFORE phase changes so authored
    // reactions win the race (water touching lava quenches; it doesn't just boil away).
    for (const r of DB.reactions) {
      const ai = DB.indexOf(r.a);
      if (ai < 0) continue;
      const ra = r.resultA ? DB.indexOf(r.resultA) : AIR;
      const chance = r.chance ?? 1;
      if (r.kind === 'heat') {
        const minT = r.minTemp ?? 0;
        for (let i = 0; i < mat.length; i++) {
          if (mat[i] === ai && !flag[i] && T[i] >= minT) {
            if (chance < 1 && Math.random() > chance) continue;
            mat[i] = ra; burn[i] = 0; flag[i] = 1;
            if (ra === AIR) T[i] = amb;
          }
        }
      } else { // contact
        const bi = DB.indexOf(r.b);
        if (bi < 0) continue;
        const rb = r.resultB ? DB.indexOf(r.resultB) : AIR;
        for (let y = 0; y < n; y++) for (let z = 0; z < n; z++) for (let x = 0; x < n; x++) {
          const i = this.idx(x, y, z);
          if (mat[i] !== ai || flag[i]) continue;
          for (let d = 0; d < 6; d++) {
            const j = this.neighborIdx(x, y, z, d);
            if (j < 0 || mat[j] !== bi || flag[j]) continue;
            if (r.minTemp != null && Math.max(T[i], T[j]) < r.minTemp) continue;
            if (chance < 1 && Math.random() > chance) break;   // failed the roll this tick
            const tMix = (T[i] + T[j]) / 2;
            // Only touch cells whose material actually changes — an unchanged catalyst
            // (e.g. lava melting sand into glass) keeps its own temperature and mobility.
            if (ra !== ai) { mat[i] = ra; flag[i] = 1; burn[i] = 0; T[i] = ra === AIR ? amb : tMix; }
            if (rb !== bi) { mat[j] = rb; flag[j] = 1; burn[j] = 0; T[j] = rb === AIR ? amb : tMix; }
            break;
          }
        }
      }
    }

    // 4. Phase transitions (melt / boil / freeze / condense)
    for (let i = 0; i < mat.length; i++) {
      const mi = mat[i];
      if (mi === AIR || flag[i]) continue;
      const m = M[mi];
      const p = getPhaseAt(m, T[i]);
      if (p === m.phase) continue;
      const targetId = transitionTargetId(m, p);
      if (!targetId) continue;
      const ti = DB.indexOf(targetId);
      if (ti < 0) continue;
      mat[i] = ti;
      burn[i] = 0;
      flag[i] = 1;
    }

    // 5a. Falling: granular solids drop & pile, liquids drop / sink by density / spread
    for (let y = 1; y < n; y++) for (let z = 0; z < n; z++) for (let x = 0; x < n; x++) {
      const i = this.idx(x, y, z);
      const mi = mat[i];
      if (mi === AIR || flag[i]) continue;
      const m = M[mi];
      const isLiquid = m.phase === PhaseState.LIQUID;
      if (!isLiquid && !m.granular) continue;

      const below = this.idx(x, y - 1, z);
      if (mat[below] === AIR) { this.moveCell(i, below); continue; }

      if (isLiquid) {
        // Denser liquid sinks through a lighter one (lava under water)
        const bm = M[mat[below]];
        if (bm.phase === PhaseState.LIQUID && !flag[below] && m.density > bm.density + 0.05) {
          this.swapCells(i, below);
          continue;
        }
        // Sideways flow — only toward a drop (over an edge) or to level out when
        // stacked on more liquid. A single-layer puddle holds its ground.
        const stacked = bm.phase === PhaseState.LIQUID;
        const dirs = shuffledHorizontal();
        for (const d of dirs) {
          const nx = x + DX[d], nz = z + DZ[d];
          if (!this.inBounds(nx, y, nz)) continue;
          const j = this.idx(nx, y, nz);
          if (mat[j] !== AIR) continue;
          const destBelowAir = y > 0 && mat[this.idx(nx, y - 1, nz)] === AIR;
          if (destBelowAir && Math.random() < 0.8) { this.moveCell(i, j); break; }
          if (!destBelowAir && stacked && Math.random() < 0.5) { this.moveCell(i, j); break; }
        }
      } else {
        // Granular: slide down diagonal slopes
        const dirs = shuffledHorizontal();
        for (const d of dirs) {
          const nx = x + DX[d], nz = z + DZ[d];
          if (!this.inBounds(nx, y - 1, nz)) continue;
          const side = this.idx(nx, y, nz);
          const diag = this.idx(nx, y - 1, nz);
          if (mat[side] === AIR && mat[diag] === AIR) { this.moveCell(i, diag); break; }
        }
      }
    }

    // 5b. Rising: gases float up and drift
    for (let y = n - 2; y >= 0; y--) for (let z = 0; z < n; z++) for (let x = 0; x < n; x++) {
      const i = this.idx(x, y, z);
      const mi = mat[i];
      if (mi === AIR || flag[i]) continue;
      if (M[mi].phase !== PhaseState.GAS) continue;

      const above = this.idx(x, y + 1, z);
      if (mat[above] === AIR && Math.random() < 0.85) { this.moveCell(i, above); continue; }
      if (Math.random() < 0.3) {
        const dirs = shuffledHorizontal();
        for (const d of dirs) {
          const nx = x + DX[d], nz = z + DZ[d];
          if (!this.inBounds(nx, y, nz)) continue;
          const j = this.idx(nx, y, nz);
          if (mat[j] === AIR) { this.moveCell(i, j); break; }
        }
      }
    }

    this.tickCount++;
  }

  neighborIdx(x, y, z, d) {
    const nx = x + DX[d], ny = y + DY[d], nz = z + DZ[d];
    return this.inBounds(nx, ny, nz) ? this.idx(nx, ny, nz) : -1;
  }

  // Heat/freeze gun: direct thermal injection into a cell (no effect on open air —
  // air is pinned to ambient).
  addHeat(x, y, z, delta) {
    if (!this.inBounds(x, y, z)) return;
    const i = this.idx(x, y, z);
    if (this.mat[i] === AIR) return;
    this.temp[i] = Math.max(-273, this.temp[i] + delta);
  }

  // Electric gun: lightning strike. Full power at the struck cell, then arcs outward
  // through electrically conductive materials (elecCond) with attenuation per step.
  // Returns the list of affected cells for the renderer's flash effect.
  zap(x, y, z, power = 1500) {
    const affected = [];
    if (!this.inBounds(x, y, z) || this.get(x, y, z) === AIR) return affected;
    const M = DB.materials;
    const si = this.idx(x, y, z);
    this.temp[si] = Math.max(-273, this.temp[si] + power);
    affected.push({ x, y, z });
    const seen = new Set([si]);
    let frontier = [[x, y, z]];
    let atten = 1;
    while (frontier.length && affected.length < 600) {
      atten *= 0.75;
      if (power * atten < 40) break;
      const next = [];
      for (const [cx, cy, cz] of frontier) {
        for (let d = 0; d < 6; d++) {
          const nx = cx + DX[d], ny = cy + DY[d], nz = cz + DZ[d];
          if (!this.inBounds(nx, ny, nz)) continue;
          const j = this.idx(nx, ny, nz);
          if (seen.has(j)) continue;
          seen.add(j);
          if (this.mat[j] === AIR) continue;
          const ec = M[this.mat[j]].elecCond ?? 0;
          if (ec < 0.15) continue;   // insulators stop the arc
          this.temp[j] = Math.max(-273, this.temp[j] + power * atten * ec);
          affected.push({ x: nx, y: ny, z: nz });
          next.push([nx, ny, nz]);
        }
      }
      frontier = next;
    }
    return affected;
  }

  moveCell(i, j) {
    this.mat[j] = this.mat[i]; this.temp[j] = this.temp[i]; this.burn[j] = this.burn[i];
    this.mat[i] = AIR; this.temp[i] = this.ambient; this.burn[i] = 0;
    this._flag[j] = 1;
  }

  swapCells(i, j) {
    const m = this.mat[i], t = this.temp[i], b = this.burn[i];
    this.mat[i] = this.mat[j]; this.temp[i] = this.temp[j]; this.burn[i] = this.burn[j];
    this.mat[j] = m; this.temp[j] = t; this.burn[j] = b;
    this._flag[i] = 1; this._flag[j] = 1;
  }
}

// 6-neighborhood: ±x, ±z, ±y
const DX = [1, -1, 0, 0, 0, 0];
const DY = [0, 0, 1, -1, 0, 0];
const DZ = [0, 0, 0, 0, 1, -1];
const HORIZ_DIRS = [0, 1, 4, 5];

function shuffledHorizontal() {
  const a = HORIZ_DIRS.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = (Math.random() * (i + 1)) | 0;
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

// ── Demo scene: one of everything interacting ─────────────────
function buildDemoScene(sim) {
  sim.clear();
  const n = sim.n;
  const S = (x, y, z, id) => sim.setCell(x, y, z, id);

  // Stone floor
  for (let x = 0; x < n; x++) for (let z = 0; z < n; z++) S(x, 0, z, 'stone');

  // Water basin (walls + water) with a dirt column inside → mud reaction
  for (let x = 1; x <= 6; x++) for (let z = 10; z <= 14; z++) {
    const wall = (x === 1 || x === 6 || z === 10 || z === 14);
    if (wall) { S(x, 1, z, 'stone'); S(x, 2, z, 'stone'); }
  }
  for (let x = 2; x <= 5; x++) for (let z = 11; z <= 13; z++) { S(x, 1, z, 'water'); S(x, 2, z, 'water'); }
  S(2, 1, 11, 'dirt'); S(2, 2, 11, 'dirt');

  // Lava basin
  for (let x = 9; x <= 14; x++) for (let z = 9; z <= 14; z++) {
    const wall = (x === 9 || x === 14 || z === 9 || z === 14);
    if (wall) { S(x, 1, z, 'stone'); S(x, 2, z, 'stone'); }
  }
  for (let x = 10; x <= 13; x++) for (let z = 10; z <= 13; z++) { S(x, 1, z, 'lava'); S(x, 2, z, 'lava'); }

  // Ice block — melts at ambient, meltwater flows toward the dirt
  for (let x = 2; x <= 4; x++) for (let y = 1; y <= 3; y++) for (let z = 2; z <= 4; z++) S(x, y, z, 'ice');

  // Tree + wooden fuse leading to a spilled lava blob → fire spread demo
  S(12, 1, 3, 'wood'); S(12, 2, 3, 'wood'); S(12, 3, 3, 'wood');
  for (let x = 11; x <= 13; x++) for (let z = 2; z <= 4; z++) { S(x, 4, z, 'leaves'); S(x, 5, z, 'leaves'); }
  S(12, 4, 3, 'wood');
  S(12, 1, 4, 'wood'); S(12, 1, 5, 'wood');
  // 2×2×2 lava blob — holds enough heat to ignite the fuse before crusting over.
  // Extra cell at (13,1,5) gives the fuse tip lava contact on two faces → guaranteed ignition.
  for (let x = 11; x <= 12; x++) for (let y = 1; y <= 2; y++) for (let z = 6; z <= 7; z++) S(x, y, z, 'lava');
  S(13, 1, 5, 'lava');

  // Ice ledge floating above the lava pool — melts, drips, quenches into steam
  for (let x = 11; x <= 12; x++) for (let z = 11; z <= 12; z++) S(x, 6, z, 'ice');

  // Floating sand — falls and piles on tick 1
  for (let x = 6; x <= 8; x++) for (let z = 5; z <= 7; z++) { S(x, 8, z, 'sand'); S(x, 9, z, 'sand'); }

  // Snow drift in a corner
  for (let x = 14; x <= 15; x++) for (let z = 1; z <= 2; z++) S(x, 1, z, 'snow');
}
