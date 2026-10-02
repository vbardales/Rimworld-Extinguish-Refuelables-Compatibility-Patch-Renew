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
- that the drawn flame really goes out, which is a picture (`02-switch-in-game.feature` and `04-north-only.feature`, `@review`);
- that every one of the thirteen buildings carries exactly one switch (`03-every-building.feature`);
- that a switched-off building survives a save and reload.

Not written, with the reason: fuel, light and heat stopping when the switch is off is vanilla's
`CompRefuelable`, `CompGlower` and `CompHeatPusher` reading `CompFlickable`, not this mod's code
(the game's behaviour, not the mod's).

`Source/` builds the one local step DLL the suite needs (`Mod/Pickle/Assemblies`, tracked, rebuilt
with `dotnet build -c Release Source/ExtinguishRefuelablesPatch.PickleSteps.csproj`): it reads the
switch off a spawned building, reads the overlay class off a def, and rotates a spawned building,
which no built-in step does. It compiles against the Pickle reference package; it has not run.

## Passes

| Pass | Command shape | Establishes |
|---|---|---|
| sans-facultatifs | no `-DepMap`, `-Filter '<suite>,!@sans-ideology,!@incompat-keshash'` | The mod loads with Continued alone and reports nothing. Most scenarios are skipped by `@requires`: a skip is not a pass. |
| avec-facultatifs | `-DepMap wsl-deps.avec-facultatifs.map`, same filter | The thirteen buildings are patched, each has one switch, the flames go out, a save round-trips, and the mod added to a save works (features 01 to 06). The three target mods are not incompatible with one another, so one pass covers them. |
| retrait | `-DepMap wsl-deps.avec-facultatifs.map -Filter '07-remove-mod::write' -Then '07-remove-mod::read' -ThenWithout nelim.extinguishrefuelablescompatibilitypatch` | A save written with the mod loads with it taken out, and the buildings lose their switch. Two launches, one request. |
| sans-ideology | `-DepMap wsl-deps.sans-ideology.map`, `-Filter '@sans-ideology'` | The `MayRequire` guard holds when the DLC is absent. |
| incompat-keshash | `-DepMap wsl-deps.incompat-keshash.map`, `-Filter '@incompat-keshash'` | The declared incompatibility still behaves as declared. The symptom asserted is a prediction. |
| gallery | `-DepMap wsl-deps.gallery.map`, `-Filter '@gallery'` | The three Workshop gallery pictures (`09-gallery.feature`), taken in the screenshot studio. `@review` only: nothing is asserted about the image, somebody opens every one. Skipped by `@requires` in the other passes. |

`<suite>` is the companion's display name, `Extinguish Refuelables Compatibility Patch - Pickle tests`.
English and French passes are **not** run: the mod adds no text (see `STATUS.md`, translation audit),
so the language would change nothing this suite can observe.

## Evidence

Reports go to `Tests/Pickle/Evidence/<run>/` through the launcher's `-EvidenceDir`. That folder is
ignored by git. What to keep after a run, and delete otherwise, is in `TESTING.md`.
