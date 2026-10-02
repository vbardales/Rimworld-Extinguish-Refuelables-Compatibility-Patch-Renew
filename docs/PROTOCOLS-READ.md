# Workflow documents read, and what they were worth

Kept so a later session does not reread a document that has not moved, and knows which ones were
no use here. A version is the first ten characters of the file's git blob hash (`git hash-object`
in the collection root, monorepo commit `3232bfc2` on 2026-09-28) and its modification time. When
either differs, reread what the "Read" column says was read, not everything.

Read on 2026-09-28. "Full" means every line; "Headings" means only the outline.

| Document | Version | Read | Worth | Note |
|---|---|---|---|---|
| `AGENTS.md` | `bb4c08c1e4`, 2026-09-24 08:33 | Full | Useful | Gate order (settings, translations, `preTest`), evidence retention rules, publication by CI. |
| `AUDIT.md` | `9a3b598f43`, 2026-09-27 21:24 | Full | Essential | Chain, transition criteria, the session title, `done` needs Pickle scenarios *written*, `tested` needs them *run*. |
| `PUBLISHING.md` | `323eccec04`, 2026-09-28 08:41 | Full | Essential | packageId without `renew` (2026-09-27), description source, `0.1.0` prepublication, commit hygiene, CI rules. Skip the GitHub topics and social-preview section unless publishing. |
| `MOD_SETTINGS.md` | `a61cd54192`, 2026-09-13 00:46 | Full | Useful once | Only the "no settings" branch applies here: verify no empty page and no shortcut. |
| `TRANSLATIONS.md` | `fac8188128`, 2026-09-25 19:19 | Full | Useful once | Only the `not_applicable` branch applies: an inventory has to prove no text is added. |
| `PickleTools/README.md` | `495a6ba602`, 2026-09-25 19:37 | Full | Useful | Table of shared step tools and how a pass map names them. |
| `PickleTools/docs/steps.md` | `8214aa8dac`, 2026-09-28 10:27 | Lines 1-120 | Partly | Only ClearScreen and the intro. Pickle's own step catalogue is on GitHub, not in the collection. |
| `PickleTools/Authoring/README.md` | `a6e3e2eac0`, 2026-09-26 22:38 | Lines 1-200 | Essential for the suite | Layout of `Tests/Pickle`, pass matrix, what deserves a running game. Sections 5 to 7 unread. |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `1bdd1eed63`, 2026-09-27 23:25 | Lines 1-70 | Useful | Filter terms, `-DepMap`, submitting instead of launching. |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `7ab5e437d4`, 2026-09-26 18:18 | Lines 1-60 | Useful | Every option of `Submit-PickleRun.ps1`, `-EvidenceDir` semantics. |
| `PickleTools/Headless/README.md` | `c023a674fb`, 2026-09-26 22:52 | Headings | Not yet | Read before the first run: staging, restart tests, what is lost. |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `347a0d63b9`, 2026-09-26 23:20 | Headings | Not yet | Read before any workflow, tag, release or Steam secret. |
| `WORKSHOP_COMMENTS.md` | `8801626c42`, 2026-09-28 10:26 | Headings | Not yet | Needed at `prepublished`: which thank-you comments are already posted. |
| `STYLE_RIMWORLD.md` | `f64a8fa446`, 2026-09-27 21:24 | Lines 1-200 | Not useful | About generating the preview and icon, which this task does not do. Only the icon control matters, and that is in `AUDIT.md`. |
| `scripts/SEARCHING.md` | `45f0fa13cc`, 2026-09-27 21:14 | Headings | Not useful | Corpus search tool; nothing here needs it. |

Repository files read: `STATUS.md`, `README.md`, `CHANGELOG.md`, `_tools/FUNCTIONAL-SCENARIOS.md`
(opening), `_tools/LICENCE-AUDIT.md` (headings and the repository search), all three patches, the C#
source, `About.xml`. Not present in this repository: `PUBLICATION.md`, `TESTING.md`, `BACKLOG.md`,
`NOTES.md`, `BUGS.md`, `Tests/Pickle/`.

## Re-check 2026-10-02

Hashes recomputed. `AUDIT.md` (`daab030ccf`, 2026-10-02 15:14) read in full again. Unchanged since the table above and
not reread: `MOD_SETTINGS.md`, `scripts/SEARCHING.md`, `PickleTools/Headless/README.md`, `Rimworld-Release-Admin/docs/OPERATIONS.md`,
`Rimworld-Ticket-Dispatcher/docs/WELCOME.md`, `SUBMIT.md`. Changed since and NOT yet reread, except TRANSLATIONS.md (read in full 2026-10-02, only the not_applicable branch matters here, FRENCH_REVIEW.md not required: no text added) (read the diff only when the
topic comes up): `AGENTS.md` `44dddcbc8f`, `PUBLISHING.md` `11de03424f`, `TRANSLATIONS.md` `7b4d9a23bd`, `STYLE_RIMWORLD.md`
`773961397c`, `WORKSHOP_COMMENTS.md` `cdd3381ba9`, `PickleTools/README.md` `1d28b27e67`, `PickleTools/docs/steps.md`
`8639a06971`, `PickleTools/Authoring/README.md` `75329decf2`.
