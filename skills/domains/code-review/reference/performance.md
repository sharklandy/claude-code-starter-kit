# Référence — Performance

> Chargé par `SKILL.md` uniquement quand le diff introduit ou modifie une boucle, une agrégation, un traitement par lot, ou un chemin exécuté fréquemment. Patterns formulés de façon stack-agnostique — à adapter au langage réel du diff.

## Complexité algorithmique évidente

- Une boucle imbriquée sur la même collection (ou deux collections liées)
  peut-elle être remplacée par un index/une map construite une seule
  fois ? Vérifier la taille réelle attendue de la collection avant de
  conclure qu'un O(n²) est un problème — une collection bornée à une
  petite taille par construction ne justifie pas une réécriture.
- Un tri ou une recherche répétée à l'intérieur d'une boucle peut-il être
  sorti de la boucle ou remplacé par une structure de données plus
  adaptée ?

## Requêtes N+1

- Une boucle qui déclenche un appel réseau, une requête base de données,
  ou un appel de service externe à chaque itération peut-elle être
  remplacée par un appel unique en lot (batch) ? (Voir aussi
  `database-queries.md` si l'appel concerné est une requête base de
  données.)

## Opérations bloquantes dans un chemin critique

- Une opération synchrone coûteuse (I/O disque, appel réseau bloquant,
  calcul lourd) est-elle exécutée sur un chemin qui doit rester réactif
  (requête utilisateur, boucle d'événements) ? Vérifier si le contexte
  d'exécution (job en arrière-plan vs requête synchrone) rend ce coût
  acceptable ou non.

## Absence de pagination sur des collections potentiellement grandes

- Une fonction qui charge une collection entière en mémoire ou la
  retourne intégralement dans une réponse a-t-elle une borne connue sur
  sa taille réelle en production ? Si la taille peut croître sans limite
  connue, signaler l'absence de pagination/limite comme un risque, sinon
  ne pas le flaguer par principe.

## Gotchas (spécifiques à cette référence)

- Un problème de performance qui ne se manifeste que sur un volume de
  données bien supérieur à celui observé en production actuelle mérite
  d'être signalé en sévérité "suggestion", pas "bloquant" — ne pas
  sur-prioriser une optimisation théorique sans données réelles à
  l'appui.
