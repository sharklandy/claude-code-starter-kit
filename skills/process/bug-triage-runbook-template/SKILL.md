---
name: bug-triage-runbook-template
description: >
  Diagnose and categorize incoming user feedback or bug reports.
  Trigger whenever processing a message from
  <TODO: nom du canal ou de la source des retours, ex. #feedback>.
---
<!-- Source : docs/guide-complet.md, Partie 7, Cas 3 (kaerio-feedback-runbook + verify-kaerio-fix) — généralisé, sans référence à l'application fictive d'origine -->

# Runbook de traitement des retours utilisateurs

1. Classer le message en une catégorie : `bug-critique`, `bug-mineur`,
   `suggestion`, ou `plainte-sans-action`.
2. Pour un `bug-critique` : reproduire le scénario décrit dans
   l'environnement de test, si reproductible passer à la correction ;
   si non reproductible, demander une capture d'écran ou les logs à
   l'utilisateur.
3. Pour un `bug-mineur` : ajouter un ticket avec label `minor` et
   passer au suivant sans correction immédiate.
4. Pour une `suggestion` : archiver dans le fichier
   `suggestions-log.md` avec la date et le nombre de mentions
   similaires déjà enregistrées.

## Vérification du correctif

Avant de marquer un `bug-critique` comme résolu :

1. Lancer l'application sur les environnements cibles
   (<TODO: ex. simulateur iOS, émulateur Android, navigateurs cibles...>).
2. Reproduire le scénario exact décrit dans le rapport, avant et après
   le correctif.
3. Vérifier qu'aucune régression n'apparaît sur les écrans/parcours les
   plus utilisés (<TODO: listez-les>).
4. Capturer une vidéo du scénario corrigé sur chaque plateforme cible.

## Gotchas

- <TODO: décrivez ici un symptôme récurrent qui est presque toujours dû
  à une cause bénigne plutôt qu'à un vrai bug — par exemple un décalage
  de fuseau horaire confondu avec un bug de synchronisation — pour que
  la routine l'écarte automatiquement sans mobiliser l'équipe.>
- <TODO: ajoutez toute autre confusion fréquente entre catégories de
  retours (bug vs suggestion, mineur vs critique) rencontrée en usage
  réel.>
