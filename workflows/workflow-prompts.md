# Templates de prompts pour workflows dynamiques

> Rappel (voir `docs/guide-complet.md`, Partie 2) : les workflows dynamiques laissent Claude écrire, à la volée, un harnais sur mesure pour la tâche en cours. Deux façons de les déclencher : demander explicitement à Claude de "faire un workflow", ou utiliser le mot-clé **`ultracode`**. Le prompting détaillé — nommer explicitement le pattern visé — produit les meilleurs résultats. Il est recommandé de combiner le déclenchement d'un workflow avec **Auto mode** pour éviter les interruptions de permission sur un run à plusieurs agents.

> Chaque pattern ci-dessous propose deux variantes : une **variante métier (vague 1)**, illustrant le pattern sur un scénario concret à adapter, et une **variante générique développeur (vague 2)**, utilisable telle quelle sur n'importe quel projet.

## 1. Classify-and-act

**Définition** : un agent classifieur détermine le type de tâche, puis route vers différents agents ou comportements.

### Variante métier (vague 1)

```
ultracode : classe chaque ticket entrant de <TODO: source des tickets>
dans une catégorie (bug, amélioration UI, dette technique), puis route
chaque ticket vers un agent spécialisé par catégorie qui propose une
action. Utilise un pattern classify-and-act.
```

**Budget de tokens recommandé** : faible à modéré (5k–15k tokens) — le classifieur est une étape peu coûteuse, le coût dépend surtout du nombre d'agents spécialisés déclenchés en aval.

### Variante générique développeur (vague 2)

```
ultracode : classe chaque fichier modifié de ce diff par type de risque
(logique métier, config/infra, tests, documentation), puis route
chaque catégorie vers un agent spécialisé : revue de logique pour le
code métier, revue de sécurité pour la config/infra, vérification
d'exécution pour les tests. Utilise un pattern classify-and-act. Utilise
10k tokens maximum.
```

**Budget de tokens recommandé** : faible à modéré (5k–15k tokens), identique à la variante métier.

## 2. Découpage-synthèse

**Définition** : une tâche est découpée en plusieurs étapes plus petites, traitées séparément, puis synthétisées en une réponse unique.

### Variante métier (vague 1)

```
Fais un workflow pour cette tâche : découpe <TODO: description de la
tâche volumineuse, ex. l'audit de tous les endpoints de l'API> en
sous-tâches indépendantes, traite chaque sous-tâche séparément, puis
synthétise l'ensemble des résultats en un rapport unique. Utilise 20k
tokens maximum pour ce workflow.
```

**Budget de tokens recommandé** : modéré à élevé (15k–40k tokens), proportionnel au nombre de sous-tâches découpées.

### Variante générique développeur (vague 2)

```
Fais un workflow pour cette tâche : découpe la revue de ce repo en
sous-tâches indépendantes par dossier de premier niveau, traite chaque
dossier séparément (bugs potentiels, code mort, dépendances obsolètes),
puis synthétise l'ensemble des résultats en un rapport unique priorisé.
Utilise 20k tokens maximum pour ce workflow.
```

**Budget de tokens recommandé** : modéré à élevé (15k–40k tokens), proportionnel au nombre de dossiers analysés.

## 3. Recherche parallèle

**Définition** : plusieurs agents explorent différentes pistes ou sources en parallèle avant convergence.

### Variante métier (vague 1)

```
Fais un workflow de recherche parallèle : explore en parallèle
<TODO: liste des pistes/sources à explorer, ex. trois approches
d'implémentation différentes, ou trois sources de documentation>,
puis synthétise les résultats en une recommandation unique. Utilise
10k tokens maximum.
```

**Budget de tokens recommandé** : modéré (10k–20k tokens) — proportionnel au nombre de pistes explorées en parallèle.

### Variante générique développeur (vague 2)

```
Fais un workflow de recherche parallèle : explore en parallèle trois
causes racines possibles pour ce bug (état partagé, condition de
course, donnée d'entrée invalide non gérée), chaque piste dans son
propre agent avec ses propres logs/tests d'isolation, puis synthétise
les résultats en un diagnostic unique avec la cause la plus probable.
Utilise 10k tokens maximum.
```

**Budget de tokens recommandé** : modéré (10k–20k tokens) — proportionnel au nombre de pistes explorées en parallèle.

## 4. Revue adversariale

**Définition** : un agent produit un résultat, un second agent à contexte frais le challenge activement pour trouver des failles.

### Variante métier (vague 1)

```
ultracode : implémente <TODO: description du changement sensible, ex.
une nouvelle règle de permission sur la table X>, puis fais reviewer
le changement par un agent avec un contexte neuf qui cherche
spécifiquement des failles de sécurité/permission. Itère jusqu'à ce
que les découvertes du second agent se réduisent à des remarques
mineures. Utilise 15k tokens maximum pour ce workflow.
```

**Budget de tokens recommandé** : modéré (10k–20k tokens) pour une tâche ciblée ; à ajuster à la hausse pour une revue de sécurité multi-fichiers.

### Variante générique développeur (vague 2)

```
ultracode : fais reviewer le diff courant de cette branche par un agent
avec un contexte neuf, en utilisant le skill adversarial-code-review,
qui cherche des bugs, des failles de sécurité évidentes, des
régressions et du code mort. Itère jusqu'à ce que les découvertes se
réduisent à des remarques mineures. Utilise 15k tokens maximum pour ce
workflow.
```

**Budget de tokens recommandé** : modéré (10k–20k tokens) pour un diff de taille normale ; à ajuster à la hausse pour un diff volumineux.

## 5. Tournoi

**Définition** : plusieurs agents ou modèles tentent la même tâche en parallèle, un juge compare les candidats et sélectionne le(s) gagnant(s).

### Variante métier (vague 1)

```
Fais un workflow de type tournoi : génère <TODO: nombre, ex. trois>
solutions indépendantes pour <TODO: description de la tâche>, chacune
dans son propre worktree git. Un agent juge compare les candidats sur
<TODO: critères de jugement, ex. lisibilité, performance, couverture
de tests> et sélectionne le(s) gagnant(s). Utilise 25k tokens maximum.
```

**Budget de tokens recommandé** : élevé (20k–50k tokens) — proportionnel au nombre de candidats générés en parallèle.

### Variante générique développeur (vague 2)

```
Fais un workflow de type tournoi : génère trois implémentations
indépendantes de <TODO: nom de la fonction/l'algorithme à implémenter>,
chacune dans son propre worktree git. Un agent juge compare les
candidats sur la performance (benchmarks reproductibles) et la
lisibilité (clarté du code, absence de complexité inutile), et
sélectionne le gagnant. Utilise 25k tokens maximum.
```

**Budget de tokens recommandé** : élevé (20k–50k tokens) — proportionnel au nombre de candidats générés en parallèle.

## 6. Loop until done

**Définition** : faire, vérifier, corriger, revérifier — jusqu'à ce qu'une véritable condition d'arrêt vérifiable soit remplie (ne fait pas confiance au premier "c'est fait").

### Variante métier (vague 1)

```
Fais un workflow loop-until-done combiné à un objectif /goal :
<TODO: description de la tâche> ; vérifie le résultat avec le skill
<TODO: nom du skill de vérification pertinent>, corrige les écarts et
recommence jusqu'à ce que le critère suivant soit atteint :
<TODO: critère de sortie déterministe>, stop after <TODO: N> tries.
```

**Budget de tokens recommandé** : variable selon le nombre d'itérations attendu — toujours combiner avec un plafond de tentatives `/goal` explicite pour borner le coût.

### Variante générique développeur (vague 2)

```
Fais un workflow loop-until-done combiné à un objectif /goal : corrige
tous les échecs de la CI sur cette branche (build, tests, lint), en
relançant la CI après chaque correctif, jusqu'à obtenir un état vert
complet, stop after 8 tries.
```

**Budget de tokens recommandé** : variable selon le nombre d'échecs de CI à corriger — toujours combiner avec un plafond de tentatives `/goal` explicite pour borner le coût.

## Pour aller plus loin

- Un workflow qui a bien fonctionné peut être sauvegardé (`s` dans `/workflows`) et réutilisé via `/<nom-du-workflow>` — voir `docs/guide-complet.md`, Partie 2.7.
- Pour des workflows destinés à être répétés (triage, recherche, vérification), combinez avec `/loop` ou `/schedule` — voir `routines/routine-templates.md`.
