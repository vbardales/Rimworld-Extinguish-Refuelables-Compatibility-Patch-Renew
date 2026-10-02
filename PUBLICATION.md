# Publication

What the Workshop page asks for and the repository holds nowhere else. Written 2026-10-02, **draft**:
the pictures do not exist yet (the gallery pass has not run), so the order below is a plan, not a
verified sequence. Nothing here was sent to Steam. The item exists, private, from the `0.1.0`
prepublication (id in `Mod/About/PublishedFileId.txt`).

## Version

`1.0.0` arrives with `published`. Until then the port stays under `Unreleased` in `CHANGELOG.md`, above
`0.1.0`. Publication is by CI only (`Rimworld-Release-Admin/docs/OPERATIONS.md`): green dry-run of the
exact commit, `publish` with the full 40-character SHA, `steam-production` approved by the owner. The
description of an existing item is not updated from `About.xml`: edit it on the Steam page, or through
the workflow's `update_description`. Rollback target: chosen before the publish, not after; none yet.

## Gallery

Rule of 2026-10-02: every gallery picture is a staged photograph. This mod adds no menu, so all three
are staged, in `Tests/Pickle/Mod/Pickle/Features/09-gallery.feature`, pass `gallery`
(`wsl-deps.gallery.map`, `-Filter '@gallery'`). Story: *The vigil of the cold hall*. Ambre keeps a hall,
lights every fire at dusk and puts them out one by one as the day comes.

| # | Capture file | Shows | Why it sits there |
|---|---|---|---|
| 1 | `gallery-1-dusk-every-fire-lit` | Brazier, stove and hearth lit, the keeper beside them | First image, shown large: the lit hall is what a visitor recognises. |
| 2 | `gallery-2-brazier-out-others-burn` | The brazier dark, the other two burning | The cause, in one frame: a fire switched off, its neighbours not. |
| 3 | `gallery-3-dawn-every-fire-out` | The Medieval 2 hearth and the wall torch dark | The effect: no flame left. |

Open every image before uploading. Disqualified: dev tools, the Pickle panel, another mod's overlay,
a lit picture without a flame, an off picture with one. **Nothing has been looked at.**

## Dependencies and DLC

- Hard: Extinguish Refuelables Continued (`blacktriple.extinguishrefuelablescontinued`, Workshop
  3772905265), used for two overlay classes.
- Optional, `loadAfter` only: Medieval Overhaul (3219596926), Vanilla Factions Expanded - Classical
  (2787850474), Medieval 2 (3444347874). The code references none of them.
- Ideology: the darklight hearth, guarded by `MayRequire`. Not a dependency.
- Declared incompatible: Keshash's original patch (`Keshash.ExtinguishRefuelablesPatch`). The
  statement is a prediction until pass 5 has run.

## Adult content boxes

None of the content is adult. Mod images: the three gallery pictures and the Preview, to be opened
before answering.

## Steam release notes

To write at send time, from the `CHANGELOG.md` section of the version. A first send without notes
leaves the page silent about what it holds.

## Thank-you comments

Register: `WORKSHOP_COMMENTS.md`. One main comment per page, ever, posted by the owner in her own voice
after the item is public. Drafts are not written: each needs the page read first (language, mood,
whether the author answers), and nothing in them may claim an in-game test that has not happened.

| Recipient | Workshop id | Register state | Note |
|---|---|---|---|
| Extinguish Refuelables Continued | 3772905265 | absent | Credit Mali (original) **and** Blacktriple (continuation) in the one message, on this page. |
| Medieval Overhaul | 3219596926 | posted (2026-09-25, from Flavor Text Extended - Français) | Add this mod to `Covers`; no second comment. |
| Vanilla Factions Expanded - Classical | 2787850474 | absent | Credit Oskar Potocki and the Vanilla Expanded team. Only if the heat stones really are covered in game. |
| Vanilla Factions Expanded - Medieval 2 | 3444347874 | absent | Same. |
| Keshash's original | 3109675320 | absent | Author of the patch this ports. Read the page for an author reply before drafting. |
