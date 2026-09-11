# Functional scenarios, to be played in game

This mod is thirteen XML operations and one comp class. Almost nothing in it can be seen from
outside the game: a patch that does not apply is silent by construction, and the one behaviour the
C# adds is a flame that is drawn or not drawn. So these scenarios carry the verification, and each
one is written with a single thing to watch and a single way of being wrong.

**The mod has never been run in a game.** Until scenario 0 passes, nothing below is worth playing.

## Setup for everything here

Development mode on, and god mode for placing buildings and filling their fuel without waiting.

Mods active: **Extinguish Refuelables Continued**, which is a hard dependency and supplies two of
the three comp classes the patches name, then **Medieval Overhaul**, **Vanilla Factions Expanded -
Classical** and **Vanilla Factions Expanded - Medieval 2**. Scenarios 11 and 12 take some of those
away again, so keep the modlist easy to edit.

Empty `Player.log` before each start, and read it after. The filter that catches everything below:

```bash
grep -E "Patch operation|XML error|Could not find type|Could not resolve" Player.log
```

The switch this mod installs is vanilla's own: a small on/off icon in the selected building's
command row, the same one a lamp has. Where a scenario says *switched off*, it means that icon
toggled off, not the building deconstructed.

The full list of what should end up with a switch, thirteen buildings across three mods:

| mod | defName | in-game label | fuel | drawn flame |
|---|---|---|---|---|
| Medieval Overhaul | `DankPyon_Brazier1x1c` | ancient brazier | **none** | vanilla overlay |
| Medieval Overhaul | `DankPyon_Brazier2x2c` | ancient obelisk brazier | **none** | vanilla overlay |
| Medieval Overhaul | `DankPyon_Candles` | candles, tallow | yes | none |
| Medieval Overhaul | `DankPyon_Candles_Beeswax` | candles, bee wax | yes | none |
| Medieval Overhaul | `DankPyon_CandleStand` | candle stand | yes | none |
| Medieval Overhaul | `DankPyon_WallLamp` | wall oil lamp | yes | none |
| Medieval Overhaul | `DankPyon_LampPost` | lamp post | yes | none |
| Medieval Overhaul | `DankPyon_WallTorch` | rustic wall torch | yes | vanilla overlay |
| Medieval Overhaul | `DankPyon_WoodBurningStove` | wood burning stove | yes | north only, this mod's class |
| Medieval Overhaul | `DankPyon_RusticHearth` | hearth | yes | north only, this mod's class |
| VFE - Classical | `VFEC_HeatStones` | heat stones | yes | none |
| VFE - Medieval 2 | `VFEM2_Hearth` | hearth | yes | vanilla overlay |
| VFE - Medieval 2 | `VFEM2_HearthDarklight` | darklight hearth | yes | darklight overlay |

**The two braziers have no fuel comp at all**, read out of Medieval Overhaul's own 1.6 def files.
They burn for ever and always did; what the switch buys there is the light, the heat and the flame
going away, not wood saved. Do not go looking for a fuel gauge on them, and do not read its absence
as a failed patch.

The labels are out of each mod's own 1.6 def files, and two pairs of them collide. **Both Medieval
Overhaul candle defs are labelled simply `candles`** and are told apart only by what refuels them,
tallow or bee wax; the description in the build menu says which. And **Medieval Overhaul's rustic
hearth and Medieval 2's hearth are both labelled `hearth`**, from two different mods, which matters
in scenario 12 where only one of the two mods is loaded. Select the building and read the defName
in the inspect pane with development mode on rather than trusting the label.

The beeswax **candle stand** is deliberately not on that list. It exists only in Medieval Overhaul's
`1.4` folder and is gone from 1.5 and 1.6, checked folder by folder, so the port dropped it. Do not
go looking for it. The `_WoodLog` and `_BlocksGranite` candle stands that 1.5 added are not on the
list either, and should not be: they are map-generation symbols pointing back at `DankPyon_CandleStand`,
not buildings of their own.

---

## 0. It loads, and the patches take

**Do.** Start the game with everything from Setup active. Reach the main menu, then load any save.

**Expect.** No red text, and nothing from this mod in the log.

**Watch for in `Player.log`.** Four lines, each meaning a different failure:

- `Patch operation ... failed`, in a line that opens with this mod's name in square brackets. One
  of the thirteen operations did not match. The line names which, and the file it came from. This
  is what splitting the operations apart was for: in the original they were one sequence per target
  mod, and the first failure swallowed every operation after it without a word.
- `Could not find type named ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable`, or
  the same for `CompProperties_DarklightOverlayExtinguishable`. Extinguish Refuelables Continued
  has renamed its namespace again. That happened once already between 2023 and 1.6, and repairing
  it was most of the port.
- `Could not find type named ExtinguishRefuelablesPatch.CompProperties_FireOverlaySouthExtinguishable`
  means this mod's own assembly did not load. Check `Mod/Assemblies`.
- `Could not find type named MedievalOverhaul.CompProperties_FireOverlaySouth` is not this mod's
  error, but seeing it means Medieval Overhaul has renamed that class, and the stove and rustic
  hearth operations will have failed on the line above.

**A silence that is not success.** `PatchOperationFindMod` compares the target mod's **name**, free
text out of its `About.xml`, not its `packageId`. If one of those names has changed by so much as
an em dash, the whole file does nothing and says nothing. Scenario 1 is what proves the patches
ran. Scenario 0 only proves nothing crashed.

**If it fails here, stop.** Everything below assumes the patches are live.

---

## 1. Every building on the list gets a switch

**Do.** Place one of each of the thirteen. Select each and look at its command row.

**Expect.** The on/off switch on all thirteen.

**Why it matters.** This is the only proof that `PatchOperationFindMod` matched. A building with no
switch means either its mod's name did not match or its `defName` has moved upstream. A whole mod's
worth missing at once points at the name; one building on its own points at the `defName`.

## 2. The switch actually puts the fire out

**Do.** A rustic wall torch, fuelled, in a closed room. Note the fuel gauge, the light on the floor
and the room temperature in the inspect pane. Switch it off. Let a few game hours pass.

**Expect.** The fuel gauge stops dropping. The light goes. The room stops being heated.

**Why it matters.** None of that is this mod's code. Vanilla's `CompRefuelable`, `CompGlower` and
`CompHeatPusher` each consult `CompFlickable` on their own, and all the mod does is put the comp
there. A switch that appears while the fuel keeps burning means something else on that building is
driving the fuel.

**Not on the braziers.** Pick any building from the table with *yes* in the fuel column. The two
braziers have nothing to save, and the whole scenario would read as a failure on them.

## 3. The flame graphic goes out with it

**Do.** The 1x1 brazier, the 2x2 brazier, the rustic wall torch, and the Medieval 2 hearth. Switch
each off.

**Expect.** The drawn flame disappears, immediately.

**Why it matters.** The overlay swap is a separate operation from the switch: the fire overlay comp
is exchanged for the extinguishable one from Extinguish Refuelables. A flame that keeps burning on
a building whose light and heat have stopped is the signature of that swap failing where the switch
went in. It is exactly the shape of failure the original had, and the reason each group is now its
own operation.

**The braziers are the sharpest case.** They have no fuel to stop, so the flame is most of what
there is to see. On them, a flame that stays means the second Medieval Overhaul operation did not
match.

## 4. The heat stones have a switch and no flame

**Do.** Heat stones, fuelled. Switch off, then on.

**Expect.** The heat and the glow stop and come back. No flame either way, since they are a heated
slab rather than a fire, and nothing red in the log.

**Why it matters.** This building gets the switch and no overlay swap, because it has no overlay to
swap. It is the case that separates *nothing to do* from *something forgotten*.

---

## 5. The stove and the rustic hearth keep the north-only rule

**Do.** Four wood burning stoves, one facing each way, all fuelled and switched on. Then the same
with four rustic hearths.

**Expect.** A flame on the one facing north. No flame on the other three.

**Why it matters.** This is the mod's one class, and the one observation by the original author
that had to be preserved. Medieval Overhaul draws these two flames only from the north, and a
generic extinguishable overlay would light a fire on the back of a stove turned away. A flame on
all four facings means the swap landed on the wrong comp.

## 6. And the switch still works on them

**Do.** The north-facing stove from scenario 5, alight. Switch it off.

**Expect.** The flame goes out, the fuel stops, the heat stops.

**Why it matters.** Scenario 5 proves the rotation rule survived. This proves it did not survive at
the cost of the thing the mod exists for. Both conditions sit in one expression in the class, and a
mistake there breaks one of these two scenarios and not the other.

## 7. The def's own flame size and offset still apply

**Do.** Look hard at a north-facing stove, alight, with this mod on. Then turn this mod off,
restart, and look at the same building again.

**Expect.** The same flame, at the same size, in the same place on the sprite.

**Why it matters.** The class derives from vanilla's `CompFireOverlay` rather than from a bare
`ThingComp`, which is what lets `Graphic_Flicker` find it and read the def's own flame size and
draw offset off it. A flame that is suddenly the default size, or sitting in the middle of the
building instead of in its firebox, means that inheritance is not doing its work.

## 8. The growth timer starts when the fire is lit, not when it is fuelled

**Do.** Build a wood burning stove facing north. Fill its fuel. Leave it **switched off** for a
full game day. Then switch it on and watch the first minute.

**Expect.** The flame starts small and grows.

**Why it matters.** This is the one behaviour the port changed rather than preserved. Medieval
Overhaul starts the growth timer on fuel alone, so a hearth left switched off overnight comes back
already at full size. A full-size flame the instant you switch on is the old behaviour, and means
the tick guard is never reached.

**Fair warning.** Neither of these two defs sets a growth duration, so the effect may be too quick
to see. If it is, this scenario proves nothing either way. Record that rather than marking it
passed.

---

## 9. The darklight hearth, with Ideology

**Do.** Ideology active. Place the darklight hearth. Switch it off and on.

**Expect.** A switch, darklight that stops and comes back, and the overlay gone while it is off.

**Why it matters.** New coverage. The 1.4 original never reached this building, and it is the only
place the mod names Extinguish Refuelables' darklight comp.

## 10. And without Ideology

**Do.** Turn Ideology off. Start. Read the log.

**Expect.** Nothing about the darklight hearth, and no patch failure from this mod.

**Why it matters.** Medieval 2 keeps that building behind an Ideology load folder, so without the
DLC the def does not exist and the two operations naming it would fail. They carry `MayRequire`,
which the game honours **only on list elements**, which is why those two alone in this mod sit
inside a sequence instead of standing on their own. A failure here means the guard is in a place
where nothing reads it.

---

## 11. None of the three target mods installed

**Do.** Extinguish Refuelables Continued and nothing else from Setup. Start, load a save, play a
few minutes.

**Expect.** Not one line from this mod in the log, and no visible effect anywhere.

**Why it matters.** `PatchOperationFindMod` reports success when the mod it names is absent, so all
thirteen operations should cost a player with none of the three exactly nothing. That is the claim
on the mod page, and it is the claim most likely to be quietly false.

## 12. One target mod at a time

**Do.** Three starts. Medieval Overhaul alone, then Classical alone, then Medieval 2 alone.

**Expect.** Each time, switches on that mod's buildings from the table and silence about the other
two.

**Why it matters.** Cheap, and it separates a failure belonging to one patch file from a failure
belonging to the mod.

## 13. No collision with Extinguish Refuelables Continued

**Do.** Both mods active. Place a vanilla campfire and a vanilla torch, and a Vanilla Furniture
Expanded brazier if you have it, which are buildings the **base** mod covers and this one does not.
Then look again at the thirteen from the table.

**Expect.** The base mod's buildings behave as they always did. No building anywhere shows two
switches, and none of the thirteen loses the one it has.

**Why it matters.** The two mods were checked to share no `defName` at all, and this is that check
made visible. Two switches on one building would mean an overlap the comparison missed.

---

## 14. Save, reload, and the state holds

**Do.** Switch off about half of the thirteen, leave the rest alight, save, quit to the menu, and
load back.

**Expect.** Every switch where you left it, every flame matching its switch, and nothing relit by
the reload.

**Why it matters.** `CompFlickable` saves its own state, so this should be free. But the comp is
added by patch rather than declared in the def, and a flame drawn from a comp field that is only
filled on spawn is the classic thing to get wrong across a load.

## 15. Adding it to a game already in progress

**Do.** A save made without this mod, holding some of the thirteen buildings already built. Add the
mod. Load.

**Expect.** The switches appear on the buildings already standing, all lit.

**Why it matters.** The mod page says it is safe to add to a save. This is the test of that
sentence.

## 16. Removing it from a game in progress

**Do.** On a **copy** of a save, never the real one. Switch everything from the table back on.
Save. Remove the mod. Load.

**Expect.** The buildings work as they did before the mod.

**Then, separately, and also on a copy.** The same, but leave one building switched **off** before
removing. This is the case the mod page warns about: the comp goes away with its saved state, and
what is left is whatever the base mod's defs say. Write down what actually happens, because that
warning is currently reasoning rather than observation.

---

## What these scenarios deliberately leave alone

**Rain fuel drain.** The original zeroed the rain fuel consumption on the comp **properties**,
which every instance of a def shares, so one switched-off stove would have stopped rain drain on
every stove on the map. That code is not in the port. There is nothing to test either, because
neither of the two defs it touched declares the field at all. The gap it was written for belongs to
Extinguish Refuelables, on the base game's own torches.

**The three mods that are no longer targets.** Vanilla Factions Expanded - Medieval and - Vikings
stop at 1.4 and cannot load in 1.6, and Vanilla Expanded Framework is no longer a dependency. If a
scenario here makes you reach for any of the three, the scenario is wrong.
