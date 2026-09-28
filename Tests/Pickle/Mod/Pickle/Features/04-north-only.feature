@requires:DankPyon.Medieval.Overhaul
Feature: The stove and the rustic hearth draw their flame only facing north

  # The rule itself is proved offline, all four rotations, 72 cases against test doubles. What only a
  # running game shows is the picture, so each facing is a @review capture: a green step says a file
  # was taken, not that a flame is in it or absent. Somebody has to open the four.
  # The stove faces north when spawned; the rotate step sets the others.

  @review
  Scenario Outline: the wood burning stove facing each way
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_WoodBurningStove" at (60, 60)
    And Extinguish Refuelables Patch: I rotate the "DankPyon_WoodBurningStove" at (60, 60) to <facing>
    And I move the camera to (60, 60)
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (60, 60) faces <facing>
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (60, 60) is switched on
    When I take a screenshot "stove-<facing>-lit"
    And Extinguish Refuelables Patch: I switch the "DankPyon_WoodBurningStove" at (60, 60) off
    And I take a screenshot "stove-<facing>-off"
    Then no errors were logged

    Examples:
      | facing |
      | North  |
      | East   |
      | South  |
      | West   |

  @review
  Scenario Outline: the rustic hearth facing each way
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_RusticHearth" at (60, 64)
    And Extinguish Refuelables Patch: I rotate the "DankPyon_RusticHearth" at (60, 64) to <facing>
    And I move the camera to (60, 64)
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_RusticHearth" at (60, 64) faces <facing>
    When I take a screenshot "hearth-<facing>-lit"
    And Extinguish Refuelables Patch: I switch the "DankPyon_RusticHearth" at (60, 64) off
    And I take a screenshot "hearth-<facing>-off"
    Then no errors were logged

    Examples:
      | facing |
      | North  |
      | East   |
      | South  |
      | West   |
