---
settings_audit: not_applicable
localization: not_applicable
translation_en: not_applicable
translation_fr: not_applicable
mod:          Extinguish Refuelables Compatibility Patch Renew (unofficial)
packageId:    nelim.extinguishrefuelablescompatibilitypatchrenew
repo:         Rimworld-Extinguish-Refuelables-Compatibility-Patch-Renew
remote:       https://github.com/vbardales/Rimworld-Extinguish-Refuelables-Compatibility-Patch-Renew.git
visibility:   public
mod_visibility: public, not published to Workshop
repository_visibility: public
local_path:   C:\Users\nelim\Documents\rimworld\ExtinguishRefuelablesCompatibilityPatchRenew
detached:     yes
maintainer:   Codex, current task responsible for this repository and STATUS.md
stage:        done
licence:      silent
licence_at:   _tools/LICENCE-AUDIT.md; original local files and live Steam description checked 2026-09-13
port_licence: MIT, additions only
dependencies: declared
showcase:     complete, recomposed and visually verified 2026-09-13
tested_on:
workshop:
automated_tests: passed, 16 XML combinations, installed 1.6 targets and DLL types, 72 C# cases
build:        passed, Release net48, 0 warnings and 0 errors
remaining:
  - unverified: manual scenarios 0-16 not executed; mandatory for tested, not for done
  - unverified: English/French UI, logs, new game, existing save and switch persistence; mandatory for tested
session:      local_52a44608-2383-4e78-b72e-789405b47e80
updated:      2026-09-13, ordered workflow audit; done retained, game validation required for tested
---

# Repository identity and maintenance

This task manages only the local repository at `local_path`, including keeping this status
current after changes and verification. `git rev-parse --show-toplevel` resolves to this folder;
its `.git` is a directory, and `--show-superproject-working-tree` returns nothing. This is an
independent local repository, not a monorepo subdirectory or a submodule.
The session field is the historical session group identifier, not an asserted current task ID.

GitHub's public REST API confirmed `private: false` and `visibility: public` on 2026-09-13.
The mod's documented distribution status is public; Workshop publication is not recorded and
there is no `Mod/About/PublishedFileId.txt`. Public repository visibility is separate from licence.

# Mod licence and title

**Classification: `silent` — no explicit original licence found.** Verified on 2026-09-13
against the installed original's full file inventory, source notices and About.xml, and the
original Workshop description fetched directly from Steam. No original repository is linked,
and targeted web searches did not identify one. Evidence and limits are recorded in
[`_tools/LICENCE-AUDIT.md`](_tools/LICENCE-AUDIT.md).

No written refusal was found (`forbidden`), no explicit original licence was found (`open`),
and this continuation is not `original`. Both identical LICENSE files scope MIT to the port's
additions only. No explicit permission to redistribute the original has been established.
Public visibility and removal on request do not supply that permission.

Correction: the 1.4 tag does not establish abandonment. The author replied about compatibility
in November 2024; current maintenance status is uncertain. `silent` here records licence silence;
if the catalogue also requires proven abandonment, that prerequisite remains unverified.

Keep the existing **`(unofficial)`** suffix: it identifies the continuation without explicit
author consent. It is present in About.xml and README. The GitHub link is now present in both
About.xml's `url` field and the actual description text.

# Verification

- Manual: `_tools/FUNCTIONAL-SCENARIOS.md` contains 17 scenarios (0-16), with actions,
  expected outcomes and failure clues. None has a recorded game run. `tested_on` remains empty.
- Automated XML: `pwsh -NoProfile -File _tools/Test-Xml.ps1` passed on 2026-09-13.
  Tests apply the supported patch operations using .NET XPath to independent contract fixtures,
  across all 8 target-mod combinations with and without Ideology. They check all 13 targets,
  single switches, comp order, overlay replacements, preserved size/offset and existing comps,
  untouched unrelated definitions, mod guards, DLC guards and core metadata.
- Build: `dotnet build -c Release Source/ExtinguishRefuelablesPatch.csproj --no-restore`
  passed on 2026-09-13 with 0 warnings and 0 errors.
- Installed mods: `_tools/Test-InstalledMods.ps1` passed against local Steam 1.6 definitions
  on 2026-09-13, with 12 targets without Ideology and 13 with it. Exact mod-name guards,
  original overlay classes, single added switches and preservation of existing comp data pass.
  All three replacement types exist in the shipped DLL metadata. No target name overlaps
  Continued's installed patch XML.
- C#: `_tools/Test-Behaviour.ps1` compiles the actual production source with minimal test
  doubles and passes 72 fuel/switch/rotation/spawn cases, including absent comps, north-only
  rendering, the height offset, delayed growth start and preservation of an existing timer.
- Release rebuild: 0 warnings, 0 errors; shipped DLL hash unchanged after rebuild.
- Packaging: `Mod/` contains only metadata, two images, three XML patches, the mod DLL,
  licence and attribution. Test harnesses, source and game assemblies are not packaged.
- Limits: these are offline checks against installed copies, not a fresh Workshop download.
  Raw upstream defs are inspected before other mods' patches and full XML inheritance.
  DLL metadata checks prove type presence; Unity loading, actual rendering and save behaviour
  are not executed. Test doubles exercise this mod's logic, not the engine implementations.
  Manual scenarios remain unplayed and explicitly non-blocking by user instruction.

The required Continued dependency is declared. The three target mods remain optional and are
listed in loadAfter, with each patch guarded by mod name. No additional dependency was introduced.

# Preview recomposition — 2026-09-13

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

# Completion and localization

`stage: done` records completion of implementation, documentation, packaging and all scoped
out-of-game checks. The user explicitly excluded in-game testing and confirmed that it does
not block stages. `tested_on` remains empty rather than claiming a game session.
Workshop publication has not been performed.

Installed source IDs checked: Medieval Overhaul 3219596926, Classical 2787850474,
Medieval 2 3444347874, Continued 3772905265. Scripts accept a different Workshop root.
Run the three PowerShell test scripts in separate fresh `pwsh -NoProfile -File` processes;
the C# harness defines test-only RimWorld/Verse/Unity names within its own process.

## Translation audit — 2026-09-13

Applied the translation gate in the parent workspace's `PUBLISHING.md` and
`TRANSLATIONS.md`. All three fields use the protocol's `not_applicable` value because
the inventory below found no text added or changed by this mod. This replaces the previous
free-form `checked` values; it does not certify dependency translations or in-game display.

Inventory and evidence:

- Enumerated published content and source with `rg --files Mod Source`, then read the
  complete production C# file and all three patch XML files. There are no `LoadFolders.xml`,
  version folders, owned Defs, language resources or additional UI source files.
- `Source/CompFireOverlaySouthExtinguishable.cs` implements flame rendering, fuel/switch
  conditions and the growth timer only. It adds no settings, gizmos, inspect strings,
  messages, generated text or translation calls, including through helper methods.
- `Mod/Patches/MedievalOverhaul.xml`, `VanillaFactionsExpandedClassical.xml` and
  `VanillaFactionsExpandedMedieval2.xml` add empty `CompProperties_Flickable` entries and
  replace overlay class attributes. All optional mod branches and the Ideology branch
  were inspected: none adds or overrides labels, descriptions or other text fields.
- The switch UI comes from the existing game comp; building text remains owned by the
  target mods. No dependency translation key is explicitly referenced or newly supplied
  by this mod. Their full English/French coverage was not audited here.
- There are zero owned Keyed keys, DefInjected paths, parameters or grammar resources to
  validate. `Check-DefInjected.ps1` is not applicable. Empty language folders and duplicate
  translations of upstream text are unnecessary.
- About.xml, preview text, licences, attribution and repository documentation are English
  metadata/documentation, excluded from the in-game translation gate by the protocol.

The static translation gate is satisfied. English/French runtime display has not been
checked and is tracked separately in `remaining`; the existing exclusion of in-game tests
is preserved. Repeat this inventory after changes to UI code, Defs, patches or text resources,
resetting affected fields to `unchecked` until the audit is complete.

# Ordered workflow audit — 2026-09-13

This section and the current front matter supersede earlier interpretations above while
preserving historical results. Audited revision: `9258f4b048355d3ecbe28db3c178edb43a583213`.
The working tree was clean at entry. Only STATUS.md was edited by this audit; build
intermediates and a fetched Steam page are under ignored `.build/`. No implementation,
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

## Settings audit

Scope: the full production C# file, csproj/default compile inventory and every distributed
patch/metadata file. The mod only adds building switches, replaces overlay types and keeps
north-only flame rendering with fuel/switch conditions and growth-timer behavior. Per-building
on/off control already uses vanilla CompFlickable. Fire size/offsets belong to upstream
building definitions; they are compatibility data, not a missing user configuration interface.
No concrete additional global option is required by this mod's purpose.

There is no Verse.Mod subclass, ModSettings, SettingsCategory, settings window, settings
serialization, MainButtonDef or MainTabWindow in its sources/defs. Thus there is neither an
empty page nor a shortcut to expose. Defaults/input bounds/settings persistence and RIMMSQOL
settings integration tests are not applicable. **No RIMMSQOL or other customization integration
was tested or claimed.** Building-switch save behavior is separate and remains a game test.
The current user clarification makes this source-based not_applicable finding sufficient for
options; it overrides the older document's runtime requirement for this case.

## Commands and observed results

- `pwsh -NoProfile -File _tools/Test-Xml.ps1`: PASS, 16 target-mod/DLC combinations.
- `pwsh -NoProfile -File _tools/Test-Behaviour.ps1`: PASS, 72 cases against test doubles
  compiling actual production source; does not run RimWorld/Unity or exercise real saves.
- `pwsh -NoProfile -File _tools/Test-InstalledMods.ps1`: PASS, 12 installed targets without
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

## Licence classification and documentary findings

The installed original inventory and notices were rechecked: only a copyright notice, no
licence grant or source repository link. The live original Steam description and tag were
retrieved with Invoke-WebRequest after Firecrawl was unavailable and the web reader failed;
local evidence: `.build/audit-steam-2026-09-13.html`. The description contains no licence,
permission or prohibition; Steam and installed metadata declare 1.4, not 1.6. The historical
bounded search/comments review in _tools/LICENCE-AUDIT.md is retained, not claimed as rerun.

Under the current PUBLISHING.md operational definition, the missing declared 1.6 support
establishes abandonment **for this workflow**. The older demand above for additional proof
of inactivity is superseded. `silent`, public and `(unofficial)` are coherent under that
rule; MIT remains limited to port additions and does not grant rights over the original.

Historical finding, corrected in the follow-up below: About.xml contains a raw GitHub URL
in the middle of its description, rather than the required final Steam-formatted
`[url=...]Source code on GitHub[/url]` link. Earlier prose claiming that link was complete
was too broad. This is required before Workshop publication, which is outside the nine
state transitions; it is not a missing English description or a blocker to done/tested.
The descriptive claims about safe save addition/removal remain unverified until the
existing scenarios are played, not proven defects.

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
No Workshop item exists for this mod, so updating a live description is not applicable.