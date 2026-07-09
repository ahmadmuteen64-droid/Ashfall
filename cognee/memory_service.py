#!/usr/bin/env python3
"""
AshFall Cognee Memory Service
=============================
Persistent AI memory layer for the AshFall Godot game.
Uses Cognee knowledge graph + DeepSeek LLM for entity extraction,
relationship mapping, and semantic search over game state.

Run modes:
  --serve    Start HTTP API server (godot_ai MCP connects here)
  --index    Ingest game data files into the knowledge graph
  --query    Run a single search query
  --reset    Wipe and rebuild the knowledge graph
"""

import asyncio
import os
import sys
from pathlib import Path

import cognee
from cognee import SearchType
from dotenv import load_dotenv

# ── Config ──────────────────────────────────────────────
PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_ROOT / "data"
DOCS_DIR = PROJECT_ROOT / "docs"
EXTERNAL_DOCS = Path("/home/iama/Documents/docs")  # primary design docs

load_dotenv(Path(__file__).resolve().parent / ".env")

DATASET = "ashfall"

# ── Identity seed ───────────────────────────────────────
IDENTITY_FACTS = [
    "Aperture and AshFall are the same project. Aperture was the original codename; AshFall is the current name.",
    "This is a Godot 4.7 3D game with Jolt Physics, GL Compatibility renderer, and the godot_ai MCP plugin.",
    "The Lord Commander (Ahmad) is the sole developer and owner of this project.",
    "The game is set in a post-apocalyptic world called the Ark of Genesis — a shattered dome civilization.",
    "Core systems: WorldState autoload, Codex knowledge system, Inventory, SaveSystem, TimeManager, WeatherController.",
]


# ── Core API ────────────────────────────────────────────

async def index_game_data(include_project_sources: bool = False):
    """Ingest design docs and identity.

    The external design docs are always indexed. In-project sources (docs/,
    data/*.tres, scripts/*.gd) cost extra extraction spend and are opt-in via
    --all. .drawio mindmaps are excluded: they are mxGraph XML, so the
    extractor pays for geometry and edge ids to recover a few node labels.
    """
    paths = []

    # Identity seed — Aperture = AshFall (fed as raw facts)
    for fact in IDENTITY_FACTS:
        await cognee.add(
            fact,
            dataset_name=DATASET,
            node_set=["identity", "project_meta"],
        )
    print(f"Seeded {len(IDENTITY_FACTS)} identity facts.")

    # Primary: external design docs (/home/iama/Documents/docs)
    if EXTERNAL_DOCS.exists():
        for md in EXTERNAL_DOCS.rglob("*.md"):
            paths.append(str(md))

    if include_project_sources:
        if DOCS_DIR.exists():
            for md in DOCS_DIR.glob("*.md"):
                paths.append(str(md))

        if DATA_DIR.exists():
            for tres in DATA_DIR.rglob("*.tres"):
                paths.append(str(tres))

        scripts_dir = PROJECT_ROOT / "scripts"
        if scripts_dir.exists():
            for gd in scripts_dir.rglob("*.gd"):
                if gd.stat().st_size < 50_000:
                    paths.append(str(gd))

    print(f"Indexing {len(paths)} files into dataset '{DATASET}'...")
    await cognee.add(paths, dataset_name=DATASET)
    await cognee.cognify(datasets=DATASET)
    print("Indexing complete. Knowledge graph built.")


async def query_memory(question: str, top_k: int = 5):
    """Search the AshFall knowledge graph."""
    results = await cognee.search(
        question,
        query_type=SearchType.GRAPH_COMPLETION,
        datasets=DATASET,
        top_k=top_k,
    )
    return results


async def add_fact(text: str, node_set: list[str] | None = None):
    """Add a single fact or observation to the graph."""
    await cognee.add(
        text,
        dataset_name=DATASET,
        node_set=node_set or ["gameplay"],
    )
    await cognee.cognify(datasets=DATASET)


async def reset_graph():
    """Wipe and rebuild."""
    # Cognee prunes by dataset
    print(f"Pruning dataset '{DATASET}'...")
    await cognee.prune(datasets=DATASET)
    print("Reset complete.")


# ── CLI ─────────────────────────────────────────────────

async def main():
    if "--reset" in sys.argv:
        await reset_graph()
    elif "--index" in sys.argv:
        await index_game_data(include_project_sources="--all" in sys.argv)
    elif "--query" in sys.argv:
        q = " ".join(a for a in sys.argv[2:] if not a.startswith("--"))
        if not q:
            print("Usage: memory_service.py --query <question>")
            return
        results = await query_memory(q)
        print(results)
    elif "--serve" in sys.argv:
        print("HTTP serve mode — not yet implemented. Use direct Python calls.")
    else:
        # Default: quick smoke test
        print("AshFall Cognee Memory Service")
        print(f"  LLM: {os.getenv('LLM_PROVIDER')} / {os.getenv('LLM_MODEL')}")
        print(f"  Dataset: {DATASET}")
        print("  Commands: --index | --query | --reset | --serve")
        print("  Running smoke test...")
        await add_fact(
            "Player discovered the Shattered Dome landmark in the Atrium district.",
            node_set=["exploration", "landmarks"],
        )
        results = await query_memory("What landmarks has the player discovered?")
        print(f"  Smoke test result: {results}")


if __name__ == "__main__":
    asyncio.run(main())
