# The Face Collector

A 3D psychological horror game built in Godot 4, told through a fixed-camera, PS2-era visual style. This repository holds an early prototype build of the project — systems, narrative structure, and combat/stealth loop are still being iterated on for the current version (in active development on a different codebase).

## Story

Harry, a soldier who fell into a coma near the end of a war, wakes up in an abandoned hospital — years too late. While he was unconscious, his wife Lena and daughter Alice both died. The player pieces together what happened to them through **audio tapes** (Lena) and **diaries** (Alice), found while exploring the family's deteriorated house.

The Collector, the game's central threat, isn't a straightforward villain — it's a symbolic manifestation of the war itself, and of Harry's own guilt: a squad of five soldiers under his command, civilians he was forced to manipulate, whose fate is uncovered gradually through the puzzles and scripted events in the basement sequence.

**Recognition:** Top 2 (global) in Horror and Top 1 in Sound Design, Hawktobers Jam 2024.

## Core Systems (this build)

- **Entities** — dedicated player, `Collector`, and `Stalker` (patrol/chase) entity folders, each with their own state and behavior scripts.
- **Interactable framework** — a generic `interactable.gd` / `interaction_trigger.gd` pair drives all world interactions (furniture, items, scripted events), decoupling "can this be interacted with" from "what happens when it is."
- **Scripted events** — chapter-scoped event scripts (`scripted-events/Chapter1`, `Chapter2`) for one-off narrative beats (jumpscares, audio-tape triggers) without hardcoding them into level scenes.
- **Flashback system** — a separate scene flow (`main-scenes/Flashbacks`) plays back the tape/diary sequences that reveal Lena and Alice's story.
- **Puzzles** — self-contained puzzle modules (e.g. `basement_portraits_puzzle`) with their own state, independent from the main interaction loop.
- **Localization** — full English/Spanish text tables for dialogue and UI (`LOCATION/*.en.translation`, `*.es.translation`), driven from CSV source files.
- **Signal-based architecture** — a global `SIGNALBUS` autoload decouples systems (UI, audio, events) from direct node references, alongside `GAMEMANAGER`/`GAMESTATE` for run state.

## Status

This build predates the current version of The Face Collector, which has since moved to a third-person, fixed-camera structure with puzzles as the central mechanic and a deeper rework of the combat/stealth loop. It's kept here as a reference for the systems and narrative groundwork the current version builds on.

## Requirements

- Engine: Godot 4.x
- Open the project root from the Godot Project Manager.
