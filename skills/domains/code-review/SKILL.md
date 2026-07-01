---
name: code-review
description: >
  Perform a structured code review of a diff, pull request, or any
  non-trivial change before it is merged or committed. Trigger on any
  request to review code, review a diff/PR, or before any non-trivial
  commit.
---
<!-- Skill de domaine (vague 2, divulgation progressive) — noyau court, voir reference/ pour le détail -->

# Revue de code structurée (noyau)

Ce skill est le noyau court d'un skill à divulgation progressive : il
définit le processus et sait *quand* consulter chaque fichier de
`reference/`, mais ne duplique jamais leur contenu détaillé ici.

## Principe directeur : raisonner sur le contexte avant de flaguer

Ne jamais signaler un problème en matchant un pattern à l'aveugle. Avant
de flaguer quoi que ce soit, vérifier le contexte réel : une valeur qui
ressemble à une entrée dangereuse peut être une constante de
configuration serveur jamais exposée à un utilisateur ; une boucle qui
semble en O(n²) peut opérer sur une collection dont la taille est bornée
par construction. **Une checklist de patterns sans ce raisonnement
contextuel produit du bruit** — c'est précisément ce qui distingue une
revue utile d'une liste de faux positifs.

## Processus en 4 phases

### 1. Contexte
Avant de lire une seule ligne de diff : quel est le scope annoncé du
changement (description de PR, message de commit, ticket lié si
disponible) ? Quelle est l'intention — corriger un bug, ajouter une
fonctionnalité, refactorer ? Un changement qui dépasse silencieusement
son scope annoncé est en soi un signal à remonter.

### 2. Revue haut niveau
Avant de descendre ligne par ligne : le changement a-t-il un impact sur
l'architecture existante ? Introduit-il un risque de performance
identifiable à ce niveau (voir `reference/performance.md` si le diff
touche une boucle, une agrégation, ou un chemin critique) ? La stratégie
de test proposée (tests ajoutés ou modifiés) couvre-t-elle le
comportement réellement changé, ou seulement le chemin nominal ?

### 3. Analyse ligne par ligne
Pour chaque fichier modifié, évaluer : logique (cas limites gérés ?),
sécurité, maintenabilité (nommage, duplication, complexité), cas
limites non couverts par les tests.

- **Si le diff touche une donnée entrante, une authentification, une
  autorisation, ou toute manipulation de données sensibles** → consulter
  `reference/security.md` avant de conclure sur ce point, et appliquer
  son raisonnement contextuel plutôt que de deviner.
- **Si le diff introduit ou modifie une boucle, une agrégation en
  mémoire, un traitement par lot, ou un chemin exécuté fréquemment** →
  consulter `reference/performance.md` avant de conclure.
- **Si le diff touche une requête base de données, un ORM, une
  transaction, ou un schéma** → consulter `reference/database-queries.md`
  avant de conclure.

### 4. Synthèse
Regrouper les findings avec un label de sévérité systématique :

- **🔴 Bloquant** — bug de logique avéré, faille de sécurité réelle,
  perte de données possible. Ne doit pas être mergé tel quel.
- **🟠 Important** — risque significatif mais pas immédiatement
  destructeur (perf dégradée sur un chemin fréquent, cas limite non
  couvert sur une fonctionnalité critique).
- **🟡 Mineur** — problème réel mais à faible impact (duplication
  locale, nommage peu clair).
- **⚪ Suggestion** — amélioration optionnelle, pas un défaut.

Chaque finding doit citer le fichier et la ligne concernés, et préciser
le raisonnement contextuel qui justifie le label (pas juste "ceci est un
risque de sécurité" sans expliquer pourquoi le contexte le confirme).

## Gotchas

- Un finding qui ne peut pas être justifié par un raisonnement
  contextuel explicite (uniquement "ce pattern ressemble à X") doit être
  reformulé en question ouverte à vérifier, pas affirmé comme un bug
  certain — voir le principe directeur ci-dessus.
- Une revue qui ne consulte aucun fichier de `reference/` alors que le
  diff touche clairement une requête base de données ou une entrée
  utilisateur est incomplète — vérifier systématiquement les conditions
  de renvoi de la phase 3 avant de conclure à une synthèse.
- <TODO: si votre projet a des zones jugées critiques par l'équipe
  (auth, paiement, migrations...), listez-les ici pour qu'elles reçoivent
  systématiquement une revue de sévérité renforcée.>
