# Pickle suite: Extinguish Refuelables Compatibility Patch Renew

Development only, never published, kept outside `Mod/`. Written on 2026-09-28 against Pickle's own
step catalogue (fetched from GitHub main that day, **not established as the staged Pickle's
version**) and the shared authoring guide. **None of it has been run.**

## What needs a running game, and what does not

The offline scripts in `_tools/` already prove, without the engine: every patch operation against
contract fixtures (16 target-mod and DLC combinations), the raw installed defs, and the one C# class
against test doubles (72 cases, including all four rotations). What only a running game shows:

- that the patches take in the **real** def database, after every other mod's patches and the real
  load order (`01-load-and-patches.feature`);
- that the drawn flame really goes out, which is a picture (`02-switch-in-game.feature`, `@review`);
- that a switched-off building survives a save and reload.

Not written, with the reason: fuel, light and heat stopping when the switch is off is vanilla's
`CompRefuelable`, `CompGlower` and `CompHeatPusher` reading `CompFlickable`, not this mod's code
(the game's behaviour, not the mod's). A south-, east- or west-facing stove has no built-in step to
rotate a spawned building: the rule is covered offline by the 72 cases, and an in-game capture would
need a local C# step, listed in `TESTING.md` as still open.

## Passes

| Pass | Command shape | Establishes |
|---|---|---|
| sans-facultatifs | no `-DepMap`, `-Filter '<suite>,!@sans-ideology'` | The mod loads with Continued alone and reports nothing. Most scenarios are skipped by `@requires`: a skip is not a pass. |
| avec-facultatifs | `-DepMap wsl-deps.avec-facultatifs.map`, `-Filter '<suite>,!@sans-ideology'` | The thirteen buildings are patched and the switch works. The three target mods are not incompatible with one another, so one pass covers them. |
| sans-ideology | `-DepMap wsl-deps.sans-ideology.map`, `-Filter '@sans-ideology'` | The `MayRequire` guard holds when the DLC is absent. |

`<suite>` is the companion's display name, `Extinguish Refuelables Compatibility Patch - Pickle tests`.
English and French passes are **not** run: the mod adds no text (see `STATUS.md`, translation audit),
so the language would change nothing this suite can observe. The declared incompatibility with
Keshash's original patch has **no pass yet**; see `TESTING.md`.

## Evidence

Reports go to `Tests/Pickle/Evidence/<run>/` through the launcher's `-EvidenceDir`. That folder is
ignored by git. What to keep after a run, and delete otherwise, is in `TESTING.md`.
