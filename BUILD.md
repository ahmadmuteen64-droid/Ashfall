# Aperture — Build Guide

## Prerequisites
- Godot 4.7+ (GL Compatibility renderer)
- Git

## Quick Start
```bash
git clone <repo-url> aperture
cd aperture
godot --editor .
```

Open `scenes/world/main.tscn` and press F5 (Play).

## Export
### Linux
```bash
godot --headless --export-release "Linux/X11" build/linux/aperture.x86_64
```
### Windows
```bash
godot --headless --export-release "Windows Desktop" build/windows/aperture.exe
```

## Project Structure
```
scripts/
  autoloads/   — Codex, WorldState, Inventory, TimeManager, WeatherController, SaveSystem
  components/  — Player controller, camera, interactable, gate, observable, memory_fragment
  systems/     — Experiment engine, loop tracker, ecology, unlocks, region builder
  resources/   — MaterialDef, ReactionDef, KnowledgeNode
  ui/          — Journal, inventory, experiment station
scenes/
  world/       — Main, level_ark_01, region_template
  player/      — Player body + camera rig
  ui/          — Journal, inventory, experiment station
  _test/       — Unit tests
data/
  codex/       — Knowledge node definitions
  materials/   — Material definitions
  reactions/   — Reaction definitions
kit/           — Reusable modular world pieces
```

## Key Bindings
- WASD — Move (camera-relative)
- SHIFT — Sprint
- SPACE — Jump / Double-jump
- E — Interact (examine/collect/activate)
- J — Toggle journal

## Architecture
All game state flows through three autoloads: Codex (knowledge), WorldState (flags), Inventory (items).
The Spine: Observe World → Write to Codex → Codex unlocks gates/tools → World changes.
