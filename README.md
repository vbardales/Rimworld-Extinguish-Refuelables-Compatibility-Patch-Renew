# Extinguish Refuelables Compatibility Patch Renew (unofficial)

UNOFFICIAL. This mod is published without the original author's explicit consent. If the original author contacts me to request its removal, I undertake to take it down promptly.

Port of **Keshash's Extinguish Refuelables Compatibilty Patch** to RimWorld 1.6.

**I am not the author of this mod.** The choice of buildings, and the one design idea in it, are
Keshash's — all I did was the work needed to make it run on 1.6 and repair what the port turned
up. Credit goes to them; mistakes in the port are mine.

Original mod: https://steamcommunity.com/sharedfiles/filedetails/?id=3109675320 — declares 1.4
and nothing further. The description remains accessible; abandonment is not established. Keshash
shipped `Source/`, so nothing here was decompiled.

## What the mod does

[Extinguish Refuelables Continued](https://steamcommunity.com/sharedfiles/filedetails/?id=3772905265)
gives a refuelable fire an on/off switch, so a colony can put a torch out instead of letting it
burn wood all night. It covers the base game, Vanilla Furniture Expanded, Medieval Lighting and
Heat and Smoked meat.

This adds the buildings it does not reach. Checked def by def: **no `defName` in common** between
the two. It is an extension of that mod, not a rival to it, and it is useless without it.

| mod | buildings |
|---|---|
| Medieval Overhaul | brazier 1×1, brazier 2×2, candles, beeswax candles, candle stand, lamp post, wall lamp, wall torch, wood burning stove, rustic hearth |
| Vanilla Factions Expanded - Classical | heat stones |
| Vanilla Factions Expanded - Medieval 2 | hearth, and darklight hearth with Ideology |

None of the three is required. Each has its own guarded patch file: with none of them installed
the mod does nothing and errors at nothing.

Safe to add to a save. Removing it mid-save leaves an off switch on a few buildings with no code
behind it any more — switch them back on first.

## What changed in the 1.6 port

Short version: **almost none of the original could still fire**, and none of it said so.

### Three namespaces had been renamed underneath it

| written in 2023 | in 1.6 |
|---|---|
| `MaliExtinguishRefuelables.CompProperties_FireOverlayExtinguishable` | `ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable` |
| `DankPyon_MedievalOverhaul.CompProperties_FireOverlaySouth` | `MedievalOverhaul.CompProperties_FireOverlaySouth` |
| `VanillaFurnitureExpanded.CompProperties_FireOverlayRotatable` | `VEF.Buildings.CompProperties_FireOverlayRotatable` |

A `PatchOperationAttributeSet` whose XPath names a class that no longer exists matches nothing
and fails. Nothing about that is loud.

### One sequence per mod, and a sequence stops at the first failure

Each patch file was one `PatchOperationFindMod` wrapping one `PatchOperationSequence`.
`PatchOperationSequence.ApplyWorker` returns as soon as a child returns false — it does not skip
and carry on. In the Medieval Overhaul file the stove's attribute set was third of six; it failed
on the namespace above, and the wall torch three operations later never got its switch.

The usual reflex, `<success>Always</success>` on the sequence, would make this worse rather than
better: the flag is read in `PatchOperation.Apply`, which clears `neverSucceeded`, so `Complete()`
stops reporting the failure — without restoring the operations that were skipped.

Each group is now its **own top-level `Operation`**. They cannot silence each other, and a failing
one still reports itself by name and file. `PatchOperationFindMod` returns `true` when the mod is
absent, so this costs nothing to a player who has none of the three.

### The Vikings guard named the wrong mod

    <mods><li>Vanilla Factions Expanded - Classical</li></mods>

in `VE_Vikings_Patch.xml` — copied from the Classical file and never changed.

`PatchOperationFindMod` compares the **mod's name**, not its `packageId`. Every name in this port
was read out of the target mod's own `About.xml` and compared on raw bytes, not on what a console
prints: an em dash or a non-breaking space would look right on screen and never match.

### Two of the four target mods cannot load in 1.6

**Vanilla Factions Expanded - Medieval** and **Vanilla Factions Expanded - Vikings** both stop at
1.4 — no `1.5` or `1.6` folder, and `<supportedVersions>` ends there. Their content was folded
into **Medieval 2**, so the patch follows it:

| 1.4 target | 1.6 |
|---|---|
| `VFEV_Hearth` | `VFEM2_Hearth`, same comps |
| `VFEV_FuneralPyre` | gone |
| `VFEM_Candle` | gone |
| `VFEM_WallTorchLamp` | gone |

`VFEM2_HearthDarklight` is new coverage and the same piece of furniture — the Ideology twin of
the hearth already being patched. Extinguish Refuelables ships
`CompProperties_DarklightOverlayExtinguishable` for exactly it.

It sits behind Medieval 2's Ideology load folder, so its operations carry `MayRequire` — and that
is why those two, alone in this mod, are inside a sequence. `MayRequire` is honoured on **list
elements** only; `ModContentPack.LoadPatches` reads a top-level `<Operation>` straight through
`DirectXmlToObject.ObjectFromXml` without ever looking at it.

### `DankPyon_CandleStand_Beeswax` is gone from Medieval Overhaul

Present in its `1.4` folder, in neither `1.5` nor `1.6`. Dropped from the list. The other ten
were read out of the def files comp by comp rather than taken on trust.

### The wall torch moved to the base game's comp — and took a dependency with it

`DankPyon_WallTorch` used VFE's rotatable fire overlay in 2023. It now uses vanilla
`CompProperties_FireOverlay`, because **RimWorld 1.6's own `CompProperties_FireOverlay` gained
`offsetNorth`, `offsetSouth`, `offsetWest`, `offsetEast` and `DrawOffsetForRot`**. Rotation-aware
fire is a base-game feature now.

That was the last thing needing `VEComp.cs`, so the class was ported to `VEF.Buildings` and then
dropped: its only remaining consumer was `VFEM_WallTorchLamp`, in a mod that cannot load here.
**Vanilla Expanded Framework is no longer a dependency.**

### The one class that remains

`Comp_FireOverlaySouthAndExtinguishable` → `CompFireOverlaySouthExtinguishable`, and it now
derives from vanilla's `CompFireOverlay` instead of from `ThingComp`.

It exists because Medieval Overhaul's stove and rustic hearth draw their flame **only while the
building faces north**. Swapping in the generic extinguishable comp would light a fire on the
back of a stove turned away. That observation is Keshash's, and it was checked at the IL level
against `MedievalOverhaul.Comp_FireOverlaySouth` rather than taken on trust — including the
`3f/74f` height nudge. Both were right.

Deriving from vanilla rather than from `ThingComp` buys two things:

- **The def's own `fireSize` and `offset` start working.** `Graphic_Flicker.DrawWorker` looks for
  a `CompFireOverlayBase` on the thing it is drawing and reads `FireSize` and
  `Props.DrawOffsetForRot(rot)` off it. The original comp was not one — which is why Extinguish
  Refuelables has to ship its own `Graphic_FlickerExtinguishable`, and why the original had to
  redeclare the props fields by hand.
- **No compile-time reference to anyone's assembly**, so the DLL loads whatever the player has
  installed.

Two faults did not come along:

    if (!flickableComp.SwitchIsOn && flickableComp != null)
        refuelableComp.Props.fuelConsumptionPerTickInRain = 0f;

The null check is after the dereference. And `Props` is the **def's** comp properties, shared by
every instance of it: one switched-off stove would zero rain fuel drain for every stove in the
colony for the rest of the session, with no way back. It aimed at something real — vanilla's
`CompRefuelable.CompTick` drains `fuelConsumptionPerTickInRain` without consulting
`CompFlickable`, so an extinguished torch still loses fuel in the rain — but neither of the two
defs it applied to declares that field, so it never did anything except risk a crash. The gap is
Extinguish Refuelables', and it has it on the base game's own torches too.

The growth timer now starts on the first tick the fire is actually alight, where the original
started it on fuel alone. Inert for these two defs, neither of which sets
`fireGrowthDurationTicks`, but it is what the class claims to do.

### Dependencies

`malistaticy.mer` was never a third mod — it was Extinguish Refuelables' own `packageId`, as its
`<displayName>` in the original `About.xml` says. Continuing the mod changed that id to
`blacktriple.extinguishrefuelablescontinued`, so the declaration as written asked the player for
a mod that no longer exists under that name.

## Building

```
dotnet build -c Release Source/ExtinguishRefuelablesPatch.csproj
```

Reference assemblies come from NuGet (`Krafs.Rimworld.Ref`), so this builds without RimWorld
installed. Intermediates go to `.build/`, outside the published folder — `Mod/` is what Steam
uploads, and it uploads it whole.

## Testing

[`_tools/FUNCTIONAL-SCENARIOS.md`](_tools/FUNCTIONAL-SCENARIOS.md) — seventeen scenarios to play in
game, one thing to watch each, and what the failure looks like in `Player.log`. Run `pwsh -NoProfile -File _tools/Test-Xml.ps1` for metadata and XML contract tests across
16 combinations of target mods and Ideology. The fixtures check switches, overlay replacement,
property preservation and guards; they are not current upstream definitions or RimWorld's loader.
Run `pwsh -NoProfile -File _tools/Test-InstalledMods.ps1` to check the installed 1.6 target defs and DLL type names, and `pwsh -NoProfile -File _tools/Test-Behaviour.ps1` for 72 C# cases against test doubles. Run each script in a fresh process. The Release build checks C# API compatibility. Actual engine rendering and save behaviour remain covered by the
manual scenarios, which have no recorded game execution and are non-blocking by maintainer decision.

## Licence and credit

MIT for what the port added; nothing is granted over Keshash's original, which declares no
licence anywhere. See [`LICENSE`](LICENSE) and [`ATTRIBUTION.md`](ATTRIBUTION.md).
