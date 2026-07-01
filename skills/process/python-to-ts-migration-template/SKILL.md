---
name: python-to-ts-migration-template
description: >
  Reference for porting a legacy Python module to a new TypeScript
  service. Trigger whenever a task involves migrating a file under
  <TODO: chemin du dossier legacy, ex. /legacy/reports/**>.
---
<!-- Source : docs/guide-complet.md, Partie 7, Cas 2 (python-to-ts-report-migration) — généralisé, sans référence à l'entreprise fictive d'origine -->

# Migrer un module Python vers TypeScript

- Chaque module Python correspond à une classe/fonction
  <TODO: nom du contrat d'interface, ex. ReportGenerator> exposant
  <TODO: signature attendue, ex. generate(params): Output>.
- Le format de sortie TypeScript doit respecter le schéma décrit dans
  `references/output-schema.md` (à créer/adapter pour votre projet).
- Les tests existants du module Python
  (<TODO: chemin des tests legacy, ex. tests/legacy/<module>_test.py>)
  définissent le comportement de référence — le port TypeScript doit
  produire des sorties identiques sur les mêmes fixtures.

## Méthode recommandée pour un lot de modules

1. Traiter un module à la fois.
2. Implémenter le port.
3. Faire challenger le port par un agent adversarial (contexte neuf)
   qui compare la sortie du port aux fixtures de test existantes.
4. Corriger les écarts détectés avant de passer au module suivant.
5. Isoler chaque module dans son propre worktree git pour permettre le
   traitement de plusieurs modules en parallèle sans interférence, et
   permettre une reprise propre en cas d'interruption.

## Gotchas

- <TODO: décrivez ici les comportements numériques ou de formatage non
  standards du moteur legacy (arrondi spécifique, encodage, etc.)>
- <TODO: décrivez ici les pièges de fuseau horaire ou de format de date
  du moteur legacy — un cas fréquent est un stockage en heure serveur
  plutôt qu'en UTC, à convertir explicitement lors du port.>
