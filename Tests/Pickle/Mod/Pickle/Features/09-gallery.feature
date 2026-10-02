@requires:nelim.pickletools.screenshotstudio
@requires:nelim.pickletools.stagedecor
@requires:DankPyon.Medieval.Overhaul
@gallery
Feature: Workshop gallery, "The vigil of the cold hall"

  # Rule of 2026-10-02: every gallery picture is a staged photograph, menus excepted, and nothing in it
  # stays at its default. This mod adds no menu, so all of them are staged.
  #
  # THE STORY. Winter, before dawn. Ambre keeps the great hall: she lit every fire at dusk, and she
  # puts them out one by one as the day comes. Same hall, same hour, same keeper in all three
  # pictures, so the set reads as one night. What the viewer must understand without a caption is the
  # mod's whole point: a fire can now be switched off, and when it is, the flame is gone.
  #
  # THE SET, shared. A strip of plank floor with a stone band down the middle, two shelves and two
  # stools against the back wall, placed in the studio's empty indoor "display" stage (centre 125, 96),
  # photographed, then taken away so the next picture starts from the same bare stage.
  #
  # THE SUBJECT. Ambre: dark brown hair, a deep blue-grey tunic and trousers. The flame is orange; the
  # cool blue-grey is the colour that makes it stand out (the Preview uses the same pair). A Female body,
  # chosen, never the random one the generator rolls. No tattoo: nothing in this story gives her one.
  #
  # Order on the page, and why: 1 is the hero, all fires lit and the keeper at the brazier, because
  # the lit hall is what the viewer recognises; 2 shows the cause (one fire out, the others burning);
  # 3 shows the effect (all out). Captions are in PUBLICATION.md once written.
  #
  # Every scenario is @review: a green step only says a file was taken. Somebody opens each image and
  # checks a flame in the lit ones and none in the off ones, no dev tool, Pickle panel or other mod's
  # overlay in the frame, and Ambre dressed as above. Run with
  # "-DepMap wsl-deps.gallery.map -Filter '@gallery'". Skipped by @requires in the other passes.
  #
  # NOT YET PLAYED. The colonist steps (stands at, out of frame, body, hair, tattoo, dye) are
  # ColonistRace's, compiled by PickleTools on 2026-10-02 and not played either (PickleTools/docs/STAGING.md).

  Background:
    Given the save "nelim-zen-meadow-studio" is loaded
    And game speed is paused
    And god mode is enabled
    And Nelim's Pickle Tools: the screen is clear
    And Nelim's Pickle Tools: "Ambre" body type is Female
    And Nelim's Pickle Tools: "Ambre" hair colour is rgb (62, 40, 30)
    And Nelim's Pickle Tools: "Ambre" wears "Apparel_CollarShirt" dyed rgb (58, 74, 92)
    And Nelim's Pickle Tools: "Ambre" wears "Apparel_Pants" dyed rgb (46, 58, 72)
    And Nelim's Pickle Tools: "Ambre" face tattoo is "none"
    # Order matters: "out of frame" sends away every colonist that no "stands at" placed in this
    # scenario, so the subject is placed first. Both steps are PickleTools' (ColonistRace), written
    # 2026-10-02, compiled and not played.
    And Nelim's Pickle Tools: "Ambre" stands at (125, 95) facing South
    And Nelim's Pickle Tools: the other colonists are out of frame
    And Nelim's Pickle Tools: I lay the floor "WoodPlankFloor" from (121, 94) to (129, 98)
    And Nelim's Pickle Tools: I lay the floor "TileSandstone" from (124, 94) to (126, 98)
    And Nelim's Pickle Tools: I place the decor "Shelf" at (121, 94)
    And Nelim's Pickle Tools: I place the decor "Shelf" at (129, 94)
    And Nelim's Pickle Tools: I place the decor "Stool" at (122, 98)
    And Nelim's Pickle Tools: I place the decor "Stool" at (128, 98)

  @review
  Scenario: gallery-1 the hall at dusk, every fire lit and the keeper at the brazier
    When I spawn a "DankPyon_Brazier1x1c" at (125, 96)
    And I spawn a "DankPyon_WoodBurningStove" at (122, 96)
    And I spawn a "DankPyon_RusticHearth" at (128, 96)
    And Nelim's Pickle Tools: I frame the studio "display"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I zoom all the way in
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (125, 96) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (122, 96) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_RusticHearth" at (128, 96) is switched on
    When I take a screenshot "gallery-1-dusk-every-fire-lit"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged

  @review
  Scenario: gallery-2 the first fire goes out, the others still burn
    When I spawn a "DankPyon_Brazier1x1c" at (125, 96)
    And I spawn a "DankPyon_WoodBurningStove" at (122, 96)
    And I spawn a "DankPyon_RusticHearth" at (128, 96)
    And Nelim's Pickle Tools: I frame the studio "display"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I zoom all the way in
    And Extinguish Refuelables Patch: I switch the "DankPyon_Brazier1x1c" at (125, 96) off
    Then Extinguish Refuelables Patch: the "DankPyon_Brazier1x1c" at (125, 96) is switched off
    And Extinguish Refuelables Patch: the "DankPyon_WoodBurningStove" at (122, 96) is switched on
    And Extinguish Refuelables Patch: the "DankPyon_RusticHearth" at (128, 96) is switched on
    When I take a screenshot "gallery-2-brazier-out-others-burn"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged

  @requires:OskarPotocki.VFE.Medieval2
  @review
  Scenario: gallery-3 dawn, the hearth of the second hall and the torch go dark
    When I spawn a "VFEM2_Hearth" at (126, 96)
    And I spawn a "DankPyon_WallTorch" at (123, 94)
    And Nelim's Pickle Tools: I frame the studio "display"
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I zoom all the way in
    And Extinguish Refuelables Patch: I switch the "VFEM2_Hearth" at (126, 96) off
    And Extinguish Refuelables Patch: I switch the "DankPyon_WallTorch" at (123, 94) off
    Then Extinguish Refuelables Patch: the "VFEM2_Hearth" at (126, 96) is switched off
    And Extinguish Refuelables Patch: the "DankPyon_WallTorch" at (123, 94) is switched off
    When I take a screenshot "gallery-3-dawn-every-fire-out"
    And Nelim's Pickle Tools: the decor is removed
    Then no errors were logged
