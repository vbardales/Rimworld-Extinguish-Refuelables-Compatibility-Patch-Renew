@incompat-keshash
@requires:Keshash.ExtinguishRefuelablesPatch
@requires:DankPyon.Medieval.Overhaul
Feature: The declared incompatibility with Keshash's original patch

  # incompatibleWith names Keshash.ExtinguishRefuelablesPatch because both patch the same defs. Green
  # here means the incompatibility behaves as declared. The symptom below is a PREDICTION, read off the
  # original's own patch files, not yet observed: its first operation on Medieval Overhaul adds a
  # CompProperties_Flickable, this mod adds one too, so a brazier ends up with two switches, and the
  # operations that name the old namespaces fail. If a run differs, the prediction is what changes.
  # A patch failure is an error in the log, which is expected here and is what @allow-errors is for.

  @allow-errors
  Scenario: both patches apply to the same brazier, which ends up with two switches
    Then mod "Keshash.ExtinguishRefuelablesPatch" is loaded
    And mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)" is loaded
    And def "DankPyon_Brazier1x1c" was patched by mod "Extinguish Refuelables Compatibilty Patch"
    And def "DankPyon_Brazier1x1c" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And an error matching "Extinguish Refuelables Compatibilty Patch" was logged
    Given the save "test-colony" is loaded
    And god mode is enabled
    When I spawn a "DankPyon_Brazier1x1c" at (60, 60)
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (60, 60) has 2 on/off switches
