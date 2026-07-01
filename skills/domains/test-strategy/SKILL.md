<!-- Skill de domaine (vague 2) -->
---
name: test-strategy
description: >
  Decide what to test and at what level, and detect fragile existing
  tests. Trigger when asked what to test, how to structure a test suite,
  whether a test belongs at the unit/integration level, or when
  reviewing existing tests for reliability — not for generating test
  code directly.
---

# Stratégie de test (générique, stack-agnostique)

Ce skill aide à décider **quoi** tester et à **quel niveau**, avant
d'écrire le code de test lui-même. Pour la vérification qu'un changement
ne régresse pas (build/tests/lint), voir `verify-code-change`. Pour le
garde-fou avant un refactor qui dépend d'une couverture suffisante, voir
`safe-refactor` — ce skill ne duplique pas cette logique, il aide à
décider *quels* tests écrire en amont.

## 1. Choisir le bon niveau (pyramide de tests)

- **Unitaire** : logique pure, sans dépendance externe (calcul, règle
  métier isolée, transformation de données). Rapide, à privilégier pour
  couvrir les cas limites en nombre.
- **Intégration** : interaction réelle entre plusieurs composants
  (accès base de données, appel à un service interne, plusieurs modules
  qui collaborent). À utiliser quand le risque réel se situe dans
  l'interaction elle-même, pas dans la logique de chaque composant pris
  isolément.
- **De bout en bout** : parcours utilisateur complet à travers le
  système réel. Coûteux à maintenir et à exécuter — réservé aux
  parcours critiques (voir les skills de vérification `verify-code-change`,
  `verify-frontend-change`, `verify-form-change` pour ce niveau).

Ne pas dupliquer la même assertion à plusieurs niveaux : si un cas
limite est déjà couvert de façon fiable en unitaire, ne pas le
re-tester identiquement en intégration.

## 2. Prioriser cas limites vs cas nominal

- Le cas nominal (chemin "heureux") mérite un test, mais n'est presque
  jamais la source de bugs en production.
- Prioriser les cas limites réels du domaine : entrée vide, valeur
  maximale/minimale, absence de réseau, réponse d'erreur d'une
  dépendance externe, concurrence (deux opérations simultanées sur la
  même ressource).
- Une couverture de lignes élevée qui ne teste que des variations du cas
  nominal donne une fausse impression de sécurité — voir le Gotcha
  correspondant, et le principe déjà énoncé dans le skill `safe-refactor`
  (une couverture élevée en pourcentage ne garantit pas une couverture
  des cas limites réels).

## 3. Détecter les tests fragiles

Un test existant doit être signalé comme fragile s'il présente au moins
un des symptômes suivants :

- **Couplé à l'implémentation plutôt qu'au comportement observable** :
  le test échoue si on renomme une variable interne ou réorganise le
  code sans changer le résultat produit — signe qu'il teste "comment"
  plutôt que "quoi".
- **Dépendant de l'ordre d'exécution** : le test suppose qu'un autre
  test s'est exécuté avant lui (état partagé, fixture non réinitialisée),
  et échoue s'il est lancé isolément.
- **Assertions trop larges** : le test vérifie seulement l'absence
  d'erreur ou un type de retour générique, sans vérifier la valeur
  réelle attendue — il passerait même si le comportement changeait de
  façon incorrecte.

## Gotchas

- Une couverture de lignes à 100% sur un module ne signifie pas que ses
  cas limites réels sont couverts — un test peut exécuter une ligne sans
  vérifier la valeur qu'elle produit dans un cas limite. Toujours
  vérifier la présence d'assertions significatives, pas seulement
  l'exécution du code.
- Un test qui mocke une dépendance de façon à masquer un changement de
  contrat réel (ex. un mock qui ne reflète plus la réponse actuelle du
  service réel) donne une fausse confiance — signaler tout mock qui n'a
  pas été mis à jour en même temps que le comportement réel qu'il
  simule.
- Un grand nombre de tests qui échouent en même temps après un petit
  changement est souvent le signe de tests trop couplés entre eux
  (fixture partagée, ordre d'exécution) plutôt que d'une vraie
  régression généralisée — vérifier ce cas avant de conclure à une
  régression massive.
