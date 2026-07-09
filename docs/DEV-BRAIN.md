# Aperture — DEV BRAIN

*The single source of truth for **what to build, in what order, how it connects, and how an autonomous AI agent verifies each step is done.** When any other doc, chat, or AI suggestion disagrees with this file, **this file wins** — or you change this file first, on purpose.*

**Owner:** Ahmad (Game Director) + friend (co-dev) · **Executor:** DeepSeek via Godot AI (MCP) · **Engine:** Godot 4.7, GL Compatibility, Jolt · **Repo:** `/home/iama/aperture`
**Status:** Phase B (Ring 0) · **Version:** 2.1 — 2026-07-08 (seven-phase micro-cycle adopted)

---

# ⟢ KICKOFF PROMPT — paste this to the Godot AI agent to start the loop

```
You are the sole build agent for the game "Aperture" in this Godot project.
Your job: execute DEV-BRAIN.md autonomously until every goal is [x] or [!].

THE LOOP — repeat forever:
1. Open DEV-BRAIN.md. Scan PART III top-to-bottom.
2. Pick the FIRST goal marked [ ] whose every dependency is [x]. If none exists, STOP and print "RUN COMPLETE".
3. Mark it [~] (in progress). Save the file.
4. Build it through the SEVEN-PHASE MICRO-CYCLE (Part II.5), NOT in one shot:
   S0 plan -> S1 data structures -> S2 interfaces/stubs -> S3 TODO skeleton ->
   S4 DRY-RUN (implement, validate, THROW AWAY, record deviations; REWIND to S1/2/3 if the design was wrong) ->
   S5 invariants -> S6 implement for real.
   Trivial goals (only files/folders/data/config, no logic) skip straight to S6.
5. Run its "DONE-CHECK" + ALL global invariants (Part II.5) using the Godot MCP tools.
   - PASS  -> mark [x], write the "Commit:" line to git, go to step 1.
   - FAIL  -> fix and re-check. After 3 failed attempts, mark [!] with a one-line reason under the goal, go to step 1.
6. After EVERY goal, confirm the game still launches (project_run) with zero parse errors AND every global invariant holds. If not, revert your last change and retry the goal.

NEVER skip a DONE-CHECK. NEVER write final logic before S4's dry-run has validated the design. NEVER patch on top of a design the dry-run proved wrong — REWIND instead. NEVER edit a goal's acceptance criteria or an invariant to make it pass. NEVER start a goal whose deps aren't [x]. NEVER work on two goals at once. STOP at any [HUMAN GATE].
```

**Goal state markers:** `[ ]` todo · `[~]` in progress · `[x]` done & verified · `[!]` blocked (reason on next line).

---

# PART I — ORIENTATION (read once, keep in mind always)

## The game in one sentence
A stylized **45° top-down** game where you wake alone on an ancient floating scientific sanctuary and progress **not by leveling up but by understanding** — observe → experiment → combine → understand → unlock. Origin spark: Infinity Craft's combination mechanic, **plus chronology, plus a world that reacts.**

## The 3 locked decisions (2026-07-08 — bedrock, every goal inherits them)
- **D1 Camera:** 45° top-down, fixed angle. Player ≈1m tall, radius ≈0.4m. (First-person is superseded.)
- **D2 World:** Modular chunks (kit of parts). No terrain sculpting. AI snaps modules on a grid.
- **D3 Order:** Traversal & game-feel first, mechanic second, content third.

## The Spine — the rule that stops "two disconnected projects"
Everything plugs into ONE of two backbones:
- **THE WORLD** — the physical place you move through (greybox → modular kit → dressed).
- **THE CODEX** — what the player understands (knowledge graph: nodes + links + confidence).
The **loop is the bridge:** Observe the World → write to the Codex → Codex unlocks gates/tools → the World changes.

**The Connection Test (apply before adding anything):** "What does this read from the World/Codex, and what does it write back?" Can't answer both → it's decoration → defer.

## Rings → Phases map
| Ring | Meaning | Phases |
|------|---------|--------|
| 0 | Greybox traversal | A, B, C, D |
| 1 | Kit + first loop beat | E, F, G, H, I |
| 2 | The vertical slice (go/no-go) | J, K, L, M, N |
| 3 | The Ark (expand) | O |
| 4 | A world that reacts | P |
| 5 | Aspirational (NPC/civ/deep time) | Q |
| — | Ship | Z |

---

# PART II — THE AUTONOMOUS BUILD PROTOCOL

## Prime Directives (the agent breaks these = the run is a waste)
1. **Playable-always.** After every goal, `project_run` must launch with zero script parse errors. If not → revert, retry.
2. **Verify, don't assume.** A goal is done only when its DONE-CHECK passes via an MCP tool. Screenshots/prints/tests — not vibes.
3. **Stay in lane (D1/D2/D3).** Top-down. Modular. No terrain sculpting. No first-person camera. No feature outside the current phase.
4. **One goal at a time.** No parallel goals. No starting a goal with unmet deps.
5. **Respect the Spine.** New systems read/write `Codex` or `WorldState` or they don't get built.
6. **Fail loud, move on.** 3 strikes → `[!]` + reason → next goal. Never loop forever on one goal.
7. **Don't touch quarantine.** Never edit or extend `scenes/world/ark_genesis/*` or terrain-first scenes (Part IV). They are dead.
8. **Commit per goal.** One goal = one commit = one checkbox. Small, revertible steps.
9. **Structure before implementation.** Every non-trivial goal runs the seven-phase micro-cycle (Part II.5). Never write final logic before the S4 dry-run validates the design. If the dry-run deviates, REWIND to the wrong sub-phase and fix it — don't patch around it.
10. **Invariants are permanent.** After every goal, ALL global invariants (Part II.5) must hold, not just the goal's own DONE-CHECK. A green DONE-CHECK that breaks an invariant = not done. Revert.

## DONE-CHECK vocabulary (how the agent self-verifies with Godot MCP tools)
- **file-exists:** `filesystem_manage` — path exists.
- **compiles:** `script_manage(read)` / `editor_state` — no parse error on the script/scene.
- **node-exists:** `node_find` / `scene_get_hierarchy` — a node of given name/type is in the scene.
- **prop-equals:** `node_get_properties` — a property matches expected.
- **runs-logs:** `project_run` then `logs_read` — the game runs and prints an expected `TAG`.
- **test-passes:** `test_run` / `test_manage` — a test in `scenes/_test/` returns green.
- **visual:** `editor_screenshot` — capture for the human to eyeball at a phase gate (never a substitute for the above).

Every gameplay goal prints a **verification tag** (e.g. `print("LOOP_OK")`) so `runs-logs` is deterministic. Non-trivial logic → prefer a real `test-passes` file over a print.

## Phase gates (human-in-the-loop)
Phases **D** and **N** end with a `[HUMAN GATE]`: the agent STOPS and Ahmad plays it. The agent may not pass a gate until Ahmad marks it `[x]`. Everything between gates is fully autonomous.

## Global Definition of Done (the whole run)
All A–N goals `[x]`; the vertical slice (Phase N) passed its human gate; zero `[!]` on the critical path. O–Z are re-detailed after N (intentionally coarse until Ring 2 proves the game).

---

# PART II.5 — THE SEVEN-PHASE MICRO-CYCLE (how each goal is built without breaking things)

*Adapted from e4coder's seven-phase methodology (github.com/e4coder/seven-phase — authored by your co-dev). Naive autonomous agents ship broken code because they jump straight to implementation and auto-advance. This forces **structure before implementation** and a **throwaway dry-run** that catches design flaws cheaply — the automated reviewer that replaces a human at every step. The two real `[HUMAN GATE]`s (D, N) remain; everything else is gated by the dry-run + invariants below.*

**Every NON-TRIVIAL goal is built through these 7 sub-phases.** A goal is *trivial* (skip to S6) only if it's pure files/folders/data/config with no branching logic — e.g. A1, or authoring `.tres`. Anything with a `.gd` that has logic (controllers, autoloads, systems, components, UI) is non-trivial.

**Durable per-goal state in `.llm/<goal-id>/`** (survives across sub-phases and restarts):
- `plan.md` — research, decisions, data shapes, interface, risks.
- `deviations.md` — what the dry-run revealed.
- `invariants.md` — assertions this goal must never violate.

### The sub-phases
- **S0 — Research + Plan.** Read the goal, the docs it references, the existing code it touches. Write `.llm/<id>/plan.md`: what you'll build, which backbone (World/Codex) it reads/writes, data shapes, public interface, risks. **No code.**
- **S1 — Data structures.** Define ONLY the data — resource classes, dicts, enums, node fields. No behavior. Commit `S1:<id>`.
- **S2 — Interfaces / stubs.** Define the public API — function signatures, signals, `@export`s — with empty/`pass` bodies. No logic. Commit `S2:<id>`.
- **S3 — TODO skeleton.** Fill each stub with a commented, plain-language TODO of the algorithm. Still no real logic. Commit `S3:<id>`.
- **S4 — DRY-RUN (the gate).** Implement the logic for real, run **validation** (the goal's DONE-CHECK + all global invariants), observe, then **THROW THE CODE AWAY** (`git stash -u && git stash drop`) — but write the lessons to `.llm/<id>/deviations.md`.
  - Clean pass, no structural surprises → design (S1–S3) is sound → go to S5.
  - Deviated (data/interface/TODO was wrong) → **REWIND** to S1/S2/S3, fix the design, replay forward. Never patch around a broken structure.
- **S5 — Invariants.** Write the assertions that must ALWAYS hold for this goal, as real `assert()`s and/or a test in `scenes/_test/`. Record in `.llm/<id>/invariants.md` and add to the global registry below. Commit `S5:<id>`.
- **S6 — Implement for real.** Structure is proven, invariants written. Implement cleanly. Run DONE-CHECK + all invariants. Only now mark the goal `[x]` and write its `Commit:` line.

### The validation command (`.llm/validation`, set once at A1)
For Aperture, "validation" = **`project_run` launches with zero parse errors AND the goal's DONE-CHECK is green AND all global invariants hold.** The agent runs this in S4 (on throwaway code) and S6 (on real code). Also gitignore `.llm/.phase`.

### Global invariants — checked after EVERY goal, forever
1. `project_run` launches with zero script parse errors.
2. Every existing test in `scenes/_test/` still passes (no regressions).
3. Player never falls through the floor or off the world (once C2 exists).
4. `Codex` never loses a discovered node; confidence never silently downgrades (once A3/L2 exist).
5. No autoload throws during `_ready()`.
6. The current main scene always loads.

A goal that breaks any invariant is **not done**, even if its own DONE-CHECK passed. Revert and fix.

### Why this stops the "keeps building broken stuff" failure
- **S1–S3** stop the agent from rushing to tangled implementation — the shape is agreed before logic exists.
- **S4** proves the design against real validation *before* you commit to it, and discards the throwaway so a bad first attempt leaves no residue.
- **Rewind** guarantees flaws are fixed at the root, not papered over.
- **Invariants** are a ratchet — the game can only ever move from "working" to "working," never silently regress.

---

# PART III — THE PHASES (A → Z)

> Goal template: **ID — Title** · deps · Build / Files / Accept / DONE-CHECK / Commit.
> Agent: obey Part II. Human: you only touch `[HUMAN GATE]` goals.

---

## PHASE A — PROJECT SPINE & CONVENTIONS
**Phase goal:** clean skeleton, shared backbones stubbed, a working test harness — so every later goal has somewhere to plug in and something to verify against.
**Exit criteria:** autoloads `Codex` + `WorldState` exist and log on boot; a sample test runs green; game launches.

- [x] **A1 — Folder & naming conventions + seven-phase scaffold** · deps: none
  - Build: ensure dirs exist: `scripts/autoloads`, `scripts/components`, `scripts/systems`, `scripts/resources`, `scripts/ui`, `scenes/player`, `scenes/world`, `scenes/ui`, `scenes/_test`, `data/codex`, `data/materials`, `data/reactions`, `kit/`, `.llm/`. Add `.gdignore` to `scenes/_test`. Create `.llm/validation` (the validation definition from Part II.5) and add `.llm/.phase` to `.gitignore`.
  - Files: dirs + `.gdignore` + `.llm/validation` + `.gitignore`.
  - Accept: all dirs present; `.llm/validation` exists; `.gitignore` ignores `.llm/.phase`.
  - DONE-CHECK: file-exists each dir + `.llm/validation`.
  - Commit: `A1: folder + seven-phase scaffold`

- [x] **A2 — WorldState autoload** · deps: A1
  - Build: `scripts/autoloads/world_state.gd` — singleton with `Dictionary flags`. API `set_flag(k,v)`, `get_flag(k,default=null)`, `has_flag(k)`; signal `flag_changed(key,value)`. `_ready()` prints `WORLDSTATE_OK`. Register autoload `WorldState`.
  - Files: `scripts/autoloads/world_state.gd`, `project.godot`.
  - Accept: boots, prints tag, API callable.
  - DONE-CHECK: runs-logs `WORLDSTATE_OK`.
  - Commit: `A2: WorldState autoload`

- [x] **A3 — Codex autoload (v0 store)** · deps: A1
  - Build: `scripts/autoloads/codex.gd` — singleton with `Dictionary observations`, `Dictionary nodes`. API `observe(id)` (emits `observed`), `knows(id)->bool`, `discover(id)` (emits `node_understood(id)`). `_ready()` prints `CODEX_OK`. Register autoload `Codex`.
  - Files: `scripts/autoloads/codex.gd`, `project.godot`.
  - Accept: boots, prints tag, API callable.
  - DONE-CHECK: runs-logs `CODEX_OK`.
  - Commit: `A3: Codex autoload v0`

- [x] **A4 — Test harness** · deps: A1
  - Build: minimal test runner in `scenes/_test/` (reuse `addons/godot_ai/testing` if present, else a tiny `test_suite.gd`). Add `test_smoke.gd` asserting `1==1`.
  - Files: `scenes/_test/test_smoke.gd`.
  - Accept: a test runs and reports pass/fail.
  - DONE-CHECK: test-passes `test_smoke`.
  - Commit: `A4: test harness + smoke test`

- [x] **A5 — Backbone contract test** · deps: A2, A3, A4
  - Build: `scenes/_test/test_backbones.gd` — `WorldState.set_flag("x",1)` → `get_flag("x")==1`; `Codex.observe("a")` twice → no duplicate; `Codex.knows("a")==false` until `discover("a")` → `true`.
  - Files: `scenes/_test/test_backbones.gd`.
  - Accept: all asserts pass.
  - DONE-CHECK: test-passes `test_backbones`.
  - Commit: `A5: backbone contract test`

---

## PHASE B — TOP-DOWN CAMERA & CONTROLLER  *(Ring 0 core)*
**Phase goal:** a body you steer and a camera that reads the space at 45°. The single most important "feel" phase.
**Exit criteria:** drive a capsule around a flat plane, camera fixed at 45°, movement feels smooth.

- [x] **B1 — Flat test plane** · deps: A1
  - Build: `scenes/_test/feel_box.tscn` — 60×60m `StaticBody3D` plane + collision, a few box obstacles, neutral light. The movement lab.
  - Files: `scenes/_test/feel_box.tscn`.
  - Accept: opens; floor has collision.
  - DONE-CHECK: node-exists floor `StaticBody3D` + `CollisionShape3D`.
  - Commit: `B1: movement lab scene`

- [x] **B2 — Player body (top-down)** · deps: B1
  - Build: `scenes/player/player.tscn` — `CharacterBody3D` (capsule ≈1m, r≈0.4), `CollisionShape3D`, placeholder mesh, `Marker3D` "CameraTarget". Group `"player"`.
  - Files: `scenes/player/player.tscn`.
  - Accept: is a `CharacterBody3D` in group `player`.
  - DONE-CHECK: node-exists `CharacterBody3D` in group `player`.
  - Commit: `B2: top-down player body`

- [~] **B3 — Top-down controller** · deps: B2
  - Build: `scripts/components/player_controller.gd` — camera-relative WASD on XZ, accel+friction (snappy), gravity+floor snap, NO jump. `@export` speed. `_ready()` prints `PLAYER_OK`.
  - Files: `scripts/components/player_controller.gd`, `scenes/player/player.tscn`.
  - Accept: moves with WASD, stays on floor.
  - DONE-CHECK: runs-logs `PLAYER_OK`; compiles; node-exists.
  - Commit: `B3: top-down movement`

- [ ] **B4 — 45° camera rig** · deps: B3
  - Build: `scenes/player/camera_rig.tscn` + `scripts/components/camera_rig.gd` — `Camera3D` fixed 45° pitch (~35–50°), fixed yaw, follows `CameraTarget` by position lerp (no rotation follow). `@export` height/distance. Prints `CAMERA_OK`.
  - Files: `scenes/player/camera_rig.tscn`, `scripts/components/camera_rig.gd`.
  - Accept: holds 45°, smoothly trails player.
  - DONE-CHECK: runs-logs `CAMERA_OK`; visual for gate D.
  - Commit: `B4: 45deg follow camera`

- [ ] **B5 — Input map audit** · deps: B3
  - Build: ensure actions exist and are top-down-correct: `move_forward/back/left/right`, `interact` (E), `journal` (J), keep `sprint`. Retire FP-only assumptions.
  - Files: `project.godot`.
  - Accept: actions present.
  - DONE-CHECK: prop-equals — actions exist in InputMap.
  - Commit: `B5: input map for top-down`

---

## PHASE C — GREYBOX TRAVERSAL LOOP  *(Ring 0)*
**Phase goal:** the real 5-area loop from the ChatGPT blockout, walkable end to end.
**Exit criteria:** spawn at Shrine, walk the full loop through all 5 areas and back.

- [ ] **C1 — Adopt the blockout** · deps: B4
  - Build: open `scenes/world/ark_layout_blockout.tscn`; confirm 5 grouped area nodes `SpawnShrine`, `GreatTreePlaza`, `ForestPath`, `CrystalRift`, `Observatory` (add any missing).
  - Files: `scenes/world/ark_layout_blockout.tscn`.
  - Accept: 5 area nodes present.
  - DONE-CHECK: node-exists each of the 5.
  - Commit: `C1: adopt greybox blockout`

- [ ] **C2 — Level collision** · deps: C1
  - Build: every walkable surface + ramp has collision; edges blocked. 4 elevations (0/+3/+6/+10, rift −5), ramps ≤20°, paths ≥6m. A tiny level script prints `WORLD_OK` if StaticBody count>0.
  - Files: `scenes/world/ark_layout_blockout.tscn`.
  - Accept: no gaps; can't fall off.
  - DONE-CHECK: runs-logs `WORLD_OK`; node-exists collision per area.
  - Commit: `C2: level collision`

- [ ] **C3 — Main scene wiring** · deps: C2, B4
  - Build: `scenes/world/main.tscn` — instance blockout + player (at SpawnShrine) + camera rig + `WorldEnvironment` + `DirectionalLight3D`. Set main scene. Prints `MAIN_OK`.
  - Files: `scenes/world/main.tscn`, `project.godot`.
  - Accept: boots into a walkable level.
  - DONE-CHECK: runs-logs `MAIN_OK` + `PLAYER_OK` + `CAMERA_OK`.
  - Commit: `C3: main scene`

- [ ] **C4 — Traversal beacons + loop test** · deps: C3
  - Build: an `Area3D` trigger at each of the 5 areas; `scripts/systems/loop_tracker.gd` logs entries and prints `LOOP_COMPLETE` when all 5 visited. Add `scenes/_test/test_loop.gd` that drives the player node through the 5 trigger positions and asserts `LOOP_COMPLETE`.
  - Files: `scripts/systems/loop_tracker.gd`, `scenes/_test/test_loop.gd`, `main.tscn`.
  - Accept: visiting all 5 completes the loop.
  - DONE-CHECK: test-passes `test_loop`.
  - Commit: `C4: loop tracker + test`

---

## PHASE D — RING 0 PLAYABILITY GATE  *(human)*
**Phase goal:** confirm it's actually fun to move before building anything else.

- [ ] **D1 — [HUMAN GATE] Feel check** · deps: C4
  - Build: agent captures 3 screenshots (Shrine, Plaza, Observatory), prints tunables (speed/accel/camera height/angle), STOPS.
  - Accept (Ahmad): walk the loop. Snappy? Camera reads the space? Loop legible? Tune, then mark `[x]` to authorize Ring 1. If it feels bad, iterate B3/B4 first.
  - DONE-CHECK: human sets `[x]`.
  - Commit: `D1: ring-0 gate passed`

---

## PHASE E — MODULAR CHUNK KIT  *(Ring 1)*
**Phase goal:** a reusable kit of parts so the world is built by snapping modules, not sculpting.
**Exit criteria:** ~10 grid-aligned kit pieces exist and assemble into a test structure.

- [ ] **E1 — Kit grid + standards** · deps: D1
  - Build: `kit/README.md` — grid unit (2m), pivot convention (pick one, document), naming (`kit_ground_2x2`, `kit_cliff_wall`, `kit_ramp`, `kit_platform`, `kit_path_straight/corner`). One shared grey material `kit/kit_grey.tres`.
  - Files: `kit/README.md`, `kit/kit_grey.tres`.
  - Accept: standards documented.
  - DONE-CHECK: file-exists both.
  - Commit: `E1: kit standards`

- [ ] **E2 — Core kit pieces (v0)** · deps: E1
  - Build: ≥10 kit `.tscn` per E1, grid-aligned, collision baked, grey: ground tile, cliff wall, 2 ramp angles, platform, path straight/corner/T, step, edge cap.
  - Files: `kit/*.tscn`.
  - Accept: ≥10 pieces, each mesh+collision on grid.
  - DONE-CHECK: file-exists ≥10; node-exists mesh+collision (spot-check 3).
  - Commit: `E2: core kit pieces`

- [ ] **E3 — Kit assembly test** · deps: E2
  - Build: `scenes/_test/kit_demo.tscn` — snap ~15 pieces into a small multi-level structure with a ramp; prove grid alignment, no gaps/z-fighting.
  - Files: `scenes/_test/kit_demo.tscn`.
  - Accept: assembles cleanly.
  - DONE-CHECK: node-exists ≥15 kit instances; visual spot-check.
  - Commit: `E3: kit assembly demo`

---

## PHASE F — REBUILD THE LOOP FROM THE KIT  *(Ring 1)*
**Phase goal:** replace raw greybox boxes with kit pieces — the world is now modular.
**Exit criteria:** the 5-area loop is kit-built and still fully walkable.

- [ ] **F1 — Kit-build the 5 areas** · deps: E3, C4
  - Build: rebuild each area as `scenes/world/level_ark_01.tscn` using kit pieces, preserving layout/elevations/paths; retire raw primitive boxes.
  - Files: `scenes/world/level_ark_01.tscn`.
  - Accept: same loop, modular, collision intact.
  - DONE-CHECK: test-passes `test_loop` (retargeted to the kit level); node-exists kit instances per area.
  - Commit: `F1: kit-built loop`

- [ ] **F2 — Swap main scene** · deps: F1
  - Build: point main scene at the kit level; retire primitive blockout usage (keep file, unreferenced).
  - Files: `main.tscn`, `project.godot`.
  - Accept: game boots the kit level.
  - DONE-CHECK: runs-logs `MAIN_OK`; test-passes `test_loop`.
  - Commit: `F2: main uses kit level`

---

## PHASE G — INTERACTION SYSTEM  *(Ring 1)*
**Phase goal:** Examine / Collect / Activate — the input side of the loop.
**Exit criteria:** walk to an object, press E, correct interaction fires and logs.

- [ ] **G1 — Interactable component** · deps: A3
  - Build: `scripts/components/interactable.gd` — `@export interact_type:{EXAMINE,COLLECT,ACTIVATE}`, `@export id:String`; group `"interactable"`; `interact(by)` emits `interacted(id,type)`.
  - Files: `scripts/components/interactable.gd`.
  - Accept: compiles; joins group.
  - DONE-CHECK: compiles; test-passes `test_interactable`.
  - Commit: `G1: interactable component`

- [ ] **G2 — Interaction sensor on player** · deps: G1, B3
  - Build: extend `InteractionManager` (existing autoload) or player-side ray/`Area3D` — find nearest front `interactable`, show prompt, on `interact` action call `interact(player)`. Prints `INTERACT:<id>`.
  - Files: `scripts/autoloads/interaction_manager.gd`, `scenes/player/player.tscn`.
  - Accept: nearest interactable detected+triggered.
  - DONE-CHECK: test-passes `test_interaction_sensor`.
  - Commit: `G2: interaction sensor`

- [ ] **G3 — Examine writes to Codex** · deps: G2, A3
  - Build: EXAMINE calls `Codex.observe(id)`. Add `scripts/components/observable.gd` (`observable_id` + property dict) so examine records real data.
  - Files: `scripts/components/observable.gd`, interactable wiring.
  - Accept: examine creates a Codex observation.
  - DONE-CHECK: test-passes `test_examine_codex`.
  - Commit: `G3: examine → codex`

---

## PHASE H — CODEX v0 UI  *(Ring 1)*
**Phase goal:** the player can see what they've observed. The journal becomes real.
**Exit criteria:** J opens a panel listing observations; it updates live.

- [ ] **H1 — Journal UI** · deps: G3
  - Build: `scenes/ui/journal.tscn` + `scripts/ui/journal.gd` — toggled by `journal` (J); lists `Codex.observations`; refreshes on `Codex.observed`.
  - Files: `scenes/ui/journal.tscn`, `scripts/ui/journal.gd`.
  - Accept: J opens/closes; shows observations.
  - DONE-CHECK: node-exists journal in main; test-passes `test_journal` (observe 3 → 3 rows).
  - Commit: `H1: codex v0 journal UI`

- [ ] **H2 — Observation hinting** · deps: H1
  - Build: after ≥3 same-type observations, `Codex` emits `pattern_ready(type)`; journal shows a "noticing a pattern…" nudge (no answers — anti-tutorial).
  - Files: `codex.gd`, `journal.gd`.
  - Accept: 3rd same-type obs surfaces a hint.
  - DONE-CHECK: test-passes `test_pattern_hint`.
  - Commit: `H2: pattern hinting`

---

## PHASE I — THE FIRST GATE (understanding → access)  *(Ring 1)*
**Phase goal:** prove the whole Spine end-to-end, once. Observing a thing opens a place.
**Exit criteria:** a blocked path opens only after understanding a specific node.

- [ ] **I1 — Gate node** · deps: A2
  - Build: `scripts/components/gate.gd` + `kit/kit_barrier.tscn` — closed until `@export require_knows:String` (Codex) or `@export require_flag:String` (WorldState); listens to `Codex.node_understood`/`WorldState.flag_changed`; opens (moves/disables collision), prints `GATE_OPEN:<id>`.
  - Files: `scripts/components/gate.gd`, `kit/kit_barrier.tscn`.
  - Accept: opens on condition.
  - DONE-CHECK: test-passes `test_gate`.
  - Commit: `I1: conditional gate`

- [ ] **I2 — First understanding** · deps: I1, G3, H1
  - Build: observable "resonant crystal" in Crystal Rift; 3× examine → `Codex.discover("resonance_basics")`; `Gate(require_knows="resonance_basics")` blocks the Observatory path, opens on discovery. Add `data/codex/resonance_basics.tres`.
  - Files: `level_ark_01.tscn`, `data/codex/resonance_basics.tres`.
  - Accept: understanding opens the Observatory.
  - DONE-CHECK: test-passes `test_first_gate`; runs-logs `GATE_OPEN:observatory`.
  - Commit: `I2: first understanding→gate`

- [ ] **I3 — Ring 1 integration test** · deps: I2, H2
  - Build: `scenes/_test/test_ring1.gd` — move → examine → codex records → pattern hint → discover → gate opens → new area reachable.
  - Files: `scenes/_test/test_ring1.gd`.
  - Accept: whole chain green.
  - DONE-CHECK: test-passes `test_ring1`.
  - Commit: `I3: ring-1 integration test`

---

## PHASE J — MATERIALS & INVENTORY  *(Ring 2 — collect)*
**Phase goal:** collectable materials with hidden properties — raw inputs for experiments.
**Exit criteria:** pick up ≥6 materials; each carries a property set the Codex can learn.

- [ ] **J1 — Material resource** · deps: A3
  - Build: `scripts/resources/material_def.gd` (Resource): `id`, `display_name`, `properties:Dictionary` (density, conductivity, era_tag…), `known_properties:Array`. ≥6 `.tres` in `data/materials/`.
  - Files: `scripts/resources/material_def.gd`, `data/materials/*.tres`.
  - Accept: ≥6 load.
  - DONE-CHECK: file-exists ≥6; test-passes `test_material_load`.
  - Commit: `J1: material defs`

- [ ] **J2 — Inventory** · deps: J1
  - Build: `scripts/autoloads/inventory.gd` — `add/remove/count`, signal `changed`; COLLECT adds. Simple `scenes/ui/inventory.tscn`.
  - Files: `scripts/autoloads/inventory.gd`, `scenes/ui/inventory.tscn`.
  - Accept: collecting adds; UI reflects.
  - DONE-CHECK: test-passes `test_inventory`.
  - Commit: `J2: inventory`

- [ ] **J3 — Material nodes in world** · deps: J2, F1
  - Build: place harvestable material nodes across the loop (kit prop + Interactable COLLECT + Observable); examine reveals one property at a time.
  - Files: `level_ark_01.tscn`.
  - Accept: collectables present; examine reveals properties.
  - DONE-CHECK: test-passes `test_harvest_reveal`.
  - Commit: `J3: world materials`

---

## PHASE K — EXPERIMENT / COMBINE STATION  *(Ring 2 — the heart)*
**Phase goal:** combine/test materials to **discover new Codex nodes** — Infinity-Craft-with-chronology.
**Exit criteria:** valid inputs yield new understanding; invalid combos give informative failure; era-gates hold.

- [ ] **K1 — Combination rules data** · deps: J1
  - Build: `scripts/resources/reaction_def.gd` — `inputs:Array[String]`, `conditions:Dictionary` (heat/pressure/era), `result_node:String`, `byproducts`. ≥5 reactions in `data/reactions/`; ≥1 era-gated (requires a prior understanding = chronology).
  - Files: `scripts/resources/reaction_def.gd`, `data/reactions/*.tres`.
  - Accept: ≥5 load; ≥1 era-gated.
  - DONE-CHECK: file-exists ≥5; test-passes `test_reaction_load`.
  - Commit: `K1: reaction defs`

- [ ] **K2 — Experiment engine** · deps: K1, A3
  - Build: `scripts/systems/experiment.gd` — `run(inputs, conditions)->Result`. Match → `Codex.discover(result_node)` + byproducts; no match → informative failure + record the attempt (failure is data); era-gates enforced via `Codex.knows`.
  - Files: `scripts/systems/experiment.gd`.
  - Accept: success / informative-fail / era-gate-block all correct.
  - DONE-CHECK: test-passes `test_experiment` (all three cases).
  - Commit: `K2: experiment engine`

- [ ] **K3 — Combine station UI** · deps: K2, J2
  - Build: `scenes/ui/experiment_station.tscn` — ACTIVATE interactable; select inputs from inventory, set conditions, run; shows result + new node. Prints `DISCOVER:<node>`.
  - Files: `scenes/ui/experiment_station.tscn`, station script, `level_ark_01.tscn`.
  - Accept: player can run experiments.
  - DONE-CHECK: node-exists station; test-passes `test_station_flow`; runs-logs `DISCOVER:`.
  - Commit: `K3: combine station`

---

## PHASE L — CODEX v1: KNOWLEDGE GRAPH  *(Ring 2)*
**Phase goal:** upgrade the Codex from a list to a real graph — nodes, links, confidence.
**Exit criteria:** discoveries form a navigable graph with suspected/tested/understood states + cross-links.

- [ ] **L1 — KnowledgeNode resource** · deps: A3
  - Build: `scripts/resources/knowledge_node.gd` — `id`, `name`, `summary`, `links:Array[String]`, `confidence:{SUSPECTED,TESTED,UNDERSTOOD}`, `unlocks:Array`. Author near-term nodes in `data/codex/`.
  - Files: `scripts/resources/knowledge_node.gd`, `data/codex/*.tres`.
  - Accept: nodes load with links.
  - DONE-CHECK: file-exists; test-passes `test_knowledge_load`.
  - Commit: `L1: knowledge node resource`

- [ ] **L2 — Codex graph model** · deps: L1, A3
  - Build: extend `Codex` to store `KnowledgeNode`s; raise confidence with evidence (observe→SUSPECTED, experiment→TESTED, confirm→UNDERSTOOD); auto-link; fire `node_understood` only at UNDERSTOOD; understanding can bump linked nodes.
  - Files: `codex.gd`.
  - Accept: confidence rises; links propagate.
  - DONE-CHECK: test-passes `test_codex_graph`.
  - Commit: `L2: codex graph model`

- [ ] **L3 — Codex graph UI** · deps: L2, H1
  - Build: upgrade journal into a node-graph — nodes colored by confidence, links drawn, click for detail + suggested next experiments (nudges, not answers).
  - Files: `scenes/ui/codex_graph.tscn`.
  - Accept: graph renders, reflects confidence, navigable.
  - DONE-CHECK: node-exists graph UI; test-passes `test_graph_ui`.
  - Commit: `L3: codex graph UI`

---

## PHASE M — APPLY: TOOLS FROM UNDERSTANDING  *(Ring 2)*
**Phase goal:** understanding grants capability that changes the world — closes the loop.
**Exit criteria:** an UNDERSTOOD node unlocks a tool/ability that opens ≥2 new things.

- [ ] **M1 — Ability/tool from node** · deps: L2
  - Build: `scripts/systems/unlocks.gd` — when a node hits UNDERSTOOD with `unlocks`, grant the tool/ability (e.g. "resonance lens" revealing hidden properties, or a tool opening a gate class) + set `WorldState` flags.
  - Files: `scripts/systems/unlocks.gd`.
  - Accept: understanding grants a real capability.
  - DONE-CHECK: test-passes `test_unlock`.
  - Commit: `M1: unlocks from understanding`

- [ ] **M2 — Two new accesses** · deps: M1, I1, J3
  - Build: gate ≥2 previously-blocked things behind the ability (locked cache + hidden path); reaching them yields new materials that feed new experiments (loop restarts at higher complexity).
  - Files: `level_ark_01.tscn`.
  - Accept: ability opens ≥2 new things that extend play.
  - DONE-CHECK: test-passes `test_apply_reaccess`.
  - Commit: `M2: understanding opens the world`

---

## PHASE N — THE VERTICAL SLICE + GO/NO-GO  *(Ring 2 — human)*
**Phase goal:** one region, one full loop, fun enough to want a second run. **The project's go/no-go.**
**Exit criteria:** a naive player completes observe→collect→experiment→understand→apply and re-engages.

- [ ] **N1 — Slice polish + content pass** · deps: M2, L3, K3
  - Build: make the Great Tree Plaza + Crystal Rift region loop-complete — ≥6 materials, ≥5 reactions, ≥6 nodes, 2 gates, 1 station, 1 ability. Tune pacing. Minimal SFX/feedback on discover.
  - Files: `level_ark_01.tscn`, audio hooks.
  - Accept: region is a coherent, complete loop.
  - DONE-CHECK: test-passes `test_full_loop` (spawn→observe→collect→combine→discover→unlock→reaccess).
  - Commit: `N1: vertical slice complete`

- [ ] **N2 — [HUMAN GATE] Is this a game?** · deps: N1
  - Build: agent produces a 60–90s scripted flythrough/screenshots + a loop summary, STOPS.
  - Accept (Ahmad): play cold. Complete the loop unaided? Want to do it again? YES → `[x]`, Ring 3 opens. NO → log what's missing; iterate J–M. **Do not build Phase O until `[x]`.**
  - DONE-CHECK: human sets `[x]`.
  - Commit: `N2: vertical slice gate`

---

## PHASE O — THE ARK (EXPAND)  *(Ring 3 — coarse until N passes)*
**Phase goal:** scale the proven loop across the island using the design bible, modular + top-down.
**Exit criteria:** ≥3 more regions, each a loop location, connected into one island.
> Re-detail into A5-style goals AFTER N2.
- [ ] **O1 — Region template** · deps: N2 · extract the slice into a reusable region pattern (materials+reactions+nodes+gate+station).
- [ ] **O2 — Mine district content** · deps: O1 · ≥3 districts from `ARK-OF-GENESIS-DISTRICT-DESIGN.md` + materials from `RESOURCE-ECOLOGY.md`, built modularly.
- [ ] **O3 — Landmarks as loop anchors** · deps: O2 · adapt key landmarks from `LANDMARK-CATALOGUE.md` as discovery hubs.
- [ ] **O4 — Island connective traversal** · deps: O3 · link regions; cross-region gates use Codex nodes.
- [ ] **O5 — Save/load** · deps: O1 · persist Codex + WorldState + inventory + world flags.

---

## PHASE P — A WORLD THAT REACTS  *(Ring 4 — coarse)*
**Phase goal:** light life — time, weather, simple ecology — so the world isn't static.
**Exit criteria:** day/night visibly runs; ≥1 ecological reaction to player action.
- [ ] **P1 — Day/night** · deps: O1 · drive `TimeManager` into visible sun/ambient changes.
- [ ] **P2 — Weather flavor** · deps: P1 · flesh out `WeatherController` — a couple of states affecting look + 1 gameplay variable.
- [ ] **P3 — Ecology-lite** · deps: O2 · harvest→regen, plant→grow, one keystone reaction. (Cherry-pick `WORLD-SIMULATION-DESIGN.md`; NOT the full engine.)

---

## PHASE Q — ASPIRATIONAL  *(Ring 5 — flagged, likely trimmed for 2 people)*
**Phase goal:** the dream layer. Only if O–P are a real, played game.
- [ ] **Q1 — NPCs + teaching** · deps: O · NPCs that adopt taught knowledge.
- [ ] **Q2 — Async notes / signs** · deps: O · leave/read notes (multiplayer-lite).
- [ ] **Q3 — Deep time / long sleep** · deps: P · time-skip that mutates world state.
- [ ] **Q4 — Civilization sim** · deps: Q1 · from `CIVILIZATION-ENGINE-DESIGN.md`. **Honestly: probably cut.**
- [ ] **Q5 — Dracula memory arc** · deps: O · protagonist/narrative from `PLAYER-ARCHITECTURE-DESIGN.md` + `TIMELINE.md`.

---

## PHASE Z — SHIP
**Phase goal:** a packaged, runnable build.
- [ ] **Z1 — Export presets** · deps: N2 · Godot export (Linux/Windows); release build runs.
- [ ] **Z2 — Build docs** · deps: Z1 · `BUILD.md` from clean checkout → runs.
- [ ] **Z3 — Perf pass** · deps: O4 · stable FPS, sane draw calls at top-down distances.

---

# PART IV — REFERENCE

## Reconciliation ledger (rulings are final)
| Conflict | Docs said | Reality/chat said | RULING |
|---|---|---|---|
| Camera | first-person | 45° top-down | **top-down (D1)** |
| World build | terrain-first sculpt | modular chunks | **modular (D2)** |
| Scope | AAA 89-task, 3 sim engines | "one dev, ship something playable" | **Rings; docs=bible** |
| Protagonist | Dracula vampire arc | (n/a) | **deferred to Phase Q** |
| First build | build the island | first 10 min of movement | **Phase B/C traversal (D3)** |

## Quarantine — never edit or extend (dead terrain-first lane)
`scenes/world/ark_genesis/**`, terrain meshes, the 8 terrain district scenes, `PRODUCTION-ROADMAP.md` as a *plan* (mine content only), `ARK-OF-GENESIS-TOPOGRAPHY.md`. Keep for reference; build nothing on them.

## Doc index (mine on demand)
VISION (always/filter) · GAMEPLAY-ARCHITECTURE Ch.4 (Phase G–N loop) · CODEX-SYSTEMS-DESIGN (Phase A/H/L) · RESOURCE-ECOLOGY (Phase J/K) · ASSET-MANIFEST (kit naming, Phase E) · TRAVERSAL-BLUEPRINT (Phase C) · DISTRICT-DESIGN + LANDMARK-CATALOGUE + ISLAND-BLUEPRINT (Phase O) · WORLD-SIMULATION (Phase P, cherry-pick) · CIVILIZATION-ENGINE + PLAYER-ARCHITECTURE + TIMELINE (Phase Q) · GODOT-PRODUCTION-ARCHITECTURE (structure, always) · `docs/_source-chatgpt-chat.json` (archive).

## Two-person split
Suggested: **friend → World track** (Phases E, F, O — kit + level), **Ahmad → Codex/mechanic track** (Phases G–M — loop). Meet at the contracts in Part I (Gate/Interactable/Observable/KnowledgeNode). The autonomous agent can run either track; keep it on one phase at a time.

## The "should we build this now?" gate (humans adding scope)
1. In the current phase? 2. Passes the Connection Test? 3. Serves "understanding unlocks capability"? 4. Game still playable after? 5. Doable top-down + modular by the AI? — First "no" = defer.

## Never build (VISION anti-goals)
hunger/thirst grind · recipe checklists · quest markers/objective log · XP/levels/skill trees · anything that tells the player what they could have observed.

---

*Dev Brain v2.1 — ratified 2026-07-08. Build plan supersedes PRODUCTION-ROADMAP.md; pipeline supersedes the ChatGPT session; per-goal build discipline follows e4coder's seven-phase methodology (Part II.5). Phases A–N are the committed near-term; O–Z are re-detailed after the Phase N go/no-go. Update this file first, deliberately, before changing course.*
