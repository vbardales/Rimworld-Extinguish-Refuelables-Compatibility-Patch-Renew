@requires:DankPyon.Medieval.Overhaul
Feature: The mod added to a save already in progress

  # A save written without this mod holds no switch state for a building and no trace of the swapped
  # overlay: comps are rebuilt from the def at every load, and their saved data is read if present.
  # The strip step takes the switch comp off standing buildings, so the file saved next is the file a
  # game without this mod would have written. Reloading it with the patches active is the case.
  # The engine's own handling of a changed mod list is not this mod's and is not tested.

  Scenario: buildings saved with no switch come back with one, lit
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_Brazier1x1c" at (40, 68)
    And I spawn a "DankPyon_WoodBurningStove" at (44, 68)
    And I spawn a "DankPyon_WallTorch" at (48, 68)
    And Extinguish Refuelables Patch: I strip the on/off switch from the "DankPyon_Brazier1x1c" at (40, 68)
    And Extinguish Refuelables Patch: I strip the on/off switch from the "DankPyon_WoodBurningStove" at (44, 68)
    And Extinguish Refuelables Patch: I strip the on/off switch from the "DankPyon_WallTorch" at (48, 68)
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (40, 68) has no on/off switch
    When I save and reload
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (40, 68) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (44, 68) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (48, 68) has exactly one on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (40, 68) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (44, 68) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (48, 68) is switched on
    And no errors were logged
