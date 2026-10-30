# Functional scenarios, to be played in game

Mod = seven XML operations over thirteen buildings, one comp class. Almost nothing visible outside game: patch that fails to apply is silent by construction, only C# behaviour is flame drawn or not drawn. So scenarios carry verification. Each has one thing to watch, one way to be wrong.

**No game run recorded.** Manual scenarios non-blocking by maintainer decision. When executing, start with scenario 0 before the rest.

## Setup for everything here

Development mode on. God mode for placing buildings and filling fuel without waiting.

Mods active: **Extinguish Refuelables Continued** (hard dependency, supplies two of three comp classes patches name), then **Medieval Overhaul**, **Vanilla Factions Expanded - Classical**, **Vanilla Factions Expanded - Medieval 2**. Scenarios 11 and 12 remove some again, so keep modlist easy to edit.

Empty `Player.log` before each start, read after. Filter catching everything below:

```bash
grep -E "Patch operation|XML error|Could not find type|Could not resolve" Player.log
```

Switch this mod installs is vanilla's own: small on/off icon in selected building's command row, same as lamp. *Switched off* = icon toggled off, not building deconstructed.

Full list of what should get a switch, thirteen buildings across three mods:

| mod | defName | in-game label | fuel | drawn flame |
|---|---|---|---|---|
| Medieval Overhaul | `DankPyon_Brazier1x1c` | ancient brazier | **none** | vanilla overlay |
| Medieval Overhaul | `DankPyon_Brazier2x2c` | ancient obelisk brazier | **none** | vanilla overlay |
| Medieval Overhaul | `DankPyon_Candles` | candles (tallow, label shared) | yes | none |
| Medieval Overhaul | `DankPyon_Candles_Beeswax` | candles (bee wax, label shared) | yes | none |
| Medieval Overhaul | `DankPyon_CandleStand` | candle stand | yes | none |
| Medieval Overhaul | `DankPyon_WallLamp` | wall oil lamp | yes | none |
| Medieval Overhaul | `DankPyon_LampPost` | lamp post | yes | none |
| Medieval Overhaul | `DankPyon_WallTorch` | rustic wall torch | yes | vanilla overlay |
| Medieval Overhaul | `DankPyon_WoodBurningStove` | wood burning stove | yes | north only, this mod's class |
| Medieval Overhaul | `DankPyon_RusticHearth` | hearth | yes | north only, this mod's class |
| VFE - Classical | `VFEC_HeatStones` | heat stones | yes | none |
| VFE - Medieval 2 | `VFEM2_Hearth` | hearth | yes | vanilla overlay |
| VFE - Medieval 2 | `VFEM2_HearthDarklight` | darklight hearth | yes | darklight overlay |

**Two braziers have no fuel comp at all**, read from Medieval Overhaul's own 1.6 def files. Burn forever, always did. Switch buys light, heat, flame going away, not wood saved. No fuel gauge on them. Absence is not failed patch.

Labels come from each mod's own 1.6 def files. Two pairs collide. **Both Medieval Overhaul candle defs labelled just `candles`**, told apart only by refuel item, tallow or bee wax. Build menu description says which. **Medieval Overhaul rustic hearth and Medieval 2 hearth both labelled `hearth`**, different mods. Matters in scenario 12, where only one of two mods loaded. Select building, read defName in inspect pane with development mode on. Do not trust label.

Beeswax **candle stand** deliberately not on list. Exists only in Medieval Overhaul `1.4` folder, gone from 1.5 and 1.6, checked folder by folder, so port dropped it. Do not look for it. `_WoodLog` and `_BlocksGranite` candle stands added in 1.5 also not on list, and should not be: map-generation symbols pointing back to `DankPyon_CandleStand`, not buildings.

---

## 0. It loads, and the patches take

**Do.** Start game with everything from Setup active. Reach main menu, load any save.

**Expect.** No red text, nothing from this mod in log.

**Watch for in `Player.log`.** Four lines, each a different failure:

- `Patch operation ... failed`, in line opening with this mod's name in square brackets. One of seven operations did not match. Line names which, and source file. This is why operations were split: original had one sequence per target mod, first failure swallowed every later operation silently.
- `Could not find type named ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable`, or same for `CompProperties_DarklightOverlayExtinguishable`. Extinguish Refuelables Continued renamed namespace again. Happened once already between 2023 and 1.6, repairing it was most of the port.
- `Could not find type named ExtinguishRefuelablesPatch.CompProperties_FireOverlaySouthExtinguishable` = this mod's own assembly did not load. Check `Mod/Assemblies`.
- `Could not find type named MedievalOverhaul.CompProperties_FireOverlaySouth` not this mod's error, but means Medieval Overhaul renamed that class, and stove and rustic hearth operations failed on the line above.

**Silence that is not success.** `PatchOperationFindMod` compares target mod's **name**, free text from its `About.xml`, not `packageId`. If a name changed by even an em dash, whole file does nothing, says nothing. Scenario 1 proves patches ran. Scenario 0 only proves nothing crashed.

**If fails here, stop.** Everything below assumes patches live.

---

## 1. Every building on the list gets a switch

**Do.** Place one of each of thirteen. Select each, look at command row.

**Expect.** On/off switch on all thirteen.

**Why it matters.** Only proof `PatchOperationFindMod` matched. No switch = mod name did not match or `defName` moved upstream. Whole mod's worth missing at once points to name; one building alone points to `defName`.

## 2. The switch actually puts the fire out

**Do.** Rustic wall torch, fuelled, in closed room. Note fuel gauge, floor light, room temperature in inspect pane. Switch off. Let a few game hours pass.

**Expect.** Fuel gauge stops dropping. Light goes. Room stops heating.

**Why it matters.** None of that is this mod's code. Vanilla `CompRefuelable`, `CompGlower`, `CompHeatPusher` each consult `CompFlickable` themselves; mod only adds the comp. Switch appears but fuel keeps burning = something else on that building drives fuel.

**Not on braziers.** Pick any building from table with *yes* in fuel column. Braziers have nothing to save, scenario would read as failure on them.

## 3. The flame graphic goes out with it

**Do.** 1x1 brazier, 2x2 brazier, rustic wall torch, Medieval 2 hearth. Switch each off.

**Expect.** Drawn flame disappears, immediately.

**Why it matters.** Overlay swap is separate operation from switch: fire overlay comp exchanged for extinguishable one from Extinguish Refuelables. Flame keeps burning on building whose light and heat stopped = swap failed where switch went in. Exact failure shape of the original, reason each group is now its own operation.

**Braziers sharpest case.** No fuel to stop, so flame is most of what there is to see. Flame stays on them = second Medieval Overhaul operation did not match.

## 4. The heat stones have a switch and no flame

**Do.** Heat stones, fuelled. Switch off, then on.

**Expect.** Heat and glow stop and return. No flame either way, since heated slab not fire. Nothing red in log.

**Why it matters.** Building gets switch, no overlay swap, since no overlay to swap. Case separating *nothing to do* from *something forgotten*.

---

## 5. The stove and the rustic hearth keep the north-only rule

**Do.** Four wood burning stoves, one facing each way, all fuelled and on. Then same with four rustic hearths.

**Expect.** Flame on the one facing north. No flame on other three.

**Why it matters.** Mod's one class, and the one observation by original author that had to be preserved. Medieval Overhaul draws these two flames only from north. Generic extinguishable overlay would light fire on back of turned-away stove. Flame on all four facings = swap landed on wrong comp.

## 6. And the switch still works on them

**Do.** North-facing stove from scenario 5, alight. Switch off.

**Expect.** Flame goes out, fuel stops, heat stops.

**Why it matters.** Scenario 5 proves rotation rule survived. This proves it did not survive at cost of what mod exists for. Both conditions sit in one expression in class, mistake there breaks one scenario and not the other.

## 7. The def's own flame size and offset still apply

**Do.** Look hard at north-facing stove, alight, mod on. Then turn mod off, restart, look at same building again.

**Expect.** Same flame, same size, same place on sprite.

**Why it matters.** Class derives from vanilla `CompFireOverlay` not bare `ThingComp`, letting `Graphic_Flicker` find it and read def's flame size and draw offset. Flame suddenly default size, or in middle of building instead of firebox = inheritance not working.

## 8. The growth timer starts when the fire is lit, not when it is fuelled

**Do.** Use isolated test copy of mod/defs with `fireGrowthDurationTicks` set to 600 on stove overlay; shipped target defs do not enable visible growth. Build wood burning stove facing north. Fill fuel. Leave **switched off** for full game day. Then switch on, watch first minute.

**Expect.** Flame starts small and grows.

**Why it matters.** One behaviour port changed rather than preserved. Medieval Overhaul starts growth timer on fuel alone, so hearth left off overnight returns already full size. Full-size flame instantly on switch-on = old behaviour, tick guard never reached.

**Without that test-only growth duration, record scenario as not applicable, not passed.** Restore normal mod list after testing.

---

## 9. The darklight hearth, with Ideology

**Do.** Ideology active. Place darklight hearth. Switch off and on.

**Expect.** A switch, darklight stops and returns, overlay gone while off.

**Why it matters.** New coverage. 1.4 original never reached this building, and it is only place mod names Extinguish Refuelables' darklight comp.

## 10. And without Ideology

**Do.** Turn Ideology off. Start. Read log.

**Expect.** Nothing about darklight hearth, no patch failure from this mod.

**Why it matters.** Medieval 2 keeps that building behind Ideology load folder, so without DLC def does not exist and two operations naming it would fail. They carry `MayRequire`, which game honours **only on list elements**, which is why those two alone sit inside a sequence instead of standing alone. Failure here = guard in place where nothing reads it.

---

## 11. None of the three target mods installed

**Do.** Extinguish Refuelables Continued and nothing else from Setup. Start, load save, play few minutes.

**Expect.** Not one line from this mod in log, no visible effect anywhere.

**Why it matters.** `PatchOperationFindMod` reports success when named mod absent, so all seven operations should cost player with none of three exactly nothing. That is the claim on mod page, and the claim most likely quietly false.

## 12. One target mod at a time

**Do.** Three starts. Medieval Overhaul alone, then Classical alone, then Medieval 2 alone.

**Expect.** Each time, switches on that mod's buildings from table, silence about other two.

**Why it matters.** Cheap, separates failure of one patch file from failure of whole mod.

## 13. No collision with Extinguish Refuelables Continued

**Do.** Both mods active. Place vanilla campfire, vanilla torch, and Vanilla Furniture Expanded brazier if you have it, buildings the **base** mod covers and this one does not. Then look again at the thirteen from table.

**Expect.** Base mod's buildings behave as always. No building shows two switches, none of thirteen loses its one.

**Why it matters.** Two mods checked to share no `defName` at all, this is that check made visible. Two switches on one building = overlap comparison missed.

---

## 14. Save, reload, and the state holds

**Do.** Switch off about half of thirteen, leave rest alight, save, quit to menu, load back.

**Expect.** Every switch where left, every flame matching its switch, nothing relit by reload.

**Why it matters.** `CompFlickable` saves own state, so should be free. But comp added by patch rather than declared in def, and flame drawn from comp field only filled on spawn is classic thing to get wrong across load.

## 15. Adding it to a game already in progress

**Do.** Save made without this mod, holding some of thirteen buildings already built. Add mod. Load.

**Expect.** Switches appear on buildings already standing, all lit.

**Why it matters.** Mod page says safe to add to save. This tests that sentence.

## 16. Removing it from a game in progress

**Do.** On a **copy** of a save, never the real one. Switch everything from table back on. Save. Remove mod. Load.

**Expect.** Buildings work as before mod.

**Then, separately, also on a copy.** Same, but leave one building switched **off** before removing. Case mod page warns about: comp goes away with its saved state, what is left is whatever base mod's defs say. Write down what actually happens, because that warning is currently reasoning not observation.

---

## What these scenarios deliberately leave alone

**Rain fuel drain.** Original zeroed rain fuel consumption on comp **properties**, shared by every instance of a def, so one switched-off stove would have stopped rain drain on every stove on map. That code not in port. Nothing to test either, since neither of two defs it touched declares the field at all. Gap it was written for belongs to Extinguish Refuelables, on base game's own torches.

**The three mods that are no longer targets.** Vanilla Factions Expanded - Medieval and - Vikings stop at 1.4, cannot load in 1.6. Vanilla Expanded Framework no longer a dependency. If a scenario makes you reach for any of the three, scenario is wrong.