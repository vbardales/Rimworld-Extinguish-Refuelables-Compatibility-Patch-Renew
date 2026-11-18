@requires:DankPyon.Medieval.Overhaul @requires:nelim.pickletools.savesteps
Feature: The mod removed from a save in progress

  # Two launches under one hold of the lock: the first writes a save with this mod, the second loads it
  # with this mod taken out of the mod list (-ThenWithout). The test companion does not depend on the
  # mod, or taking it out would take the companion with it.
  # The first launch hands the save to the test companion, which stays loaded: the second launch finds it as a
  # fixture (a plain "save and reload as" save is not one, run cb15: "Fixture 'efc-remove-mod' not found").
  # What the mod page warns about is asserted here as a fact rather than reasoned: a switched-off
  # building loses its switch with the mod, and comes back burning like the target mod's own def.

  Scenario: write a save with one building switched off and one on
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_WoodBurningStove" at (60, 84)
    And I spawn a "DankPyon_Brazier1x1c" at (64, 84)
    And Extinguish Refuelables Patch: I switch the "DankPyon_WoodBurningStove" at (60, 84) off
    Then Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (60, 84) is switched off
    And Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (64, 84) is switched on
    When Nelim's Pickle Tools: the game is saved as "efc-remove-mod"
    And Nelim's Pickle Tools: the saved game "efc-remove-mod" is handed to the mod "nelim.extinguishrefuelablescompatibilitypatch.pickletests"
    Then a "DankPyon_WoodBurningStove" exists
    And no errors were logged

  Scenario: read it without the mod
    Given the save "efc-remove-mod" is loaded
    Then mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)" is not loaded
    And a "DankPyon_WoodBurningStove" exists
    And a "DankPyon_Brazier1x1c" exists
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (60, 84) has no on/off switch
    And Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (64, 84) has no on/off switch
    And no errors were logged
