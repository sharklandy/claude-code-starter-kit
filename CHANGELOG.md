# Changelog

## [1.3.0] - 2026-07-01

### Ajouté

- `skills/choose-your-loop` : skill conversationnel qui intervient avant
  la rédaction du prompt final, pour aider à choisir et valider le bon
  mécanisme (`/goal`, workflow dynamique, routine `/loop`/`/schedule`,
  ou simple boucle turn-based). Rappelle le concept visé, pose des
  questions de cadrage structurées, applique un arbre de décision
  explicite et traçable, détecte et reformule les critères de succès
  flous, rend un verdict en trois issues (✅/⚠️/❌), puis propose un
  prompt adapté à partir des templates existants de `goals/`,
  `workflows/` et `routines/`.
- `README.md` : mention du skill `choose-your-loop` dans la section
  "Démarrer sur un projet".

## [1.2.0] - 2026-07-01

### Ajouté

- `docs/onboarding-prompt.md` : prompt d'onboarding prêt à copier-coller
  dans Claude Code après `install.sh`, qui remplit automatiquement les
  placeholders `<TODO: ...>` des skills installés.
  - **Cas A — projet existant** : analyse du code, des dépendances, des
    commandes de build/test/lint et de l'historique git pour déduire les
    valeurs des placeholders avec confiance ; tout ce qui relève d'un
    choix métier reste signalé "à compléter manuellement".
  - **Cas B — projet vierge** : questions de cadrage courtes plutôt que
    déduction à l'aveugle, puis classification des skills installés en
    "actifs dès maintenant" / "en attente" du premier code réel.
- `README.md` : bloc `## Quickstart` en tête de fichier (commandes brutes
  uniquement), et nouvelle section `## Démarrer sur un projet` reliée au
  prompt d'onboarding. La section "Comment adapter les templates à votre
  stack" a été raccourcie pour éviter la duplication avec ces deux
  nouveaux blocs.

## [1.1.0] - 2026-07-01

### Ajouté

- 9 nouveaux skills génériques développeur (vague 2), utilisables sur
  n'importe quel projet sans connaissance préalable d'un domaine
  métier :
  - `verify-code-change`
  - `adversarial-code-review`
  - `commit-message-quality`
  - `pr-description-generator`
  - `systematic-debugging`
  - `dependency-update-check`
  - `new-feature-scaffold`
  - `changelog-from-commits`
  - `safe-refactor`
- 5 nouveaux prompts `/goal` génériques dans `goals/goal-templates.md`,
  séparés visuellement des prompts issus de cas d'usage métier.
- Une variante générique développeur pour chacun des 6 patterns de
  composition dans `workflows/workflow-prompts.md`.
- Une nouvelle routine générique développeur (surveillance quotidienne
  de la CI sur les branches ouvertes) dans `routines/routine-templates.md`.
- `README.md` mis à jour pour distinguer clairement vague 1 (templates
  métier) et vague 2 (skills génériques développeur).

## [1.0.0] - 2026-07-01

### Ajouté

- Création initiale du repo.
- Documentation complète : `docs/guide-complet.md`, `docs/glossaire.md`, `docs/commandes-utiles.md`.
- Six skills prêts à l'emploi dans `skills/` :
  - `verify-frontend-change`
  - `verify-form-change`
  - `checkout-verifier-template`
  - `bug-triage-runbook-template`
  - `python-to-ts-migration-template`
  - `library-reference-template`
- Templates de prompts `/goal` dans `goals/goal-templates.md`.
- Templates de prompts de workflows dynamiques dans `workflows/workflow-prompts.md`.
- Templates de routines `/schedule` + `/goal` + workflow dans `routines/routine-templates.md`.
- Script d'installation `install.sh` (`--global` / `--local <chemin>`).
- `CONTRIBUTING.md`, templates d'issue et de pull request.
