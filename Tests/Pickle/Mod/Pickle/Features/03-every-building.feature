Feature: Every patched building carries exactly one switch and the swapped overlay

  # No gizmo label is assumed here: the steps read CompFlickable off the spawned building, which is
  # the same proof a command row gives, and the overlay class off its def. Cells run along z = 60,
  # four apart so the 2x2 buildings do not overlap. If a cell is taken on "test-colony", the failure
  # names what stands there.

  @requires:DankPyon.Medieval.Overhaul
  Scenario: the ten Medieval Overhaul buildings each have one switch
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_Brazier1x1c" at (20, 60)
    And I spawn a "DankPyon_Brazier2x2c" at (24, 60)
    And I spawn a "DankPyon_Candles" at (28, 60)
    And I spawn a "DankPyon_Candles_Beeswax" at (32, 60)
    And I spawn a "DankPyon_CandleStand" at (36, 60)
    And I spawn a "DankPyon_WallLamp" at (40, 60)
    And I spawn a "DankPyon_LampPost" at (44, 60)
    And I spawn a "DankPyon_WallTorch" at (48, 60)
    And I spawn a "DankPyon_WoodBurningStove" at (52, 60)
    And I spawn a "DankPyon_RusticHearth" at (56, 60)
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (20, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_Brazier2x2c" at (24, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_Candles" at (28, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_Candles_Beeswax" at (32, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_CandleStand" at (36, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_WallLamp" at (40, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_LampPost" at (44, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (48, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (52, 60) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_RusticHearth" at (56, 60) has exactly one on/off switch
    And no errors were logged

  @requires:DankPyon.Medieval.Overhaul
  Scenario: the four Medieval Overhaul fires draw with the swapped overlay
    Then Extinguish Refuelables Patch: the def "DankPyon_Brazier1x1c" draws its fire with an extinguishable overlay
    And Extinguish Refuelables Patch: the def "DankPyon_Brazier2x2c" draws its fire with an extinguishable overlay
    And Extinguish Refuelables Patch: the def "DankPyon_WallTorch" draws its fire with an extinguishable overlay
    And Extinguish Refuelables Patch: the def "DankPyon_WoodBurningStove" draws its fire with an extinguishable overlay
    And Extinguish Refuelables Patch: the def "DankPyon_RusticHearth" draws its fire with an extinguishable overlay

  @requires:OskarPotocki.VFE.Classical
  Scenario: the heat stones have one switch
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "VFEC_HeatStones" at (20, 64)
    Then Extinguish Refuelables Patch: the "VFEC_HeatStones" at (20, 64) has exactly one on/off switch
    And no errors were logged

  @requires:OskarPotocki.VFE.Medieval2
  Scenario: the Medieval 2 hearth has one switch and the swapped overlay
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "VFEM2_Hearth" at (24, 64)
    Then Extinguish Refuelables Patch: the "VFEM2_Hearth" at (24, 64) has exactly one on/off switch
    And Extinguish Refuelables Patch: the def "VFEM2_Hearth" draws its fire with an extinguishable overlay
    And no errors were logged

  @requires:OskarPotocki.VFE.Medieval2
  @requires:Ludeon.RimWorld.Ideology
  Scenario: the darklight hearth has one switch and the swapped overlay, with Ideology
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "VFEM2_HearthDarklight" at (28, 64)
    Then Extinguish Refuelables Patch: the "VFEM2_HearthDarklight" at (28, 64) has exactly one on/off switch
    And Extinguish Refuelables Patch: the def "VFEM2_HearthDarklight" draws its fire with an extinguishable overlay
    And no errors were logged
