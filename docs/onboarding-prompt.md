# Prompt d'onboarding

> **Ce prompt ne concerne que l'installation par `install.sh`.** Si vous avez installé le kit en plugin (`/plugin install ...`), il n'y a rien à remplir : les skills hors `-template` ne contiennent aucun placeholder, et les fichiers d'un plugin vivent dans un cache non modifiable, hors des chemins (`./.claude/skills/`, `~/.claude/skills/`) où ce prompt cherche. Pour adapter un skill `-template` à votre domaine, installez-le via `install.sh` ou copiez son dossier dans le `.claude/skills/` de votre projet.

Ce prompt est destiné à être collé **tel quel, sans modification**, dans une session Claude Code, juste après avoir installé les skills de ce repo avec `install.sh` (voir `README.md`, section "Démarrer sur un projet"). Il fait le travail que vous feriez sinon manuellement dans chaque `SKILL.md` : remplacer les placeholders `<TODO: ...>` par les informations réelles de votre projet.

Le prompt distingue deux cas, détectés automatiquement par Claude :

- **Cas A — Projet existant** : le code, les dépendances et l'historique git sont analysés pour remplir les `<TODO:>` déductibles avec confiance.
- **Cas B — Projet vierge** : rien n'est deviné à partir de code qui n'existe pas ; Claude pose quelques questions de cadrage à la place, puis classe les skills installés en "actifs dès maintenant" et "en attente" du premier code réel.

Dans les deux cas, tout ce qui relève d'un choix métier ou d'une convention propre à votre équipe (nom de canal, processus d'approbation, zones jugées "à risque"...) reste explicitement signalé comme "à compléter manuellement" — ce prompt ne devine jamais ce type d'information.

---

## Le prompt à copier-coller

```
Tu vas m'aider à adapter les skills que je viens d'installer depuis le
claude-code-starter-kit à mon projet réel, en remplissant automatiquement
les placeholders <TODO: ...> présents dans chaque SKILL.md installé sous
./.claude/skills/ et/ou ~/.claude/skills/.

Étape 1 — Détecte le type de projet.
Regarde si ce dépôt est un "projet existant" ou un "projet vierge" :
- Projet existant si au moins un des signaux suivants est présent :
  des fichiers sources non triviaux en dehors du scaffolding par défaut
  du framework, un manifeste de dépendances (package.json, pyproject.toml,
  Cargo.toml, go.mod...) listant au moins une dépendance réelle, ou un
  historique git avec plusieurs commits qui décrivent un travail
  fonctionnel (pas uniquement "init" ou "initial commit").
- Projet vierge sinon (dépôt tout juste initialisé, scaffolding par
  défaut non modifié, aucune dépendance ajoutée, historique git vide ou
  quasi vide).

Annonce-moi clairement lequel des deux cas tu as détecté et pourquoi,
avant de continuer.

--- CAS A : PROJET EXISTANT ---

Si le projet est existant :

1. Analyse la structure du projet : langage(s) principal(aux), framework,
   organisation des dossiers (code, tests, docs).
2. Détecte les commandes réelles de build, de test et de lint en lisant
   les fichiers de configuration pertinents (package.json, Makefile,
   pyproject.toml, Cargo.toml, go.mod, fichiers de CI sous .github/workflows/
   ou équivalent) plutôt qu'en les devinant par convention.
3. Analyse `git log` (les 30-50 derniers commits) pour détecter la
   convention de message de commit déjà en usage (Conventional Commits ou
   autre pattern récurrent), et la nomme explicitement.
4. Si une CI existe déjà, note son nom d'outil et ce qu'elle vérifie
   (build, tests, lint, déploiement).
5. Pour chaque SKILL.md installé sous ./.claude/skills/ ou
   ~/.claude/skills/ contenant au moins un placeholder <TODO: ...> :
   - Remplis chaque <TODO:> que tu peux déduire avec confiance à partir
     des étapes 1-4 (commandes de build/test/lint, convention de commit,
     langage cible, structure de dossiers).
   - Si un <TODO:> demande une information qui relève d'un choix métier,
     d'une convention propre à l'équipe, ou de données que le code seul
     ne permet pas de déduire avec confiance (nom de canal de
     communication, processus d'approbation interne, zones jugées
     "à risque" par l'équipe, format de ticket...), NE DEVINE PAS —
     laisse le placeholder tel quel et liste-le explicitement dans le
     résumé final comme "à compléter manuellement".
6. Ne modifie jamais la section ## Gotchas existante d'un skill au-delà
   du remplissage de ses propres <TODO:> — n'invente pas de nouveaux
   gotchas non observés.

--- CAS B : PROJET VIERGE ---

Si le projet est vierge :

1. Ne tente pas de déduire quoi que ce soit à partir d'un code qui
   n'existe pas encore.
2. Pose-moi les questions suivantes (utilise des questions à choix
   structurées si ton harnais le permet), en une seule fois :
   a. Quel langage/stack principal est envisagé pour ce projet ?
   b. Quel type d'application est-ce (API backend, application web
      frontend, CLI, librairie, autre) ?
   c. Quelle convention de message de commit veux-tu utiliser ?
      (par défaut, si tu ne précises rien : Conventional Commits)
   d. Une CI est-elle prévue à court terme, et si oui laquelle (GitHub
      Actions, GitLab CI, autre) ?
   e. (Optionnel) Y a-t-il déjà un nom de branche ou une convention de
      nommage que tu veux imposer dès le départ ?
3. À partir de mes réponses, remplis les <TODO:> qui sont directement
   déductibles (langage/stack cible, convention de commit, présence ou
   non d'une CI) dans chaque SKILL.md installé.
4. Classe les skills installés en deux groupes, et présente-moi cette
   classification clairement :
   - "Actifs dès maintenant" : les skills utilisables sans code, tests
     ou historique existants — typiquement commit-message-quality,
     pr-description-generator, new-feature-scaffold,
     systematic-debugging, et tout autre skill installé dont le corps
     ne dépend pas de code/tests/dépendances déjà en place (règle
     générale : si le skill peut s'appliquer utilement au tout premier
     commit du projet, il est actif).
   - "En attente" : les skills qui ne peuvent pas être configurés
     utilement avant l'apparition de code, de tests ou d'un historique
     — typiquement verify-code-change, safe-refactor,
     dependency-update-check, changelog-from-commits, et tout autre
     skill installé dont au moins un <TODO:> ne peut être rempli sans
     dépendances, tests ou historique déjà présents.
5. Pour chaque skill classé "en attente", ajoute en toute première ligne
   de son SKILL.md le commentaire HTML suivant (avant le frontmatter
   existant, sans rien supprimer d'autre) :
   <!-- En attente : à revalider une fois le projet démarré — relancer
   docs/onboarding-prompt.md après les premiers commits/tests -->

--- RÉSUMÉ FINAL (dans les deux cas) ---

Termine par un résumé clair contenant :
- Le nombre total de placeholders <TODO:> résolus automatiquement.
- La liste précise des placeholders restants à ma charge (fichier +
  ligne + ce qu'il faut y renseigner).
- Si projet vierge : la liste des skills "actifs dès maintenant" et la
  liste des skills "en attente", avec un rappel qu'il suffit de relancer
  ce même prompt une fois du code, des tests ou un historique réels
  disponibles pour re-classer les skills "en attente".
```
