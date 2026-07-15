// Headless smoke test: load data.js + sim.js, run the demo scene, assert core behaviors emerge.
const fs = require('fs');
const path = require('path');
const WEB = __dirname;

function loadLib() {
  const code = fs.readFileSync(path.join(WEB, 'data.js'), 'utf8')
    + '\n' + fs.readFileSync(path.join(WEB, 'sim.js'), 'utf8')
    + '\n;({ DB, PhaseState, getPhaseAt, transitionTargetId, VoxelSim, buildDemoScene, AIR });';
  return eval(code);
}
const { DB, PhaseState, getPhaseAt, transitionTargetId, VoxelSim, buildDemoScene, AIR } = loadLib();

function count(sim, id) {
  const mi = DB.indexOf(id);
  let c = 0;
  for (let i = 0; i < sim.mat.length; i++) if (sim.mat[i] === mi) c++;
  return c;
}
function burningCount(sim) {
  let c = 0;
  for (let i = 0; i < sim.burn.length; i++) if (sim.burn[i] > 0) c++;
  return c;
}

let pass = 0, fail = 0;
function check(name, cond, detail = '') {
  if (cond) { pass++; console.log(`  ✔ ${name}`); }
  else { fail++; console.log(`  ✘ ${name} ${detail}`); }
}

// ── Test 1: pure phase logic ─────────────────────────────
console.log('Phase logic:');
const ice = DB.byId('ice'), water = DB.byId('water'), steam = DB.byId('steam'), lava = DB.byId('lava');
check('ice solid at -5', getPhaseAt(ice, -5) === PhaseState.SOLID);
check('ice liquid at 20', getPhaseAt(ice, 20) === PhaseState.LIQUID);
check('water freezes at -2', getPhaseAt(water, -2) === PhaseState.SOLID);
check('water gas at 150', getPhaseAt(water, 150) === PhaseState.GAS);
check('steam condenses at 60', getPhaseAt(steam, 60) === PhaseState.LIQUID);
check('lava freezes at 600', getPhaseAt(lava, 600) === PhaseState.SOLID);
check('ice→water target', transitionTargetId(ice, PhaseState.LIQUID) === 'water');
check('water→steam target', transitionTargetId(water, PhaseState.GAS) === 'steam');
check('lava→volcanic target', transitionTargetId(lava, PhaseState.SOLID) === 'volcanic');

// ── Test 2: demo scene evolution ─────────────────────────
console.log('Demo scene, 300 ticks:');
const sim = new VoxelSim(16);
buildDemoScene(sim);
const ice0 = count(sim, 'ice'), sandAt8 = sim.get(6, 8, 5);
check('demo has ice', ice0 > 0);
check('demo has floating sand', sandAt8 === DB.indexOf('sand'));

let sawBurning = false, sawSteam = false, sawMud = false, sawVolcanic = false;
for (let t = 0; t < 300; t++) {
  sim.tick();
  if (burningCount(sim) > 0) sawBurning = true;
  if (count(sim, 'steam') > 0) sawSteam = true;
  if (count(sim, 'mud') > 0) sawMud = true;
  if (count(sim, 'volcanic') > 0) sawVolcanic = true;
}
check('ice melted (fewer ice cells)', count(sim, 'ice') < ice0, `now ${count(sim, 'ice')} was ${ice0}`);
check('sand fell (top cell empty)', sim.get(6, 9, 5) === AIR);
check('dirt+water made mud', sawMud);
check('lava crusted to volcanic', sawVolcanic);
check('fire ignited via lava fuse', sawBurning);
check('steam appeared', sawSteam);
check('ash from burning', count(sim, 'ash') > 0 || !sawBurning);

// ── Test 3: ambient freeze ───────────────────────────────
console.log('Ambient freeze:');
const sim2 = new VoxelSim(8);
sim2.ambient = -40;
sim2.setCell(4, 0, 4, 'water');
for (let t = 0; t < 200; t++) sim2.tick();
check('water froze to ice at -40 ambient', count(sim2, 'ice') === 1, `ice=${count(sim2, 'ice')} water=${count(sim2, 'water')}`);

// ── Test 4: sand → glass heat reaction ───────────────────
console.log('Heat reaction:');
const sim3 = new VoxelSim(8);
sim3.setCell(4, 0, 4, 'sand');
sim3.temp[sim3.idx(4, 0, 4)] = 2500;   // hot enough to stay ≥1700 after first-tick diffusion losses
sim3.tick();
check('sand vitrified to glass', count(sim3, 'glass') === 1);

// ── Test 5: water quenches lava on contact ───────────────
console.log('Contact reaction:');
const sim4 = new VoxelSim(8);
sim4.setCell(3, 0, 4, 'lava');
sim4.setCell(4, 0, 4, 'water');
sim4.tick();
check('lava+water → volcanic+steam on contact', count(sim4, 'volcanic') === 1 && count(sim4, 'steam') === 1);

// ── Test 6: heat/freeze gun ──────────────────────────────
console.log('Thermal guns:');
const sim5 = new VoxelSim(8);
sim5.setCell(4, 0, 4, 'stone');
sim5.addHeat(4, 0, 4, 500);
check('heat gun raises temp', sim5.temp[sim5.idx(4, 0, 4)] === 520);
sim5.addHeat(4, 0, 4, -9999);
check('freeze gun clamps at -273', sim5.temp[sim5.idx(4, 0, 4)] === -273);
sim5.addHeat(5, 0, 4, 500);   // air cell — must be a no-op
check('gun is no-op on air', sim5.get(5, 0, 4) === AIR);

// ── Test 7: electric gun arcs through water ──────────────
console.log('Electric gun:');
const sim6 = new VoxelSim(8);
for (let x = 1; x <= 6; x++) sim6.setCell(x, 0, 4, 'water');
sim6.setCell(1, 0, 3, 'glass');   // insulator touching the pool
const zapped = sim6.zap(3, 0, 4);
check('zap affects multiple cells', zapped.length >= 4, `got ${zapped.length}`);
check('struck cell superheated', sim6.temp[sim6.idx(3, 0, 4)] > 1000);
check('arc travels through water', sim6.temp[sim6.idx(5, 0, 4)] > 100);
check('insulator (glass) not zapped', sim6.temp[sim6.idx(1, 0, 3)] < 50);
for (let t = 0; t < 3; t++) sim6.tick();
check('zapped water boiled to steam', count(sim6, 'steam') > 0);

// ── Test 8: probabilistic reactions (moss creep) ─────────
console.log('Chance reactions:');
const sim7 = new VoxelSim(8);
sim7.setCell(3, 0, 4, 'moss');
sim7.setCell(4, 0, 4, 'stone');
for (let t = 0; t < 800; t++) sim7.tick();   // 2%/tick → P(fail) ≈ 1e-7
check('moss crept over stone', count(sim7, 'moss') === 2, `moss=${count(sim7, 'moss')}`);

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
