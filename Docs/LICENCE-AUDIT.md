# Licence verification — 2026-09-13

Classification: **silent** (no explicit licence found). Permission to redistribute the original
has not been established. This classification does not certify that the author abandoned it.

## Primary sources checked

1. Installed original: `C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\3109675320`.
   Full file inventory, including hidden files: no LICENSE, COPYING, NOTICE or README.
   Text search for licence/license, copyright, permission, redistribution, reupload, GitHub and
   forbidden found only `AssemblyCopyright("Copyright ©  2023")` in
   `Source/RefuelablesPatch/Properties/AssemblyInfo.cs:13`, not a permission grant.
   This is the locally installed copy; no fresh Workshop package was downloaded.
2. Original `About/About.xml`: packageId `Keshash.ExtinguishRefuelablesPatch`, author Keshash,
   supported version 1.4. No licence, no `url`; the two Steam links are dependencies.
3. [Original Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3109675320&l=english):
   fetched directly with Invoke-WebRequest on 2026-09-13 after the web reader returned HTTP 429.
   The complete mod description describes compatibility and dependencies only. No licence,
   permission to republish, redistribution prohibition or source repository link appears there.
   The indexed page's four comments contain no permission grant either. The author answered a
   compatibility question on 2024-11-28: version 1.4 alone is not proof of abandonment.
4. No original source repository is linked in About.xml or on the Workshop page. Web searches
   for the exact mod title and for Keshash + Extinguish + GitHub did not identify one.
   This is a bounded search, not proof that no repository or permission exists anywhere.
5. Port `LICENSE` and `Mod/LICENSE` are byte-identical (SHA256
   `D3880261E197445B5DE1127E47A6627B09C764569CEF6D5C4E32BD2CDF7BBC51`). Both explicitly
   scope MIT to the port's additions and exclude the original mod.

## Interpretation for this repository

- `silent`: no explicit original licence found in the checked sources.
- Not `open`: MIT in this repository does not license the original author's contribution.
- Not `forbidden`: no explicit refusal found in the checked sources.
- Not `original`: this is a continuation of Keshash's mod.
- Original maintenance status: uncertain; do not infer that the author is inactive from a version tag.
  If the catalogue requires proven abandonment for `silent`, that prerequisite remains unverified.
- Repository visibility stays public; it describes access, not permission from the original author.
- Keep `(unofficial)` and attribution. Removal on request is the port maintainer's policy,
  not an explicit licence from Keshash.
