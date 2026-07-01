<!-- Skill générique de la "vague 2" -->
---
name: readme-generator
description: >
  Generate or incrementally update a project's README.md from an
  analysis of its structure, dependencies, scripts, tests and CI.
  Trigger whenever asked to write, generate, or update a README.
---

# Générer ou mettre à jour un README (générique)

1. **Détecter si un `README.md` existe déjà.**
   - S'il existe et contient déjà du contenu substantiel, proposer une
     **mise à jour incrémentale** (ajouter/corriger les sections
     obsolètes ou manquantes) plutôt qu'un remplacement complet par
     défaut. Ne remplacer entièrement que si l'utilisateur le demande
     explicitement ou si le fichier existant est un simple stub vide de
     scaffolding.
   - S'il n'existe pas, en générer un nouveau à partir des sections
     ci-dessous.
2. **Analyser le projet** avant de rédiger :
   - Nom et description : déduits du manifeste (`package.json`,
     `pyproject.toml`, `Cargo.toml`...) ou du nom du dépôt si absent.
   - Installation : commande d'installation des dépendances détectée
     (`npm install`, `pip install -r requirements.txt`, `cargo build`...).
   - Usage : scripts disponibles dans le manifeste (`scripts` de
     `package.json`, cibles de `Makefile`...), avec un exemple d'appel
     pour chacun des plus utilisés (démarrage, build, test).
   - Structure du projet : dossiers de premier niveau significatifs,
     avec une phrase par dossier plutôt qu'un simple arbre de fichiers
     brut.
   - Tests et CI : commande de test détectée, et présence d'une CI
     (`.github/workflows/`, `.gitlab-ci.yml`...) à mentionner si elle
     existe.
   - Contribution : renvoyer vers un `CONTRIBUTING.md` existant s'il y en
     a un, sinon proposer une section minimale.
   - Licence : détectée depuis un fichier `LICENSE` existant si présent.
3. **S'adapter à ce qui existe déjà plutôt que d'imposer un template
   rigide** : si le projet a des sections déjà présentes qui ne
   correspondent pas exactement à la liste ci-dessus (ex. une section
   "Architecture" ou "FAQ" spécifique au projet), les conserver plutôt
   que de les supprimer pour se conformer strictement au gabarit.
4. Ne jamais affirmer qu'une commande "fonctionne" ou qu'un test "passe"
   sans l'avoir réellement vérifié dans cette session — décrire ce que
   fait la commande d'après le manifeste, pas un résultat non observé.

## Gotchas

- Un projet avec plusieurs manifestes (monorepo avec un `package.json`
  par package) ne doit pas être résumé uniquement à partir du manifeste
  racine — vérifier s'il existe une structure de sous-projets à refléter
  dans la section "Structure du projet".
- Un `README.md` existant peut contenir des instructions d'installation
  déjà obsolètes par rapport au manifeste actuel (dépendance renommée,
  commande de script renommée) — comparer explicitement le contenu
  existant à l'état réel du manifeste avant de le considérer à jour.
- <TODO: si votre projet a des sections obligatoires spécifiques
  (badges de CI, lien vers une documentation externe, mention de
  licence commerciale...), documentez-les ici.>
