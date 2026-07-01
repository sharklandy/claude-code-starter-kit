# Templates de prompts pour workflows dynamiques

> Rappel (voir `docs/guide-complet.md`, Partie 2) : les workflows dynamiques laissent Claude écrire, à la volée, un harnais sur mesure pour la tâche en cours. Deux façons de les déclencher : demander explicitement à Claude de "faire un workflow", ou utiliser le mot-clé **`ultracode`**. Le prompting détaillé — nommer explicitement le pattern visé — produit les meilleurs résultats. Il est recommandé de combiner le déclenchement d'un workflow avec **Auto mode** pour éviter les interruptions de permission sur un run à plusieurs agents.

## 1. Classify-and-act

**Définition** : un agent classifieur détermine le type de tâche, puis route vers différents agents ou comportements.

```
ultracode : classe chaque ticket entrant de <TODO: source des tickets>
dans une catégorie (bug, amélioration UI, dette technique), puis route
chaque ticket vers un agent spécialisé par catégorie qui propose une
action. Utilise un pattern classify-and-act.
```

**Budget de tokens recommandé** : faible à modéré (5k–15k tokens) — le classifieur est une étape peu coûteuse, le coût dépend surtout du nombre d'agents spécialisés déclenchés en aval.

## 2. Découpage-synthèse

**Définition** : une tâche est découpée en plusieurs étapes plus petites, traitées séparément, puis synthétisées en une réponse unique.

```
Fais un workflow pour cette tâche : découpe <TODO: description de la
tâche volumineuse, ex. l'audit de tous les endpoints de l'API> en
sous-tâches indépendantes, traite chaque sous-tâche séparément, puis
synthétise l'ensemble des résultats en un rapport unique. Utilise 20k
tokens maximum pour ce workflow.
```

**Budget de tokens recommandé** : modéré à élevé (15k–40k tokens), proportionnel au nombre de sous-tâches découpées.

## 3. Recherche parallèle

**Définition** : plusieurs agents explorent différentes pistes ou sources en parallèle avant convergence.

```
Fais un workflow de recherche parallèle : explore en parallèle
<TODO: liste des pistes/sources à explorer, ex. trois approches
d'implémentation différentes, ou trois sources de documentation>,
puis synthétise les résultats en une recommandation unique. Utilise
10k tokens maximum.
```

**Budget de tokens recommandé** : modéré (10k–20k tokens) — proportionnel au nombre de pistes explorées en parallèle.

## 4. Revue adversariale

**Définition** : un agent produit un résultat, un second agent à contexte frais le challenge activement pour trouver des failles.

```
ultracode : implémente <TODO: description du changement sensible, ex.
une nouvelle règle de permission sur la table X>, puis fais reviewer
le changement par un agent avec un contexte neuf qui cherche
spécifiquement des failles de sécurité/permission. Itère jusqu'à ce
que les découvertes du second agent se réduisent à des remarques
mineures. Utilise 15k tokens maximum pour ce workflow.
```

**Budget de tokens recommandé** : modéré (10k–20k tokens) pour une tâche ciblée ; à ajuster à la hausse pour une revue de sécurité multi-fichiers.

## 5. Tournoi

**Définition** : plusieurs agents ou modèles tentent la même tâche en parallèle, un juge compare les candidats et sélectionne le(s) gagnant(s).

```
Fais un workflow de type tournoi : génère <TODO: nombre, ex. trois>
solutions indépendantes pour <TODO: description de la tâche>, chacune
dans son propre worktree git. Un agent juge compare les candidats sur
<TODO: critères de jugement, ex. lisibilité, performance, couverture
de tests> et sélectionne le(s) gagnant(s). Utilise 25k tokens maximum.
```

**Budget de tokens recommandé** : élevé (20k–50k tokens) — proportionnel au nombre de candidats générés en parallèle.

## 6. Loop until done

**Définition** : faire, vérifier, corriger, revérifier — jusqu'à ce qu'une véritable condition d'arrêt vérifiable soit remplie (ne fait pas confiance au premier "c'est fait").

```
Fais un workflow loop-until-done combiné à un objectif /goal :
<TODO: description de la tâche> ; vérifie le résultat avec le skill
<TODO: nom du skill de vérification pertinent>, corrige les écarts et
recommence jusqu'à ce que le critère suivant soit atteint :
<TODO: critère de sortie déterministe>, stop after <TODO: N> tries.
```

**Budget de tokens recommandé** : variable selon le nombre d'itérations attendu — toujours combiner avec un plafond de tentatives `/goal` explicite pour borner le coût.

## Pour aller plus loin

- Un workflow qui a bien fonctionné peut être sauvegardé (`s` dans `/workflows`) et réutilisé via `/<nom-du-workflow>` — voir `docs/guide-complet.md`, Partie 2.7.
- Pour des workflows destinés à être répétés (triage, recherche, vérification), combinez avec `/loop` ou `/schedule` — voir `routines/routine-templates.md`.
