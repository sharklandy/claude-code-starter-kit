# Subagent ou skill ? Choisir le bon outil

Ce repo fournit deux types de briques : des **skills** (`skills/`) et des
**subagents** (`.claude/agents/`). Ils se ressemblent — un fichier
Markdown avec un frontmatter YAML — mais ne résolvent pas le même
problème, et le réflexe par défaut doit rester le skill.

## La différence en une phrase

Un **skill** injecte une méthode dans la conversation principale ; un
**subagent** exécute une tâche dans une **fenêtre de contexte séparée**,
avec son propre prompt système, ses propres restrictions d'outils, et ne
renvoie que sa synthèse.

## Quand un skill suffit (le cas par défaut)

Un skill est le bon choix quand la valeur est dans la *méthode* et que le
travail doit se faire **dans** la conversation :

- la tâche a besoin du contexte déjà accumulé (le code qu'on vient
  d'écrire, la discussion en cours) ;
- elle implique des allers-retours avec l'utilisateur (questions de
  cadrage, validation d'étapes) — les subagents n'ont pas accès à
  `AskUserQuestion` ;
- c'est une discipline transversale à appliquer en continu
  (`avoid-agentic-pitfalls`, `commit-message-quality`) plutôt qu'une
  tâche délimitée avec un livrable.

C'est pourquoi la grande majorité des briques de ce repo sont des skills
et le resteront.

## Quand un subagent se justifie

Un subagent se justifie quand au moins un de ces quatre bénéfices
concrets s'applique — pas par principe :

1. **Isolation du volume.** La tâche produit une sortie verbeuse dont la
   conversation principale n'a pas besoin (sortie complète d'une suite de
   tests, changelogs récupérés sur le web, logs de bissection). Seule la
   synthèse remonte ; le bruit reste dans le contexte du subagent.
2. **Contexte frais obligatoire.** La tâche exige un regard *non
   influencé* par le raisonnement qui a produit le code — le cas de la
   revue adversariale : un agent qui se relit lui-même dans la même
   fenêtre de contexte souffre d'un biais d'auto-préférence par
   construction (voir `docs/guide-complet.md`, Partie 2.2).
3. **Restriction d'outils garantie.** Le frontmatter `tools:` /
   `disallowedTools:` impose structurellement ce qu'un skill ne peut que
   demander poliment : un relecteur qui ne *peut pas* éditer le code, un
   exécuteur de tests qui ne *peut pas* "corriger" un test pour le faire
   passer.
4. **Mémoire persistante inter-sessions.** Le champ `memory:` donne au
   subagent un répertoire de connaissances qui survit d'une conversation
   à l'autre — là où un skill repart de zéro à chaque session.

Si aucun des quatre ne s'applique, écrivez un skill.

## Les deux se combinent

Le champ `skills:` du frontmatter d'un subagent précharge le contenu
complet d'un skill dans son contexte au démarrage. C'est ce que fait
`code-reviewer` : il embarque le skill de domaine `code-review` (et son
architecture à divulgation progressive `reference/`) comme grille de
lecture. Le skill reste la source de vérité de la *méthode* ; le
subagent apporte l'*isolation*.

Condition : le skill préchargé doit être disponible là où le subagent
tourne — c'est le cas via `install.sh` comme via l'installation plugin
(vérifié en session réelle : un agent du plugin résout le skill du même
plugin par son nom court). S'il est absent, Claude Code l'ignore avec un
warning — le subagent fonctionne, sans la grille préchargée.

## Les subagents fournis par ce repo

| Subagent | Rôle | Bénéfice subagent | Modèle | Mémoire |
|---|---|---|---|---|
| `code-reviewer` | Revue adversariale à contexte frais, labels 🔴🟠🟡⚪ | Contexte frais + lecture seule | hérité | `project` — zones à risque, problèmes récurrents |
| `test-runner` | Lance build/tests/lint, ne rapporte que les échecs | Isolation du volume + lecture seule | `haiku` (rapide, économique) | `project` — commandes CI confirmées, tests flaky |
| `dependency-scout` | Rapport d'impact avant un bump de dépendance | Isolation du volume (changelogs web) | `sonnet` | aucune (les findings périment avec les versions) |
| `bug-investigator` | Reproduction, bissection, diagnostic de cause racine | Isolation du volume + capitalisation | hérité | `project` — zones fragiles, patterns de bugs |

Trois d'entre eux utilisent `memory: project`
(`.claude/agent-memory/<nom>/`) : leurs connaissances sont propres au
projet et **versionnables dans git**, donc partagées avec l'équipe. C'est
la réponse dynamique aux placeholders `<TODO: zones à risque...>` des
skills : au lieu de les remplir à la main, le subagent les apprend.

## Comment les invoquer

- **Automatiquement** : Claude délègue de lui-même quand la tâche
  correspond à la `description` du subagent.
- **En langage naturel** : « fais relire ce diff par le subagent
  code-reviewer ».
- **Garantie d'exécution** : mentionnez le subagent avec `@` dans votre
  message (`@agent-code-reviewer`).

## Correspondance avec les skills existants

Ces subagents ne remplacent pas les skills du repo — ils en incarnent la
partie qui bénéficie de l'isolation :

- `adversarial-code-review` (skill) décrit le pattern ; `code-reviewer`
  (subagent) **est** l'agent à contexte frais que le skill prescrit.
- `verify-code-change` (skill) reste la discipline « ne jamais déclarer
  terminé sans vérifier » ; `test-runner` en est le bras armé isolé.
- `dependency-update-check` (skill) décrit le processus complet, mise à
  jour incluse ; `dependency-scout` n'en couvre que la recherche
  d'impact, en lecture seule.
- `systematic-debugging` (skill) couvre tout le cycle jusqu'au
  correctif ; `bug-investigator` s'arrête volontairement au diagnostic —
  la correction se décide dans la conversation principale.

## Gotchas

- Un subagent ajouté ou modifié directement sur le disque n'est chargé
  qu'au **démarrage de session** : redémarrez la session Claude Code
  pour le voir apparaître (ceux créés via `/agents` sont pris en compte
  immédiatement).
- Les subagents ne voient **pas** l'historique de votre conversation :
  la tâche qu'ils reçoivent doit être autoportante. Si un subagent rend
  des résultats à côté de la plaque, c'est souvent que la délégation
  manquait de contexte, pas que l'agent est mauvais.
- La sortie détaillée d'un subagent revient dans la conversation
  principale : demander à plusieurs subagents des rapports exhaustifs en
  parallèle recrée précisément la pollution de contexte qu'on cherchait
  à éviter. Exiger des synthèses compactes.
- `memory: project` versionne la mémoire de l'agent dans git — relisez
  `.claude/agent-memory/` avant de committer, comme n'importe quel autre
  fichier généré.
