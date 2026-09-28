Feature: The torch and the Medieval 2 hearth flames go out with the switch

  # Same method as 02 and 04: the switch state is asserted, the flame is a @review capture that
  # somebody has to open. The wall torch is drawn by the vanilla overlay, the hearth by the same
  # class Extinguish Refuelables Continued supplies for its own buildings.

  @requires:DankPyon.Medieval.Overhaul
  @review
  Scenario: the rustic wall torch, lit then switched off
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_WallTorch" at (60, 72)
    And I move the camera to (60, 72)
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (60, 72) is switched on
    When I take a screenshot "torch-lit"
    And Extinguish Refuelables Patch: I switch the "DankPyon_WallTorch" at (60, 72) off
    Then Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (60, 72) is switched off
    When I take a screenshot "torch-off"
    Then no errors were logged

  @requires:OskarPotocki.VFE.Medieval2
  @review
  Scenario: the Medieval 2 hearth, lit then switched off
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "VFEM2_Hearth" at (60, 76)
    And I move the camera to (60, 76)
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "VFEM2_Hearth" at (60, 76) is switched on
    When I take a screenshot "medieval2-hearth-lit"
    And Extinguish Refuelables Patch: I switch the "VFEM2_Hearth" at (60, 76) off
    Then Extinguish Refuelables Patch: the "VFEM2_Hearth" at (60, 76) is switched off
    When I take a screenshot "medieval2-hearth-off"
    Then no errors were logged

  @requires:OskarPotocki.VFE.Medieval2
  @requires:Ludeon.RimWorld.Ideology
  @review
  Scenario: the darklight hearth, lit then switched off
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "VFEM2_HearthDarklight" at (60, 80)
    And I move the camera to (60, 80)
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "VFEM2_HearthDarklight" at (60, 80) is switched on
    When I take a screenshot "darklight-hearth-lit"
    And Extinguish Refuelables Patch: I switch the "VFEM2_HearthDarklight" at (60, 80) off
    Then Extinguish Refuelables Patch: the "VFEM2_HearthDarklight" at (60, 80) is switched off
    When I take a screenshot "darklight-hearth-off"
    Then no errors were logged
