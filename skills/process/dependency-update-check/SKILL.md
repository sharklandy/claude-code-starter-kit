---
name: dependency-update-check
description: >
  Check for breaking changes and codebase impact before bumping a
  dependency version. Trigger whenever asked to upgrade, update, or
  bump a package/library/dependency version.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Vérifier une mise à jour de dépendance (générique)

1. Identifier la version actuelle et la version cible de la dépendance
   concernée (fichier de lock ou manifeste de dépendances du projet :
   `package.json`/lockfile, `pyproject.toml`/`poetry.lock`,
   `Cargo.toml`/`Cargo.lock`, `go.mod`, etc.).
2. Consulter le changelog ou les notes de version de la dépendance entre
   la version actuelle et la version cible, en portant une attention
   particulière à :
   - toute section explicitement marquée "breaking change(s)" ;
   - un changement de version majeure (semver) qui suppose des
     changements d'API par convention.
3. Rechercher dans la base de code **tous les usages** du package
   concerné (imports, appels de fonctions/méthodes exposées par ce
   package) — ne pas se contenter du fichier de manifeste.
4. Pour chaque usage trouvé, signaler s'il correspond à une API listée
   comme modifiée ou supprimée dans le changelog consulté à l'étape 2.
5. Mettre à jour la dépendance, puis lancer la vérification complète du
   projet (voir le skill `verify-code-change`) avant de considérer la
   mise à jour terminée.
6. Si des usages signalés à l'étape 4 n'ont pas pu être vérifiés
   automatiquement (ex. comportement runtime plutôt qu'erreur de
   compilation), le mentionner explicitement plutôt que d'affirmer que
   la mise à jour est sans risque.

## Gotchas

- Une mise à jour mineure ou de correctif (semver) peut malgré tout
  contenir un changement de comportement non documenté comme
  "breaking" — ne pas sauter les étapes 3-4 sous prétexte que le numéro
  de version majeure n'a pas changé.
- Les dépendances transitives (dépendances de vos dépendances) peuvent
  changer de version en même temps que la dépendance directe mise à
  jour — vérifier le diff complet du lockfile, pas uniquement la ligne
  du package demandé explicitement.
- <TODO: si votre projet a un processus d'approbation de dépendances
  (revue sécurité, liste blanche de licences...), documentez-le ici.>
