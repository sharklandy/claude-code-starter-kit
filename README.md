# Claude Code Starter Kit — Boucles, Workflows & Skills

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)

## Quickstart

```bash
git clone https://github.com/sharklandy/claude-code-starter-kit.git
cd claude-code-starter-kit
chmod +x install.sh
./install.sh --global   # ou --local /chemin/vers/votre/projet
```

Puis collez le [prompt d'onboarding](./docs/onboarding-prompt.md) dans Claude Code pour que les skills s'adaptent automatiquement à votre projet.

Une bibliothèque de skills prêts à l'emploi et de templates de prompts `/goal`, `/loop`, `/schedule` et workflows dynamiques pour démarrer avec Claude Code en quelques minutes.

## Pourquoi ce repo

Construire de bons skills et de bons prompts de boucle/workflow prend du temps et beaucoup d'itérations. Ce repo rassemble des templates génériques déjà structurés — description orientée déclenchement, section Gotchas, divulgation progressive — pour que vous n'ayez qu'à les adapter à votre stack plutôt que de partir d'une page blanche. Il s'accompagne d'un guide théorique complet si vous voulez comprendre le "pourquoi" derrière chaque pattern.

Le repo distingue deux vagues de skills :

- **Vague 1 — templates issus de cas d'usage métier** (`-template`) : illustrent un pattern à partir d'un scénario concret (checkout, migration de langage, triage de feedback produit) et nécessitent une adaptation à votre propre domaine avant usage.
- **Vague 2 — skills génériques développeur** : utilisables tels quels sur n'importe quel projet, quelle que soit la stack, sans connaître le guide théorique au préalable. Ils complètent le guide théorique plutôt que d'en être extraits directement.

Les skills sont rangés en deux catégories dans `skills/` : `process/` pour les skills transverses (indépendants d'un domaine technique précis) et `domains/` pour les skills liés à un domaine (revue de code, stratégie de test...). Un skill de domaine volumineux suit le principe de **divulgation progressive** (voir `docs/guide-complet.md`, Partie 3.3) : un noyau `SKILL.md` court, toujours chargé, et un sous-dossier `reference/` avec le détail, que Claude ne consulte que lorsque le contexte le justifie — voir `skills/domains/code-review/` comme exemple.

## Structure du repo

```
claude-code-starter-kit/
├── README.md                     # ce fichier
├── LICENSE                       # licence MIT
├── CONTRIBUTING.md               # comment contribuer un skill/prompt
├── CHANGELOG.md                  # historique des versions
├── install.sh                    # installe les skills en local ou globalement
├── docs/
│   ├── guide-complet.md          # théorie complète : boucles, workflows, skills
│   ├── glossaire.md              # extrait rapide : définitions
│   ├── commandes-utiles.md       # extrait rapide : tableau des commandes
│   └── subagents-vs-skills.md    # quand créer un subagent plutôt qu'un skill
├── .claude/
│   └── agents/                   # subagents prêts à l'emploi (installés par install.sh)
│       ├── code-reviewer.md      # revue adversariale à contexte frais
│       ├── test-runner.md        # build/tests/lint isolés, ne rapporte que les échecs
│       ├── dependency-scout.md   # rapport d'impact avant un bump de dépendance
│       └── bug-investigator.md   # reproduction + diagnostic de cause racine
├── skills/                       # skills prêts à l'emploi (SKILL.md + Gotchas)
│   ├── process/                  # skills transverses, indépendants d'un domaine technique
│   │   ├── verify-frontend-change/            # vague 1
│   │   ├── verify-form-change/                # vague 1
│   │   ├── checkout-verifier-template/        # vague 1
│   │   ├── bug-triage-runbook-template/       # vague 1
│   │   ├── python-to-ts-migration-template/   # vague 1
│   │   ├── library-reference-template/        # vague 1
│   │   ├── verify-code-change/                # vague 2
│   │   ├── adversarial-code-review/           # vague 2
│   │   ├── commit-message-quality/            # vague 2
│   │   ├── pr-description-generator/          # vague 2
│   │   ├── systematic-debugging/              # vague 2
│   │   ├── dependency-update-check/           # vague 2
│   │   ├── new-feature-scaffold/              # vague 2
│   │   ├── changelog-from-commits/            # vague 2
│   │   ├── safe-refactor/                     # vague 2
│   │   ├── choose-your-loop/                  # vague 2 — à utiliser en amont de goals/, workflows/, routines/
│   │   ├── readme-generator/                  # vague 2
│   │   ├── env-doctor/                        # vague 2
│   │   └── avoid-agentic-pitfalls/            # vague 2
│   └── domains/                  # skills de domaine, à divulgation progressive si volumineux
│       ├── code-review/
│       │   ├── SKILL.md          # noyau court, toujours chargé
│       │   └── reference/        # détail chargé par Claude à la demande
│       │       ├── security.md
│       │       ├── performance.md
│       │       └── database-queries.md
│       └── test-strategy/
├── goals/
│   └── goal-templates.md         # prompts /goal prêts à copier-coller
├── workflows/
│   └── workflow-prompts.md       # un prompt par pattern de composition
├── routines/
│   └── routine-templates.md      # combinaisons /schedule + /goal + workflow
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── new-skill.md
    │   └── bug-report.md
    └── PULL_REQUEST_TEMPLATE.md
```

## Installation

Le script `install.sh` détecte chaque skill sous `skills/process/` et `skills/domains/` (y compris les sous-dossiers `reference/` d'un skill à divulgation progressive) et l'installe à plat vers l'emplacement de votre choix. Il installe aussi les subagents de `.claude/agents/` vers `~/.claude/agents/` (`--global`) ou `<projet>/.claude/agents/` (`--local`).

**Installation globale** (disponible dans tous vos projets, usage personnel) :

```bash
./install.sh --global
```

Installe dans `~/.claude/skills/`.

**Installation locale** (partagée avec toute personne qui clone le dépôt du projet ciblé) :

```bash
./install.sh --local /chemin/vers/votre/projet
```

Installe dans `/chemin/vers/votre/projet/.claude/skills/`.

Dans les deux cas, si un skill du même nom existe déjà à la destination, le script demande confirmation avant de l'écraser, puis affiche un résumé des skills installés et du chemin de destination.

## Démarrer sur un projet

Le parcours complet tient en 4 étapes : cloner le repo → lancer `install.sh` → coller le [prompt d'onboarding](./docs/onboarding-prompt.md) dans Claude Code → suivre les instructions que Claude vous donne.

Ce prompt analyse automatiquement votre situation et se comporte différemment selon le cas :

- **Projet existant** : Claude analyse votre code, vos dépendances, vos commandes de build/test/lint et votre historique git, puis remplit lui-même les placeholders `<TODO: ...>` des skills installés qu'il peut déduire avec confiance — le reste est signalé explicitement comme "à compléter manuellement".
- **Projet vierge** : Claude ne devine rien à partir de code qui n'existe pas. Il vous pose quelques questions de cadrage (stack envisagée, type d'application, convention de commit...), puis classe les skills installés en "actifs dès maintenant" et "en attente" du premier code réel.

Voir [`docs/onboarding-prompt.md`](./docs/onboarding-prompt.md) pour le détail des deux cas et le prompt complet.

Si vous n'êtes pas sûr du mécanisme à choisir (`/goal`, workflow dynamique, ou routine), utilisez le skill `choose-your-loop` **avant** de piocher dans `goals/`, `workflows/` ou `routines/` : il cadre la tâche, détecte un critère de succès trop flou, et valide (ou corrige) le choix avant de rédiger le prompt final.

## Comment adapter les templates à votre stack

Le [prompt d'onboarding](./docs/onboarding-prompt.md) ci-dessus automatise le remplissage des placeholders `<TODO: description>` présents dans chaque `SKILL.md`. Si vous préférez les adapter manuellement plutôt que de passer par ce prompt :

1. Gardez la structure existante — en particulier ne videz jamais la section `## Gotchas` : c'est le contenu au plus fort signal d'un skill (voir `docs/guide-complet.md`, Partie 3.3).
2. Testez le déclenchement du skill dans une session Claude Code réelle : s'il ne se déclenche pas spontanément sur une tâche pertinente, la `description` du frontmatter n'est probablement pas assez explicite sur les mots-clés qui doivent l'activer.
3. Enrichissez la section Gotchas au fil du temps, à chaque nouveau piège rencontré, plutôt que de corriger uniquement le cas isolé.

## Subagents : les tâches qui méritent leur propre contexte

En plus des skills, le repo fournit quatre **subagents** prêts à l'emploi (`.claude/agents/`, installés par `install.sh`). Un subagent tourne dans une fenêtre de contexte séparée, avec ses propres restrictions d'outils, et ne renvoie que sa synthèse — là où un skill guide la conversation principale :

- **`code-reviewer`** — revue adversariale à contexte frais : l'agent n'a pas vu comment le code a été écrit, ne peut pas l'éditer, et précharge le skill de domaine `code-review` comme grille de lecture.
- **`test-runner`** — lance build/tests/lint (détectés depuis la CI du projet) et ne rapporte que les échecs ; la sortie verbeuse des tests ne pollue jamais votre conversation.
- **`dependency-scout`** — avant un bump de dépendance, absorbe changelogs et recherche d'usages, et renvoie un rapport d'impact ; il n'applique jamais la mise à jour lui-même.
- **`bug-investigator`** — reproduit, bissecte et confirme la cause racine d'un bug, puis rend un diagnostic avec preuves ; le correctif se décide dans la conversation principale.

Trois d'entre eux ont une **mémoire persistante par projet** (`memory: project`) : zones à risque, commandes de CI confirmées, tests flaky, patterns de bugs — des connaissances qui s'accumulent d'une session à l'autre et se partagent via git, au lieu d'être redécouvertes à chaque fois.

Pour savoir quand créer un subagent plutôt qu'un skill (et pourquoi la plupart des briques doivent rester des skills), voir [`docs/subagents-vs-skills.md`](./docs/subagents-vs-skills.md).

## Utiliser les prompts /goal, /loop, /schedule et workflows

- [`goals/goal-templates.md`](./goals/goal-templates.md) — prompts `/goal` prêts à l'emploi (tests, performance, migration, sécurité...), avec plafond de tentatives explicite.
- [`workflows/workflow-prompts.md`](./workflows/workflow-prompts.md) — un prompt par pattern de composition (classify-and-act, découpage-synthèse, recherche parallèle, revue adversariale, tournoi, loop-until-done).
- [`routines/routine-templates.md`](./routines/routine-templates.md) — combinaisons complètes `/schedule` + `/goal` + workflow pour des flux entièrement autonomes.

## Pour aller plus loin

La théorie complète derrière ces templates — boucles agentiques, modes de défaillance des workflows dynamiques, catégories de skills, tutoriels pas à pas — est disponible dans [`docs/guide-complet.md`](./docs/guide-complet.md).

## Contribution

Les contributions sont bienvenues — voir [`CONTRIBUTING.md`](./CONTRIBUTING.md) pour la marche à suivre (structure attendue d'un skill, convention de nommage, exigence d'une section Gotchas non vide).

## Licence

Ce projet est distribué sous licence [MIT](./LICENSE).
