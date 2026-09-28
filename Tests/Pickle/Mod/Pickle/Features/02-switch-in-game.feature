@requires:DankPyon.Medieval.Overhaul
Feature: The switch puts the flame out, and the state survives a save

  # First run, expected adjustments (none of this has been played): the cell (60, 60) must be free on
  # the "test-colony" map, the label "ancient brazier" is Medieval Overhaul's own (read from its 1.6
  # defs on 2026-09-13), and the gizmo label "Toggle power" is vanilla's default for CompFlickable
  # (CommandTogglePowerLabel, Core 1.6). Extinguish Refuelables Continued may relabel it; the first
  # failure message prints what the selection actually offers.
  #
  # The brazier is the sharpest case: it has no fuel to stop, so the drawn flame is most of what there
  # is to see, and it is drawn by the overlay comp this mod swaps. The captures are @review: a green
  # step says a file was taken, not that the flame is in it or gone. Somebody has to open them.

  @review
  Scenario: the ancient brazier is lit, then switched off and on again
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_Brazier1x1c" at (60, 60)
    And I move the camera to (60, 60)
    And I zoom all the way in
    And I select "ancient brazier"
    And I take a screenshot "brazier-lit"
    And I click gizmo "Toggle power"
    And I take a screenshot "brazier-switched-off"
    And I click gizmo "Toggle power"
    And I take a screenshot "brazier-lit-again"
    Then no errors were logged

  @review
  Scenario: a switched-off brazier stays off across a save and reload
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_Brazier1x1c" at (60, 60)
    And I move the camera to (60, 60)
    And I zoom all the way in
    And I select "ancient brazier"
    And I click gizmo "Toggle power"
    And I save and reload
    And I move the camera to (60, 60)
    And I select "ancient brazier"
    And I take a screenshot "brazier-off-after-reload"
    Then a "DankPyon_Brazier1x1c" exists
    And the save round trips
    And no errors were logged
