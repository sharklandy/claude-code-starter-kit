<!-- Source : docs/guide-complet.md, Partie 3.2 (catégorie 1, "Référence de librairie et d'API") et Partie 3.3 (bonnes pratiques de rédaction) -->
---
name: library-reference-template
description: >
  Reference for using <TODO: nom de la librairie, CLI ou SDK, interne
  ou externe> correctly. Trigger whenever a task involves importing,
  configuring, or calling <TODO: nom du package ou de la commande>.
---

# Référence : <TODO: nom de la librairie/CLI/SDK>

Ce skill n'a pas vocation à répéter ce que Claude sait déjà faire par
défaut — il doit se concentrer sur ce qui **pousse Claude en dehors de
sa façon de penser habituelle** : conventions internes, pièges connus,
comportements non intuitifs de cette librairie précise.

## Utilisation de base

- <TODO: point d'entrée principal de la librairie/CLI/SDK>
- <TODO: convention de configuration ou d'authentification attendue>
- <TODO: sous-commandes ou fonctions les plus utilisées, avec un
  exemple d'appel pour chacune>

## Références détaillées

Pour la divulgation progressive, séparez les signatures et exemples
détaillés dans des fichiers dédiés que Claude consultera à la demande,
par exemple :

- `references/api.md` — signatures de fonctions et exemples d'usage
  complets.
- `references/config.md` — options de configuration disponibles.

<TODO: créez ces fichiers si la référence complète est trop longue pour
tenir dans ce SKILL.md.>

## Gotchas

- <TODO: décrivez ici un piège d'usage non évident de cette librairie,
  par exemple un champ qui porte un nom différent selon le service
  ("ce champ s'appelle `@request_id` ici et `trace_id` là-bas — c'est
  la même valeur"), ou une table/API qui se comporte différemment de
  ce que son nom suggère.>
- <TODO: ajoutez une ligne à chaque nouveau piège rencontré en usage
  réel plutôt que de corriger uniquement le cas isolé (voir
  docs/guide-complet.md, Partie 1.6 et Partie 3.3).>
