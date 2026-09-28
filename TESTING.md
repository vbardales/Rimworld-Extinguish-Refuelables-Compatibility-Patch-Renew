# Testing

How this mod is tested, which passes it needs, and what evidence is kept. Nothing here has been run in
a game yet: every in-game line below is `unverified`, not a pass.

## Layers

| Layer | Where | Runs | Proves |
|---|---|---|---|
| XML contracts | `_tools/Test-Xml.ps1` | offline | Every patch operation against contract fixtures, 16 target-mod and DLC combinations, guards, comp order, preserved size and offset. |
| Installed defs | `_tools/Test-InstalledMods.ps1` | offline | The same against the raw defs of the installed target mods. **Needs Medieval Overhaul in the Steam workshop folder, which it is not at the moment**, so its ten targets are unverified since 2026-09-28. |
| C# behaviour | `_tools/Test-Behaviour.ps1` | offline | The one comp class, compiled from the real source against test doubles: 72 cases, fuel and switch, all four rotations, the height nudge, the growth timer. |
| Pickle | `Tests/Pickle/` | in game | The patches in the real def database, one switch on each of the 13 buildings, the swapped overlay class, the drawn flame in four facings, save and reload. A local step DLL (`Tests/Pickle/Source`, built 2026-09-28, compiles against the Pickle reference package) supplies the switch, overlay and rotation steps. See `Tests/Pickle/README.md`. |

## Passes a full validation needs

1. **sans-facultatifs**: no map. Continued alone.
2. **avec-facultatifs**: `wsl-deps.avec-facultatifs.map`. Medieval Overhaul, Classical and Medieval 2.
   They are not incompatible with one another, so no split is needed.
3. **sans-ideology**: `wsl-deps.sans-ideology.map`, filter `@sans-ideology`.
4. **incompatibility with Keshash's original patch**: `incompatibleWith` declares
   `Keshash.ExtinguishRefuelablesPatch`. **No pass and no scenario yet.** The original stops at 1.4 and
   depends on `malistaticy.mer`, which has not existed since Extinguish Refuelables was continued, so
   the first thing to read is what the game does with it beside this mod. Its symptom is not known, and
   is to be observed once, then asserted (an `an error matching` step under `@allow-errors`), not guessed.

Languages: no French or English pass. The mod adds no text, see the translation audit in `STATUS.md`.

## The 17 manual scenarios, and where each one goes

`_tools/FUNCTIONAL-SCENARIOS.md` stays as the detailed description. For `tested`, none may remain a
manual check to tick: each is automated and green, or listed here as not applicable with its reason.

| # | Scenario | Disposition |
|---|---|---|
| 0 | It loads and the patches take | Pickle 01, first scenario, in passes 1 and 2. |
| 1 | Every building gets a switch | Pickle 03: all thirteen spawned, each read for exactly one `CompFlickable`, plus the swapped overlay class on the fire defs. No gizmo label is assumed. Pickle 02 clicks the real gizmo on one brazier. |
| 2 | The switch stops fuel, light and heat | Not applicable: vanilla's own comps read `CompFlickable`. Not this mod's code. |
| 3 | The flame graphic goes out | Pickle 02 (brazier) and Pickle 04 (stove and hearth) `@review`, each captured lit then switched off. The torch and the Medieval 2 hearth captures are **open**. |
| 4 | Heat stones, switch and no flame | Pickle 01 (patched). No capture: there is no flame to see. |
| 5 | North-only rule | Pickle 04: four facings each of stove and hearth, `@review` captures, facing asserted. The flame itself is judged by eye, so it stays open until the images are opened. Covered offline by 72 cases. |
| 6 | The switch still works on them | Pickle 04: each facing is switched off and captured, and the switch state is read back. Same `@review` limit as 5. |
| 7 | Def flame size and offset still apply | **Open**: a comparison of two captures by eye, `@review` at best. |
| 8 | Growth timer starts when lit | Not applicable: no shipped def sets `fireGrowthDurationTicks`. Offline cases cover it. |
| 9 | Darklight hearth with Ideology | Pickle 01 (patched, pass 2). |
| 10 | Without Ideology | Pickle 01 `@sans-ideology`, pass 3. |
| 11 | None of the three target mods | Pickle 01, first scenario, pass 1. |
| 12 | One target mod at a time | Not applicable: pass 2 names each def, so a failing file is already identified. |
| 13 | No collision with Continued | Pickle 01 last scenario: Continued still patches its own building. Two switches on one building is asserted offline (single switches, no shared defName). |
| 14 | Save, reload, state holds | Pickle 02 second scenario, `@review`. |
| 15 | Adding the mod to a save in progress | **Open.** Needs a fixture made without the mod that holds the buildings. |
| 16 | Removing the mod from a save in progress | **Open.** The test companion depends on the mod, so `-ThenWithout` cannot remove it. |

The open rows, and the unrun passes above, are what stands between this mod and `tested`.

## Evidence

Reports land in `Tests/Pickle/Evidence/<run>/` through the launcher's `-EvidenceDir`, ignored by git.
After each run, read `exitReason`, then keep only:

- the **latest report for the revision now in the repository**, per pass;
- an older one only if it is the sole proof of a check the latest run did not repeat;
- captures of `@review` scenarios that were actually opened and judged, minified;
- `summary.md` and `junit.xml` of each kept report.

Delete everything else, list what goes before deleting, and never delete a file `STATUS.md` still
points to (repoint it first). A report about a superseded build proves nothing about the current one.
History is one text line per run in `docs/runs/`, never folders.
