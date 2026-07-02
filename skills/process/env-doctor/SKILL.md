---
name: env-doctor
description: >
  Diagnose a broken local development environment: incompatible runtime
  versions, missing or conflicting dependencies, missing environment
  variables, or ports already in use. Trigger whenever a project fails
  to start, build, or install for reasons that look environmental
  rather than a code bug.
---
<!-- Skill générique de la "vague 2" -->

# Diagnostic d'environnement de développement (générique)

Ne jamais deviner la cause d'un environnement cassé — lire les fichiers
de configuration pertinents avant de proposer un diagnostic.

1. **Lire la configuration attendue avant de diagnostiquer** :
   - Version de runtime attendue : `.nvmrc`, `.node-version`, le champ
     `engines` de `package.json`, `.python-version`, la version
     spécifiée dans `pyproject.toml`, `go.mod`, `rust-toolchain.toml`,
     etc.
   - Dépendances attendues : lockfile présent (`package-lock.json`,
     `poetry.lock`, `Cargo.lock`...) comparé à ce qui est réellement
     installé localement.
   - Variables d'environnement attendues : comparer `.env.example` (ou
     équivalent documenté) au `.env` réel présent — lister les variables
     manquantes ou vides, sans jamais afficher la valeur d'une variable
     déjà présente si elle ressemble à un secret.
   - Ports attendus par les services du projet (fichier de config, code
     source, documentation) comparés aux ports réellement libres sur la
     machine.
2. **Comparer version attendue vs version réelle** du runtime installé
   localement, et signaler tout écart (pas seulement une absence totale).
3. **Diagnostiquer un conflit de dépendances** : si l'installation échoue
   avec un message de résolution de versions incompatibles, identifier
   les paquets en conflit à partir du message d'erreur réel plutôt que
   de relancer l'installation en boucle sans changer d'hypothèse.
4. **Vérifier les ports** : si le projet échoue à démarrer avec une
   erreur de port déjà utilisé, identifier quel processus occupe ce port
   avant de proposer de le libérer.
5. **Proposer une correction pour chaque problème identifié**, sans
   l'appliquer automatiquement si elle est destructive :
   - Installer une dépendance manquante : peut être appliqué directement.
   - Changer de version de runtime (ex. via un gestionnaire de versions) :
     proposer la commande, demander confirmation avant de modifier une
     configuration partagée par d'autres projets sur la machine.
   - **Ne jamais écraser un `.env` existant sans confirmation explicite**
     — même pour ajouter une variable manquante, proposer le contenu à
     ajouter plutôt que de réécrire le fichier directement.
   - Tuer un processus qui occupe un port : toujours confirmer avant de
     terminer un processus qui n'est pas clairement lié au projet en
     cours.

## Gotchas

- Un gestionnaire de versions (nvm, pyenv, rustup...) peut être installé
  mais non activé dans le shell courant — un échec de version qui
  semble être une désinstallation peut n'être qu'un problème
  d'activation de shell à vérifier avant de proposer une réinstallation.
- Un `.env` réel peut contenir des variables supplémentaires non
  présentes dans `.env.example` (ajoutées manuellement par un
  développeur) — ne pas les signaler comme des erreurs, seulement
  signaler les variables **manquantes** par rapport à l'exemple.
- <TODO: si votre projet a des dépendances système non gérées par le
  gestionnaire de paquets du langage (base de données locale, outil
  CLI externe...), documentez-les ici pour que le diagnostic les
  couvre aussi.>
