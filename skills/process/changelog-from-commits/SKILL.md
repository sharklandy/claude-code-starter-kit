<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->
---
name: changelog-from-commits
description: >
  Generate or update CHANGELOG.md from git history since the last tag
  or entry. Trigger whenever asked to prepare a release, update the
  changelog, or summarize changes since the last version.
---

# Générer un CHANGELOG à partir de l'historique git (générique)

1. Déterminer le point de départ : le dernier tag git (`git describe
   --tags --abbrev=0`) si le projet en utilise, sinon la date/le commit
   de la dernière entrée déjà présente dans `CHANGELOG.md`.
2. Lister tous les commits depuis ce point de départ
   (`git log <dernier-tag>..HEAD --oneline`), en excluant les commits de
   merge sans contenu propre.
3. Respecter le format déjà utilisé dans le `CHANGELOG.md` existant du
   projet (souvent inspiré de "Keep a Changelog") :
   `## [version] - date`, avec des sous-sections `### Ajouté`,
   `### Corrigé`, `### Modifié` (ou l'équivalent anglais `Added`/
   `Fixed`/`Changed` si c'est la langue déjà utilisée dans le fichier).
4. Classer chaque commit dans la bonne sous-section à partir de son
   contenu réel (pas uniquement son préfixe de type de commit, qui peut
   être absent ou incorrect) — un commit `fix: ...` qui en réalité
   ajoute une fonctionnalité doit être classé dans "Ajouté", pas
   "Corrigé".
5. Regrouper les commits qui décrivent la même unité de travail vue par
   l'utilisateur final (ex. plusieurs commits "wip" successifs sur la
   même fonctionnalité) en une seule ligne de changelog, plutôt que de
   lister chaque commit brut.
6. Ne jamais lister un commit purement interne (renommage de variable,
   config CI, formatage) dans le changelog destiné aux utilisateurs,
   sauf si le projet distingue explicitement une section technique.

## Gotchas

- Un projet sans tags git rend la détection du "dernier point de
  départ" ambiguë — se rabattre sur la date de la dernière entrée du
  `CHANGELOG.md` existant plutôt que de remonter tout l'historique du
  dépôt par défaut.
- Des commits de type `chore(release): ...` ou de bump de version
  automatique ne doivent pas apparaître comme une entrée de changelog à
  part entière — les exclure explicitement.
- <TODO: si votre projet suit un format de changelog différent de "Keep
  a Changelog" (ex. généré automatiquement par un outil comme
  semantic-release), documentez le format exact attendu ici.>
