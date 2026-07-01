# Templates de routines complètes (`/schedule` + `/goal` + workflow)

> Ces routines combinent les trois piliers du guide (voir `docs/guide-complet.md`, Partie 1.5 et Partie 6, Tutoriel 4) : un déclencheur planifié (`/schedule`), un critère d'arrêt vérifiable (`/goal`), et une orchestration multi-agents (workflow dynamique). Elles supposent que les skills de vérification et de runbook nécessaires existent déjà — voir `skills/`.
>
> **Avant le grand déploiement** : ne lancez jamais une routine directement sur l'ensemble d'un flux de production. Commencez par une exécution manuelle limitée à 2-3 éléments pour calibrer le comportement et le coût en tokens (principe de la Partie 1.7), puis activez la planification.

## 1. Triage automatique de retours utilisateurs / rapports de bugs

**Contexte d'usage** : des retours utilisateurs (bugs, suggestions, plaintes) arrivent en continu sur un canal ou une file d'attente, et personne n'a le temps de tous les traiter au fil de l'eau.

**Skills prérequis** : un skill de vérification pour votre stack (voir `skills/verify-frontend-change` ou `skills/verify-form-change`), et un skill de runbook de triage (voir `skills/bug-triage-runbook-template`).

```
/schedule every hour: check <TODO: nom du canal, ex. #feedback> for
new messages.
/goal: don't stop until every message found this run is categorized
using bug-triage-runbook-template, and every critical bug is either
fixed and verified with <TODO: nom de votre skill de vérification>,
or flagged with a request for more information. When fixing a
critical bug, use a workflow to try two independent fixes in parallel
worktrees and have a judge pick the one with fewer side effects. Use
15k tokens per critical bug.
```

**Ajustement dans la durée** : si les messages arrivent surtout à certaines heures, ajustez l'intervalle plutôt que de tourner en continu (principe de la Partie 1.7) :

```
/schedule every 2 hours, 8am-10pm: check <TODO: nom du canal> for new
messages.
```

## 2. Migration progressive d'un ensemble de modules

**Contexte d'usage** : un ensemble de modules doit être porté d'une stack vers une autre, un module à la fois, avec vérification de parité à chaque étape — à exécuter de façon récurrente jusqu'à épuisement de la liste des modules restants.

**Skills prérequis** : un skill de référence de migration (voir `skills/python-to-ts-migration-template`, à adapter si votre migration ne concerne pas Python → TypeScript).

```
/schedule every day at 9am: check <TODO: chemin ou registre listant
les modules restants à migrer> for modules not yet migrated.
/goal: don't stop until every module found this run is ported,
verified against its existing test fixtures using
python-to-ts-migration-template, and the diff is committed on its own
branch. Use a workflow: for each module, implement the port in its own
git worktree, then have a fresh-context agent adversarially compare the
output against the legacy fixtures before accepting the change. Use
20k tokens per module, and stop the run after 10 modules to control
cost per execution.
```

**Reprise après interruption** : si l'exécution est interrompue (fermeture de session, erreur), relancer la routine reprend là où elle s'était arrêtée sans retraiter les modules déjà validés (voir `docs/guide-complet.md`, Partie 2.3).

## Suivi et ajustement de toutes les routines

- `/usage` régulièrement, pour suivre la consommation par skills, sous-agents et MCPs.
- `/workflows`, pour voir l'usage de tokens de chaque agent et arrêter un agent qui dévie.
- Enrichissez la section Gotchas des skills prérequis à chaque nouveau cas non couvert rencontré par la routine — voir `CONTRIBUTING.md`.
