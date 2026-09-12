---
mod:        Extinguish Refuelables Compatibility Patch Renew
packageId:  nelim.extinguishrefuelablescompatibilitypatchrenew
repo:       Rimworld-Extinguish-Refuelables-Compatibility-Patch-Renew
visibility: public
detached:   yes
stage:      done
licence:    silent
licence_at: none, looked for at the four places it could have been, see ATTRIBUTION.md
showcase:   complete
tested_on:
workshop:
remaining:
  - unverified: the seventeen scenarios in _tools/FUNCTIONAL-SCENARIOS.md, none played, scenario 0
    included. This mod has never run in a game, and nothing in it can be seen from outside one: a
    patch operation that misses its target is silent by construction.
  - feature: the showcase is engraved in black, from before the 2026-09-12 instruction on the veil
    taking a colour from the image
session:    local_52a44608-2383-4e78-b72e-789405b47e80
updated:    2026-09-12, automatic sweep, then the mod's session, then turned to English
---

# Extinguish Refuelables Compatibility Patch Renew — status

A status sheet, read by a pass over every mod rather than by asking each thread in turn. It lives
at the root and never in `Mod/`, so Steam does not receive it.

The fields above were deduced from disk on 2026-09-12. Three could not be and waited for the
session that holds this mod; they are filled in here, and a fourth is corrected:

- **`stage`** — `done` confirmed. The port is made and documented, the build passes without a
  warning, and the assembly committed under `Mod/Assemblies/` has exactly the fingerprint a clean
  build produces. What is left is not development, it is verification in game.
- **`tested_on`** — left empty, and that is the fact rather than an omission: nobody has ever seen
  this mod run in a game. Not even scenario 0, which asks only that the game start and the patches
  take.
- **`remaining`** — the catch-all line becomes two. The first says the same thing with a number on
  it, now that `_tools/FUNCTIONAL-SCENARIOS.md` is there to count. The second is a debt rather than
  a defect: the showcase was engraved on the 11th, the day before the veil was told to take a
  colour from the image. It stays black until the mod next passes through the Workshop, but the
  sheet should say so rather than show a showcase marked complete with nothing qualifying it.
- **`visibility`** — corrected from private to public. The GitHub repository is public, asked of
  GitHub rather than deduced from disk.

`licence` reads `silent`: the original mod declares a licence nowhere, checked at the four places
it could have — no `LICENSE` file, nothing in its `About.xml`, no linked repository since it has
no `<url>` at all, nothing in the body of its Steam description — and it stopped at 1.4. What the
port added is MIT. The detail is in `ATTRIBUTION.md`.

`workshop` stays empty: nothing has ever been published under this name, and the mod carries no
`About/PublishedFileId.txt`. Keshash's own was dropped in the port, since it names their item.

The `remaining` categories: `feature` for something missing from the first cut, `defect` for a
known fault left unfixed, `unverified` for what could not be checked.

The `session` field is untouched: it comes from the sweep and names the session group, not this
conversation.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source, `alive`
no licence but a living source, `forbidden` a written refusal, `original` nothing reused.
