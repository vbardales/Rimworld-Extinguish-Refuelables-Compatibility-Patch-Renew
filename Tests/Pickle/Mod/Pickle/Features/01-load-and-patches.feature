Feature: The patches take in the real def database

  # These scenarios need no save: the def database is already built at the main menu, and
  # Pickle reads the patch tree just before the patches run, so "was patched by mod" says which
  # operation really changed which def after every other mod's patches and load order.
  # The mod name below is the one PatchOperationFindMod-style matching reads from About.xml.

  Scenario: the mod loads after the mod it depends on, and says nothing
    Then mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)" is loaded
    And mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)" loads after "blacktriple.extinguishrefuelablescontinued"
    And no errors were logged
    And no warnings from mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"

  @requires:DankPyon.Medieval.Overhaul
  Scenario: the ten Medieval Overhaul buildings were patched by this mod
    Then def "DankPyon_Brazier1x1c" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_Brazier2x2c" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_Candles" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_Candles_Beeswax" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_CandleStand" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_WallLamp" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_LampPost" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_WallTorch" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_WoodBurningStove" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And def "DankPyon_RusticHearth" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"

  @requires:DankPyon.Medieval.Overhaul
  Scenario: the beeswax candle stand upstream removed is still gone
    Then no def "DankPyon_CandleStand_Beeswax" exists

  @requires:OskarPotocki.VFE.Classical
  Scenario: the heat stones were patched by this mod
    Then def "VFEC_HeatStones" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"

  @requires:OskarPotocki.VFE.Medieval2
  Scenario: the Medieval 2 hearth was patched by this mod
    Then def "VFEM2_Hearth" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"

  @requires:OskarPotocki.VFE.Medieval2
  @requires:Ludeon.RimWorld.Ideology
  Scenario: the darklight hearth was patched by this mod, with Ideology
    Then def "VFEM2_HearthDarklight" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"

  # Played only in the pass without Ideology, selected by tag: a scenario that asserts the DLC is
  # absent cannot share a run with the DLC.
  @sans-ideology
  @requires:OskarPotocki.VFE.Medieval2
  Scenario: without Ideology the darklight hearth does not exist and nothing is reported
    Then mod "Ludeon.RimWorld.Ideology" is not loaded
    And no def "VFEM2_HearthDarklight" exists
    And def "VFEM2_Hearth" was patched by mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"
    And no errors were logged
    And no warnings from mod "Extinguish Refuelables Compatibility Patch Renew (unofficial)"

  Scenario: the base mod still patches its own buildings
    # Continued and this mod share no defName; the vanilla campfire is Continued's, not ours.
    Then def "Campfire" was patched by mod "Extinguish Refuelables Continued"
