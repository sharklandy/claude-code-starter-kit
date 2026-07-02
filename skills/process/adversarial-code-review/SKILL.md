---
name: adversarial-code-review
description: >
  Challenge a code diff with a fresh-context adversarial reviewer
  looking for bugs, obvious security flaws, regressions, and dead code.
  Trigger before merging any non-trivial diff, or whenever asked for a
  second opinion / adversarial review / "fresh eyes" on a change.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Revue adversariale de code (générique, tout diff)

Ce skill met en œuvre le pattern *revue adversariale* du guide théorique
(`docs/guide-complet.md`, Partie 2.5) : un agent avec un contexte neuf,
non influencé par le raisonnement qui a produit le diff, cherche
activement des failles plutôt que de simplement confirmer que le code
"a l'air bien".

1. Isoler le diff à revoir (branche, commit range, ou fichiers modifiés).
2. Faire réviser ce diff par un agent à **contexte frais** — c'est-à-dire
   qui n'a pas participé à l'implémentation et ne connaît que le diff, le
   contexte du fichier environnant, et les conventions du projet.
3. L'agent adversarial doit chercher spécifiquement :
   - des bugs de logique (cas limites non gérés, erreurs off-by-one,
     conditions inversées) ;
   - des failles de sécurité évidentes (injection, données utilisateur
     non validées, secrets en dur, contrôle d'accès manquant) ;
   - des régressions sur le comportement existant ;
   - du code mort ou dupliqué introduit par le changement.
4. Pour chaque découverte, l'agent adversarial doit citer précisément le
   fichier et la ligne concernés, et proposer un correctif.
5. L'implémenteur applique les corrections, puis soumet à nouveau le
   diff corrigé à une nouvelle passe de revue.
6. Itérer jusqu'à ce que les découvertes du second agent se réduisent à
   des remarques mineures (style, nommage) plutôt que des bugs ou des
   failles.

## Gotchas

- Ne jamais laisser le même agent qui a écrit le diff se relire
  lui-même dans la même fenêtre de contexte pour "faire la revue
  adversariale" — le biais d'auto-préférence (voir
  `docs/guide-complet.md`, Partie 2.2) rend cette auto-évaluation peu
  fiable par construction.
- Un diff volumineux (plusieurs centaines de lignes) fait souvent
  décrocher l'agent adversarial avant la fin : découper la revue par
  fichier ou par module plutôt que de tout soumettre d'un bloc.
- Les zones à risque connu (auth, paiement, migrations de données...)
  s'accumulent revue après revue dans la mémoire de projet du subagent
  `code-reviewer` (`.claude/agent-memory/code-reviewer/`) : la
  consulter au démarrage quand elle existe, plutôt que de redécouvrir
  les mêmes zones à chaque session.
