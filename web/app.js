// AshFall — Voxel Lab: application glue. Owns the sim/view/UI trio and the main loop.

const App = {
  sim: null,
  view: null,
  state: {
    tool: 'paint',      // paint | erase | inspect | heat | freeze | zap
    brush: 1,           // 1 or 3 (cube side)
    matId: 'stone',
    playing: false,
    speed: 8,           // ticks per second
    inspected: null,    // pinned cell {x,y,z}
  },
  GUN_RATE: 900,        // °C per second while a heat/freeze gun is held
  _accum: 0,
  _lastTime: 0,
  _painting: false,
  _px: 0, _py: 0,       // last pointer position (for held guns)

  init() {
    this.sim = new VoxelSim(16);
    const canvas = document.getElementById('gl');
    this.view = new VoxelView(canvas, this.sim);
    UI.init(this);
    UI.syncClipRange(this.sim.n, this.view.clipY);

    buildDemoScene(this.sim);
    this.wirePointer(canvas);
    this.wireKeyboard();

    window.addEventListener('resize', () => this.view.resize());
    requestAnimationFrame(t => this.loop(t));
  },

  // ── Main loop ──────────────────────────────────────────
  loop(time) {
    const dt = Math.min((time - this._lastTime) / 1000, 0.25);
    this._lastTime = time;

    if (this.state.playing) {
      this._accum += dt;
      const step = 1 / this.state.speed;
      let ran = 0;
      while (this._accum >= step && ran < 4) {   // cap catch-up so tab-switch doesn't freeze
        this.sim.tick();
        this._accum -= step;
        ran++;
      }
      if (ran) UI.updateTick(this.sim.tickCount);
    }

    // Held heat/freeze gun: continuous thermal injection at the hovered voxel
    if (this._painting && (this.state.tool === 'heat' || this.state.tool === 'freeze')) {
      const res = this.view.pick(this._px, this._py);
      if (res && res.hit) {
        const delta = (this.state.tool === 'heat' ? this.GUN_RATE : -this.GUN_RATE) * dt;
        const r = this.state.brush === 3 ? 1 : 0;
        for (let dx = -r; dx <= r; dx++) for (let dy = -r; dy <= r; dy++) for (let dz = -r; dz <= r; dz++) {
          this.sim.addHeat(res.hit.x + dx, res.hit.y + dy, res.hit.z + dz, delta);
        }
      }
    }

    // Live inspector refresh
    if (this.state.inspected) {
      const c = this.state.inspected;
      UI.renderCellPanel(this.sim.cellInfo(c.x, c.y, c.z));
    }

    this.view.render();
    requestAnimationFrame(t => this.loop(t));
  },

  // ── Controls invoked by UI ─────────────────────────────
  togglePlay() {
    this.state.playing = !this.state.playing;
    UI.updatePlayButton(this.state.playing);
  },

  step() {
    this.sim.tick();
    UI.updateTick(this.sim.tickCount);
  },

  demo() {
    buildDemoScene(this.sim);
    UI.updateTick(0);
  },

  clearGrid() {
    this.sim.clear();
    UI.updateTick(0);
  },

  setVolume(n) {
    const ambient = this.sim.ambient;
    this.sim = new VoxelSim(n);
    this.sim.ambient = ambient;
    this.view.setSim(this.sim);
    UI.syncClipRange(n, this.view.clipY);
    buildDemoScene(this.sim);
    UI.updateTick(0);
  },

  // ── Painting / picking ─────────────────────────────────
  wirePointer(canvas) {
    let lastKey = '';
    const isGun = () => this.state.tool === 'heat' || this.state.tool === 'freeze';

    const apply = (e) => {
      const res = this.view.pick(e.clientX, e.clientY);
      if (!res) return;
      const tool = this.state.tool;

      if (tool === 'inspect') {
        if (res.hit) {
          this.state.inspected = res.hit;
          UI.renderCellPanel(this.sim.cellInfo(res.hit.x, res.hit.y, res.hit.z));
          UI.selectTab('cell');
        }
        return;
      }

      if (tool === 'zap') {
        if (res.hit) {
          const cells = this.sim.zap(res.hit.x, res.hit.y, res.hit.z);
          this.view.flashCells(cells);
        }
        return;
      }

      const target = tool === 'erase' ? res.hit : res.place;
      if (!target) return;
      const key = `${tool}:${target.x},${target.y},${target.z}`;
      if (key === lastKey) return;   // don't re-apply on tiny pointer moves
      lastKey = key;

      const r = this.state.brush === 3 ? 1 : 0;
      for (let dx = -r; dx <= r; dx++) for (let dy = -r; dy <= r; dy++) for (let dz = -r; dz <= r; dz++) {
        const x = target.x + dx, y = target.y + dy, z = target.z + dz;
        if (!this.sim.inBounds(x, y, z)) continue;
        if (tool === 'erase') this.sim.setCell(x, y, z, null);
        else if (this.sim.get(x, y, z) === AIR) this.sim.setCell(x, y, z, this.state.matId);
      }
    };

    canvas.addEventListener('pointerdown', (e) => {
      if (e.button !== 0) return;
      this._painting = true;
      this._px = e.clientX; this._py = e.clientY;
      lastKey = '';
      if (!isGun()) apply(e);   // guns are applied continuously in the main loop
    });
    canvas.addEventListener('pointermove', (e) => {
      this._px = e.clientX; this._py = e.clientY;
      if (this._painting && !isGun() && this.state.tool !== 'zap') apply(e);
      // Hover highlight
      const res = this.view.pick(e.clientX, e.clientY);
      const wantsHit = this.state.tool !== 'paint';   // everything except paint targets the existing voxel
      const cell = res ? (wantsHit ? res.hit : (res.place || res.hit)) : null;
      this.view.showHighlight(cell || null);
    });
    window.addEventListener('pointerup', () => { this._painting = false; });
    canvas.addEventListener('pointerleave', () => { this._painting = false; this.view.showHighlight(null); });
    canvas.addEventListener('contextmenu', e => e.preventDefault());
  },

  wireKeyboard() {
    document.addEventListener('keydown', (e) => {
      const tag = (e.target.tagName || '').toLowerCase();
      if (tag === 'input' || tag === 'textarea' || tag === 'select') return;
      if (e.code === 'Space') { this.togglePlay(); e.preventDefault(); }
      else if (e.key === 's') this.step();
      else if (e.key === '1') { this.state.tool = 'paint'; UI.buildTools(); }
      else if (e.key === '2') { this.state.tool = 'erase'; UI.buildTools(); }
      else if (e.key === '3') { this.state.tool = 'inspect'; UI.buildTools(); }
      else if (e.key === '4') { this.state.tool = 'heat'; UI.buildTools(); }
      else if (e.key === '5') { this.state.tool = 'freeze'; UI.buildTools(); }
      else if (e.key === '6') { this.state.tool = 'zap'; UI.buildTools(); }
    });
  },
};

App.init();
