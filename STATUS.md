---
mod:        Extinguish Refuelables Compatibility Patch Renew
packageId:  nelim.extinguishrefuelablescompatibilitypatchrenew
depot:      Rimworld-Extinguish-Refuelables-Compatibility-Patch-Renew
visibilite: public
detache:    oui
etape:      done
licence:    silent
licence_ou: aucune, cherchee aux quatre endroits possibles, voir ATTRIBUTION.md
vitrine:    complete
teste_le:
workshop:   
reste:
  - non_verifie: les dix-sept scenarios de _tools/FUNCTIONAL-SCENARIOS.md, aucun joue, scenario 0
    compris. Le mod n'a jamais tourne dans une partie, et rien ici ne se voit hors du jeu : une
    operation de patch qui ne trouve pas sa cible est muette par construction.
  - feature: la vitrine est gravee en noir, d'avant la consigne du 2026-09-12 sur le voile en couleur
session:    local_52a44608-2383-4e78-b72e-789405b47e80
maj:        2026-09-12, releve automatique, puis precise par la session du mod
---

# Extinguish Refuelables Compatibility Patch Renew — etat

Fiche d'etat, lue par une passe sur tous les mods plutot qu'en interrogeant les fils un a un.
Elle vit a la racine, jamais dans `Mod/`, donc Steam ne la recoit pas.

Les champs ci-dessus ont ete deduits du disque le 2026-09-12. Trois ne pouvaient pas l'etre et
attendaient la session qui tient ce mod ; ils sont renseignes ici, et un quatrieme est corrige :

- **`etape`** — `done` confirme. Le port est fait et documente, la compilation passe sans
  avertissement, et la DLL versionnee dans `Mod/Assemblies/` a exactement l'empreinte de celle
  qu'une compilation propre produit. Ce qui reste n'est pas du developpement, c'est la
  verification en jeu.
- **`teste_le`** — laisse vide, et c'est exact plutot qu'oublie : personne n'a jamais vu ce mod
  tourner dans une partie. Pas meme le scenario 0, qui demande seulement que le jeu demarre et
  que les patchs prennent.
- **`reste`** — la ligne posee d'office est remplacee par deux. La premiere dit la meme chose,
  mais chiffree, maintenant que `_tools/FUNCTIONAL-SCENARIOS.md` existe pour la chiffrer. La
  seconde est une dette et non un defaut : la vitrine a ete gravee le 11, la veille du jour ou le
  voile a recu la consigne de prendre une couleur de l'image. Elle reste noire jusqu'au prochain
  passage du mod par le Workshop, mais la fiche doit le dire plutot que montrer une vitrine
  marquee complete sans rien qui la nuance.
- **`visibilite`** — corrige de `prive` en `public`. Le depot GitHub est public, demande a GitHub
  et non deduit du disque.

`licence` vaut `silent` : le mod d'origine ne declare de licence nulle part, verifie aux quatre
endroits ou il aurait pu le faire — pas de fichier `LICENSE`, rien dans son `About.xml`, aucun
depot lie puisqu'il n'a pas de `<url>`, rien dans le corps de sa description Steam — et il s'est
arrete a la 1.4. Ce que le port a ajoute est MIT. Le detail est dans `ATTRIBUTION.md`.

`workshop` reste vide : rien n'a jamais ete publie sous ce nom, et le mod ne porte pas de
`About/PublishedFileId.txt` — celui de Keshash a ete retire au portage, puisqu'il designe son
objet a lui.

Rappel des categories de `reste` : `feature` pour une fonctionnalite manquante au premier jet,
`defaut` pour un defaut connu non corrige, `non_verifie` pour ce qui n'a pas pu etre verifie.

Le champ `session` n'a pas ete touche : il vient du releve et designe le groupe de session, pas
cette conversation.

Vocabulaire de `licence` : `open` licence explicite, `silent` aucune licence et source morte,
`alive` aucune licence mais source vivante, `forbidden` refus ecrit, `original` rien de repris.
