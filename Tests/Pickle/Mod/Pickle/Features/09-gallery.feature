@requires:nelim.pickletools.screenshotstudio
@requires:DankPyon.Medieval.Overhaul
@gallery
Feature: Workshop gallery captures

  # Pictures for the Workshop page, not checks: every scenario is @review. Order on the page is in
  # PUBLICATION.md; Steam shows the first one large, so "gallery-1" is the most demonstrative one:
  # the same brazier, lit then switched off, in one frame. Taken in the screenshot studio's empty
  # indoor demonstration stage, interface hidden by the studio's presentation mode (the game's own
  # screenshot mode, restored after the scenario). The state of each building is asserted BEFORE its
  # capture, but a green step only says a file was taken: somebody has to open every image and
  # check that a flame is in the lit one and gone from the off one, that no dev tool, Pickle panel
  # or other mod's overlay is in the frame, and that the stage is not empty.
  # Run with "-DepMap wsl-deps.gallery.map -Filter '@gallery'". Never in the other passes: without
  # the studio mod these scenarios are skipped by @requires.

  Background:
    Given the save "nelim-zen-meadow-studio" is loaded
    And game speed is paused
    And god mode is enabled
    And Nelim's Pickle Tools: the screen is clear

  @review
  Scenario: gallery-1 two braziers, one lit and one switched off
    When I spawn a "DankPyon_Brazier1x1c" at (124, 96)
    And I spawn a "DankPyon_Brazier1x1c" at (127, 96)
    And Nelim's Pickle Tools: I frame the studio "display"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (124, 96) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (127, 96) is switched on
    When Extinguish Refuelables Patch: I switch the "DankPyon_Brazier1x1c" at (127, 96) off
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (127, 96) is switched off
    When I take a screenshot "gallery-1-braziers-lit-and-off"
    Then no errors were logged

  @review
  Scenario: gallery-2 the stove and the hearth, lit then out
    When I spawn a "DankPyon_WoodBurningStove" at (123, 96)
    And I spawn a "DankPyon_RusticHearth" at (127, 96)
    And Nelim's Pickle Tools: I frame the studio "display"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (123, 96) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_RusticHearth" at (127, 96) is switched on
    When I take a screenshot "gallery-2-stove-and-hearth-lit"
    And Extinguish Refuelables Patch: I switch the "DankPyon_WoodBurningStove" at (123, 96) off
    And Extinguish Refuelables Patch: I switch the "DankPyon_RusticHearth" at (127, 96) off
    Then Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (123, 96) is switched off
    And Extinguish Refuelables Patch: the "DankPyon_RusticHearth" at (127, 96) is switched off
    When I take a screenshot "gallery-2-stove-and-hearth-off"
    Then no errors were logged

  @requires:OskarPotocki.VFE.Medieval2
  @review
  Scenario: gallery-3 the wall torch and the Medieval 2 hearths
    When I spawn a "DankPyon_WallTorch" at (123, 96)
    And I spawn a "VFEM2_Hearth" at (126, 96)
    And Nelim's Pickle Tools: I frame the studio "display"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (123, 96) is switched on
    And Extinguish Refuelables Patch: the "VFEM2_Hearth" at (126, 96) is switched on
    When I take a screenshot "gallery-3-torch-and-hearth-lit"
    And Extinguish Refuelables Patch: I switch the "DankPyon_WallTorch" at (123, 96) off
    And Extinguish Refuelables Patch: I switch the "VFEM2_Hearth" at (126, 96) off
    And I take a screenshot "gallery-3-torch-and-hearth-off"
    Then no errors were logged
