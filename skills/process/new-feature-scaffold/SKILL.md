---
name: new-feature-scaffold
description: >
  Scaffold a new feature consistently with existing project conventions.
  Trigger whenever starting a new feature, module, or component from
  scratch.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Scaffolding d'une nouvelle fonctionnalité (générique)

1. Créer une branche dédiée à la fonctionnalité, nommée selon la
   convention déjà observée dans l'historique du dépôt (ex.
   `feature/<nom>`, `feat/<nom>` — inspecter `git log --oneline` et les
   noms de branches existants plutôt que de deviner).
2. Observer la structure des dossiers/fichiers d'une fonctionnalité déjà
   existante et comparable dans le même dépôt, et reproduire la même
   organisation (emplacement du code, des tests, des styles, du
   routing...) plutôt que d'imposer une structure générique venue
   d'ailleurs.
3. Créer les fichiers de test correspondants **avant ou en même temps**
   que le code de la fonctionnalité, avec au moins un cas de test
   trivial qui passe déjà (ex. "le composant se monte sans erreur", "la
   fonction retourne la valeur par défaut attendue") — pour garantir que
   l'infrastructure de test de la nouvelle fonctionnalité est
   fonctionnelle dès le départ.
4. Ajouter les entrées nécessaires dans les fichiers d'assemblage du
   projet si la convention l'exige (registre de routes, export
   d'index, enregistrement de plugin...).
5. Terminer par un rappel explicite de mise à jour de la documentation
   pertinente (README du module, CHANGELOG, doc utilisateur) — ne pas
   la rédiger à la place de l'utilisateur sans validation du contenu
   fonctionnel réel de la fonctionnalité.

## Gotchas

- Copier la structure d'une fonctionnalité existante trop ancienne peut
  reproduire un pattern que le projet a depuis abandonné — préférer la
  fonctionnalité comparable la plus récente comme référence.
- Un scaffolding qui crée des fichiers de test vides sans aucune
  assertion donne une fausse impression de couverture ("le fichier de
  test existe donc c'est testé") — le cas trivial de l'étape 3 doit
  contenir une assertion réelle, même minimale.
- Avant de créer la structure à la main, vérifier si le projet fournit
  déjà un générateur (script `generate`/`scaffold` dans le manifeste,
  CLI du framework, dossier de templates dans le repo) — l'utiliser
  produit une structure conforme aux conventions locales, là où une
  création manuelle les réinvente.
