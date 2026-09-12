---
localization: checked, no mod-owned in-game strings
translation_en: checked, English metadata; in-game text inherited
translation_fr: not applicable, no mod-owned in-game strings
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
  - non_blocking: manual scenarios 0-16 not executed, explicitly excluded by user
session:      local_52a44608-2383-4e78-b72e-789405b47e80
updated:      2026-09-13, offline verification complete; in-game tests non-blocking by user instruction
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

Localization audit: the three patches add/replace comps only; they define no labels,
descriptions or translation keys. The C# class emits no user-visible strings or custom gizmos.
English and French in-game labels and switches are inherited from RimWorld and the target mods,
whose translation coverage remains their responsibility. About.xml and the Preview use English
as required for this public mod. No mod-owned French translation file is needed.
