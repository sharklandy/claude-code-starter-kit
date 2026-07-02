---
name: avoid-agentic-pitfalls
description: >
  Apply on virtually any non-trivial coding task, regardless of domain
  or stack. Enforces discipline against silent unverified assumptions,
  over-engineering, and out-of-scope edits. Trigger on any substantial
  code change, not just specific cases.
---
<!-- Skill générique de la "vague 2" — discipline comportementale transversale, indépendante de tout domaine technique -->

# Éviter les dérives classiques d'un agent de code

Ce skill s'applique de façon transversale, quel que soit le domaine ou
la stack. Il ne remplace aucun skill de vérification ou de domaine
existant — il encode une discipline de comportement à appliquer en plus.

## Règle 1 — Pas de suppositions silencieuses

Si une information nécessaire pour continuer correctement n'est pas
disponible avec confiance (convention ambiguë, comportement attendu non
spécifié, choix entre deux interprétations également plausibles), le
signaler explicitement plutôt que de choisir une interprétation et
continuer sans le mentionner. Une supposition raisonnable reste une
supposition : elle doit être visible, pas absorbée silencieusement dans
le résultat final.

## Règle 2 — Pas de sur-ingénierie

Résister à la tentation de transformer une modification simple en
abstraction généralisée, configuration extensible, ou gestion de cas non
demandés. La complexité ajoutée doit être justifiée par un besoin
exprimé, pas anticipée par prudence. Un correctif d'un cas précis ne
nécessite pas un système de gestion de cas généralisé ; une fonction
utilisée une fois ne nécessite pas une interface pluggable.

## Règle 3 — Pas de modifications hors-scope

Ne modifier que les fichiers et fonctions directement concernés par la
demande. Si une modification connexe semble utile en cours de route
(renommage, nettoyage, refactor adjacent, mise à jour de style sur du
code non touché par la demande), la **proposer séparément** plutôt que
de l'inclure silencieusement dans le changement demandé — même si elle
semble être une amélioration évidente.

## Règle 4 — Pas de déclaration de travail terminé sans vérification

Ne jamais déclarer une tâche terminée sur la seule base d'une édition
réussie. Appliquer la vérification décrite dans le skill
`verify-code-change` (build, tests existants, lint) déjà présent dans ce
repo avant d'affirmer qu'un changement fonctionne — ce skill ne duplique
pas cette logique, il rappelle seulement qu'elle doit s'appliquer
systématiquement, y compris sur les tâches qui semblent triviales.

## Gotchas

- Une tâche formulée de façon vague ("améliore cette fonction") pousse
  naturellement vers la Règle 2 par manque de cadrage — dans ce cas,
  reformuler la demande avec l'utilisateur (voir le skill
  `choose-your-loop` si un mécanisme de boucle est envisagé) plutôt que
  de combler le flou par une réécriture large non demandée.
- Un renommage de variable qui semble trivial et "sans risque" reste une
  modification hors-scope s'il n'a pas été demandé — même un changement
  perçu comme purement cosmétique doit être proposé séparément plutôt
  qu'inclus silencieusement dans un correctif fonctionnel.
- Une tâche qui touche plusieurs fichiers par nécessité réelle (ex. une
  interface partagée par plusieurs modules) n'est pas une violation de
  la Règle 3 — la règle porte sur les modifications non nécessaires à la
  demande, pas sur l'étendue réelle et justifiée du changement.
