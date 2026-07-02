---
name: verify-code-change
description: >
  Verify any non-trivial code change before declaring it done: build,
  existing test suite, and linter must all pass. Trigger after any edit
  that touches source files, regardless of language or stack.
---
<!-- Skill générique de la "vague 2" (par opposition aux skills orientés cas d'usage de la vague 1) -->

# Vérifier une modification de code (générique, tout langage)

Ne jamais déclarer une modification de code terminée sur la seule base
d'une édition réussie ou d'une lecture du code. Vérifier systématiquement
avant de rendre la main :

1. **Détecter les commandes pertinentes avant de deviner.** Lire les
   fichiers de configuration du projet pour identifier les commandes
   réelles plutôt que de supposer une convention :
   - `package.json` (`scripts.build`, `scripts.test`, `scripts.lint`)
   - `Makefile` (cibles `build`, `test`, `lint`)
   - `pyproject.toml` / `setup.cfg` (section `[tool.pytest]`,
     `[tool.ruff]`, etc.)
   - `Cargo.toml`, `go.mod`, `pom.xml`/`build.gradle`, ou tout autre
     fichier de build spécifique au langage détecté.
   Si plusieurs candidats existent, préférer celui utilisé par la CI du
   projet (`.github/workflows/`, `.gitlab-ci.yml`, etc.) s'il est
   présent, pour rester cohérent avec ce qui est réellement vérifié en
   intégration continue.
2. **Build/compile** : lancer la commande de build ou de typecheck
   détectée. Zéro erreur attendue.
3. **Suite de tests existante** : lancer la commande de test détectée.
   100% des tests déjà présents doivent rester au vert — un nouveau test
   qui échoue est acceptable temporairement pendant le développement,
   mais un test préexistant qui régresse ne l'est jamais.
4. **Linter** : lancer la commande de lint détectée. Zéro nouveau
   warning introduit par le changement (les warnings préexistants et non
   liés au changement peuvent être signalés séparément, pas bloqués).
5. Si une étape échoue, corriger et reprendre depuis l'étape 2 — ne
   jamais rendre la main sur un travail partiellement vérifié.

## Gotchas

- Un `package.json` peut définir plusieurs scripts qui se ressemblent
  (`test`, `test:unit`, `test:ci`) — vérifier lequel est réellement
  utilisé par la CI avant de vous fier au premier trouvé, sous peine de
  valider localement un état que la CI rejettera.
- L'absence d'erreur de build ne garantit rien sur un langage à typage
  dynamique (Python, JavaScript) : ne jamais sauter l'étape des tests
  sous prétexte que le build/l'import a réussi.
- Les commandes réelles de build/test/lint d'un projet (y compris les
  configurations multiples d'un monorepo) sont apprises et consignées
  par le subagent `test-runner` dans sa mémoire de projet
  (`.claude/agent-memory/test-runner/`) ; à défaut, les lire dans la
  configuration de CI du projet plutôt que de les deviner par
  convention.
