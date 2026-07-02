---
name: pr-description-generator
description: >
  Generate a complete pull request description from a diff or commit
  range. Trigger whenever asked to open a PR, write a PR description, or
  summarize a branch's changes for review.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Générer une description de pull request (générique)

1. Identifier le diff complet de la branche par rapport à sa base
   (`git diff <base>...HEAD` ou équivalent), en incluant **tous** les
   commits de la branche, pas seulement le dernier.
2. Rédiger la description avec la structure suivante :
   - **Contexte** : pourquoi ce changement est nécessaire (1-3 phrases).
     Éviter de paraphraser le diff — expliquer la motivation.
   - **Changements** : liste à puces des changements significatifs,
     groupés par thème si la PR touche plusieurs zones.
   - **Comment tester** : étapes concrètes et reproductibles pour
     qu'un relecteur humain vérifie le changement lui-même (commandes à
     lancer, scénario UI à suivre, etc.) — pas juste "lancer les tests".
   - **Risques identifiés** : effets de bord possibles, zones non
     couvertes par des tests automatisés, ou changements de
     comportement pour les utilisateurs existants.
3. Si le dépôt a un template de PR (`.github/PULL_REQUEST_TEMPLATE.md`),
   respecter sa structure plutôt que d'imposer un format différent.
4. Ne jamais affirmer qu'un point a été "testé" ou "vérifié" dans la
   description sans que la vérification correspondante ait réellement
   été effectuée dans cette session (voir le skill `verify-code-change`).

## Gotchas

- Une branche avec plusieurs commits de "fix" successifs sur son propre
  travail (typiquement après des retours de CI) ne doit pas produire une
  liste de changements qui reflète cet historique de va-et-vient — se
  baser sur le diff net final, pas sur la liste brute des commits.
- Une section "Comment tester" qui se contente de renvoyer vers la CI
  n'aide pas un relecteur humain à comprendre ce qui a changé
  fonctionnellement — toujours inclure au moins un scénario manuel
  reproductible, même bref.
- Si le repo contient un template de PR
  (`.github/PULL_REQUEST_TEMPLATE.md` ou équivalent), le remplir
  section par section — le format imposé par le projet a toujours
  priorité sur la structure proposée par ce skill.
