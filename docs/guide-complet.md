# Maîtriser Claude Code : Boucles, Workflows Dynamiques et Skills

### Guide pratique basé sur trois articles du blog Anthropic (juin 2026)

> **Note de navigation rapide** : ce guide complet est long. Pour un accès rapide sans charger tout l'ebook, voir aussi [`docs/glossaire.md`](./glossaire.md) (table des termes) et [`docs/commandes-utiles.md`](./commandes-utiles.md) (table des commandes `/goal`, `/loop`, `/schedule`, `/workflows`...). Le contenu de ces deux fichiers est repris à l'identique des Annexes ci-dessous.

---

## Table des matières

1. [Introduction](#introduction)
2. [Partie 1 — Les boucles agentiques](#partie-1--les-boucles-agentiques)
   - 1.1 [Qu'est-ce qu'une boucle ?](#11-quest-ce-quune-boucle-)
   - 1.2 [Boucle turn-based](#12-boucle-turn-based)
   - 1.3 [Boucle goal-based (/goal)](#13-boucle-goal-based-goal)
   - 1.4 [Boucle time-based (/loop et /schedule)](#14-boucle-time-based-loop-et-schedule)
   - 1.5 [Boucles proactives](#15-boucles-proactives)
   - 1.6 [Maintenir la qualité du code](#16-maintenir-la-qualité-du-code)
   - 1.7 [Gérer la consommation de tokens](#17-gérer-la-consommation-de-tokens)
   - 1.8 [Tableau récapitulatif](#18-tableau-récapitulatif)
3. [Partie 2 — Les workflows dynamiques](#partie-2--les-workflows-dynamiques)
   - 2.1 [Le problème du harnais unique](#21-le-problème-du-harnais-unique)
   - 2.2 [Les trois modes de défaillance](#22-les-trois-modes-de-défaillance)
   - 2.3 [Workflow statique vs workflow dynamique](#23-workflow-statique-vs-workflow-dynamique)
   - 2.4 [Comment déclencher un workflow](#24-comment-déclencher-un-workflow)
   - 2.5 [Les six patterns de composition](#25-les-six-patterns-de-composition)
   - 2.6 [Bonnes pratiques de prompting](#26-bonnes-pratiques-de-prompting)
   - 2.7 [Sauvegarder et partager un workflow](#27-sauvegarder-et-partager-un-workflow)
   - 2.8 [Étude de cas : la migration Zig → Rust](#28-étude-de-cas--la-migration-zig--rust)
4. [Partie 3 — Les skills](#partie-3--les-skills)
   - 3.1 [Qu'est-ce qu'un skill ?](#31-quest-ce-quun-skill-)
   - 3.2 [Les neuf catégories de skills](#32-les-neuf-catégories-de-skills)
   - 3.3 [Bonnes pratiques de rédaction](#33-bonnes-pratiques-de-rédaction)
   - 3.4 [Distribution des skills](#34-distribution-des-skills)
   - 3.5 [Gérer un marketplace de skills](#35-gérer-un-marketplace-de-skills)
   - 3.6 [Composer des skills entre eux](#36-composer-des-skills-entre-eux)
   - 3.7 [Mesurer l'usage des skills](#37-mesurer-lusage-des-skills)
5. [Partie 4 — Comment ces trois concepts s'articulent](#partie-4--comment-ces-trois-concepts-sarticulent)
6. [Partie 5 — Application pratique : cas d'usage](#partie-5--application-pratique--cas-dusage)
7. [Partie 6 — Tutoriels pas à pas](#partie-6--tutoriels-pas-à-pas)
   - 6.1 [Tutoriel 1 — Créer un skill de vérification de A à Z](#tutoriel-1--créer-un-skill-de-vérification-de-a-à-z)
   - 6.2 [Tutoriel 2 — Lancer sa première boucle goal-based](#tutoriel-2--lancer-sa-première-boucle-goal-based)
   - 6.3 [Tutoriel 3 — Construire un workflow dynamique de revue adversariale](#tutoriel-3--construire-un-workflow-dynamique-de-revue-adversariale)
   - 6.4 [Tutoriel 4 — Monter une routine proactive complète](#tutoriel-4--monter-une-routine-proactive-complète)
8. [Partie 7 — Cas d'usage complets (fictifs)](#partie-7--cas-dusage-complets-fictifs)
   - 7.1 [Cas 1 — NovaCart : une checkout qui ne devait plus jamais casser](#cas-1--novacart--une-checkout-qui-ne-devait-plus-jamais-casser)
   - 7.2 [Cas 2 — Lumina Analytics : migration d'un moteur de reporting](#cas-2--lumina-analytics--migration-dun-moteur-de-reporting)
   - 7.3 [Cas 3 — Kaerio : triage automatique des retours utilisateurs](#cas-3--kaerio--triage-automatique-des-retours-utilisateurs)
9. [Annexes](#annexes)
   - [Glossaire](#glossaire)
   - [Commandes utiles](#commandes-utiles)
   - [Sources](#sources)

> **Note** : les cas d'usage de la Partie 7 (NovaCart, Lumina Analytics, Kaerio) sont **entièrement fictifs** et servent uniquement d'illustration pédagogique dans ce document source. Les skills réutilisables qui en sont dérivés, généralisés et sans référence à ces noms fictifs, se trouvent dans `skills/` à la racine du repo.

---

## Introduction

En juin 2026, l'équipe Claude Code d'Anthropic a publié coup sur coup trois articles qui, mis bout à bout, dessinent une vision cohérente de la manière dont un agent de codage doit évoluer : des simples échanges "un prompt, une réponse" jusqu'à des systèmes semi-autonomes capables de tourner pendant des heures, de se corriger eux-mêmes, et de capitaliser sur l'expérience accumulée.

Ces trois piliers sont :

- **Les boucles** (*loops*) — la mécanique de répétition qui permet à Claude de continuer à travailler au-delà d'un seul tour de conversation.
- **Les workflows dynamiques** — la capacité de Claude à écrire, à la volée, le programme qui orchestre son propre travail (et celui d'agents auxiliaires).
- **Les skills** — les briques de connaissance et d'outillage réutilisables qui rendent chaque tour de boucle, chaque étape de workflow, plus fiable et plus rapide.

Ce document reprend en détail le contenu des trois articles sources, dans un ordre pédagogique, en les complétant avec des explications, des exemples concrets et des tableaux de synthèse pour en faciliter la lecture et la mise en pratique.

> **Note sur les dates de publication**
> - *Lessons from building Claude Code: How we use skills* — 3 juin 2026
> - *A harness for every task: dynamic workflows in Claude Code* — début juin 2026
> - *Getting started with loops* — 30 juin 2026

---

## Partie 1 — Les boucles agentiques

### 1.1 Qu'est-ce qu'une boucle ?

L'équipe Claude Code définit une boucle ainsi :

> Un agent qui répète des cycles de travail jusqu'à ce qu'une condition d'arrêt soit remplie.

Cette définition volontairement simple sert de socle à une classification en quatre familles, distinguées selon quatre critères :

1. **Comment la boucle est déclenchée** (un prompt manuel, un intervalle de temps, un événement...)
2. **Comment elle s'arrête** (jugement de Claude, critère explicite, action de l'utilisateur...)
3. **Quelle primitive de Claude Code est utilisée** (prompt simple, `/goal`, `/loop`, `/schedule`...)
4. **Pour quel type de tâche elle est la plus adaptée**

Le message clé de l'article : **ne pas systématiquement complexifier**. Une tâche courte et simple n'a pas besoin d'un `/goal` avec critère de sortie, encore moins d'une routine planifiée. Il faut choisir le niveau de boucle proportionné à la tâche, et ne monter en complexité que lorsque c'est justifié.

### 1.2 Boucle turn-based

C'est la boucle par défaut — celle que tout utilisateur de Claude Code pratique dès le premier prompt.

| Caractéristique | Détail |
|---|---|
| **Déclenchée par** | Un prompt utilisateur |
| **Critère d'arrêt** | Claude juge qu'il a terminé la tâche, ou qu'il a besoin de plus de contexte |
| **Idéale pour** | Les tâches courtes, ponctuelles, hors processus récurrent |
| **Se pilote via** | Des prompts précis + des skills de vérification pour réduire le nombre d'allers-retours |

**Déroulé typique** : Claude rassemble du contexte (lecture de fichiers, recherche), agit (édition de code), vérifie son travail (tests), recommence si besoin, puis répond. C'est ce que l'article appelle *la boucle agentique*.

**Exemple donné** : demander à Claude de créer un bouton "like". Il lit le code existant, fait la modification, lance les tests, et rend la main en affirmant que ça fonctionne — mais cette affirmation reste une **croyance**, pas une certitude vérifiée de bout en bout par un humain ou un outil externe.

**Le levier d'amélioration : encoder la vérification en skill.**

L'idée centrale de cette section est que la qualité de la boucle turn-based dépend directement de la qualité de l'étape de vérification. Si vous vérifiez manuellement un type de changement de façon répétée (par exemple : ouvrir le navigateur, cliquer sur le nouveau bouton, vérifier la console), cette procédure peut être transformée en `SKILL.md` pour que Claude l'exécute lui-même. Plus la vérification est quantitative (score, capture d'écran comparée, assertion programmatique), plus Claude peut s'auto-évaluer fidèlement.

**Exemple de skill de vérification donné dans l'article :**

```markdown
---
name: verify-frontend-change
description: Verify any UI change end-to-end before declaring it done.
---

# Verifying frontend changes
Never report a UI change as complete based on a successful edit alone.
Verify it the way a human reviewer would:

1. Start the dev server and open the edited page in the browser.
2. Interact with the change directly. For a new control (button, input,
   toggle): click it, confirm the expected state change, and screenshot
   before/after.
3. Check the browser console: zero new errors or warnings.
4. Use the Chrome Devtools MCP, run a performance trace and audit
   Core Web Vitals.

If any step fails, fix the issue and rerun from step 1 — do not hand
back partially verified work.
```

Ce skill, une fois installé, transforme une simple modification "à l'aveugle" en un cycle de vérification quasi-automatique proche de ce qu'un développeur ferait manuellement.

### 1.3 Boucle goal-based (/goal)

| Caractéristique | Détail |
|---|---|
| **Déclenchée par** | Un prompt manuel, en temps réel |
| **Critère d'arrêt** | Objectif atteint OU nombre maximum de tentatives atteint |
| **Idéale pour** | Les tâches avec un critère de sortie vérifiable |
| **Se pilote via** | Une définition précise du critère de complétion + un plafond de tentatives explicite |

Pour les tâches complexes, un seul tour ne suffit généralement pas — Claude a besoin d'itérer. La commande `/goal` permet d'étendre la durée de la boucle en définissant explicitement à quoi ressemble "terminé".

**Le mécanisme clé** : quand la définition du succès est explicite, Claude n'a plus à juger lui-même si le résultat est "assez bon" — ce jugement est délégué à un **modèle évaluateur** qui vérifie la condition à chaque tentative de sortie, et renvoie Claude au travail tant que l'objectif n'est pas atteint (ou que le nombre de tours défini est épuisé).

C'est pourquoi les **critères déterministes** sont particulièrement efficaces : un nombre de tests qui passent, un score qui dépasse un seuil, etc. — plutôt que des critères flous ("le code est propre").

**Exemple donné :**

```
/goal get the homepage Lighthouse score to 90 or above, stop after 5 tries.
```

**Bonnes pratiques complémentaires (non explicitement dans l'article mais logiques avec le système décrit) :**
- Toujours fixer un plafond de tentatives (`stop after N tries`) pour éviter une boucle qui tourne indéfiniment et consomme des tokens sans converger.
- Préférer un critère binaire et mesurable ("tous les tests passent", "0 erreur ESLint") à un critère qualitatif.

### 1.4 Boucle time-based (/loop et /schedule)

| Caractéristique | Détail |
|---|---|
| **Déclenchée par** | Un intervalle de temps défini |
| **Critère d'arrêt** | Annulation manuelle, ou travail terminé (PR mergée, file d'attente vide) |
| **Idéale pour** | Le travail récurrent, ou l'interfaçage avec des systèmes externes |
| **Se pilote via** | Des intervalles plus longs, ou une réaction aux événements plutôt qu'au temps |

Certaines tâches sont intrinsèquement récurrentes : la nature du travail ne change pas, seules les données d'entrée changent (exemple donné : résumer les messages Slack chaque matin). D'autres tâches dépendent de systèmes externes dont l'état évolue de façon imprévisible — une manière simple de s'y interfacer est de vérifier périodiquement leur état et de réagir aux changements (exemple : une PR qui reçoit des reviews ou dont la CI échoue).

**`/loop`** relance un prompt à intervalle régulier :

```
/loop 5m check my PR, address review comments, and fix failing CI
```

Point important : **`/loop` s'exécute sur votre machine locale**. Si vous éteignez votre ordinateur ou fermez le terminal, la boucle s'arrête.

**`/schedule`** permet de déplacer cette boucle dans le cloud, en créant une **routine** qui continue de tourner indépendamment de votre machine.

### 1.5 Boucles proactives

| Caractéristique | Détail |
|---|---|
| **Déclenchée par** | Un événement ou un planning, sans humain en temps réel |
| **Critère d'arrêt** | Chaque tâche individuelle se termine quand son objectif est atteint ; la routine elle-même tourne jusqu'à désactivation |
| **Idéale pour** | Les flux récurrents de travail bien défini : rapports de bugs, triage de tickets, migrations, mises à jour de dépendances |
| **Se pilote via** | Router les tâches routinières vers des modèles plus petits/rapides, et réserver le modèle le plus capable pour les décisions de jugement |

C'est le niveau le plus élevé de composition. Il assemble les primitives précédentes avec deux autres fonctionnalités de Claude Code :

- **Auto mode** : la routine s'exécute sans s'arrêter à chaque demande de permission.
- **Dynamic workflows** *(voir Partie 2)* : orchestration d'agents pour trier, corriger et vérifier chaque élément de travail.

**Exemple de composition donné, pour gérer les retours utilisateurs entrants :**

1. `/schedule` (research preview) — exécute une routine qui vérifie l'arrivée de nouveaux rapports.
2. `/goal` — définit ce qu'est "terminé", combiné à des **skills** qui documentent comment vérifier.
3. **Dynamic workflows** — orchestrent des agents qui trient chaque rapport, corrigent, et font une revue de la correction.
4. **Auto mode** — pour que la routine tourne sans interruption de permission.

**Prompt complet donné en exemple :**

```
/schedule every hour: check #project-feedback for bug reports.
/goal: don't stop until every report found this run is triaged,
actioned, and responded to. When fixing a bug, use a workflow to
explore three solutions in parallel worktrees and have a judge
adversarially review them.
```

Ce prompt illustre bien l'articulation des trois piliers de ce guide : une routine planifiée (`/schedule`), un objectif vérifiable (`/goal`), et une orchestration multi-agents (le mot "workflow" dans le prompt).

### 1.6 Maintenir la qualité du code

La qualité de sortie d'une boucle dépend directement du **système** construit autour d'elle. Quatre leviers sont mentionnés :

1. **Garder la base de code propre.** Claude suit les patterns et conventions déjà présents dans le code — un code désordonné produit un code désordonné en retour.
2. **Donner à Claude un moyen de vérifier son propre travail.** C'est le rôle des skills (voir Partie 3), qui encodent ce à quoi ressemble "du bon travail" pour votre équipe.
3. **Rendre la documentation accessible.** Les docs à jour des frameworks et librairies utilisés doivent être facilement atteignables par Claude.
4. **Utiliser un second agent pour les revues de code.** Un reviewer avec un contexte "frais" est moins biaisé et non influencé par le raisonnement de l'agent principal. On peut utiliser le skill intégré `/code-review` ou l'intégration **Code Review** pour GitHub.

Un principe transversal : **quand un résultat individuel ne respecte pas le standard attendu, ne pas se contenter de corriger ce cas isolé — chercher à encoder la correction dans le système pour que toutes les itérations futures en bénéficient.** C'est exactement la logique du "Gotchas" évoquée dans la Partie 3 sur les skills.

### 1.7 Gérer la consommation de tokens

Une boucle mal maîtrisée peut consommer des quantités importantes de tokens sans y être invitée. Six leviers de contrôle sont proposés :

| Levier | Explication |
|---|---|
| **Choisir la bonne primitive et le bon modèle** | Les petites tâches n'ont pas besoin de multiples agents ou de boucles. Certaines tâches peuvent utiliser des modèles moins chers et plus rapides. |
| **Définir des critères de succès et d'arrêt clairs** | Plus "terminé" est défini précisément, plus vite Claude y arrive (sans pour autant s'arrêter trop tôt). |
| **Piloter avant un grand run** | Les dynamic workflows peuvent générer des centaines d'agents. Tester sur un sous-ensemble réduit du travail avant de lancer à grande échelle. |
| **Utiliser des scripts pour le travail déterministe** | Exécuter un script coûte moins cher que de faire raisonner Claude à chaque étape. Exemple : un skill PDF peut embarquer un script de remplissage de formulaire que Claude réutilise, plutôt que de re-dériver le code à chaque fois. |
| **Ne pas exécuter les routines plus souvent que nécessaire** | Faire correspondre l'intervalle à la fréquence réelle de changement de ce qui est surveillé. |
| **Revoir l'usage régulièrement** | `/usage` détaille l'usage récent par skills, sous-agents et MCPs. `/goal` sans argument affiche le nombre de tours et l'usage de tokens en cours. `/workflows` affiche l'usage de tokens de chaque agent, et permet de stopper un agent à tout moment. |

### 1.8 Tableau récapitulatif

| Boucle | Ce que vous déléguez | Quand l'utiliser | Primitive |
|---|---|---|---|
| **Turn-based** | La vérification | Vous explorez ou décidez | Skills de vérification personnalisés |
| **Goal-based** | La condition d'arrêt | Vous savez à quoi ressemble "terminé" | `/goal` |
| **Time-based** | Le déclencheur | Le travail se produit hors de votre projet, selon un planning | `/loop`, `/schedule` |
| **Proactive** | Le prompt lui-même | Le travail est récurrent et bien défini | Toutes les primitives ci-dessus + dynamic workflows |

**Méthode de démarrage conseillée par l'article** : regarder le travail que vous faites déjà, identifier une tâche où vous êtes le goulot d'étranglement, et vous demander quelle partie vous pourriez déléguer — pouvez-vous écrire le critère de vérification ? L'objectif est-il assez clair ? Le travail arrive-t-il selon un planning régulier ? Une fois la boucle lancée, observez où elle échoue ou dépasse ses attributions, et itérez sans crainte.

---

## Partie 2 — Les workflows dynamiques

### 2.1 Le problème du harnais unique

Un **harnais** (*harness*) est l'échafaudage logiciel autour du modèle : la partie qui décide comment une tâche est planifiée, découpée, vérifiée et exécutée. Le harnais par défaut de Claude Code est construit avant tout pour des tâches de codage — et il s'avère utile bien au-delà, parce que beaucoup de tâches ressemblent, structurellement, à des tâches de code.

Mais certaines catégories de travail ont historiquement nécessité la construction de harnais personnalisés au-dessus de Claude Code pour atteindre des performances optimales : la recherche, l'analyse de sécurité, les équipes d'agents (*agent teams*), ou la revue de code.

Les **workflows dynamiques**, disponibles depuis Claude Opus 4.8, permettent à Claude d'écrire lui-même, à la volée, un harnais sur mesure pour la tâche en cours — plutôt que de rester dans le harnais générique unique.

> **Point important** : les workflows dynamiques consomment généralement plus de tokens que le mode par défaut, et sont donc mieux adaptés aux tâches complexes et à forte valeur ajoutée, pas à toutes les tâches de codage courantes.

### 2.2 Les trois modes de défaillance

Lorsqu'on confie une tâche au harnais par défaut, Claude doit à la fois **planifier** et **exécuter** dans la même fenêtre de contexte. Pour de nombreuses tâches de code, c'est très efficace — mais cela se dégrade sur des tâches longues, massivement parallèles, hautement structurées et/ou adversariales. Plus Claude travaille longtemps sur une tâche complexe dans une seule fenêtre de contexte, plus il devient vulnérable à trois modes de défaillance spécifiques :

1. **La paresse agentique (*agentic laziness*)**
   Claude s'arrête avant d'avoir terminé une tâche complexe à plusieurs parties, et déclare le travail terminé après un progrès partiel. Exemple canonique : une revue de sécurité qui traite 35 éléments sur 50 et se déclare "terminée". Le modèle ne ment pas délibérément : sa mémoire de travail est saturée, il perd le fil de ce qui reste à faire, et rationalise un point d'arrêt.

2. **Le biais d'auto-préférence (*self-preferential bias*)**
   Quand on demande à Claude de vérifier ou de juger ses propres résultats par rapport à une grille d'évaluation, il a tendance à privilégier ses propres conclusions — un biais qui se manifeste particulièrement quand c'est lui-même qui note son propre travail.

3. **La dérive (*drift*)**
   Sur de longues sessions, à force de tours multiples, l'objectif initial se dilue progressivement.

Chaque workflow dynamique est conçu pour contrer au moins un de ces trois modes de défaillance.

### 2.3 Workflow statique vs workflow dynamique

Il était déjà possible, avant les workflows dynamiques, de construire un harnais "à la main" — avec le Claude Agent SDK, ou en exécutant `claude -p` en boucle, pour créer un système fixe et réutilisable. C'est un **workflow statique** : utile, reproductible, mais conçu à l'avance.

Le problème des workflows statiques : parce qu'ils doivent fonctionner pour tous les cas particuliers, ils tendent à devenir génériques — une seule orchestration que l'on espère adaptée à tout ce qui viendra ensuite.

Le **workflow dynamique** est l'inverse : parce que Claude Opus 4.8 est assez intelligent pour écrire un harnais correct à la demande, Claude construit un harnais taillé sur mesure pour la tâche exacte en cours. Une migration touchant trois modules obtient un harnais à trois modules. Une vérification factuelle d'un article de blog obtient un harnais de vérification affirmation par affirmation. Rien de générique, aucun cas particulier à anticiper à l'avance, parce que le harnais n'a besoin de gérer que la tâche unique pour laquelle il a été écrit.

**Mécanisme concret** : Claude écrit un petit programme (JavaScript) qui contient littéralement le plan — "pour chacun de ces éléments, fais ceci puis cela, et voici où tout le monde attend tout le monde". Le script porte la boucle, les branches conditionnelles et les résultats intermédiaires. Claude n'a plus qu'à gérer l'étape en cours et la synthèse finale — **le plan sort de la tête de Claude et devient du code exécutable.**

### 2.4 Comment déclencher un workflow

Deux façons simples :

- **Demander explicitement** à Claude de "faire un workflow" pour une tâche donnée.
- **Utiliser le mot-clé "ultracode"**, qui envoie un effort de raisonnement élevé (*xhigh*) au modèle et lui permet de décider lui-même quand une tâche justifie un harnais sur mesure.

Un réglage complémentaire, `/effort ultracode`, fait en sorte que Claude planifie un workflow pour chaque tâche substantielle de la session — ce réglage se réinitialise au démarrage d'une nouvelle session.

Il est également recommandé de combiner le déclenchement d'un workflow avec **Auto mode**, pour qu'un run qui génère des dizaines de sous-agents ne s'arrête pas à chaque demande de permission.

### 2.5 Les six patterns de composition

Claude compose ces patterns entre eux selon la nature de la tâche :

| # | Pattern | Description |
|---|---|---|
| 1 | **Classify-and-act** | Un agent classifieur détermine le type de tâche, puis route vers différents agents ou comportements. Le classifieur peut aussi être placé en fin de chaîne, pour déterminer comment structurer la sortie finale. |
| 2 | **Découpage-synthèse** | Une tâche est découpée en plusieurs étapes plus petites, un agent traite chaque étape séparément, puis les résultats sont synthétisés en une réponse unique. |
| 3 | **Recherche parallèle** | Plusieurs agents explorent différentes pistes ou sources en parallèle avant convergence. |
| 4 | **Revue adversariale** | Un agent produit un résultat, un autre agent (avec un contexte "frais", donc moins biaisé) le challenge activement pour trouver des failles. |
| 5 | **Tournoi** | Plusieurs agents ou modèles tentent la même tâche en parallèle. Un juge compare les candidats, élimine les plus faibles et sélectionne le(s) gagnant(s). Utile pour le routage de modèles et la sélection de solutions : des modèles moins chers peuvent produire des passes rapides, un modèle plus capable juge les finalistes, et des styles de modèles différents peuvent s'affronter plutôt que de laisser un seul modèle biaiser tout le workflow. |
| 6 | **Loop until done** | Faire, vérifier, corriger, revérifier — jusqu'à ce qu'une véritable condition d'arrêt soit remplie. Proche de la logique de `/loop`, mais ne fait pas confiance au premier "c'est fait" — la confiance est placée dans une condition d'arrêt vérifiable. Avec `/goal`, le workflow garde la cible fixée pour que l'agent ne travaille pas fort dans la mauvaise direction. |

Ces patterns ne sont pas figés isolément : dans la pratique, Claude les **compose** (par exemple : classify-and-act, suivi d'un découpage-synthèse par catégorie, suivi d'une revue adversariale sur le résultat final).

**Capacités additionnelles des workflows :**

- Un workflow peut décider **quel modèle** chaque agent utilise, et si les sous-agents sont exécutés dans **leur propre worktree git** — Claude choisit ainsi le niveau d'intelligence et le niveau d'isolation nécessaires à chaque étape.
- Si un workflow est interrompu (intervention utilisateur, fermeture du terminal), **reprendre la session permet au workflow de repartir exactement où il s'était arrêté**, sans repartir de zéro.

### 2.6 Bonnes pratiques de prompting

- **Le prompting détaillé** produit les meilleurs résultats pour les workflows dynamiques — nommer explicitement les patterns ci-dessus dans votre prompt aide Claude à composer le bon harnais.
- **Les workflows ne sont pas réservés aux grosses tâches.** On peut demander un "quick workflow" pour, par exemple, une revue contradictoire rapide d'une seule hypothèse.
- **Combiner avec `/loop` et `/goal`** pour les workflows destinés à être répétés (triage, recherche, vérification) : `/loop` pour l'exécution à intervalle régulier, `/goal` pour fixer une exigence de complétion stricte.
- **Fixer un budget de tokens explicite.** On peut simplement demander "utilise 10k tokens" dans le prompt, ce qui devient le plafond du run.

### 2.7 Sauvegarder et partager un workflow

Un workflow qui a bien fonctionné peut être sauvegardé :

- Appuyer sur **`s`** dans le menu `/workflows` pour le sauvegarder comme commande réutilisable.
- Le stocker dans **`.claude/workflows/`** (partagé avec toute personne qui clone le dépôt) ou **`~/.claude/workflows/`** (disponible dans tous vos projets, en usage personnel uniquement).
- Il devient alors accessible via **`/<nom-du-workflow>`** dans les sessions futures, et peut accepter des paramètres via une variable globale `args`.
- Pour une distribution plus large, les fichiers JavaScript du workflow peuvent être placés dans un **skill**, référencés dans son `SKILL.md`. Il est conseillé de prompt Claude pour qu'il traite ces fichiers de workflow **comme un gabarit à adapter**, plutôt que comme un script à exécuter tel quel — ce qui garde le workflow flexible d'un projet à l'autre.

### 2.8 Étude de cas : la migration Zig → Rust

Un exemple largement repris pour illustrer la puissance des workflows dynamiques concerne un besoin de porter, fichier par fichier, environ **750 000 lignes de code Zig vers Rust**. Le pattern utilisé était simple mais rigoureux : faire une unité de travail, exécuter une revue adversariale sur ce travail, puis appliquer les changements validés.

Résultat rapporté : environ 750 000 lignes de Rust produites, **99,8 % de la suite de tests existante qui passe**, et seulement **11 jours** entre le premier commit et le merge final — une tâche qui aurait pris une équipe entière plusieurs mois selon une approche traditionnelle.

L'idée centrale que cet exemple illustre : **Claude n'a plus besoin de garder tout le plan en tête**. Le workflow déplace le plan dans le code — le script porte la boucle, les branches, et les résultats intermédiaires — pendant que Claude se concentre sur l'étape courante et la synthèse finale.

---

## Partie 3 — Les skills

### 3.1 Qu'est-ce qu'un skill ?

Un skill est une **collection d'instructions, de scripts et de ressources** qu'un agent peut découvrir et utiliser pour accomplir des tâches avec plus de précision et d'efficacité. Contrairement à l'idée reçue, ce n'est pas "juste un fichier markdown" : c'est un **dossier**, potentiellement composé de scripts, d'assets, de données, que l'agent explore et manipule.

Dans Claude Code, les skills disposent d'un large éventail d'options de configuration, notamment l'enregistrement de **hooks dynamiques** — des scripts qui s'exécutent à des moments précis du cycle de vie de l'agent, mais uniquement quand le skill est actif.

### 3.2 Les neuf catégories de skills

Après avoir catalogué l'ensemble de leurs skills internes (plusieurs centaines en usage actif chez Anthropic), l'équipe a constaté qu'ils se regroupent naturellement en neuf catégories. **Les meilleurs skills entrent proprement dans une seule catégorie** ; ceux qui essaient d'en couvrir plusieurs à la fois finissent par embrouiller l'agent.

#### 1. Référence de librairie et d'API

Expliquent comment utiliser correctement une librairie, une CLI ou un SDK — interne ou externe. Contiennent souvent un dossier d'extraits de code de référence et une liste de pièges à éviter.

*Exemples : `billing-lib` (librairie de facturation interne, cas limites, pièges), `internal-platform-cli` (chaque sous-commande d'un wrapper CLI interne avec exemples d'usage), `sandbox-proxy` (configuration de la passerelle réseau sortante — quels hôtes sont accessibles, comment déboguer une "connexion refusée").*

#### 2. Vérification produit

Décrivent comment tester ou vérifier qu'un code fonctionne réellement — souvent associés à Playwright, tmux ou d'autres outils externes.

> **C'est la catégorie qui a eu le plus d'impact mesurable sur la qualité de sortie de Claude en interne.** L'article suggère qu'il peut valoir la peine de dédier une semaine complète d'un ingénieur à rendre ces skills excellents.

Techniques recommandées : faire enregistrer une vidéo à Claude de ce qu'il a testé pour voir exactement ce qui a été vérifié, ou imposer des assertions programmatiques sur l'état à chaque étape.

*Exemples : `signup-flow-driver` (parcourt inscription → vérification email → onboarding dans un navigateur headless, avec des hooks d'assertion à chaque étape), `checkout-verifier` (pilote l'UI de paiement avec des cartes de test Stripe, vérifie que la facture atterrit dans le bon état), `tmux-cli-driver` (pour tester des CLI interactives nécessitant un TTY).*

#### 3. Récupération et analyse de données

Se connectent aux stacks de données et de monitoring : librairies pour récupérer des données avec les bons identifiants, IDs de dashboards spécifiques, instructions sur les workflows courants.

*Exemples : `funnel-query` (quels événements joindre pour voir inscription → activation → paiement, et où se trouve la table avec le user_id canonique), `cohort-compare` (comparer la rétention/conversion de deux cohortes, signaler les écarts statistiquement significatifs), `grafana` (UIDs de sources de données, noms de clusters, table de correspondance problème → dashboard), `datadog` (référence des champs comme `@request_id` vs `trace_id`, liste des services, conventions de préfixes de métriques).*

#### 4. Automatisation de processus métier et d'équipe

Automatisent des workflows répétitifs en une seule commande. Généralement des instructions assez simples, mais pouvant dépendre d'autres skills ou de MCPs. Sauvegarder les résultats précédents dans des fichiers de log aide le modèle à rester cohérent et à se référer aux exécutions passées.

*Exemples : `standup-post` (agrège tracker de tickets, activité GitHub et Slack précédent → post de standup formaté, uniquement les deltas), `create-<ticket-system>-ticket` (impose un schéma — valeurs d'énumération valides, champs requis — plus un workflow post-création comme notifier le reviewer), `weekly-recap` (PRs mergées + tickets fermés + déploiements → post de récap formaté).*

#### 5. Scaffolding de code et templates

Génèrent du boilerplate pour une fonction spécifique de la base de code. Particulièrement utiles quand le scaffolding a des exigences en langage naturel qui ne peuvent pas être purement couvertes par du code.

*Exemples : `new-<framework>-workflow` (génère un nouveau service/workflow/handler avec vos annotations), `new-migration` (template de fichier de migration + pièges courants), `create-app` (nouvelle app interne avec auth, logging et config de déploiement pré-câblés).*

#### 6. Qualité de code et revue

Font respecter la qualité de code au sein de l'organisation et aident à la revue. Peuvent inclure des scripts ou outils déterministes pour une robustesse maximale. Souvent exécutés automatiquement via des hooks ou dans une GitHub Action.

*Exemples : `adversarial-review` (fait naître un sous-agent "fresh-eyes" pour critiquer, implémenter les corrections, itérer jusqu'à ce que les découvertes se réduisent à des remarques mineures), `code-style` (fait respecter un style de code, en particulier ceux que Claude ne suit pas naturellement bien), `testing-practices` (instructions sur comment écrire des tests et quoi tester).*

#### 7. CI/CD et déploiement

Aident à récupérer, pousser et déployer du code. Peuvent référencer d'autres skills pour collecter des données.

*Exemples : `babysit-pr` (surveille une PR → relance la CI flaky → résout les conflits de merge → active l'auto-merge), `deploy-<service>` (build → smoke test → rollout progressif du trafic avec comparaison du taux d'erreur → rollback automatique en cas de régression), `cherry-pick-prod` (worktree isolé → cherry-pick → résolution de conflit → PR avec template).*

#### 8. Runbooks

Prennent un symptôme (thread Slack, alerte, signature d'erreur), déroulent une investigation multi-outils, et produisent un rapport structuré.

*Exemples : `<service>-debugging` (fait correspondre symptômes → outils → patterns de requête pour vos services à plus fort trafic), `oncall-runner` (récupère l'alerte → vérifie les suspects habituels → formate une conclusion), `log-correlator` (à partir d'un request ID, extrait les logs correspondants de tous les systèmes qui ont pu être traversés).*

#### 9. Opérations d'infrastructure

Effectuent la maintenance de routine et les procédures opérationnelles, dont certaines impliquent des actions destructives qui bénéficient de garde-fous.

*Exemples : `<resource>-orphans` (trouve les pods/volumes orphelins → poste sur Slack → période de latence → confirmation utilisateur → nettoyage en cascade), `dependency-management` (workflow d'approbation des dépendances de l'organisation), `cost-investigation` ("pourquoi notre facture de stockage/egress a explosé" avec les buckets et patterns de requête spécifiques).*

### 3.3 Bonnes pratiques de rédaction

#### N'énoncez pas l'évident

Claude sait déjà coder et peut lire votre base de code. Un skill qui répète ce que Claude ferait par défaut ajoute du contexte sans ajouter de valeur. Si vous publiez un skill principalement axé sur la connaissance, concentrez-vous sur les informations qui **poussent Claude en dehors de sa façon de penser habituelle**.

Le skill `frontend-design` d'Anthropic est cité comme un excellent exemple : construit en itérant avec des clients pour améliorer le goût esthétique de Claude, en évitant explicitement des patterns classiques comme la police Inter ou les dégradés violets omniprésents dans les interfaces générées par IA.

#### Construisez une section "Gotchas"

C'est **le contenu au plus fort signal de tout skill**. Ces sections doivent être construites à partir des points d'échec courants que Claude rencontre en utilisant votre skill, et doivent idéalement être enrichies dans le temps.

**Exemples cités dans l'article :**

> *"La table `subscriptions` est append-only. La ligne que vous voulez est celle avec la version la plus élevée, pas celle avec le `created_at` le plus récent."*
>
> *"Ce champ s'appelle `@request_id` dans la passerelle API et `trace_id` dans le service de facturation. C'est la même valeur."*
>
> *"Le staging renvoie 200 même quand le webhook Stripe n'a pas réellement été traité. Vérifiez `payment_events` pour l'état réel."*

#### Utilisez le système de fichiers et la divulgation progressive

Un skill est un **dossier**, pas seulement un fichier markdown. Il faut penser l'ensemble du système de fichiers comme une forme d'ingénierie de contexte et de divulgation progressive. En indiquant à Claude quels fichiers composent le skill, il les lira au moment approprié.

La forme la plus simple de divulgation progressive consiste à pointer vers d'autres fichiers markdown. Par exemple, séparer les signatures de fonctions détaillées et les exemples d'usage dans `references/api.md`. Autre exemple : si la sortie finale est un fichier markdown, un fichier gabarit peut être inclus dans `assets/` que Claude copie et utilise.

On peut ainsi avoir des dossiers entiers de références, de scripts, d'exemples, qui aident Claude à travailler plus efficacement.

#### Évitez de trop cadrer ("railroader") Claude

Claude a tendance à suivre fidèlement les instructions données — et comme les skills sont conçus pour être réutilisés, il faut être vigilant à ne pas être trop spécifique dans les instructions. Donnez à Claude l'information nécessaire, mais laissez-lui la flexibilité de s'adapter à la situation rencontrée.

#### Pensez la configuration initiale

Certains skills nécessitent d'être configurés avec du contexte fourni par l'utilisateur. Par exemple, un skill qui poste votre standup sur Slack peut avoir besoin de demander dans quel canal poster.

Le pattern recommandé : stocker ces informations de configuration dans un fichier **`config.json`** au sein du dossier du skill. Si la configuration n'est pas encore définie, l'agent peut alors demander l'information à l'utilisateur — en utilisant, si l'on veut des questions structurées à choix multiples, l'outil `AskUserQuestion`.

#### Rédigez les descriptions pour le modèle, pas pour les humains

Au démarrage d'une session Claude Code, une liste de tous les skills disponibles avec leur description est construite. C'est cette liste que Claude scanne pour décider "y a-t-il un skill pertinent pour cette demande ?".

**Conséquence importante** : le champ description n'est pas un résumé du skill — c'est **une description de quand déclencher ce skill**. Il est utile d'y inclure explicitement des mots-déclencheurs (l'exemple donné dans l'article est le mot "babysit" pour un skill de surveillance de PR).

#### Aidez Claude à se souvenir

Certains skills peuvent inclure une forme de mémoire en stockant des données en leur sein — d'un simple fichier de log en append-only, à des fichiers JSON, jusqu'à une base SQLite complète.

Exemple : un skill `standup-post` pourrait conserver un fichier `standups.log` avec chaque post rédigé — ce qui signifie qu'à la prochaine exécution, Claude lit son propre historique et peut identifier ce qui a changé depuis la veille.

La variable d'environnement **`${CLAUDE_PLUGIN_DATA}`** fournit un répertoire stable où stocker ces données de façon persistante.

#### Stockez des scripts, générez du code

Un des outils les plus puissants que l'on puisse donner à Claude, c'est du **code**. Fournir des scripts et des librairies permet à Claude de consacrer ses tours à la composition — décider quoi faire ensuite — plutôt qu'à la reconstruction de boilerplate à chaque fois.

Exemple donné : dans un skill `data-science`, fournir une librairie de fonctions pour récupérer des données depuis une source d'événements permet à Claude de générer des scripts à la volée qui composent ces fonctions pour répondre à des questions complexes comme *"Que s'est-il passé mardi ?"*.

#### Utilisez des hooks à la demande

Les skills peuvent inclure des hooks qui ne s'activent que lorsque le skill est appelé, et qui ne durent que le temps de la session. Utile pour des hooks très marqués que vous ne voulez pas voir tourner en permanence.

**Exemples donnés :**

- **`/careful`** — bloque `rm -rf`, `DROP TABLE`, force-push, `kubectl delete` via un matcher PreToolUse sur Bash. Utile uniquement quand on sait qu'on touche à la prod — l'avoir activé en permanence rendrait fou.
- **`/freeze`** — bloque tout Edit/Write en dehors d'un répertoire spécifique. Utile en debug : "je veux ajouter des logs mais je me surprends à 'corriger' accidentellement du code non lié."

### 3.4 Distribution des skills

Deux méthodes principales pour partager des skills avec une équipe :

1. **Les commiter dans le dépôt**, sous `./.claude/skills` — approche qui fonctionne bien pour les petites équipes travaillant sur relativement peu de dépôts.
2. **Créer un plugin**, distribué via un marketplace de plugins Claude Code, où les utilisateurs peuvent uploader et installer des plugins.

**Point d'attention** : chaque skill commité ajoute un peu de contexte au modèle. À mesure que l'organisation grandit, un marketplace de plugins interne permet de distribuer les skills tout en laissant chaque personne décider lesquels installer, avec un flux de configuration dédié.

### 3.5 Gérer un marketplace de skills

Anthropic n'a pas d'équipe centralisée qui décide quels skills entrent dans le marketplace — l'approche est **organique** :

1. Une personne qui a un skill qu'elle souhaite faire tester par d'autres l'upload dans un dossier "sandbox" sur GitHub, et le partage sur Slack ou d'autres forums internes.
2. Une fois qu'un skill a gagné en traction (c'est au propriétaire du skill d'en juger), il ou elle soumet une PR pour l'intégrer au marketplace officiel.

### 3.6 Composer des skills entre eux

Il peut être souhaitable d'avoir des skills qui dépendent les uns des autres — par exemple, un skill d'upload de fichier et un skill de génération de CSV qui génère un CSV puis l'upload.

**Limite actuelle** : cette gestion de dépendances n'est pas nativement intégrée aux marketplaces ou aux skills. Il est cependant possible de simplement **référencer un autre skill par son nom** — le modèle l'invoquera lui-même si ce skill est installé.

### 3.7 Mesurer l'usage des skills

Pour comprendre la performance d'un skill, Anthropic utilise un **hook PreToolUse** qui journalise l'usage des skills à l'échelle de l'entreprise. Cela permet d'identifier les skills populaires, ou ceux qui se déclenchent moins souvent qu'attendu (sous-déclenchement, souvent révélateur d'une description mal calibrée pour le modèle — voir 3.3).

---

## Partie 4 — Comment ces trois concepts s'articulent

Ces trois notions ne sont pas indépendantes : elles forment un système à trois couches.

```
┌─────────────────────────────────────────────────────┐
│  BOUCLES — la mécanique de répétition                │
│  (turn-based → goal-based → time-based → proactive)  │
│                                                       │
│   ┌───────────────────────────────────────────────┐ │
│   │  WORKFLOWS DYNAMIQUES — l'orchestration        │ │
│   │  (le "comment" à l'intérieur d'une boucle       │ │
│   │   complexe : classify-and-act, tournoi,        │ │
│   │   revue adversariale, loop-until-done...)      │ │
│   │                                                 │ │
│   │   ┌───────────────────────────────────────┐   │ │
│   │   │  SKILLS — la connaissance réutilisable │   │ │
│   │   │  (ce que chaque agent, à chaque étape, │   │ │
│   │   │   sait faire de façon fiable et rapide) │   │ │
│   │   └───────────────────────────────────────┘   │ │
│   └───────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

- **Les boucles** définissent *quand* et *combien de fois* Claude retravaille une tâche.
- **Les workflows dynamiques** définissent *comment* le travail est structuré à l'intérieur d'une itération complexe — notamment en répartissant le travail entre plusieurs agents spécialisés.
- **Les skills** sont les briques que chaque agent, à chaque étape d'un workflow, à chaque tour d'une boucle, va utiliser pour être fiable et cohérent — en particulier les **skills de vérification**, qui sont ce qui permet à une boucle `/goal` de savoir objectivement si elle a atteint son critère de sortie.

C'est cette articulation qui permet l'exemple le plus abouti de l'article sur les boucles : une routine `/schedule` (boucle proactive) qui utilise un `/goal` (critère d'arrêt) et un **workflow** interne pour explorer trois solutions en parallèle et les faire juger de façon adversariale — chaque étape s'appuyant sur des **skills** pour savoir comment vérifier correctement le travail produit.

---

## Partie 5 — Application pratique : cas d'usage

Cette section propose des scénarios concrets pour illustrer la mise en pratique combinée des trois concepts, applicables à des projets de développement personnels ou professionnels.

### Cas 1 — Application web avec base de données (Supabase, PostgreSQL...)

| Composant | Application concrète |
|---|---|
| **Skill de vérification** | Un skill qui pilote un navigateur headless pour tester un flux d'authentification de bout en bout (inscription → confirmation email → connexion), avec assertions sur chaque état intermédiaire. |
| **Boucle goal-based** | `/goal fais passer tous les tests d'intégration au vert, stop après 5 tentatives.` |
| **Workflow dynamique** | Une revue adversariale automatique après chaque modification touchant les règles de sécurité au niveau ligne (RLS) — un agent implémente, un second agent "fresh-eyes" cherche les failles de permissions. |

### Cas 2 — Projet full-stack avec back-end et front-end séparés

| Composant | Application concrète |
|---|---|
| **Skill de référence** | Documenter les conventions internes du projet (structure des dossiers, conventions de nommage SQL, pièges connus d'un ORM) dans un skill dédié, avec une section Gotchas alimentée au fil des erreurs rencontrées. |
| **Boucle time-based** | `/loop 10m vérifie l'état de la CI et corrige les échecs de build.` |
| **Workflow dynamique** | Pattern *classify-and-act* : un agent classifie chaque ticket entrant (bug, amélioration UI, dette technique), puis route vers un agent spécialisé par catégorie. |

### Cas 3 — Automatisation de veille ou de reporting personnel

| Composant | Application concrète |
|---|---|
| **Skill d'automatisation** | Un skill qui agrège l'activité GitHub de la semaine et produit un post de récapitulatif formaté, avec un fichier log conservant l'historique des récaps précédents pour ne signaler que les deltas. |
| **Boucle proactive** | `/schedule chaque lundi matin : génère le récap hebdomadaire et poste-le.` |
| **Garde-fou** | Un hook à la demande de type `/careful` pour empêcher toute action destructive accidentelle pendant les sessions de nettoyage de dépendances obsolètes. |

### Bonnes pratiques transverses à retenir

1. **Commencer simple.** La boucle turn-based par défaut suffit à la majorité des tâches quotidiennes — ne pas construire un workflow dynamique pour ce qu'un bon prompt et un skill de vérification suffisent à résoudre.
2. **Investir dans la vérification avant tout.** C'est la catégorie de skill au plus fort impact mesuré en interne chez Anthropic — un skill de vérification bien construit améliore la fiabilité de toutes les boucles qui s'appuient dessus.
3. **Rendre les critères d'arrêt mesurables.** Un critère flou ("le code est propre") ne permet ni un bon `/goal`, ni une bonne condition de sortie dans un workflow *loop-until-done*.
4. **Capitaliser sur les erreurs rencontrées.** Chaque fois que Claude se trompe d'une façon récurrente, la bonne réaction n'est pas seulement de corriger l'instance en cours, mais d'ajouter l'apprentissage à un skill (section Gotchas) pour que toutes les itérations futures en bénéficient.
5. **Piloter avant de passer à l'échelle.** Avant de lancer un workflow ou une routine proactive sur l'ensemble d'un projet, tester sur un sous-ensemble réduit pour calibrer le comportement et le coût en tokens.

---

## Partie 6 — Tutoriels pas à pas

Cette partie propose quatre tutoriels concrets, à suivre dans l'ordre pour monter en compétence progressivement : d'un simple skill de vérification jusqu'à une routine proactive complète.

### Tutoriel 1 — Créer un skill de vérification de A à Z

**Objectif** : transformer une vérification manuelle répétitive (tester un changement d'interface) en skill réutilisable par Claude Code.

**Étape 1 — Identifier une vérification que vous faites déjà à la main.**
Posez-vous la question : *"Qu'est-ce que je vérifie systématiquement après que Claude a fait une modification de ce type ?"* Exemple retenu ici : après chaque modification touchant un formulaire, vous ouvrez le navigateur, remplissez le formulaire, vérifiez le message de succès, et regardez la console pour des erreurs.

**Étape 2 — Créer l'arborescence du skill.**

```
mkdir -p ~/.claude/skills/verify-form-change
cd ~/.claude/skills/verify-form-change
touch SKILL.md
```

**Étape 3 — Rédiger le `SKILL.md`.**
Rappel important (Partie 3.3) : la description doit dire *quand* déclencher le skill, pas résumer ce qu'il fait.

```markdown
---
name: verify-form-change
description: >
  Verify any form or input change end-to-end before declaring it done.
  Trigger this whenever a task touches a <form>, an input validation
  rule, or a submit handler.
---

# Vérifier un changement de formulaire

Ne jamais déclarer un changement de formulaire terminé sur la seule base
d'une édition réussie. Vérifier comme le ferait un relecteur humain :

1. Démarrer le serveur de dev et ouvrir la page concernée dans le
   navigateur.
2. Remplir le formulaire avec des données valides, soumettre, et
   confirmer que le message de succès attendu s'affiche.
3. Remplir le formulaire avec des données invalides (champ vide,
   format incorrect) et confirmer que les messages d'erreur attendus
   s'affichent, sans soumission.
4. Vérifier la console du navigateur : zéro nouvelle erreur ou warning.
5. Prendre une capture d'écran avant/après pour les cas valide et
   invalide.

Si une étape échoue, corriger le problème et reprendre depuis l'étape 1
— ne jamais rendre la main sur un travail partiellement vérifié.

## Gotchas

- Le message de succès met environ 400ms à apparaître (attendre un
  état, pas un délai fixe).
- Le champ email accepte à tort les adresses sans TLD en dev — vérifier
  aussi ce cas si le formulaire concerne un email.
```

**Étape 4 — Vérifier l'installation globale.**
C'est le piège récurrent évoqué dans l'article : un skill peut s'installer localement à un projet au lieu d'être disponible globalement.

```
ls -la ~/.claude/skills/verify-form-change
ls -la ~/.agents/skills/verify-form-change   # si vous utilisez cette convention
```

Si le skill n'apparaît que dans un projet précis, déplacez-le vers `~/.claude/skills/` (usage personnel, tous projets) ou `./.claude/skills/` à la racine du repo (partagé avec l'équipe).

**Étape 5 — Tester le déclenchement.**
Dans une session Claude Code, faites une modification touchant un formulaire et observez si le skill se déclenche spontanément. S'il ne se déclenche pas, la description n'est probablement pas assez explicite sur les mots-clés qui doivent l'activer (revoir 3.3).

**Étape 6 — Enrichir la section Gotchas dans le temps.**
Chaque fois que Claude rate un cas particulier malgré le skill, ajoutez une ligne dans la section Gotchas plutôt que de vous contenter de corriger le cas isolé (principe rappelé en 1.6).

---

### Tutoriel 2 — Lancer sa première boucle goal-based

**Objectif** : utiliser `/goal` pour une tâche qui nécessite plusieurs itérations avec un critère de sortie objectif.

**Étape 1 — Choisir une tâche avec un critère mesurable.**
`/goal` fonctionne mieux avec des critères déterministes : un nombre de tests qui passent, un score, une absence d'erreurs. Évitez les critères flous.

| Mauvais critère | Bon critère |
|---|---|
| "Le code est propre" | "0 warning ESLint sur le dossier `src/`" |
| "Les perfs sont meilleures" | "Le score Lighthouse Performance ≥ 90" |
| "Les tests marchent" | "100% des tests de `tests/checkout/` passent" |

**Étape 2 — Fixer un plafond de tentatives.**
Toujours accompagner le critère d'un nombre maximum d'essais, pour éviter une boucle qui consomme des tokens sans converger :

```
/goal fais passer tous les tests du dossier tests/checkout/ au vert,
stop after 6 tries.
```

**Étape 3 — Observer le déroulé.**
À chaque tentative, Claude modifie le code, relance les tests, et un modèle évaluateur vérifie si le critère est atteint avant de laisser Claude s'arrêter. Vous pouvez suivre la progression avec :

```
/goal
```

Sans argument, cette commande affiche le nombre de tours et l'usage de tokens en cours.

**Étape 4 — Si le plafond est atteint sans succès.**
Regardez ce qui bloque : souvent, soit le critère était mal formulé, soit la tâche nécessite un découpage préalable (auquel cas un workflow dynamique — Tutoriel 3 — devient pertinent).

**Étape 5 — Combiner avec un skill de vérification.**
Si vous avez déjà un skill de vérification (Tutoriel 1) couvrant le domaine concerné, `/goal` s'appuiera dessus automatiquement pour juger de la réussite — c'est la combinaison la plus fiable entre les deux mécanismes.

---

### Tutoriel 3 — Construire un workflow dynamique de revue adversariale

**Objectif** : mettre en place un pattern *revue adversariale* (Partie 2.5) pour fiabiliser une tâche sensible — ici, une modification touchant des règles de permissions.

**Étape 1 — Identifier une tâche à risque de biais d'auto-préférence.**
Typiquement : toute tâche où Claude modifie *et* doit juger la correction de sa propre modification (règles de sécurité, migrations de données, logique de facturation).

**Étape 2 — Déclencher le workflow.**
Deux options :

```
Fais un workflow pour cette tâche : ajoute la nouvelle règle de
permission sur la table `documents`, puis fais reviewer le changement
par un agent avec un contexte neuf qui cherche spécifiquement des
failles de permission.
```

ou, plus court, en utilisant le mot-clé dédié :

```
ultracode : ajoute la nouvelle règle de permission sur la table
`documents` et fais-la challenger par un agent adversarial.
```

**Étape 3 — Nommer explicitement le pattern dans le prompt.**
Rappel de la Partie 2.6 : le prompting détaillé donne les meilleurs résultats. Plutôt que de laisser Claude deviner la structure, on peut être explicite :

```
Utilise un pattern de revue adversariale : un agent implémente la règle
de permission, un second agent avec un contexte frais cherche
activement des cas où un utilisateur non autorisé pourrait quand même
accéder à la ressource. Itère jusqu'à ce que les découvertes du second
agent se réduisent à des remarques mineures.
```

**Étape 4 — Fixer un budget de tokens.**
Pour une tâche de cette taille, un budget explicite évite les mauvaises surprises :

```
Utilise 15k tokens maximum pour ce workflow.
```

**Étape 5 — Suivre l'exécution.**
```
/workflows
```
affiche l'usage de tokens de chaque agent du workflow, et permet d'arrêter un agent à tout moment si le comportement dévie.

**Étape 6 — Sauvegarder le workflow s'il a bien fonctionné.**
Dans le menu `/workflows`, appuyez sur **`s`** pour le sauvegarder. Stockez-le dans `.claude/workflows/` si vous voulez qu'il soit partagé avec toute personne qui clone le dépôt, ou `~/.claude/workflows/` s'il s'agit d'un usage personnel cross-projets.

**Étape 7 — Réutiliser le workflow sauvegardé.**
Une fois sauvegardé sous un nom, par exemple `permission-review`, il devient accessible directement :

```
/permission-review "ajoute une règle de permission sur la table invoices"
```

---

### Tutoriel 4 — Monter une routine proactive complète

**Objectif** : combiner `/schedule`, `/goal`, un workflow dynamique et des skills pour un flux de travail entièrement autonome — ici, le triage automatique de rapports de bugs remontés sur un canal Slack (ou équivalent).

**Étape 1 — Préparer les skills nécessaires en amont.**
Avant de construire la routine, assurez-vous d'avoir :
- Un skill de **vérification** pour votre stack (Tutoriel 1).
- Un skill de **runbook** décrivant comment diagnostiquer un rapport de bug typique dans votre codebase (catégorie 8, Partie 3.2).

**Étape 2 — Définir le déclencheur planifié.**
```
/schedule every hour: check #bug-reports for new reports.
```

**Étape 3 — Ajouter un critère d'arrêt strict pour chaque exécution.**
```
/goal: don't stop until every report found this run is triaged,
actioned, and responded to.
```

**Étape 4 — Injecter un workflow pour la partie correction.**
```
When fixing a bug, use a workflow to explore three solutions in
parallel worktrees and have a judge adversarially review them before
picking the best one.
```

**Étape 5 — Activer Auto Mode.**
Sans cela, la routine s'arrêterait à chaque demande de permission (édition de fichier, exécution de commande), ce qui casserait l'autonomie recherchée.

**Étape 6 — Assembler le prompt complet.**
En reprenant l'exemple de la Partie 1.5 et en l'adaptant :

```
/schedule every hour: check #bug-reports for new reports.
/goal: don't stop until every report found this run is triaged,
actioned, and responded to. When fixing a bug, use a workflow to
explore three solutions in parallel worktrees and have a judge
adversarially review them. Use the verify-form-change and
bug-triage-runbook skills wherever relevant. Use 20k tokens per report.
```

**Étape 7 — Piloter avant le grand déploiement.**
Conformément à la Partie 1.7, ne pas lancer directement sur l'ensemble du canal : commencer par une exécution manuelle limitée à 2-3 rapports pour calibrer le comportement, avant d'activer la planification horaire.

**Étape 8 — Surveiller dans la durée.**
- `/usage` régulièrement pour suivre la consommation par skills, sous-agents et MCPs.
- Ajuster l'intervalle de `/schedule` si les rapports arrivent moins fréquemment que toutes les heures (principe de la Partie 1.7 : ne pas exécuter plus souvent que nécessaire).
- Enrichir le skill de runbook à chaque nouveau type de bug rencontré qui n'était pas bien couvert.

---

## Partie 7 — Cas d'usage complets (fictifs)

Les trois cas suivants sont **entièrement fictifs** — entreprises, projets et chiffres inventés à des fins pédagogiques — mais construits pour illustrer de bout en bout l'enchaînement boucle → workflow → skill sur des scénarios réalistes.

### Cas 1 — NovaCart : une checkout qui ne devait plus jamais casser

**Contexte fictif.** NovaCart est une petite marketplace e-commerce fictive. Son équipe de deux développeurs a subi, le mois précédent, une régression silencieuse sur le tunnel de paiement : un changement de style CSS avait cassé la validation du formulaire de carte bancaire pendant six heures avant d'être repéré, sans qu'aucun test automatisé ne le détecte.

**Objectif.** Faire en sorte qu'aucune modification touchant au tunnel de paiement ne puisse être déclarée "terminée" sans une vérification de bout en bout automatique.

**Étape 1 — Construire le skill de vérification.**

L'équipe crée `checkout-verifier`, dans la catégorie *vérification produit* :

```markdown
---
name: checkout-verifier
description: >
  Verify any change touching the checkout flow, payment form, or
  cart summary before declaring it done. Trigger on changes to
  /components/checkout/**, /components/payment/**, or any file
  importing the Stripe SDK.
---

# Vérifier le tunnel de paiement de NovaCart

1. Démarrer l'environnement de dev avec des clés Stripe de test.
2. Ajouter un article au panier, aller jusqu'au formulaire de paiement.
3. Soumettre avec la carte de test Stripe `4242 4242 4242 4242` —
   confirmer que la commande passe en statut "confirmée".
4. Soumettre avec la carte de test de refus `4000 0000 0000 0002` —
   confirmer qu'un message d'erreur clair s'affiche et qu'aucune
   commande n'est créée en base.
5. Vérifier dans la table `payment_events` que l'état enregistré
   correspond à l'état affiché à l'écran.
6. Vérifier la console navigateur : zéro nouvelle erreur.
7. Capturer une vidéo du parcours complet.

Si une étape échoue, corriger et reprendre depuis l'étape 1.

## Gotchas

- Le staging renvoie 200 même quand le webhook Stripe n'a pas
  réellement été traité. Toujours vérifier `payment_events` pour
  l'état réel, jamais uniquement le code HTTP.
- La carte de refus `4000...0002` doit être testée à chaque fois :
  une régression passée a cassé uniquement le chemin d'échec.
```

Ce skill est commité dans `./.claude/skills/checkout-verifier` pour être partagé avec le second développeur.

**Étape 2 — Une boucle goal-based pour une tâche concrète.**

Deux semaines plus tard, l'équipe doit ajouter un nouveau moyen de paiement (virement instantané fictif "NovaPay"). Le développeur lance :

```
/goal intègre NovaPay comme second moyen de paiement dans le tunnel de
checkout, tous les scénarios du skill checkout-verifier doivent passer
pour Stripe ET pour NovaPay, stop after 8 tries.
```

**Déroulé simulé.** Claude implémente une première version (tentative 1) : le paiement Stripe fonctionne toujours, mais NovaPay échoue silencieusement sur le cas de refus (étape 4 du skill). Le modèle évaluateur refuse de laisser Claude s'arrêter. Tentative 3 : le problème est corrigé, mais une régression apparaît sur `payment_events` pour Stripe (gotcha directement identifié grâce à la section dédiée du skill). Tentative 5 : les deux moyens de paiement passent l'intégralité des scénarios du skill — l'objectif est atteint, la boucle s'arrête d'elle-même avant le plafond de 8 tentatives.

**Étape 3 — Capitaliser sur l'incident.**

Le nouveau gotcha découvert pendant la tentative 3 ("l'ajout d'un second provider de paiement peut faire régresser silencieusement le premier sur `payment_events`") est ajouté à la section Gotchas du skill, pour que toute intégration future d'un troisième moyen de paiement en bénéficie automatiquement.

**Résultat fictif.** Sur les trois mois suivants, NovaCart ne rapporte plus aucune régression silencieuse sur le tunnel de paiement — chaque modification touchant ces fichiers déclenche désormais systématiquement `checkout-verifier` avant d'être considérée comme terminée.

---

### Cas 2 — Lumina Analytics : migration d'un moteur de reporting

**Contexte fictif.** Lumina Analytics est une entreprise fictive de reporting B2B. Son moteur de génération de rapports, écrit il y a huit ans dans un framework Python vieillissant, doit être porté vers un service Node.js/TypeScript plus performant, module par module — au total 46 modules de génération de rapports (ventes, RH, finance, etc.), soit environ 60 000 lignes de code.

**Objectif.** Reproduire, à plus petite échelle, l'approche décrite dans l'étude de cas de la migration Zig → Rust (Partie 2.8) : une unité de travail, une revue adversariale, puis application.

**Étape 1 — Un skill de référence pour cadrer la migration.**

L'équipe crée `python-to-ts-report-migration`, catégorie *scaffolding et templates* :

```markdown
---
name: python-to-ts-report-migration
description: >
  Reference for porting a Lumina reporting module from the legacy
  Python engine to the new TypeScript service. Trigger whenever a
  task involves migrating a file under /legacy/reports/**.
---

# Migrer un module de reporting Python vers TypeScript

- Chaque module Python correspond à une classe `ReportGenerator`
  exposant `generate(params): ReportOutput`.
- Le format de sortie TypeScript doit respecter le schéma
  `references/report-output-schema.md`.
- Les tests existants du module Python (`tests/legacy/<module>_test.py`)
  définissent le comportement de référence — le port TypeScript doit
  produire des sorties identiques sur les mêmes fixtures.

## Gotchas

- Le module `finance/vat_report.py` utilise un arrondi bancaire
  spécifique (`ROUND_HALF_EVEN`), pas l'arrondi standard.
- Les dates du moteur legacy sont stockées en fuseau horaire du
  serveur, pas en UTC — à convertir explicitement lors du port.
```

**Étape 2 — Un workflow dynamique de type "unité de travail + revue adversariale".**

Plutôt que de migrer les 46 modules un par un manuellement, l'équipe déclenche :

```
ultracode : migre les modules de /legacy/reports/sales/ vers le
nouveau service TypeScript, un module à la fois. Pour chaque module :
implémente le port, fais-le challenger par un agent adversarial qui
compare la sortie sur les fixtures de test existantes, corrige les
écarts, puis passe au module suivant. Utilise le skill
python-to-ts-report-migration. Isole chaque module dans son propre
worktree git.
```

**Déroulé simulé.** Le workflow traite les 9 modules du dossier `sales/` : pour chacun, un agent réalise le port, un second agent (contexte neuf) compare la sortie sur les fixtures existantes et signale les écarts. Sur le module `sales/quarterly_forecast.py`, l'agent adversarial détecte que l'arrondi diffère de la référence — la correction est appliquée avant de passer au module suivant. Chaque module étant isolé dans son propre worktree, les 9 migrations progressent sans interférer entre elles.

**Étape 3 — Reprise après interruption.**

Le vendredi soir, le développeur ferme son terminal après 6 des 9 modules traités. Le lundi matin, il relance la session : conformément au mécanisme décrit en Partie 2.3, le workflow reprend exactement où il s'était arrêté, sans retraiter les modules déjà validés.

**Étape 4 — Généraliser aux autres dossiers.**

Une fois le pattern validé sur `sales/`, le workflow est sauvegardé (`s` dans `/workflows`) sous le nom `migrate-report-module`, puis réutilisé pour les dossiers `hr/`, `finance/` et `operations/` :

```
/migrate-report-module "legacy/reports/finance/"
```

**Résultat fictif.** Sur les 46 modules, 44 sont portés en douze jours ouvrés avec 100% des fixtures historiques qui passent ; les 2 modules restants, jugés trop complexes pour le pattern automatisé (dépendances externes non testables), sont traités manuellement par un développeur senior.

---

### Cas 3 — Kaerio : triage automatique des retours utilisateurs

**Contexte fictif.** Kaerio est une application mobile fictive de suivi d'habitudes, développée par une équipe de trois personnes. Les retours utilisateurs (bugs, suggestions, plaintes) arrivent en vrac sur un canal `#feedback-kaerio`, et personne n'a le temps de tous les lire chaque jour — certains bugs critiques restent parfois signalés pendant plusieurs jours sans action.

**Objectif.** Mettre en place une routine proactive complète qui trie, priorise, et pour les bugs simples, propose directement un correctif à valider.

**Étape 1 — Le skill de runbook.**

```markdown
---
name: kaerio-feedback-runbook
description: >
  Diagnose and categorize incoming Kaerio user feedback. Trigger
  whenever processing a message from #feedback-kaerio.
---

# Runbook de traitement des retours Kaerio

1. Classer le message en une catégorie : `bug-critique`,
   `bug-mineur`, `suggestion`, ou `plainte-sans-action`.
2. Pour un `bug-critique` : reproduire le scénario décrit dans
   l'environnement de test, si reproductible passer à la correction ;
   si non reproductible, demander une capture d'écran ou les logs
   à l'utilisateur.
3. Pour un `bug-mineur` : ajouter un ticket avec label `minor` et
   passer au suivant sans correction immédiate.
4. Pour une `suggestion` : archiver dans le fichier
   `suggestions-log.md` avec la date et le nombre de mentions
   similaires déjà enregistrées.

## Gotchas

- Le bug de synchronisation entre appareils est presque toujours dû
  au fuseau horaire de l'appareil, pas à un vrai bug de synchro —
  vérifier ce point avant de créer un ticket.
```

**Étape 2 — Un skill de vérification adapté au mobile.**

```markdown
---
name: verify-kaerio-fix
description: >
  Verify any bug fix in the Kaerio app before marking it resolved.
---

# Vérifier un correctif Kaerio

1. Lancer l'app sur le simulateur iOS et l'émulateur Android.
2. Reproduire le scénario exact décrit dans le rapport, avant et
   après le correctif.
3. Vérifier qu'aucune régression n'apparaît sur les trois écrans les
   plus utilisés (accueil, ajout d'habitude, statistiques).
4. Capturer une vidéo du scénario corrigé sur les deux plateformes.
```

**Étape 3 — La routine proactive complète.**

```
/schedule every hour: check #feedback-kaerio for new messages.
/goal: don't stop until every message found this run is categorized
using kaerio-feedback-runbook, and every bug-critique is either fixed
and verified with verify-kaerio-fix, or flagged with a request for
more information. When fixing a bug-critique, use a workflow to try
two independent fixes in parallel worktrees and have a judge pick the
one with fewer side effects. Use 15k tokens per bug-critique.
```

**Déroulé simulé sur une semaine.**

- **Lundi, 9h** : trois nouveaux messages détectés. Un est classé `bug-critique` (l'export CSV des statistiques plante), un `suggestion` (mode sombre), un `plainte-sans-action` (retard de notification ponctuel non reproductible).
- **Lundi, 9h04** : pour le bug critique, le workflow lance deux correctifs en parallèle dans deux worktrees distincts — l'un modifie la génération du CSV, l'autre modifie le composant d'export en amont. Un agent juge compare les deux : le second introduit un effet de bord sur l'export PDF existant, le premier est retenu.
- **Lundi, 9h11** : le correctif retenu est vérifié via `verify-kaerio-fix` sur les deux plateformes, puis marqué résolu.
- **Mercredi** : le gotcha sur le fuseau horaire (section Gotchas du runbook) permet à la routine d'écarter en quelques secondes un signalement de "bug de synchronisation" qui n'en était pas un, sans mobiliser l'équipe.
- **Vendredi** : revue hebdomadaire de `/usage` par l'équipe — la routine a traité 27 messages dans la semaine, dont 4 bugs critiques corrigés et vérifiés automatiquement, pour un coût jugé raisonnable au regard du temps auparavant passé à trier manuellement.

**Étape 4 — Ajustement dans la durée.**

Après un mois, l'équipe remarque que les messages arrivent surtout en début de matinée et quasiment jamais la nuit. Conformément au principe de la Partie 1.7 ("ne pas exécuter les routines plus souvent que nécessaire"), l'intervalle est ajusté :

```
/schedule every 2 hours, 8am-10pm: check #feedback-kaerio for new
messages.
```

**Résultat fictif.** Le délai moyen de prise en charge d'un bug critique passe de plus de deux jours (avant la routine) à moins de quinze minutes, sans intervention humaine dans la majorité des cas — l'équipe ne reste impliquée que pour les suggestions et les cas ambigus signalés comme tels par la routine.

---

## Annexes

### Glossaire

| Terme | Définition |
|---|---|
| **Boucle (loop)** | Un agent qui répète des cycles de travail jusqu'à ce qu'une condition d'arrêt soit remplie. |
| **Harnais (harness)** | L'échafaudage logiciel autour du modèle : décide comment une tâche est planifiée, découpée, vérifiée et exécutée. |
| **Workflow dynamique** | Un harnais écrit par Claude lui-même, à la volée, sous forme de programme (JavaScript), sur mesure pour la tâche en cours. |
| **Workflow statique** | Un harnais construit à l'avance par un humain (via le Claude Agent SDK ou `claude -p` en boucle), générique pour couvrir tous les cas. |
| **Skill** | Un dossier d'instructions, de scripts et de ressources qu'un agent peut découvrir et utiliser pour accomplir des tâches plus précisément et efficacement. |
| **Paresse agentique** | Mode de défaillance où Claude déclare une tâche complexe terminée après un progrès seulement partiel. |
| **Biais d'auto-préférence** | Tendance de Claude à privilégier ses propres résultats quand il évalue son propre travail. |
| **Dérive (drift)** | Perte progressive du fil de l'objectif initial au fil d'une session longue. |
| **Divulgation progressive** | Structurer un skill en plusieurs fichiers, lus par Claude uniquement au moment pertinent, plutôt que de tout charger d'un coup. |
| **Gotchas** | Section d'un skill listant les pièges et erreurs récurrentes rencontrées, considérée comme le contenu au plus fort signal d'un skill. |

### Commandes utiles

| Commande | Rôle |
|---|---|
| `/goal <critère>, stop after N tries` | Lance une boucle goal-based avec un critère de sortie et un plafond de tentatives |
| `/goal` (sans argument) | Affiche le nombre de tours et l'usage de tokens de l'objectif en cours |
| `/loop <intervalle> <prompt>` | Relance un prompt à intervalle régulier, sur la machine locale |
| `/schedule` | Déplace une boucle time-based dans le cloud sous forme de routine |
| `/workflows` | Affiche l'usage de tokens de chaque agent d'un workflow ; permet de sauvegarder (`s`) ou d'arrêter un agent |
| `/usage` | Détaille l'usage récent, réparti par skills, sous-agents et MCPs |
| `/code-review` | Skill intégré de revue de code par un second agent à contexte frais |
| `/effort ultracode` | Force un effort de raisonnement élevé et la planification automatique de workflows pour toute la session |
| Mot-clé `"ultracode"` dans un prompt | Force la création d'un workflow dynamique pour cette tâche précise |

### Sources

Ce document synthétise et complète le contenu des trois articles suivants, publiés sur le blog Claude d'Anthropic :

1. **"Getting started with loops"** — Claude by Anthropic, 30 juin 2026.
   `https://claude.com/blog/getting-started-with-loops`

2. **"A harness for every task: dynamic workflows in Claude Code"** — Claude by Anthropic, Thariq Shihipar & Sid Bidasaria, début juin 2026.
   `https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code`

3. **"Lessons from building Claude Code: How we use skills"** — Claude by Anthropic, Thariq Shihipar, 3 juin 2026.
   `https://claude.com/blog/lessons-from-building-claude-code-how-we-use-skills`

Pour aller plus loin, les articles renvoient vers la documentation officielle :
- Documentation des skills : `https://code.claude.com/docs/en/skills`
- Exemples de skills : `https://github.com/anthropics/skills`
- Documentation `/goal` : `https://code.claude.com/docs/en/goal`
- Documentation `/schedule` (routines) : `https://code.claude.com/docs/en/routines`
- Documentation des workflows dynamiques : `https://code.claude.com/docs/en/workflows#orchestrate-subagents-at-scale-with-dynamic-workflows`
- Agents en parallèle : `https://code.claude.com/docs/en/agents`

---

*Document compilé et enrichi à partir de trois articles du blog Claude by Anthropic (juin 2026). Les extraits d'exemples de code et de prompts sont repris directement des articles sources ; les tableaux de synthèse, le glossaire, la Partie 4 et la Partie 5 sont des compléments pédagogiques ajoutés pour faciliter l'appropriation du contenu.*
