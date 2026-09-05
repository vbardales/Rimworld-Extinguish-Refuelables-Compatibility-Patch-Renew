# Extinguish Refuelables Compatibility Patch — attribution

A 1.6 port of **Extinguish Refuelables Compatibilty Patch**, by **Keshash**
([3109675320](https://steamcommunity.com/sharedfiles/filedetails/?id=3109675320)).

## Status: public

The source mod is **dead** — it declares 1.4 and nothing further — and **no licence is declared
anywhere**, checked at the four places one could be: no `LICENSE` file in the mod, no mention in
its `About.xml`, no linked repository (`<url>` is absent entirely), and nothing in the body of
the description on its Steam page. That last check is the one that matters: it is the one that
was skipped once on たたら製鉄, whose ban on redistribution turned out to be a sentence in its
description and nowhere else.

This is the usual convention for ports on the RimWorld Workshop: republished with **credit by
name** and **removal on request, without argument**. The `<author>` field reads
`Keshash - 1.6 port: nelim`, and the removal clause is in the description.

Keshash shipped `Source/`, so nothing here was decompiled.

## What the mod is

Extinguish Refuelables (Mali, continued by Blacktriple) gives refuelable fires an on/off switch.
It covers the base game plus Vanilla Furniture Expanded, Medieval Lighting and Heat and Smoked
meat. This patch adds the buildings it does not reach. The two have **no `defName` in common**,
checked def by def — this is an extension of that mod, not a rival to it.

## What was carried over

Keshash's choice of buildings, and his one real idea: that Medieval Overhaul's stove and rustic
hearth need a comp of their own, because their flame is drawn only while the building faces
north and the generic extinguishable comp would light a fire on the back of a stove turned away.

Everything else was rewritten, because everything else had stopped pointing at anything.

## What changed in the port

### Every class name in every patch file was dead

Three separate renames, none of them announced, all of them silent at load — RimWorld's
`PatchOperationAttributeSet` simply matches nothing and the operation fails.

| written in 2023 | in 1.6 |
|---|---|
| `MaliExtinguishRefuelables.CompProperties_FireOverlayExtinguishable` | `ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable` |
| `DankPyon_MedievalOverhaul.CompProperties_FireOverlaySouth` | `MedievalOverhaul.CompProperties_FireOverlaySouth` |
| `VanillaFurnitureExpanded.CompProperties_FireOverlayRotatable` | `VEF.Buildings.CompProperties_FireOverlayRotatable` |

The first is Extinguish Refuelables being continued under a new name; the assembly went from
`MaliExtinguishRefuelables.dll` to `ExtinguishRefuelablesContinued.dll` and took its namespace
with it. The second and third are Medieval Overhaul and Vanilla Expanded Framework tidying their
own namespaces.

### The sequence that stops instead of skipping

Each of the four patch files was one `PatchOperationFindMod` wrapping one
`PatchOperationSequence`. `PatchOperationSequence.ApplyWorker` returns on the first child that
fails, so **one dead `defName` silences every operation after it**. In the Medieval Overhaul
file, the stove's attribute set was third of six; it failed on the namespace above, and the wall
torch never got its switch either.

`<success>Always</success>` on the sequence would have hidden the failure without restoring the
run — the flag is read in `PatchOperation.Apply` and clears `neverSucceeded`, so `Complete()`
logs nothing.

Each group is now its **own top-level `Operation`**. They are independent, and a failing one
still reports itself by name and file. `PatchOperationFindMod` returns `true` when the mod is
absent, so a player without Medieval Overhaul sees nothing.

### The Vikings guard named the wrong mod

`VE_Vikings_Patch.xml` was guarded by

    <mods><li>Vanilla Factions Expanded - Classical</li></mods>

— copied from the Classical file and never changed. With Vikings installed and Classical not,
the whole file did nothing. With both, it ran the Vikings operations, found no `VFEV_` defs and
failed.

That guard is moot now, for the reason below, but it is the same class of fault the port was
watching for: `PatchOperationFindMod` compares the **mod's name**, not its `packageId`, and a
name that does not match is silent. Every name in this port was read out of the target mod's own
`About.xml` and compared on raw bytes, not on what a console prints — an em dash or a
non-breaking space would look right and never match.

### Two of the four target mods no longer exist in 1.6

**Vanilla Factions Expanded - Medieval** (`OskarPotocki.VanillaFactionsExpanded.MedievalModule`)
and **Vanilla Factions Expanded - Vikings** (`OskarPotocki.VFE.Vikings`) both stop at 1.4 — no
`1.5` or `1.6` folder, and `<supportedVersions>` ends there. Their content was folded into
**Vanilla Factions Expanded - Medieval 2**, so the patch follows it:

| 1.4 target | 1.6 |
|---|---|
| `VFEV_Hearth` (Vikings) | `VFEM2_Hearth`, same comps: refuelable, glower, heat pusher, `CompProperties_FireOverlay`, art, meditation focus |
| `VFEV_FuneralPyre` (Vikings) | gone |
| `VFEM_Candle` (Medieval) | gone |
| `VFEM_WallTorchLamp` (Medieval) | gone |

Medieval 2's whole set of refuelable buildings was read to check this, not just searched by
name: the only two carrying a fire or darklight overlay are `VFEM2_Hearth` and
`VFEM2_HearthDarklight`.

`VFEM2_HearthDarklight` is **new coverage**, and it is the same piece of furniture — the
Ideology twin of the hearth already being patched, differing only in `CompProperties_DarklightOverlay`.
Extinguish Refuelables ships `CompProperties_DarklightOverlayExtinguishable` for exactly that.
It lives behind Medieval 2's Ideology load folder, so its two operations carry `MayRequire`,
which meant putting them in a sequence: `MayRequire` is honoured on list elements only, and
`ModContentPack.LoadPatches` builds a top-level `<Operation>` without ever looking at it.

### One `defName` gone from Medieval Overhaul

`DankPyon_CandleStand_Beeswax` exists in Medieval Overhaul's `1.4` folder and in neither `1.5`
nor `1.6`. It is dropped from the list. The other ten are present and were read out of the def
files, comp by comp.

### Medieval Overhaul moved its wall torch to the base game's comp

`DankPyon_WallTorch` used `VanillaFurnitureExpanded.CompProperties_FireOverlayRotatable` in 2023.
It now uses vanilla `CompProperties_FireOverlay` — because **RimWorld 1.6's own
`CompProperties_FireOverlay` gained `offsetNorth`, `offsetSouth`, `offsetWest`, `offsetEast` and
`DrawOffsetForRot`**. Rotation-aware fire is a base-game feature now, and the mod's own def sets
all four offsets.

Extinguish Refuelables' `CompProperties_FireOverlayExtinguishable` declares the same eight fields
as vanilla, so the attribute swap carries `fireSize` and every offset across untouched.

That was the last thing needing `VEComp.cs`, and with it the **hard dependency on Vanilla
Expanded Framework is gone**. The class was ported and then dropped: its only remaining consumer
was `VFEM_WallTorchLamp`, in a mod that cannot load in 1.6.

### The one class that remains

`Comp_FireOverlaySouthAndExtinguishable` is rewritten as
`CompFireOverlaySouthExtinguishable`, and derives from vanilla's `CompFireOverlay` rather than
from `ThingComp`. Three things fall out of that:

- **The def's own `fireSize` and `offset` start working.** `Graphic_Flicker.DrawWorker` looks for
  a `CompFireOverlayBase` on the thing it draws and reads `FireSize` and
  `Props.DrawOffsetForRot(rot)` off it. The original comp was not one, which is why Extinguish
  Refuelables needs its own `Graphic_FlickerExtinguishable` — and why the original had to
  redeclare all four props fields by hand.
- **No reference to anyone's assembly.** Not Extinguish Refuelables, not Medieval Overhaul, not
  Vanilla Expanded Framework. The assembly loads whatever the player has installed.
- Medieval Overhaul's `Comp_FireOverlaySouth` was read at the IL level rather than guessed at, to
  confirm the north-only rule and the `3f/74f` height nudge. Keshash had both right.

Two faults in the original are not carried over:

    if (!flickableComp.SwitchIsOn && flickableComp != null)
        refuelableComp.Props.fuelConsumptionPerTickInRain = 0f;

The null check is after the dereference, and `refuelableComp` is not checked at all. Worse,
`Props` is the **def's** comp properties, shared by every instance: placing one switched-off
stove would zero rain fuel drain for every stove in the colony, for the rest of the session, with
no way back. It was aimed at a real gap — vanilla's `CompRefuelable.CompTick` drains
`fuelConsumptionPerTickInRain` without consulting `CompFlickable` — but neither
`DankPyon_WoodBurningStove` nor `DankPyon_RusticHearth` declares that field, so it never did
anything but risk a crash. The gap itself belongs to Extinguish Refuelables, which has it on the
base game's own torches too; it is not a compatibility patch's to fix globally.

The growth timer now starts on the first tick the fire is actually alight, where the original
started it on fuel alone. Inert for these two defs — neither sets `fireGrowthDurationTicks` — but
it is the behaviour the class claims.

### Dependencies

`malistaticy.mer` was not a third mod: it was Extinguish Refuelables' own `packageId`, and the
`<displayName>` in the original `About.xml` says so. Continuing it changed that id to
`blacktriple.extinguishrefuelablescontinued`, so the declaration as written asks the player for a
mod that no longer exists under that name. Updated.

`oskarpotocki.vanillafactionsexpanded.core` is dropped, per the wall torch above.

## What was dropped from the published folder

- `About/PublishedFileId.txt`, for the obvious reason: it names Keshash's Workshop item.
- `About/Preview.png`. It is Keshash's own showcase and carries a **1.4** badge in the corner,
  which would be a lie on a 1.6 page.
- `Source/bin/`, `Source/obj/` and `Source/.vs/`, which the original shipped — including a copy
  of `MaliExtinguishRefuelables.dll`, another author's assembly, redistributed by accident.

## Adoption

If I do not answer within a reasonable time after being contacted, anyone may freely update this
or any other of my mods, including publishing a continuation of it. All credit must be preserved.
