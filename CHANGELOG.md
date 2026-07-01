# Changelog

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
