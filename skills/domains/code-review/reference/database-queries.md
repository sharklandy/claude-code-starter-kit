# Référence — Requêtes base de données

> Chargé par `SKILL.md` uniquement quand le diff touche une requête base de données, un ORM, une transaction, ou un schéma. Patterns génériques applicables à SQL/ORM en général, sans cibler un moteur ou un ORM précis.

## Requêtes N+1

- Un accès à une relation (ex. `order.customer`, `post.comments`) est-il
  effectué à l'intérieur d'une boucle sur une collection, sans
  chargement anticipé (eager loading / `JOIN`/`include`/`preload` selon
  l'ORM) ? Vérifier si l'ORM utilisé déclenche réellement une requête
  séparée par itération dans ce contexte précis avant de conclure.

## Transactions mal scopées

- Une transaction englobe-t-elle des opérations qui n'ont pas besoin
  d'atomicité entre elles (ex. un appel réseau externe lent à l'intérieur
  d'une transaction qui verrouille des lignes) ? Une transaction trop
  large peut retenir des verrous plus longtemps que nécessaire.
- À l'inverse, plusieurs écritures qui doivent être atomiques
  (cohérence métier) sont-elles bien regroupées dans une même
  transaction, ou risquent-elles un état incohérent si l'une échoue
  sans l'autre ?

## Absence d'index sur des colonnes de filtrage/jointure fréquentes

- Une nouvelle colonne utilisée dans une clause de filtrage (`WHERE`),
  de tri (`ORDER BY`) ou de jointure fréquente dispose-t-elle d'un index
  cohérent avec son usage réel ? Vérifier si un index existe déjà avant
  de recommander d'en ajouter un redondant.

## Requêtes non paramétrées

- Une requête construite par concaténation de chaînes inclut-elle une
  valeur qui provient d'une entrée utilisateur ou d'un paramètre
  variable, sans passer par un mécanisme de requête préparée/paramétrée
  de l'ORM ou du driver utilisé ? (Ce point recoupe `security.md` —
  privilégier ce dernier si le risque identifié est avant tout une
  injection plutôt qu'un problème de performance ou de lisibilité.)

## Gotchas (spécifiques à cette référence)

- Un ORM peut charger une relation "à la demande" (lazy loading) qui
  semble absente du code mais déclenche malgré tout une requête N+1 au
  moment de la sérialisation de la réponse — vérifier le comportement
  réel de sérialisation, pas seulement le code de la requête explicite.
