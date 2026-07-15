// AshFall — Voxel Lab: UI layer. Palette, tools, material/reaction authoring, inspector, export.

const UI = {
  app: null,

  init(app) {
    this.app = app;
    this.buildPalette();
    this.buildTools();
    this.buildTabs();
    this.buildMaterialEditor();
    this.buildReactionsPanel();
    this.renderCellPanel(null);
    this.wireTopbar();
  },

  // ── Palette ──────────────────────────────────────────────
  buildPalette() {
    const el = document.getElementById('palette');
    el.innerHTML = '';
    const groups = {};
    for (const m of DB.materials) {
      if (m.deleted) continue;
      (groups[m.category] ||= []).push(m);
    }
    const catNames = { earth: 'Earth', mineral: 'Mineral', organic: 'Organic', constructed: 'Constructed', water: 'Water Cycle', special: 'Special', custom: 'Custom' };
    for (const [cat, mats] of Object.entries(groups)) {
      const h = document.createElement('div');
      h.className = 'pal-cat';
      h.textContent = catNames[cat] || cat;
      el.appendChild(h);
      for (const m of mats) {
        const row = document.createElement('div');
        row.className = 'pal-item' + (this.app.state.matId === m.id ? ' active' : '');
        row.dataset.id = m.id;
        row.innerHTML = `<span class="swatch" style="background:${m.color};opacity:${Math.max(m.opacity, 0.4)}"></span>
          <span class="pal-name">${esc(m.name)}</span>
          <span class="pal-phase">${PHASE_LABELS[m.phase][0]}</span>`;
        row.onclick = () => {
          this.app.state.matId = m.id;
          this.app.state.tool = 'paint';
          this.buildPalette();
          this.buildTools();
          this.buildMaterialEditor();
          this.selectTab('material');
        };
        el.appendChild(row);
      }
    }
  },

  // ── Tools ────────────────────────────────────────────────
  buildTools() {
    const el = document.getElementById('tools');
    const t = this.app.state.tool, b = this.app.state.brush;
    el.innerHTML = `
      <button class="tool ${t === 'paint' ? 'active' : ''}" data-tool="paint" title="Paint (1)">🖌 Paint</button>
      <button class="tool ${t === 'erase' ? 'active' : ''}" data-tool="erase" title="Erase (2)">⌫ Erase</button>
      <button class="tool ${t === 'inspect' ? 'active' : ''}" data-tool="inspect" title="Inspect (3)">🔍 Inspect</button>
      <button class="tool ${t === 'heat' ? 'active' : ''}" data-tool="heat" title="Heat gun — hold to heat (4)">🔥 Heat</button>
      <button class="tool ${t === 'freeze' ? 'active' : ''}" data-tool="freeze" title="Freeze gun — hold to cool (5)">❄ Freeze</button>
      <button class="tool ${t === 'zap' ? 'active' : ''}" data-tool="zap" title="Electric gun — arcs through conductive materials (6)">⚡ Zap</button>
      <button class="tool brush ${b === 3 ? 'active' : ''}" title="Toggle 3×3×3 brush">▦ 3³</button>`;
    el.querySelectorAll('.tool[data-tool]').forEach(btn => {
      btn.onclick = () => { this.app.state.tool = btn.dataset.tool; this.buildTools(); };
    });
    el.querySelector('.brush').onclick = () => {
      this.app.state.brush = this.app.state.brush === 3 ? 1 : 3;
      this.buildTools();
    };
  },

  // ── Tabs ─────────────────────────────────────────────────
  buildTabs() {
    document.querySelectorAll('.tab').forEach(tab => {
      tab.onclick = () => this.selectTab(tab.dataset.tab);
    });
    document.getElementById('newMatBtn').onclick = () => this.createMaterial();
  },

  selectTab(name) {
    document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.tab === name));
    for (const p of ['material', 'reactions', 'cell']) {
      document.getElementById('panel-' + p).style.display = p === name ? 'block' : 'none';
    }
  },

  // ── Material editor ──────────────────────────────────────
  buildMaterialEditor() {
    const m = DB.byId(this.app.state.matId);
    const el = document.getElementById('panel-material');
    if (!m) { el.innerHTML = '<p class="hint">Select a material.</p>'; return; }

    el.innerHTML = `
      <div class="ed-head">
        <span class="swatch big" style="background:${m.color}"></span>
        <div>
          <div class="ed-name">${esc(m.name)} ${m.custom ? '<span class="badge">custom</span>' : ''}</div>
          <div class="ed-id">${esc(m.id)}</div>
        </div>
      </div>
      <div class="form">
        ${field('Name', `<input type="text" data-k="name" value="${esc(m.name)}">`)}
        ${m.custom ? field('ID', `<input type="text" data-k="id" value="${esc(m.id)}">`) : ''}
        ${field('Category', `<input type="text" data-k="category" value="${esc(m.category)}">`)}
        ${field('Description', `<textarea data-k="desc" rows="2">${esc(m.desc)}</textarea>`)}
        ${field('Color', `<input type="color" data-k="color" value="${m.color}">`)}
        ${field('Opacity', `<input type="range" data-k="opacity" min="0.2" max="1" step="0.05" value="${m.opacity}"><span class="rv">${m.opacity}</span>`)}
        ${field('Natural phase', `<select data-k="phase">
            <option value="0" ${m.phase === 0 ? 'selected' : ''}>Solid</option>
            <option value="1" ${m.phase === 1 ? 'selected' : ''}>Liquid</option>
            <option value="2" ${m.phase === 2 ? 'selected' : ''}>Gas</option>
          </select>`)}
        ${field('Default temp °C', `<input type="number" data-k="defaultTemp" value="${m.defaultTemp}">`)}
        ${field('Heat conduct.', `<input type="range" data-k="conductivity" min="0" max="1" step="0.05" value="${m.conductivity}"><span class="rv">${m.conductivity}</span>`)}
        ${field('Elec. conduct.', `<input type="range" data-k="elecCond" min="0" max="1" step="0.05" value="${m.elecCond ?? 0.05}"><span class="rv">${m.elecCond ?? 0.05}</span>`)}
        ${field('Density', `<input type="number" data-k="density" step="0.1" value="${m.density}">`)}
        <div class="form-sep">Phase thresholds — blank = never</div>
        ${field('Melt °C', `<input type="text" data-k="meltPoint" placeholder="—" value="${m.meltPoint ?? ''}">`)}
        ${field('→ on melt', matSelect('onMelt', m.onMelt))}
        ${field('Boil °C', `<input type="text" data-k="boilPoint" placeholder="—" value="${m.boilPoint ?? ''}">`)}
        ${field('→ on boil', matSelect('onBoil', m.onBoil))}
        ${field('Freeze °C', `<input type="text" data-k="freezePoint" placeholder="—" value="${m.freezePoint ?? ''}">`)}
        ${field('→ on freeze', matSelect('onFreeze', m.onFreeze))}
        <div class="form-sep">Behavior</div>
        ${field('Granular (falls)', `<input type="checkbox" data-k="granular" ${m.granular ? 'checked' : ''}>`)}
        ${field('Flammable', `<input type="checkbox" data-k="flammable" ${m.flammable ? 'checked' : ''}>`)}
        ${field('Ignition °C', `<input type="number" data-k="ignition" value="${m.ignition}">`)}
        ${field('Burn life (ticks)', `<input type="number" data-k="burnLife" value="${m.burnLife}">`)}
        ${field('→ after burning', matSelect('burnResult', m.burnResult, true))}
      </div>
      <button id="delMatBtn" class="danger-btn">Delete material</button>`;

    el.querySelectorAll('[data-k]').forEach(input => {
      const k = input.dataset.k;
      input.addEventListener(input.type === 'checkbox' || input.tagName === 'SELECT' ? 'change' : 'input', () => {
        this.applyMaterialEdit(m, k, input);
      });
    });
    el.querySelector('#delMatBtn').onclick = () => this.deleteMaterial(m);
  },

  applyMaterialEdit(m, k, input) {
    const nullable = ['meltPoint', 'boilPoint', 'freezePoint'];
    if (input.type === 'checkbox') m[k] = input.checked;
    else if (nullable.includes(k)) {
      const v = parseFloat(input.value);
      m[k] = Number.isFinite(v) ? v : null;
    } else if (['defaultTemp', 'density', 'ignition', 'burnLife'].includes(k)) {
      const v = parseFloat(input.value);
      if (Number.isFinite(v)) m[k] = v;
    } else if (k === 'opacity' || k === 'conductivity' || k === 'elecCond') {
      m[k] = parseFloat(input.value);
      const rv = input.parentElement.querySelector('.rv');
      if (rv) rv.textContent = m[k];
    } else if (k === 'phase') {
      m[k] = parseInt(input.value);
    } else if (k === 'id') {
      const slug = input.value.trim().toLowerCase().replace(/[^a-z0-9_]/g, '_');
      if (slug && !DB.byId(slug)) {
        const old = m.id;
        m.id = slug;
        if (this.app.state.matId === old) this.app.state.matId = slug;
        DB.refresh();
      }
    } else {
      m[k] = input.value;
    }
    DB.refresh();
    DB.save();
    // Palette shows name/color/phase — keep it in sync without stealing focus
    if (['name', 'color', 'phase', 'category', 'id'].includes(k)) this.buildPalette();
  },

  createMaterial() {
    let i = 1;
    while (DB.byId('custom_' + i)) i++;
    const m = makeNewMaterial('custom_' + i);
    m.custom = true;
    DB.materials.push(m);
    DB.refresh();
    DB.save();
    this.app.state.matId = m.id;
    this.buildPalette();
    this.buildMaterialEditor();
    this.selectTab('material');
    this.buildReactionsPanel();
  },

  deleteMaterial(m) {
    if (!confirm(`Delete "${m.name}"? Any placed voxels of it become air.`)) return;
    const mi = DB.materials.indexOf(m);
    m.deleted = true;
    DB.refresh();
    DB.save();
    this.app.sim.purgeMaterialIndex(mi);
    if (this.app.state.matId === m.id) this.app.state.matId = 'stone';
    this.buildPalette();
    this.buildMaterialEditor();
    this.buildReactionsPanel();
  },

  // ── Reactions panel ──────────────────────────────────────
  buildReactionsPanel() {
    const el = document.getElementById('panel-reactions');
    const rows = DB.reactions.map((r, i) => {
      const pct = (r.chance ?? 1) < 1 ? ` <span class="rx-chance">${Math.round((r.chance ?? 1) * 100)}%/tick</span>` : '';
      const desc = (r.kind === 'heat'
        ? `<b>${esc(r.a)}</b> at ≥${r.minTemp}° → <b>${esc(r.resultA) || 'air'}</b>`
        : `<b>${esc(r.a)}</b> + <b>${esc(r.b)}</b>${r.minTemp != null ? ` (≥${r.minTemp}°)` : ''} → <b>${esc(r.resultA) || 'air'}</b> + <b>${esc(r.resultB) || 'air'}</b>`) + pct;
      return `<div class="rx-row">
        <div class="rx-desc">${desc}<div class="rx-note">${esc(r.note || '')}</div></div>
        <button class="rx-del" data-i="${i}" title="Delete reaction">×</button>
      </div>`;
    }).join('');

    el.innerHTML = `
      <div class="rx-list">${rows || '<p class="hint">No reactions defined.</p>'}</div>
      <div class="form-sep">New reaction</div>
      <div class="form">
        ${field('Kind', `<select id="rxKind"><option value="contact">Contact (A + B)</option><option value="heat">Heat (A + temp)</option></select>`)}
        ${field('Material A', selectHtml('rxA', matOptionList('')))}
        <div id="rxBWrap">${field('Material B', selectHtml('rxB', matOptionList('')))}</div>
        ${field('Min temp °C', `<input type="text" id="rxTemp" placeholder="— (any)">`)}
        ${field('Chance / tick', `<input type="text" id="rxChance" placeholder="1 = always, 0.02 = slow">`)}
        ${field('A becomes', selectHtml('rxRA', matOptionList('', true)))}
        <div id="rxRBWrap">${field('B becomes', selectHtml('rxRB', matOptionList('', true)))}</div>
        ${field('Note', `<input type="text" id="rxNote" placeholder="What is this?">`)}
      </div>
      <button id="rxAddBtn" class="accent-btn">＋ Add reaction</button>`;

    el.querySelectorAll('.rx-del').forEach(btn => {
      btn.onclick = () => {
        DB.reactions.splice(parseInt(btn.dataset.i), 1);
        DB.save();
        this.buildReactionsPanel();
      };
    });
    const kindSel = el.querySelector('#rxKind');
    kindSel.onchange = () => {
      const heat = kindSel.value === 'heat';
      el.querySelector('#rxBWrap').style.display = heat ? 'none' : 'block';
      el.querySelector('#rxRBWrap').style.display = heat ? 'none' : 'block';
    };
    el.querySelector('#rxAddBtn').onclick = () => {
      const kind = kindSel.value;
      const tv = parseFloat(el.querySelector('#rxTemp').value);
      const cv = parseFloat(el.querySelector('#rxChance').value);
      const r = {
        kind,
        a: el.querySelector('#rxA').value,
        b: kind === 'heat' ? '' : el.querySelector('#rxB').value,
        minTemp: Number.isFinite(tv) ? tv : (kind === 'heat' ? 100 : null),
        chance: Number.isFinite(cv) ? Math.min(Math.max(cv, 0), 1) : 1,
        resultA: el.querySelector('#rxRA').value,
        resultB: kind === 'heat' ? '' : el.querySelector('#rxRB').value,
        note: el.querySelector('#rxNote').value,
      };
      DB.reactions.push(r);
      DB.save();
      this.buildReactionsPanel();
    };
  },

  // ── Cell inspector ───────────────────────────────────────
  renderCellPanel(info) {
    const el = document.getElementById('panel-cell');
    if (!info) {
      el.innerHTML = '<p class="hint">Pick the 🔍 tool and click a voxel to pin it here. Values update live while the sim runs.</p>';
      return;
    }
    if (info.air) {
      el.innerHTML = `<div class="cell-head">Air @ (${info.x}, ${info.y}, ${info.z})</div>
        <p class="hint">Ambient ${info.temp.toFixed(1)} °C</p>`;
      return;
    }
    const m = info.mat;
    el.innerHTML = `
      <div class="cell-head"><span class="swatch" style="background:${m.color}"></span> ${esc(m.name)} @ (${info.x}, ${info.y}, ${info.z})</div>
      <div class="cell-grid">
        <div class="prop"><span>Temperature</span><b>${info.temp.toFixed(1)} °C</b></div>
        <div class="prop"><span>Phase now</span><b style="color:${PHASE_COLORS[info.phase]}">${PHASE_LABELS[info.phase]}</b></div>
        <div class="prop"><span>Natural phase</span><b>${PHASE_LABELS[m.phase]}</b></div>
        <div class="prop"><span>Burning</span><b>${info.burning ? '🔥 yes' : 'no'}</b></div>
        ${m.meltPoint != null ? `<div class="prop"><span>Melts at</span><b>${m.meltPoint}° → ${esc(m.onMelt) || '—'}</b></div>` : ''}
        ${m.boilPoint != null ? `<div class="prop"><span>Boils at</span><b>${m.boilPoint}° → ${esc(m.onBoil) || '—'}</b></div>` : ''}
        ${m.freezePoint != null ? `<div class="prop"><span>Freezes at</span><b>${m.freezePoint}° → ${esc(m.onFreeze) || '—'}</b></div>` : ''}
        ${m.flammable ? `<div class="prop"><span>Ignites at</span><b>${m.ignition}°</b></div>` : ''}
      </div>`;
  },

  // ── Topbar ───────────────────────────────────────────────
  wireTopbar() {
    const app = this.app;
    const $ = id => document.getElementById(id);

    $('playBtn').onclick = () => app.togglePlay();
    $('stepBtn').onclick = () => app.step();
    $('demoBtn').onclick = () => app.demo();
    $('clearBtn').onclick = () => { if (confirm('Clear all voxels?')) app.clearGrid(); };
    $('resetTempsBtn').onclick = () => app.sim.resetTemps();

    $('speedRange').oninput = e => {
      app.state.speed = parseInt(e.target.value);
      $('speedVal').textContent = app.state.speed;
    };
    // Ambient: slider for quick sweeps, number field for exact/out-of-range values
    const ambR = $('ambientRange'), ambN = $('ambientNum');
    ambR.oninput = () => {
      app.sim.ambient = parseFloat(ambR.value);
      ambN.value = ambR.value;
    };
    ambN.onchange = () => {
      const v = parseFloat(ambN.value);
      if (!Number.isFinite(v)) { ambN.value = app.sim.ambient; return; }
      app.sim.ambient = v;
      ambR.value = Math.min(Math.max(v, parseFloat(ambR.min)), parseFloat(ambR.max));
    };
    $('clipRange').oninput = e => {
      app.view.clipY = parseInt(e.target.value);
      $('clipVal').textContent = 'y≤' + app.view.clipY;
    };
    $('volumeSel').onchange = e => app.setVolume(parseInt(e.target.value));

    $('exportBtn').onclick = () => {
      const blob = new Blob([DB.exportJSON()], { type: 'application/json' });
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = 'ashfall_materials.json';
      a.click();
      URL.revokeObjectURL(a.href);
    };
    $('copyBtn').onclick = async () => {
      const json = DB.exportJSON();
      try { await navigator.clipboard.writeText(json); flash($('copyBtn'), 'Copied ✓'); }
      catch (e) {
        const ta = document.createElement('textarea');
        ta.value = json; document.body.appendChild(ta); ta.select();
        document.execCommand('copy'); ta.remove();
        flash($('copyBtn'), 'Copied ✓');
      }
    };
    $('resetDbBtn').onclick = () => {
      if (!confirm('Reset ALL materials & reactions to project defaults? Custom edits will be lost.')) return;
      DB.resetToDefaults();
      app.clearGrid();
      this.app.state.matId = 'stone';
      this.buildPalette();
      this.buildMaterialEditor();
      this.buildReactionsPanel();
    };
  },

  updatePlayButton(playing) {
    document.getElementById('playBtn').textContent = playing ? '⏸ Pause' : '▶ Play';
    document.getElementById('playBtn').classList.toggle('playing', playing);
  },

  updateTick(t) {
    document.getElementById('tickVal').textContent = t;
  },

  syncClipRange(n, clipY) {
    const r = document.getElementById('clipRange');
    r.max = n - 1;
    r.value = clipY;
    document.getElementById('clipVal').textContent = 'y≤' + clipY;
  },
};

// ── Small helpers ──────────────────────────────────────────
function esc(s) {
  return String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}

function field(label, control) {
  return `<label class="field"><span class="fl">${label}</span><span class="fc">${control}</span></label>`;
}

function matOptionList(selected, allowAir = true) {
  let opts = allowAir ? [`<option value="" ${!selected ? 'selected' : ''}>— (air / none)</option>`] : [];
  for (const m of DB.materials) {
    if (m.deleted) continue;
    opts.push(`<option value="${esc(m.id)}" ${selected === m.id ? 'selected' : ''}>${esc(m.name)}</option>`);
  }
  return opts.join('');
}

function matSelect(key, selected, allowAir = true) {
  return `<select data-k="${key}">${matOptionList(selected, allowAir)}</select>`;
}

function selectHtml(id, options) {
  return `<select id="${id}">${options}</select>`;
}

function flash(btn, text) {
  const old = btn.textContent;
  btn.textContent = text;
  setTimeout(() => { btn.textContent = old; }, 1200);
}
