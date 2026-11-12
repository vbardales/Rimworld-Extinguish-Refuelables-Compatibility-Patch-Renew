# STATUS.md history, folded out on 2026-10-11 (audits of 2026-09-13, 2026-09-28 and the Preview notes). Superseded by the re-audit of 2026-10-11 in STATUS.md.

# Audit against AUDIT.md — 2026-09-28

Audited revision `e60310a` plus uncommitted documentation and test files added by this audit.
Untracked and left alone: `Art/ModIcon.ico`, `Art/Preview.ico`. Documents read, and their versions,
are in `docs/PROTOCOLS-READ.md`. No RimWorld was launched and no Pickle run was submitted.

Decision: **done -> done**, on a corrected basis. The 2026-09-13 audit below found `done` validated
without any Pickle scenario, because the criterion did not yet exist. `AUDIT.md` now requires Pickle
scenarios to be **written** and their scope justified before `done`. Before this audit that criterion
failed, so the honest stage was `preTest`. It is met now by `Tests/Pickle/` and `TESTING.md`, which
also map all 17 manual scenarios to a disposition. Nothing in the suite has been run.

What changed since the earlier audit, and what it does to the chain:

- **Prepublication happened.** `Mod/About/PublishedFileId.txt` exists (item created 2026-09-23). The
  CHANGELOG now opens with `0.1.0`, dated by that file's timestamp, and the port's content sits under
  `Unreleased` above it, since 1.0.0 arrives with `published`. That earlier changelog dated a 1.0.0 on
  2026-09-05 which was never tagged or released. This is a prepublication, not the `prepublished` state.
- **packageId lost `renew`** (`nelim.extinguishrefuelablescompatibilitypatch`), on the owner's instruction
  and in line with `PUBLISHING.md` (2026-09-27). The 0.1.0 item was uploaded under the old id.
- **The offline installed-defs test can no longer complete.** Medieval Overhaul is missing from the local
  Steam workshop folder; its ten targets are unverified, not failed. The 2026-09-13 pass stands for what
  it read then.
- **Extinguish Refuelables Continued does not cover this mod.** Its installed copy is 1.6-only and
  patches the base game, Vanilla Furniture Expanded, Smoked meat and Medieval Lighting and Heat. No
  defName of Medieval Overhaul, Classical or Medieval 2 appears in it.
- **No original repository.** GitHub searches for Keshash's patch and for Extinguish Refuelables find
  nothing to fork or send a pull request to. Mali's original source is mirrored in `emipa606/ModRequests`
  (2864470385), which is a request register, not a maintained upstream. Continued links no repository.
- **`.dds`:** none in the repository or its history to remove; `*.dds` and the evidence folders are now
  ignored. **Evidence:** none was ever committed; retention rules are in `TESTING.md`.

Distance to `tested`, from `AUDIT.md`: see `remaining`. Scenarios 1, 3, 5, 6, 15 and 16 and the
Keshash pass are written since, unrun; scenario 7 is not written.

# Preview recomposition — 2026-09-13

**Replaced on 2026-10-02.** The owner regenerated `Mod/About/Preview.png` and `Mod/About/ModIcon.png` and
cleaned `Art/`. Gone from the repository: `Art/preview.html`, `Art/render-preview.cjs`, `Art/preview-qa.json`,
`Art/preview-background.png`, `Art/preview-268.png`, `Art/Preview.png`. The composition is now described by
`Art/preview-copy.json` (with `Art/echo.png`), the sources stay `Art/ModIcon-source.png` and
`Art/Preview-source.png`, and `Art/Gallery/` holds the Workshop pictures. Every measurement below
(size, fonts, contrast, title sizes) describes the **previous** image and no longer holds for the shipped
one; the paragraph is kept as history only. The shipped Preview and icon are not re-measured by this
session: icon and Preview generation belong to the owner (`AUDIT.md`).

- Final: `Mod/About/Preview.png`, 896 × 504, 653,861 bytes (under 900 KB).
- Illustration retained without regeneration. `Art/Preview.png` is a byte-identical copy of
  `Art/Preview-source.png`; the full-resolution original remains preserved at that path.
  No text has been added to either source. Top-aligned cover framing keeps both braziers below
  the text and readable. No publication was performed.
- Composition and parameters: `Art/preview.html`; sole colour reference:
  `Art/preview-palette.json`. Reproduce with `node Art/render-preview.cjs` using the bundled
  Playwright/Sharp dependencies and installed Chrome. Version is read from the shipped About.xml.
- Palette rationale: the broad cool stone slabs provide the slate veil and the blue-grey
  material family used for the light blue secondary ink. The orange flame and its warm pool
  supply the accent; its warm saturated orange separates clearly from the cool blue tag.
  The dominant material family is retained rather than averaging stone and fire together.
- Exact name and summary preserved, with Renew at 65% and `(unofficial)` on its own line.
  Title 38 px fits two lines; text block starts at (50,54). Summary remains 21 px / 430 px.
  The dark coloured radial veil holds behind the text and fades vertically below it to preserve
  the flame. Standard dark-veil text shadow retained. Badge uses declared stable version 1.6.
- Actual rendered fonts verified through Chrome DevTools after `document.fonts.ready`:
  Segoe UI Semibold for title, Segoe UI regular for tag/summary, Segoe UI Bold for badge.
  No fallback. Report: `Art/preview-qa.json`.
- Contrast checked against every pixel in the text rectangles of the rendered background-only
  image (`Art/preview-background.png`), without relying on text shadows: title 10.916:1,
  Renew 8.304:1, tag 8.005:1, summary 6.138:1; badge ink on its opaque accent 9.783:1.
  All exceed 4.5:1. Bounds checked within the frame.
- Visually inspected at 896 × 504 and in `Art/preview-268.png`: no clipping or overlap,
  both subjects clear, title/Renew/version identifiable, rule visible, secondary/accent distinct.
  The summary is intended for the full-size view, as specified by the style guide.

# Ordered workflow audit — 2026-09-13

This section and the current front matter supersede earlier interpretations above while
preserving historical results. Audited revision: `9258f4b048355d3ecbe28db3c178edb43a583213`.
The working tree was clean at entry. Only STATUS.md was edited by this audit; build
intermediates and a fetched Steam page are under ignored `build/`. No implementation,
image, licence or distributed document was changed; no commit, push or publication occurred.

Decision: **done -> done**. These are the user's literal workflow states, not aliases:
`dansMonoRepo -> horsMonoRepo -> ModIcon générée -> Preview générée -> preOptions ->
options -> l10n -> preTest -> done -> tested`. Here `done` means ready for final game
validation. The earlier exclusion of game testing does not waive the current `tested` gate.

## Ordered gate results

| Transition | Result | Current evidence |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Validated | Independent .git directory and root, no superproject; origin configured; live git ls-remote origin HEAD equals the audited revision; GitHub API reports public/private=false and main. English README, ATTRIBUTION, LICENSE and CHANGELOG present; distributed attribution/licence copies byte-identical. Package ID, title, folder and repository consistently identify this continuation. |
| horsMonoRepo -> ModIcon générée | Validated | Production source and three patches reviewed; Release net48 build passed, 0 warnings/errors; shipped DLL unchanged after build. Installed PNG icon is 128x128, 24,268 bytes and directly inspected. No unfinished implementation identified by available checks. |
| ModIcon générée -> Preview générée | Validated | Directly inspected shipped PNG, 896x504, 653,861 bytes, below 1 MB; coherent overhead scene, tiled ground, lit/unlit subjects, no concrete camera defect. |
| Preview générée -> preOptions | Validated | English description and image text; exact unofficial title, Renew reduced to 65% in secondary ink, separate unofficial tag; no linking words requiring reduction in this title. Cool blue secondary and warm orange accent visibly distinct. Full image and existing 268 px derivative inspected: no clipping/overlap. Art HTML loads the single palette JSON. |
| preOptions -> options | Not applicable, justified; gate passed | Settings inventory below; no empty settings page or MainButtons shortcut. No invented settings required. |
| options -> l10n | Not applicable, justified; gate passed | Complete production source and all distributed XML re-read. No owned player-facing text, Keyed calls, DefInjected paths, parameters or grammar resources. Only vanilla switch UI and unchanged upstream building text; no redundant language files required. |
| l10n -> preTest | Validated | Continued required and used for two XML overlay classes; three target mods optional, correctly ordered and guarded by exact installed names. Package IDs and 1.6 support checked in installed About files. Medieval 2 Ideology load folder agrees with MayRequire on sequence list entries. No local LoadFolders/version folder. Harmony is transitive through Continued, VEF through optional target mods; no direct API usage requiring either to be added here. |
| preTest -> done | Validated | Existing 17 manual scenarios have shared setup/preconditions, actions and expected results; all three existing offline test scripts rerun successfully, plus build. Results apply to the unchanged delivered DLL/XML. |
| done -> tested | Unverified | No game session performed or matching runtime evidence found in the repository. Scenarios, logs, EN/FR UI, new game, existing-save addition/removal and switch persistence still require execution. |

## Commands and observed results

- `pwsh -NoProfile -File scripts/Test-Xml.ps1`: PASS, 16 target-mod/DLC combinations.
- `pwsh -NoProfile -File scripts/Test-Behaviour.ps1`: PASS, 72 cases against test doubles
  compiling actual production source; does not run RimWorld/Unity or exercise real saves.
- `pwsh -NoProfile -File scripts/Test-InstalledMods.ps1`: PASS, 12 installed targets without
  Ideology, 13 with it, preserved comp data, replacement DLL types and no Continued overlap.
  These are raw installed defs, not the complete engine inheritance/patch pipeline.
- `dotnet build -c Release Source/ExtinguishRefuelablesPatch.csproj --no-restore`: initial
  sandbox access error for Microsoft SDKs; authorized retry passed, 0 warnings/0 errors.
  DLL SHA256 before/after: `48717BB5038B3392DEF1CAF6CF8B5CA9253A45F97A9A46B623B326F8EC818D4D`.
- GitHub read checks initially hit sandbox network/config restrictions; authorized retry
  verified the pushed revision and public visibility. These were environment restrictions,
  not repository/build defects.
- PNG dimensions/format read with System.Drawing; icon and full/thumbnail Preview directly
  viewed. Historical font/contrast measurements in Art/preview-qa.json are preserved;
  those numeric measurements were not rerun or presented as fresh measurements.
- LICENSE/Mod/LICENSE SHA256 match; ATTRIBUTION.md/Mod/ATTRIBUTION.md SHA256 match.
  Mod contains nine files, no source, test harness or game/reference DLL.

## Strict next transition and optional follow-up

To reach tested, execute the applicable functional scenarios in RimWorld 1.6, record exact
mod/game versions and outcomes, inspect logs and EN/FR UI, and cover a new game and existing
saves including switch persistence. Scenario 8 is explicitly not applicable to normal shipped
defs without a growth duration; record that distinction instead of inventing a pass.
Retest any affected behavior after corrections. No settings page or shortcut is needed.
No game was launched by this audit; runtime results remain unverified, not failed.

Optional documentary cleanup: align the older abandonment/testing wording in README,
ATTRIBUTION and scenario notes with this audit, preserving their historical evidence.
No optional visual correction is identified.

## Description link correction and workflow integration — 2026-09-13

Replaced the raw source URL in the middle of About.xml with the exact Steam-formatted
`Source code on GitHub` link at the end of the description, after credits. Its target
matches the metadata URL and the verified repository remote.

The shared PUBLISHING.md now assigns this check to `Preview générée -> preOptions`:
the final formatted link and exact repository target are mandatory gate criteria, not
an item outside the workflow. This supersedes the earlier audit's classification above.
The corrected artifact satisfies the added criterion; `stage: done` is retained.
Only metadata changed; independent build, behavior and image validations remain valid.
XML parsing, the final-link/URL check and the existing XML suite passed after the change.
At the time, no Workshop item existed. One was created on 2026-09-23, see the 2026-09-28 audit above.


## Preview source migration — 2026-10-03

Copy, typography, layout and palette are consolidated in `Art/Preview.config.json`. Canonical inputs are `Art/Preview-source.png`, `Art/echo.png` and `Art/ModIcon-source.png`; temporary renderer diagnostics belong under ignored `Art/.render/`. Existing Preview, gallery and ICO outputs were preserved because they were present and coherent; no render was run. Superseded JSON files and generated QA intermediates were removed. Nothing published.
