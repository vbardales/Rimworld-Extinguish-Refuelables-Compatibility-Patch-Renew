# Changelog

All notable changes to this mod are documented here.

## [1.0.0] — 2026-09-05

First release. Port of Keshash's **Extinguish Refuelables Compatibilty Patch** to RimWorld 1.6.

### Fixed

- Every class name in every patch file. Three namespaces had been renamed upstream without
  notice, and a `PatchOperationAttributeSet` whose XPath names a class that no longer exists
  matches nothing and fails silently:
  `MaliExtinguishRefuelables.` → `ExtinguishRefuelables.` (the mod was continued under a new
  name, and the assembly went from `MaliExtinguishRefuelables.dll` to
  `ExtinguishRefuelablesContinued.dll`), `DankPyon_MedievalOverhaul.` → `MedievalOverhaul.`,
  `VanillaFurnitureExpanded.` → `VEF.Buildings.`.
- Each patch file was one `PatchOperationFindMod` wrapping one `PatchOperationSequence`. A
  sequence **stops** at the first operation that fails rather than skipping it, so one dead
  `defName` silenced every operation after it — in the Medieval Overhaul file, the stove's
  attribute set was third of six and the wall torch three later never got its switch. Each group
  is now its own top-level `Operation`: independent, and each still reports its own failure by
  name and file. `<success>Always</success>` on the sequence was **not** the fix — it is read in
  `PatchOperation.Apply`, clears `neverSucceeded`, and stops `Complete()` reporting anything
  without restoring the skipped run.
- `VE_Vikings_Patch.xml` was guarded by `<li>Vanilla Factions Expanded - Classical</li>`, copied
  from the Classical file and never changed. With Vikings but not Classical the file did nothing;
  with both, it ran and failed. Moot now that the Vikings patch targets Medieval 2, but it is the
  fault the port was watching for: `PatchOperationFindMod` compares the mod's **name**, not its
  `packageId`, and every name here was read out of the target's own `About.xml` and compared on
  raw bytes.
- `CompFireOverlaySouthExtinguishable` (was `Comp_FireOverlaySouthAndExtinguishable`): dropped
  `if (!flickableComp.SwitchIsOn && flickableComp != null) refuelableComp.Props.fuelConsumptionPerTickInRain = 0f;`.
  The null check came after the dereference, `refuelableComp` was not checked at all, and `Props`
  is the **def's** comp properties, shared by every instance — placing one switched-off stove
  would have zeroed rain fuel drain for every stove in the colony for the rest of the session,
  irreversibly. It aimed at a real gap (vanilla's `CompRefuelable.CompTick` drains
  `fuelConsumptionPerTickInRain` without consulting `CompFlickable`), but neither
  `DankPyon_WoodBurningStove` nor `DankPyon_RusticHearth` declares that field, so it never did
  anything but risk a crash. The gap belongs to Extinguish Refuelables, which has it on the base
  game's own torches too.

### Changed

- `packageId` from `Keshash.ExtinguishRefuelablesPatch` to `nelim.extinguishrefuelablespatch`,
  and `Keshash.ExtinguishRefuelablesPatch` declared in `<incompatibleWith>`: both patch the same
  defs.
- `<supportedVersions>` set to 1.6. Name corrected to *Compatibility*.
- The dependency on `malistaticy.mer` updated to `blacktriple.extinguishrefuelablescontinued`.
  It was never a third mod — that was Extinguish Refuelables' own `packageId`, as the
  `<displayName>` beside it said — and continuing the mod changed it, so the declaration as
  written asked the player for a mod that no longer exists under that name.
- The dependency on `oskarpotocki.vanillafactionsexpanded.core` **dropped**. See below.
- The Vanilla Factions Expanded - Medieval and - Vikings patches replaced by one for **Vanilla
  Factions Expanded - Medieval 2**. Both of those mods stop at 1.4 — no `1.5` or `1.6` folder —
  and their content was folded into Medieval 2, where the Vikings hearth survives as
  `VFEM2_Hearth` with the same comps. `VFEV_FuneralPyre`, `VFEM_Candle` and `VFEM_WallTorchLamp`
  did not make the move; Medieval 2's full set of refuelable buildings was read to confirm it.
- `DankPyon_CandleStand_Beeswax` dropped from the Medieval Overhaul list: present in that mod's
  `1.4` folder, in neither `1.5` nor `1.6`.
- `DankPyon_WallTorch` now has its vanilla `CompProperties_FireOverlay` swapped for the
  extinguishable one, instead of VFE's rotatable overlay. Medieval Overhaul moved it, because
  **RimWorld 1.6's own `CompProperties_FireOverlay` gained `offsetNorth`, `offsetSouth`,
  `offsetWest`, `offsetEast` and `DrawOffsetForRot`** — rotation-aware fire is a base-game
  feature now, and the def sets all four offsets.
- `CompFireOverlaySouthExtinguishable` now derives from vanilla's `CompFireOverlay` instead of
  from `ThingComp`. `Graphic_Flicker.DrawWorker` looks for a `CompFireOverlayBase` on the thing
  it draws and reads `FireSize` and `Props.DrawOffsetForRot(rot)` off it, so the def's own
  `fireSize` and `offset` are honoured — the original comp was not one, and had to redeclare
  those fields by hand for nothing to read them. The north-only rule and the `3f/74f` height
  nudge are unchanged; both were checked at the IL level against
  `MedievalOverhaul.Comp_FireOverlaySouth`.
- The fire growth timer starts on the first tick the fire is actually alight, where the original
  started it on fuel alone. Inert for these two defs — neither sets `fireGrowthDurationTicks` —
  but it is what the class claims to do.
- Assembly and namespace renamed from `RefuelablesPatch` to `ExtinguishRefuelablesPatch`. No save
  data refers to either: comp classes are named in defs, which are rebuilt from the patches at
  every load.

### Added

- `VFEM2_HearthDarklight`, the Ideology twin of the Medieval 2 hearth — the same furniture,
  differing only in `CompProperties_DarklightOverlay`, for which Extinguish Refuelables ships
  `CompProperties_DarklightOverlayExtinguishable`. It lives behind Medieval 2's Ideology load
  folder, so its two operations carry `MayRequire` and therefore sit inside a sequence:
  `MayRequire` is honoured on list elements only, and `ModContentPack.LoadPatches` builds a
  top-level `<Operation>` without ever looking at it.

### Removed

- `VEComp.cs` and with it the hard dependency on **Vanilla Expanded Framework**. The class was
  ported to VEF 1.6's `VEF.Buildings` namespace first, then dropped: its only remaining consumer
  was `VFEM_WallTorchLamp`, in a mod that cannot load in 1.6.
- `About/PublishedFileId.txt`: it names Keshash's Workshop item.
- `About/Preview.png`: Keshash's own showcase, and it carries a **1.4** badge in the corner.
- `Source/bin/`, `Source/obj/` and `Source/.vs/`, which the original shipped — including a copy of
  `MaliExtinguishRefuelables.dll`, another author's assembly, redistributed by accident.

### Unchanged

- Which buildings are patched, minus what upstream deleted — Keshash's choice throughout.
- That Medieval Overhaul's stove and rustic hearth need a comp of their own, because their flame
  is drawn only while the building faces north.
