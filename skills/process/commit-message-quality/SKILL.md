---
name: commit-message-quality
description: >
  Enforce clear, atomic commit messages before committing. Trigger
  whenever about to run `git commit`, or when asked to clean up / split
  a commit or commit history.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Qualité des messages de commit (générique)

1. Avant de committer, vérifier que le changement staged correspond à
   **une seule idée logique**. Si `git diff --staged` mélange plusieurs
   préoccupations indépendantes (ex. un correctif de bug et un
   renommage sans rapport), proposer de découper en plusieurs commits
   plutôt que de tout committer d'un bloc.
2. Rédiger le message selon la convention déjà en usage dans le projet
   — la détecter dans les 30-50 derniers commits de `git log` plutôt
   que de la supposer. À défaut de convention détectable, utiliser
   Conventional Commits :
   `<type>(<scope optionnel>): <résumé au présent, impératif, < 72 car.>`
   Types courants : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.
3. Le résumé doit décrire le **pourquoi** ou l'effet observable du
   changement, pas une paraphrase du diff ("fix bug" est insuffisant ;
   "fix: prevent duplicate submit on double-click of the form button"
   est correct).
4. Si le changement le justifie, ajouter un corps de message expliquant
   le contexte, sans dépasser ce qui n'est pas déjà lisible dans le
   diff lui-même.
5. Vérifier qu'aucun message ne référence un état temporaire ou interne
   à la session ("suite au commentaire de review", "comme demandé") —
   ce contexte doit vivre dans la description de la PR, pas dans
   l'historique git qui doit rester compréhensible hors contexte.

## Gotchas

- Un commit qui touche à la fois `src/` et des fichiers de config
  générés (lockfiles, build artifacts) donne l'impression d'un gros
  commit alors que l'intention est petite — séparer le commit de
  contenu du commit de régénération d'artefacts quand c'est possible.
- Le type `fix` est souvent utilisé à tort pour des changements qui sont
  en réalité des `refactor` sans changement de comportement observable
  — vérifier qu'un `fix` corrige bien un comportement incorrect
  constaté, pas juste "amélioré".
- Si les messages récents du `git log` contiennent un identifiant de
  ticket (ex. `JIRA-123: ...`), reproduire exactement ce format — la
  convention réelle d'un projet se lit dans son historique, pas dans
  une supposition.
