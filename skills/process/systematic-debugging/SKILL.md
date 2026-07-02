---
name: systematic-debugging
description: >
  Generic runbook to diagnose any bug or unexpected behavior. Trigger
  whenever asked to fix a bug, investigate an error, or explain why
  something isn't working — before proposing a fix.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Runbook de débogage systématique (générique)

1. **Reproduire de façon fiable.** Écrire ou identifier le scénario
   minimal qui déclenche le bug de façon déterministe (input, état,
   séquence d'actions). Ne pas passer à l'étape suivante tant que la
   reproduction n'est pas fiable — un bug qu'on ne peut pas reproduire
   à volonté ne peut pas être vérifié comme corrigé ensuite.
2. **Isoler la cause.**
   - Formuler une hypothèse précise avant chaque test, pas une
     exploration au hasard.
   - Utiliser la bissection quand c'est possible : `git bisect` pour
     trouver le commit introducteur, ou couper le scénario de
     reproduction en deux pour localiser la portion fautive.
   - Ajouter des logs ou des points d'arrêt ciblés sur l'hypothèse en
     cours, pas partout dans le code.
   - Éliminer les hypothèses une par une ; ne jamais conclure sur la
     cause sans l'avoir confirmée par une observation directe (log,
     valeur inspectée, test qui échoue puis passe).
3. **Corriger la cause racine**, pas le symptôme observé en premier —
   si le correctif le plus simple ne fait que masquer l'effet sans
   traiter la cause identifiée à l'étape 2, le signaler explicitement.
4. **Vérifier le correctif contre le scénario de reproduction original**
   de l'étape 1, puis contre la suite de tests existante (voir le skill
   `verify-code-change`) pour écarter toute régression.
5. **Capitaliser** : si le bug révèle un piège récurrent ou une zone du
   code particulièrement fragile, l'ajouter à la section Gotchas du
   skill le plus pertinent pour ce projet (voir
   `docs/guide-complet.md`, Partie 1.6).

## Gotchas

- Un bug qui "disparaît" après un redémarrage ou un simple retry n'est
  pas résolu — c'est souvent le signe d'un état partagé ou d'une
  condition de course ; documenter précisément dans quelles conditions
  il disparaît plutôt que de classer l'incident comme clos.
- La première hypothèse plausible n'est pas toujours la bonne : si le
  correctif proposé ne change rien à la reproduction de l'étape 1,
  revenir à l'étape 2 plutôt que d'empiler un second correctif par
  -dessus le premier.
- Les outils de debug propres au projet (profiler, dashboard de logs,
  réplica de prod en lecture seule...) déjà utilisés avec succès sont
  consignés par le subagent `bug-investigator` dans sa mémoire de
  projet (`.claude/agent-memory/bug-investigator/`) — la consulter
  avant d'improviser une instrumentation à la main.
