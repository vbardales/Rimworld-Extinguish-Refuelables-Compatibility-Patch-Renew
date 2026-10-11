@requires:DankPyon.Medieval.Overhaul
Feature: The swapped overlays keep the flame size each Medieval Overhaul def declares

  # Scenario 7 of TEST_SCENARIOS.md. The swap only changes the Class attribute, so the def's own
  # fireSize must survive it. Expected values were read on 2026-10-11 from the installed 1.6 defs of
  # Medieval Overhaul (workshop 3219596926, 1.6/Defs/ThingDefs_Buildings): stove 0.7, rustic hearth 0.8,
  # brazier 1x1 0.8, brazier 2x2 1.5, wall torch 0.45. A new Medieval Overhaul version can move them:
  # a red here after it updates means re-read the defs, not that the mod broke. The offsets are not
  # asserted: a vector has no stable text form through the step, and the drawn position is judged
  # in the @review captures of 04.

  Scenario: each swapped fire keeps its def's flame size
    Then Extinguish Refuelables Patch: the def "DankPyon_WoodBurningStove" fire overlay field "fireSize" is "0.7"
    And Extinguish Refuelables Patch: the def "DankPyon_RusticHearth" fire overlay field "fireSize" is "0.8"
    And Extinguish Refuelables Patch: the def "DankPyon_Brazier1x1c" fire overlay field "fireSize" is "0.8"
    And Extinguish Refuelables Patch: the def "DankPyon_Brazier2x2c" fire overlay field "fireSize" is "1.5"
    And Extinguish Refuelables Patch: the def "DankPyon_WallTorch" fire overlay field "fireSize" is "0.45"
