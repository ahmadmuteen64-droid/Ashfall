// AshFall — Voxel Lab: Three.js instanced voxel renderer + DDA voxel picking.
// World mapping: cell (x,y,z) → world (x - n/2 + 0.5, y + 0.5, z - n/2 + 0.5). Ground plane at y=0.

class VoxelView {
  constructor(canvas, sim) {
    this.canvas = canvas;
    this.sim = sim;
    this.clipY = sim.n - 1;

    this.renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0x0d1117);
    this.scene.fog = new THREE.Fog(0x0d1117, 60, 140);

    this.camera = new THREE.PerspectiveCamera(50, 1, 0.1, 500);
    this.camera.position.set(sim.n * 1.15, sim.n * 1.0, sim.n * 1.35);

    this.controls = new THREE.OrbitControls(this.camera, canvas);
    this.controls.target.set(0, sim.n * 0.28, 0);
    this.controls.enableDamping = true;
    this.controls.dampingFactor = 0.08;
    this.controls.maxPolarAngle = Math.PI * 0.52;
    this.controls.minDistance = 6;
    this.controls.maxDistance = 120;
    // LEFT is reserved for painting; orbit with RIGHT drag, pan with MIDDLE.
    this.controls.mouseButtons = { LEFT: -1, MIDDLE: THREE.MOUSE.PAN, RIGHT: THREE.MOUSE.ROTATE };

    const hemi = new THREE.HemisphereLight(0xbfd4ff, 0x3a2f28, 0.75);
    this.scene.add(hemi);
    const sun = new THREE.DirectionalLight(0xffffff, 0.85);
    sun.position.set(1.5, 2.5, 1.0);
    this.scene.add(sun);

    // Volume shell + floor grid
    const grid = new THREE.GridHelper(sim.n, sim.n, 0x30363d, 0x21262d);
    this.scene.add(grid);
    this._shell = this._makeShell(sim.n);
    this.scene.add(this._shell);

    // Instanced meshes: opaque + translucent (liquids, gases, glassy solids)
    const cap = MAX_N * MAX_N * MAX_N;
    const box = new THREE.BoxGeometry(1, 1, 1);
    this.opaque = new THREE.InstancedMesh(box, new THREE.MeshLambertMaterial({ color: 0xffffff }), cap);
    this.trans = new THREE.InstancedMesh(box, new THREE.MeshLambertMaterial({
      color: 0xffffff, transparent: true, opacity: 0.55, depthWrite: false,
    }), cap);
    this.opaque.instanceMatrix.setUsage(THREE.DynamicDrawUsage);
    this.trans.instanceMatrix.setUsage(THREE.DynamicDrawUsage);
    // Allocate instanceColor buffers up front
    this.opaque.setColorAt(0, new THREE.Color());
    this.trans.setColorAt(0, new THREE.Color());
    this.opaque.count = 0;
    this.trans.count = 0;
    this.scene.add(this.opaque);
    this.scene.add(this.trans);

    // Hover highlight
    const edge = new THREE.LineSegments(
      new THREE.EdgesGeometry(new THREE.BoxGeometry(1.02, 1.02, 1.02)),
      new THREE.LineBasicMaterial({ color: 0xf0c541 })
    );
    edge.visible = false;
    this.scene.add(edge);
    this.highlight = edge;

    this._mat4 = new THREE.Matrix4();
    this._color = new THREE.Color();
    this._matColorCache = new Map();
    this._flash = new Map();   // cell index → remaining flash frames (⚡ effect)

    this.resize();
  }

  flashCells(cells) {
    for (const c of cells) this._flash.set(this.sim.idx(c.x, c.y, c.z), 10);
  }

  setSim(sim) {
    this.sim = sim;
    this.clipY = sim.n - 1;
    this._flash.clear();
    this.scene.remove(this._shell);
    this._shell = this._makeShell(sim.n);
    this.scene.add(this._shell);
    this.controls.target.set(0, sim.n * 0.28, 0);
  }

  _makeShell(n) {
    const geo = new THREE.BoxGeometry(n, n, n);
    const edges = new THREE.EdgesGeometry(geo);
    const shell = new THREE.LineSegments(edges, new THREE.LineBasicMaterial({ color: 0x30363d }));
    shell.position.set(0, n / 2, 0);
    return shell;
  }

  gridToWorld(x, y, z) {
    const n = this.sim.n;
    return new THREE.Vector3(x - n / 2 + 0.5, y + 0.5, z - n / 2 + 0.5);
  }

  resize() {
    const w = this.canvas.clientWidth || this.canvas.parentElement.clientWidth;
    const h = this.canvas.clientHeight || this.canvas.parentElement.clientHeight;
    if (w === 0 || h === 0) return;
    this.renderer.setSize(w, h, false);
    this.camera.aspect = w / h;
    this.camera.updateProjectionMatrix();
  }

  _colorFor(m) {
    let c = this._matColorCache.get(m.color);
    if (!c) { c = new THREE.Color(m.color); this._matColorCache.set(m.color, c); }
    return c;
  }

  updateInstances() {
    const sim = this.sim, n = sim.n, M = DB.materials;
    const mat4 = this._mat4, col = this._color;
    let no = 0, nt = 0;

    for (let y = 0; y < n; y++) {
      if (y > this.clipY) break;
      for (let z = 0; z < n; z++) for (let x = 0; x < n; x++) {
        const i = sim.idx(x, y, z);
        const mi = sim.mat[i];
        if (mi === AIR) continue;
        const m = M[mi];
        if (!m || m.deleted) continue;

        const isGas = m.phase === PhaseState.GAS;
        const translucent = isGas || m.opacity < 0.95;
        const s = isGas ? 0.62 : (m.phase === PhaseState.LIQUID ? 0.96 : 1.0);
        const p = this.gridToWorld(x, y, z);
        mat4.makeScale(s, s, s);
        mat4.setPosition(p.x, p.y, p.z);

        col.copy(this._colorFor(m));
        const t = sim.temp[i];
        if (this._flash.get(i) > 0) {
          col.lerp(ZAP_COLOR, 0.55 + Math.random() * 0.45);         // ⚡ crackle
        } else if (sim.burn[i] > 0) {
          col.lerp(FIRE_COLOR, 0.45 + Math.random() * 0.4);         // flicker
        } else if (t > 300 && m.id !== 'lava') {
          col.lerp(GLOW_COLOR, Math.min((t - 300) / 900, 0.6));     // hot things glow
        }

        if (translucent) { this.trans.setMatrixAt(nt, mat4); this.trans.setColorAt(nt, col); nt++; }
        else { this.opaque.setMatrixAt(no, mat4); this.opaque.setColorAt(no, col); no++; }
      }
    }

    this.opaque.count = no;
    this.trans.count = nt;
    this.opaque.instanceMatrix.needsUpdate = true;
    this.trans.instanceMatrix.needsUpdate = true;
    if (this.opaque.instanceColor) this.opaque.instanceColor.needsUpdate = true;
    if (this.trans.instanceColor) this.trans.instanceColor.needsUpdate = true;
  }

  render() {
    this.controls.update();
    this.updateInstances();
    this.renderer.render(this.scene, this.camera);
    for (const [i, ttl] of this._flash) {
      if (ttl <= 1) this._flash.delete(i); else this._flash.set(i, ttl - 1);
    }
  }

  // ── Picking ────────────────────────────────────────────────
  // Returns { hit: {x,y,z}, place: {x,y,z} } | { place: {x,y,z} } (ground) | null.
  pick(clientX, clientY) {
    const rect = this.canvas.getBoundingClientRect();
    const ndc = new THREE.Vector2(
      ((clientX - rect.left) / rect.width) * 2 - 1,
      -((clientY - rect.top) / rect.height) * 2 + 1
    );
    const ray = new THREE.Raycaster();
    ray.setFromCamera(ndc, this.camera);

    const n = this.sim.n;
    // Ray in grid space (grid spans [0,n]³, world is centered on x/z)
    const o = ray.ray.origin, d = ray.ray.direction;
    const ox = o.x + n / 2, oy = o.y, oz = o.z + n / 2;

    const vox = this._ddaTraverse(ox, oy, oz, d.x, d.y, d.z);
    if (vox) return vox;

    // Ground-plane fallback: place on the floor
    if (d.y < -1e-6) {
      const t = -oy / d.y;
      if (t > 0) {
        const gx = Math.floor(ox + d.x * t), gz = Math.floor(oz + d.z * t);
        if (gx >= 0 && gx < n && gz >= 0 && gz < n) return { place: { x: gx, y: 0, z: gz } };
      }
    }
    return null;
  }

  // Amanatides & Woo voxel traversal. Coordinates already in grid space.
  _ddaTraverse(ox, oy, oz, dx, dy, dz) {
    const n = this.sim.n;
    const EPS = 1e-9;

    // Advance origin to the volume's AABB if outside
    let t0 = 0;
    const inv = (v) => Math.abs(v) < EPS ? Infinity * Math.sign(v || 1) : 1 / v;
    const ix = inv(dx), iy = inv(dy), iz = inv(dz);
    let tmin = -Infinity, tmax = Infinity;
    for (const [oc, ic] of [[ox, ix], [oy, iy], [oz, iz]]) {
      if (!isFinite(ic)) { if (oc < 0 || oc > n) return null; continue; }
      let ta = (0 - oc) * ic, tb = (n - oc) * ic;
      if (ta > tb) [ta, tb] = [tb, ta];
      tmin = Math.max(tmin, ta); tmax = Math.min(tmax, tb);
    }
    if (tmax < Math.max(tmin, 0)) return null;
    t0 = Math.max(tmin, 0) + 1e-5;

    let px = ox + dx * t0, py = oy + dy * t0, pz = oz + dz * t0;
    let x = clampInt(Math.floor(px), 0, n - 1);
    let y = clampInt(Math.floor(py), 0, n - 1);
    let z = clampInt(Math.floor(pz), 0, n - 1);

    const stepX = dx > 0 ? 1 : -1, stepY = dy > 0 ? 1 : -1, stepZ = dz > 0 ? 1 : -1;
    const tDeltaX = Math.abs(ix), tDeltaY = Math.abs(iy), tDeltaZ = Math.abs(iz);
    let tMaxX = isFinite(ix) ? ((x + (stepX > 0 ? 1 : 0)) - px) * ix : Infinity;
    let tMaxY = isFinite(iy) ? ((y + (stepY > 0 ? 1 : 0)) - py) * iy : Infinity;
    let tMaxZ = isFinite(iz) ? ((z + (stepZ > 0 ? 1 : 0)) - pz) * iz : Infinity;

    let lastNormal = null;
    for (let step = 0; step < 3 * MAX_N + 6; step++) {
      if (x < 0 || y < 0 || z < 0 || x >= n || y >= n || z >= n) return null;
      if (y <= this.clipY && this.sim.mat[this.sim.idx(x, y, z)] !== AIR) {
        const hit = { x, y, z };
        const nrm = lastNormal || { x: 0, y: 1, z: 0 };
        const px2 = x + nrm.x, py2 = y + nrm.y, pz2 = z + nrm.z;
        const place = (px2 >= 0 && py2 >= 0 && pz2 >= 0 && px2 < n && py2 < n && pz2 < n)
          ? { x: px2, y: py2, z: pz2 } : null;
        return { hit, place };
      }
      if (tMaxX <= tMaxY && tMaxX <= tMaxZ) { x += stepX; tMaxX += tDeltaX; lastNormal = { x: -stepX, y: 0, z: 0 }; }
      else if (tMaxY <= tMaxZ) { y += stepY; tMaxY += tDeltaY; lastNormal = { x: 0, y: -stepY, z: 0 }; }
      else { z += stepZ; tMaxZ += tDeltaZ; lastNormal = { x: 0, y: 0, z: -stepZ }; }
    }
    return null;
  }

  showHighlight(cell) {
    if (!cell) { this.highlight.visible = false; return; }
    const p = this.gridToWorld(cell.x, cell.y, cell.z);
    this.highlight.position.copy(p);
    this.highlight.visible = true;
  }
}

const FIRE_COLOR = new THREE.Color('#ff8c1a');
const GLOW_COLOR = new THREE.Color('#ff4d00');
const ZAP_COLOR = new THREE.Color('#cfe7ff');

function clampInt(v, lo, hi) { return v < lo ? lo : (v > hi ? hi : v); }
