# Changelog

## [1.5.0] - en cours

### Ajouté

- `.claude-plugin/marketplace.json` : le dépôt est désormais un
  marketplace de plugins Claude Code natif (proposition 01 de la roadmap
  v2). Installation en une commande :
  `/plugin marketplace add sharklandy/claude-code-starter-kit`, puis
  `/plugin install starter-kit-essentials@claude-code-starter-kit`
  (noyau : 6 skills vague 2 + 4 subagents) ou
  `starter-kit-full@claude-code-starter-kit` (les 21 skills + 4
  subagents). Mises à jour via `/plugin marketplace update`. Vérifié en
  installation réelle : les composants s'enregistrent sous leur
  namespace (`starter-kit-*:<nom>`), et le préchargement
  `skills: [code-review]` des subagents résout correctement le skill
  du même plugin.
- `README.md` : le Quickstart documente la voie plugin (recommandée) et
  conserve `install.sh` comme voie alternative (copie physique, noms de
  skills courts sans préfixe).
- **Important pour les mainteneurs** : le champ `version` des deux
  entrées de `marketplace.json` doit être bumpé à chaque release, sinon
  les utilisateurs ne reçoivent pas la mise à jour.
- CI de validation des skills (proposition 02) :
  `.github/workflows/validate.yml` + `scripts/validate-skills.sh`
  (exécutable en local). Vérifie sur chaque PR : frontmatter YAML à
  l'octet 0 de chaque SKILL.md et subagent (la classe de bug corrigée
  en 2a7e1c8), `name` kebab-case identique au dossier/fichier,
  `description` présente, section `## Gotchas` non vide, aucun
  `<TODO:` hors skills `-template`, mode `100755` d'`install.sh` et
  smoke test d'installation complète (`reference/` inclus).
- `scripts/validate-skills-selftest.sh` : 8 fixtures prouvant que le
  validateur attrape chaque classe d'erreur — dont la reconstruction
  exacte du bug 2a7e1c8 (commentaire HTML avant le frontmatter).
- Badge « validate » dans le README.
- README bilingue (proposition 03) : `README.md` devient la version
  anglaise (rédigée nativement, porte d'entrée du dépôt) ; le contenu
  français vit désormais dans `README.fr.md`, avec lien croisé entre
  les deux. Le guide théorique et les corps de skills restent en
  français — assumé et annoncé dans la version anglaise. Les
  arborescences des deux README intègrent `.claude-plugin/`, `scripts/`
  et la CI.
- Reste à faire côté GitHub (actions sur le remote, hors périmètre de
  cette branche) : description du dépôt, topics, releases taguées.

### Modifié

- La promesse « utilisable tel quel » est désormais tenue (proposition
  04) : plus aucun placeholder `<TODO:` hors des 4 skills `-template`.
  Les 16 occurrences des 15 skills concernés sont réécrites en gotchas
  génériques réellement vrais partout : renvoi vers la mémoire de
  projet des subagents (`.claude/agent-memory/`) pour les zones à
  risque, outils de debug et commandes de CI ; détection dans le repo
  (template de PR, config de release automatique, générateur de
  scaffolding, convention de commit lue dans `git log`) pour le reste.
  Le suffixe `-template` redevient le seul marqueur « nécessite
  adaptation », et la règle est vérifiée par la CI. La validation
  passe : 21 skills, 4 subagents, 0 erreur.

## [1.4.0] - 2026-07-01

### Ajouté

- Réorganisation de `skills/` en deux catégories : `skills/process/`
  (skills transverses, les 16 skills existants) et `skills/domains/`
  (skills liés à un domaine technique).
- `skills/domains/code-review/` : skill de revue de code à divulgation
  progressive — noyau `SKILL.md` court + `reference/security.md`,
  `reference/performance.md`, `reference/database-queries.md`, chacun
  formulé en questions de raisonnement contextuel plutôt qu'en
  checklist de patterns à chercher aveuglément.
- `skills/domains/test-strategy/SKILL.md` : aide à décider quoi tester
  et à quel niveau, détecte les tests fragiles.
- `skills/process/readme-generator/SKILL.md` : génère ou met à jour un
  README à partir de l'analyse du projet.
- `skills/process/env-doctor/SKILL.md` : diagnostique un environnement
  de développement cassé (runtime, dépendances, variables
  d'environnement, ports).
- `skills/process/avoid-agentic-pitfalls/SKILL.md` : discipline
  comportementale transversale contre les suppositions silencieuses, la
  sur-ingénierie et les modifications hors-scope.
- `install.sh` : détecte désormais les skills sur deux niveaux de
  profondeur (`process/`, `domains/`) et copie chaque skill installé
  avec l'intégralité de son contenu, y compris un sous-dossier
  `reference/`.
- `README.md` et `CONTRIBUTING.md` mis à jour pour documenter la
  catégorisation `process/`/`domains/` et le pattern `reference/` de
  divulgation progressive.

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
