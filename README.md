# Claude Code Starter Kit — Boucles, Workflows & Skills

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)

Une bibliothèque de skills prêts à l'emploi et de templates de prompts `/goal`, `/loop`, `/schedule` et workflows dynamiques pour démarrer avec Claude Code en quelques minutes.

## Pourquoi ce repo

Construire de bons skills et de bons prompts de boucle/workflow prend du temps et beaucoup d'itérations. Ce repo rassemble des templates génériques déjà structurés — description orientée déclenchement, section Gotchas, divulgation progressive — pour que vous n'ayez qu'à les adapter à votre stack plutôt que de partir d'une page blanche. Il s'accompagne d'un guide théorique complet si vous voulez comprendre le "pourquoi" derrière chaque pattern.

Le repo distingue deux vagues de skills :

- **Vague 1 — templates issus de cas d'usage métier** (`-template`) : illustrent un pattern à partir d'un scénario concret (checkout, migration de langage, triage de feedback produit) et nécessitent une adaptation à votre propre domaine avant usage.
- **Vague 2 — skills génériques développeur** : utilisables tels quels sur n'importe quel projet, quelle que soit la stack, sans connaître le guide théorique au préalable. Ils complètent le guide théorique plutôt que d'en être extraits directement.

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
│   └── commandes-utiles.md       # extrait rapide : tableau des commandes
├── skills/                       # skills prêts à l'emploi (SKILL.md + Gotchas)
│   ├── verify-frontend-change/            # vague 1
│   ├── verify-form-change/                # vague 1
│   ├── checkout-verifier-template/        # vague 1
│   ├── bug-triage-runbook-template/       # vague 1
│   ├── python-to-ts-migration-template/   # vague 1
│   ├── library-reference-template/        # vague 1
│   ├── verify-code-change/                # vague 2
│   ├── adversarial-code-review/           # vague 2
│   ├── commit-message-quality/            # vague 2
│   ├── pr-description-generator/          # vague 2
│   ├── systematic-debugging/              # vague 2
│   ├── dependency-update-check/           # vague 2
│   ├── new-feature-scaffold/              # vague 2
│   ├── changelog-from-commits/            # vague 2
│   └── safe-refactor/                     # vague 2
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

Le script `install.sh` copie les dossiers de `skills/` vers l'emplacement de votre choix.

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

## Comment adapter les templates à votre stack

Chaque `SKILL.md` de ce repo contient des placeholders au format `<TODO: description>`. Avant utilisation :

1. Remplacez chaque `<TODO: ...>` par les informations réelles de votre projet (chemins, noms de tables, commandes, fournisseurs tiers...).
2. Gardez la structure existante — en particulier ne videz jamais la section `## Gotchas` : c'est le contenu au plus fort signal d'un skill (voir `docs/guide-complet.md`, Partie 3.3).
3. Testez le déclenchement du skill dans une session Claude Code réelle : s'il ne se déclenche pas spontanément sur une tâche pertinente, la `description` du frontmatter n'est probablement pas assez explicite sur les mots-clés qui doivent l'activer.
4. Enrichissez la section Gotchas au fil du temps, à chaque nouveau piège rencontré, plutôt que de corriger uniquement le cas isolé.

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
