# Référence — Sécurité

> Chargé par `SKILL.md` uniquement quand le diff touche une entrée utilisateur, une authentification/autorisation, ou des données sensibles. Chaque point ci-dessous est une **question de raisonnement contextuel**, pas un pattern à chercher aveuglément — voir le principe directeur du noyau.

## Secrets et données sensibles

- Une valeur en dur ressemble-t-elle à un secret (clé API, mot de passe,
  token) — et si oui, provient-elle réellement d'un fichier de
  configuration versionné, ou est-ce une valeur de test/exemple
  explicitement documentée comme telle ? Ne pas flaguer une valeur
  factice clairement nommée `test_key`/`example_token` comme un secret
  réel sans vérifier le contexte d'usage.
- Une donnée utilisateur sensible (mot de passe, donnée personnelle) est-
  elle loggée, mise en cache, ou transmise en clair à un endroit où elle
  ne devrait pas l'être ?

## Injection

- Une valeur utilisée dans une requête (SQL, shell, requête HTTP
  sortante) provient-elle d'une entrée utilisateur qui n'a pas été
  validée, échappée, ou paramétrée avant d'atteindre ce point du code ?
  (Ne pas conclure à une injection uniquement parce qu'une variable est
  interpolée dans une chaîne — vérifier d'où vient réellement cette
  variable.)
- Le mécanisme de paramétrage utilisé (requêtes préparées, échappement
  de bibliothèque) est-il réellement appliqué sur ce chemin précis, ou
  seulement sur un chemin voisin qui donne une fausse impression de
  sécurité globale ?

## XSS / CSRF

- Une donnée utilisateur est-elle insérée dans une page rendue sans
  échappement, dans un contexte où le framework utilisé ne l'échappe
  pas automatiquement par défaut ?
- Une action qui modifie un état (formulaire, appel API mutateur)
  dispose-t-elle d'une protection CSRF cohérente avec le reste de
  l'application, ou ce point précis fait-il exception ?

## Authentification et autorisation

- Ce endpoint ou cette fonction vérifie-t-il l'identité de l'appelant
  avant d'agir, ou suppose-t-il implicitement qu'un contrôle a déjà eu
  lieu en amont (à vérifier explicitement, pas à supposer) ?
- Un contrôle d'autorisation vérifie-t-il que l'utilisateur a le droit
  d'agir sur **cette ressource précise** (pas seulement qu'il est
  authentifié en général) ?

## Note sur les faux positifs

Un pattern qui ressemble à une faille de sécurité dans une configuration
serveur, un script d'infrastructure, ou un fichier de test n'est pas
nécessairement exploitable — le risque réel dépend de qui peut
influencer cette valeur et à quel moment. Toujours vérifier la
provenance réelle de la donnée avant de conclure, plutôt que de flaguer
sur la seule ressemblance syntaxique avec un pattern dangereux connu.

## Gotchas (spécifiques à cette référence)

- Une bibliothèque de validation peut être importée dans un fichier sans
  être réellement appliquée sur le chemin examiné — vérifier l'usage
  effectif, pas seulement la présence de l'import.
