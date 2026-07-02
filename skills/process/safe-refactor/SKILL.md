---
name: safe-refactor
description: >
  Guardrail before any non-trivial refactor: confirm sufficient test
  coverage exists first. Trigger whenever asked to refactor, restructure,
  clean up, or rewrite existing code without changing its behavior.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Garde-fou avant un refactor (générique)

1. Identifier précisément le périmètre du refactor (fichiers, fonctions,
   modules concernés) avant toute modification.
2. Vérifier qu'une couverture de tests **suffisante** existe déjà sur ce
   périmètre :
   - Lancer la suite de tests existante et confirmer qu'elle passe
     avant toute modification (état de référence).
   - Identifier si les chemins de comportement significatifs du
     périmètre (cas nominal, cas limites principaux, cas d'erreur) sont
     couverts par au moins un test — pas seulement si un fichier de
     test existe.
3. **Si la couverture est insuffisante** : ne pas refactorer à l'aveugle.
   Proposer d'abord d'ajouter des **tests de caractérisation** — des
   tests qui décrivent le comportement actuel du code tel qu'il est
   réellement (pas tel qu'il devrait être), pour disposer d'un filet de
   sécurité avant de changer la structure interne.
4. Effectuer le refactor par petites étapes vérifiables, en relançant la
   suite de tests (existante + tests de caractérisation ajoutés) après
   chaque étape plutôt qu'une seule fois à la toute fin.
5. Confirmer en fin de refactor qu'aucun comportement observable n'a
   changé, sauf si un changement de comportement était explicitement
   demandé et documenté séparément du refactor lui-même.

## Gotchas

- Un refactor "pur" qui change accidentellement un comportement
  observable (ordre d'itération, message d'erreur exact, format de
  sortie) casse parfois des consommateurs externes qui dépendaient de
  ce détail non documenté — traiter tout changement observable comme un
  signal d'alerte, pas comme un détail d'implémentation sans
  conséquence.
- Une couverture de tests élevée en pourcentage de lignes ne garantit
  pas une couverture des cas limites réels — ne pas se fier uniquement
  au pourcentage rapporté par l'outil de couverture pour juger qu'un
  refactor est sûr.
- Les zones trop risquées pour un refactor sans supervision humaine se
  repèrent par deux signaux : la mémoire de projet des subagents
  `code-reviewer` et `bug-investigator` (`.claude/agent-memory/`) quand
  elle existe, et une forte densité de commits `fix` récents sur les
  mêmes fichiers dans `git log`. En présence de l'un des deux, demander
  avant de refactorer.
