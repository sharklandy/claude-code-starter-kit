---
name: choose-your-loop
description: >
  Help choose and validate the right Claude Code mechanism (turn-based
  prompt, /goal, dynamic workflow, or /loop /schedule routine) BEFORE
  writing the final prompt. Trigger whenever the user expresses intent
  to set up a /goal, a workflow, a routine, or more generally "automate
  this", "make Claude do this on its own", "run this in a loop" — always
  before a final prompt is drafted, not after.
---
<!-- Skill générique de la "vague 2" — intervient en amont des templates goals/, workflows/, routines/ -->

# Choisir et valider son mécanisme de boucle (avant de rédiger le prompt)

Ce skill s'exécute **en amont** de `goals/goal-templates.md`,
`workflows/workflow-prompts.md` et `routines/routine-templates.md`. Il ne
remplace pas ces fichiers : il aide à déterminer lequel piocher, et si le
critère de succès de l'utilisateur est réellement exploitable, avant
qu'un prompt final ne soit écrit.

## 1. Identifier le mécanisme visé (ou son absence)

- Si l'utilisateur a déjà nommé un mécanisme précis (`/goal`, "workflow",
  "routine", `/loop`, `/schedule`), le confirmer explicitement à voix
  haute ("tu veux dire : ...") avant de poursuivre.
- Si l'utilisateur arrive sans idée précise ("je veux automatiser un
  truc", "j'aimerais que Claude fasse ça tout seul"), basculer en **mode
  découverte** : l'aider à identifier une tâche candidate avant de
  choisir un mécanisme. Reprendre l'esprit de la méthode de démarrage de
  `docs/guide-complet.md` (Partie 1.8) :
  - Quelle tâche répétitive vous fait perdre du temps aujourd'hui ?
  - Pouvez-vous écrire son critère de vérification ?
  - Cette tâche arrive-t-elle selon un planning régulier ?
  Une fois une tâche candidate identifiée, reprendre à l'étape 2 avec
  le mécanisme qui semble a priori le plus proche (voir l'arbre de
  décision à l'étape 4) — sans encore l'annoncer comme définitif.

## 2. Rappeler le concept en 2-3 phrases maximum

Avant de poser la moindre question, rappeler brièvement ce que fait (et
ne fait pas) le mécanisme identifié, en reprenant fidèlement les
définitions déjà présentes dans `docs/glossaire.md` et
`docs/commandes-utiles.md` — ne jamais reformuler une définition
différente de celle du guide. Exemples de rappels attendus :

- **`/goal`** : étend une boucle turn-based avec un critère de sortie
  explicite et un plafond de tentatives ; un modèle évaluateur vérifie
  la condition à chaque tentative. Ne gère pas, seul, l'orchestration de
  plusieurs agents en parallèle.
- **Workflow dynamique** : Claude écrit un harnais sur mesure (script)
  pour découper/orchestrer la tâche en cours, potentiellement avec
  plusieurs agents et worktrees. Consomme plus de tokens que le mode par
  défaut — réservé aux tâches complexes à forte valeur ajoutée.
- **`/loop`** : relance un prompt à intervalle régulier, **sur la
  machine locale** (s'arrête si l'ordinateur s'éteint).
- **`/schedule`** (routine) : déplace une boucle time-based dans le
  cloud, tourne indépendamment de la machine de l'utilisateur.

## 3. Poser des questions de cadrage structurées

Utiliser des questions à choix structurées si l'outillage du harnais le
permet (ex. `AskUserQuestion`), sinon poser les questions suivantes en
une seule fois sous forme de liste claire. Adapter la liste selon le
mécanisme déjà identifié à l'étape 1 (ne pas reposer une question déjà
répondue explicitement par l'utilisateur) :

1. Le critère de réussite de cette tâche peut-il être vérifié
   objectivement (test qui passe, score, absence d'erreur), ou est-il
   actuellement plutôt qualitatif ?
2. Cette tâche est-elle ponctuelle (une seule fois) ou récurrente (elle
   se représente régulièrement) ?
3. Y a-t-il un déclencheur temporel ou événementiel identifiable
   (intervalle, arrivée d'un événement externe), ou l'utilisateur
   veut-il juste lancer quelque chose maintenant ?
4. Le travail peut-il se découper en plusieurs sous-tâches indépendantes
   qui bénéficieraient d'agents séparés, ou est-ce une tâche unique et
   linéaire ?
5. *(Si le mécanisme envisagé est une routine)* Cette routine doit-elle
   continuer de tourner même si l'utilisateur ferme son ordinateur, ou
   seulement pendant qu'il travaille dessus activement ?

## 4. Appliquer un arbre de décision explicite

Ne jamais trancher "au feeling" — appliquer les règles suivantes dans
l'ordre, en citant explicitement quelle réponse a mené à quelle
conclusion. Ces règles formalisent le tableau récapitulatif de
`docs/guide-complet.md` Partie 1.8 et la distinction `/goal` vs workflow
de la Partie 2 :

- **Règle 1 (déclencheur)** : si la réponse à Q3 est "aucun déclencheur,
  juste maintenant" → écarter d'emblée `/loop`/`/schedule`. Passer à la
  Règle 2.
- **Règle 2 (récurrence)** : si la réponse à Q2 est "récurrente" **et**
  la réponse à Q3 identifie un intervalle ou un événement externe réel
  → mécanisme de base = **boucle time-based / proactive**
  (`/loop` si l'exécution doit rester liée à la machine locale d'après
  Q5, `/schedule` si elle doit continuer hors ligne). Sinon, passer à la
  Règle 3.
- **Règle 3 (critère vérifiable)** : si la réponse à Q1 indique un
  critère déjà objectivement vérifiable ou reformulable comme tel (voir
  étape 5) → mécanisme de base = **`/goal`**. Si le critère reste
  irréductiblement qualitatif après la reformulation de l'étape 5 →
  mécanisme de base = **boucle turn-based simple** (un bon prompt +
  un skill de vérification, pas de `/goal`).
- **Règle 4 (découpabilité)** : quel que soit le mécanisme de base
  retenu par les règles 1-3, si la réponse à Q4 indique que la tâche se
  découpe en sous-tâches indépendantes (plusieurs modules, plusieurs
  candidats à comparer, plusieurs étapes séquentielles distinctes) →
  ajouter un **workflow dynamique** par-dessus le mécanisme de base
  (ex. `/goal` + workflow, `/schedule` + workflow). Si la tâche est
  unique et linéaire → ne pas ajouter de workflow, le mécanisme de base
  suffit.
- **Règle 5 (garde-fou anti-complaisance)** : si le mécanisme réclamé
  initialement par l'utilisateur à l'étape 1 diverge du résultat des
  règles 1-4, ne jamais valider le choix initial par complaisance —
  rendre un verdict ❌ (étape 6) en citant précisément la règle qui
  contredit ce choix.

## 5. Détecter et reformuler un critère flou automatiquement

Si le critère de succès donné par l'utilisateur est qualitatif ("le code
est propre", "ça doit bien marcher", "les tests passent" sans précision),
ne pas se contenter de signaler que c'est flou : proposer activement une
reformulation mesurable, dans l'esprit du tableau de
`docs/guide-complet.md` (Tutoriel 2), adaptée au contexte réel décrit par
l'utilisateur — par exemple :

| Critère donné | Reformulation proposée (à adapter au contexte réel) |
|---|---|
| "Le code est propre" | "0 warning du linter détecté sur les fichiers modifiés" |
| "Les tests passent" | "100% des tests de `<dossier concerné, à préciser avec l'utilisateur>` passent" |
| "Ça doit bien marcher" | "Le scénario `<à préciser>` se déroule sans erreur console et produit `<résultat observable attendu>`" |

Si l'utilisateur répond "oui c'est mesurable" sans donner de chemin, de
seuil ou de commande précise, creuser une nouvelle fois avant de
considérer le critère comme validé (voir Gotchas).

## 6. Rendre un verdict structuré en trois issues possibles

- **✅ Bon choix, réalisable tel quel** — le mécanisme initial (ou
  identifié en mode découverte) correspond au résultat de l'arbre de
  décision, et le critère de succès est déjà mesurable. Passer
  directement à l'étape 7.
- **⚠️ Mécanisme correct mais critère ou déclencheur à ajuster** — le
  mécanisme est validé par l'arbre de décision, mais le critère (étape 5)
  ou le déclencheur (intervalle, plafond de tentatives) doit être
  précisé. Présenter la correction proposée, et ne passer à l'étape 7
  qu'une fois la correction acceptée explicitement par l'utilisateur.
- **❌ Mauvais mécanisme pour cette tâche** — le mécanisme réclamé
  diverge du résultat de l'arbre de décision (Règle 5). Recommander
  l'alternative correcte, expliquer en une phrase pourquoi en citant la
  règle concernée (ex. "Règle 2 : ta tâche n'a pas de déclencheur
  temporel identifiable, une routine `/schedule` n'est donc pas
  adaptée ici"), puis reprendre le questionnement de l'étape 3 sur ce
  nouveau mécanisme si l'utilisateur est d'accord.

## 7. Proposer un prompt final à partir des templates existants

Une fois un verdict ✅ obtenu (directement ou après ajustement) :

1. Vérifier d'abord si `goals/goal-templates.md`,
   `workflows/workflow-prompts.md` ou `routines/routine-templates.md`
   contient déjà un template proche de la tâche décrite, et proposer de
   l'adapter (en remplaçant ses placeholders) plutôt que d'en écrire un
   nouveau intégralement.
2. Si aucun template existant ne correspond, rédiger un nouveau prompt
   en respectant le format déjà utilisé dans ces fichiers : contexte
   d'usage en une phrase, prompt complet, plafond de tentatives
   (`/goal`) ou budget de tokens explicite (workflow/routine).
3. Rappeler à l'utilisateur qu'un nouveau prompt qui fonctionne bien
   mérite d'être ajouté au fichier de templates correspondant (voir
   `CONTRIBUTING.md`) plutôt que de rester à usage unique.

## Gotchas

- Un utilisateur qui répond "oui c'est mesurable" alors que son critère
  reste en réalité qualitatif une fois creusé (ex. "les tests passent"
  sans préciser lesquels, sur quel dossier) doit être requestionné plus
  précisément avant de valider la Règle 3 de l'étape 4 — ne jamais
  passer à l'étape 6 sur un critère encore ambigu.
- Un utilisateur qui veut absolument un mécanisme précis par habitude ou
  par name-dropping ("je veux faire un workflow") alors que sa tâche est
  en réalité une simple boucle turn-based doit recevoir un verdict ❌
  clair (Règle 5), sans que le skill se contente de suivre l'intention
  initiale par complaisance.
- En l'absence de seuils propres à l'équipe, utiliser comme valeurs par
  défaut les plafonds des templates de `goals/goal-templates.md` (5 à 8
  tentatives) et les budgets de tokens indiqués dans
  `workflows/workflow-prompts.md` — et toujours annoncer le seuil
  retenu explicitement dans le verdict plutôt que de le laisser
  implicite.
