# Contribuer

Merci de vouloir contribuer à ce starter kit ! Ce document décrit comment proposer un nouveau skill, un nouveau prompt `/goal`/workflow/routine, et les conventions attendues.

## Proposer un nouveau skill

1. Choisissez la bonne catégorie et créez un dossier en respectant la convention de nommage :
   - **`skills/process/<nom>/`** pour un skill transverse, indépendant d'un domaine technique précis (vérification, discipline de l'agent, automatisation de processus...).
   - **`skills/domains/<nom>/`** pour un skill lié à un domaine technique (revue de code, stratégie de test, sécurité...).
   - **kebab-case** pour le nom du dossier.
   - Suffixe **`-template`** si le skill est générique et destiné à être adapté (contient des placeholders `<TODO: ...>`), pas de suffixe s'il est directement utilisable tel quel.
2. Le dossier doit contenir au minimum un fichier `SKILL.md` avec :
   - Un frontmatter `name` (kebab-case, identique au nom du dossier) et `description`.
   - La `description` doit dire **quand déclencher** le skill (mots-clés, types de fichiers concernés, contexte d'usage), pas résumer ce qu'il fait — voir `docs/guide-complet.md`, Partie 3.3.
   - Un corps de skill clair, sans énoncer l'évident (ce que Claude ferait déjà par défaut).
   - Une section `## Gotchas` **non vide** — même si elle contient des placeholders `<TODO: ...>` à compléter par l'utilisateur final, elle ne doit jamais être totalement absente.
3. Si le skill est généralisé à partir d'un cas d'usage réel ou fictif, retirez tout nom d'entreprise, de produit ou détail non réutilisable, et remplacez les valeurs spécifiques par des placeholders `<TODO: description de ce qu'il faut adapter>`.
4. Testez que le skill se déclenche correctement dans une session Claude Code réelle avant de soumettre votre PR.
5. Testez que `install.sh` installe correctement votre nouveau skill (mode `--local` sur un répertoire temporaire) avant de soumettre votre PR.
6. Lancez le validateur structurel en local : `bash scripts/validate-skills.sh`. C'est exactement ce que la CI exécute sur chaque PR — frontmatter YAML commençant à l'octet 0 (rien avant le `---` d'ouverture), `name` en kebab-case ≤ 64 caractères identique au dossier, `description` non vide ≤ 1024 caractères, section `## Gotchas` non vide, aucun `<TODO:` hors skills `-template`, chemins de `marketplace.json` résolus sur le disque, liens relatifs des README valides, et skills préchargés par les subagents existants. Une PR qui échoue en local échouera en CI.

## Évals de déclenchement (`evals/evals.json`)

Les skills du noyau embarquent un dossier `evals/` contenant un `evals.json` au format [skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator) : `{ "skill_name": "<nom>", "evals": [{ "id", "prompt", "expected_output", "assertions": [...] }] }`. Si vous en ajoutez un à votre skill (optionnel mais bienvenu pour un skill de portée générale) :

- `skill_name` doit être identique au nom du dossier du skill — la CI le vérifie, ainsi que la présence des champs requis ;
- écrivez 2-3 prompts réalistes (formulations variées, au moins un cas limite) et des assertions **observables** (« la synthèse utilise les labels 🔴/🟠/🟡/⚪ »), pas des jugements vagues (« la sortie est bonne ») ;
- l'exécution des évals reste manuelle (coût API) via le plugin `skill-creator` du marketplace officiel Anthropic — la CI ne valide que la structure du fichier.

## Plugin et marketplace : ce qu'il faut savoir en contribuant

Le dépôt est aussi un marketplace de plugins Claude Code (`.claude-plugin/marketplace.json`) exposant deux plugins :

- **`starter-kit-full`** référence les répertoires `./skills/process` et `./skills/domains` entiers : un nouveau skill placé au bon endroit y est inclus **automatiquement**, rien à déclarer.
- **`starter-kit-essentials`** liste ses 6 skills **individuellement** : si votre contribution a vocation à rejoindre le noyau, il faut l'ajouter explicitement à la liste `skills:` de cette entrée (décision mainteneur).
- La CI compare chaque chemin déclaré dans `marketplace.json` au disque : renommer ou déplacer un dossier de skill sans mettre à jour le manifeste fait échouer la PR.

## Releases (mainteneurs)

Le champ `version` des deux entrées de `marketplace.json` **doit être bumpé à chaque release**, sinon les utilisateurs du plugin ne reçoivent jamais la mise à jour (la version épingle le contenu). La CI refuse un CHANGELOG dont la dernière release datée ne correspond pas à la version du marketplace. Utilisez `scripts/release.sh <version>` qui enchaîne : datage du CHANGELOG, bump des deux entrées, validation, tag et Release GitHub — et refuse de continuer si les versions divergent.

## Skills de domaine volumineux : le pattern `reference/`

Si un skill de domaine devient trop volumineux pour rester dans un seul `SKILL.md` lisible (plusieurs centaines de lignes couvrant des sous-thèmes distincts), appliquez la **divulgation progressive** plutôt que d'alourdir le noyau :

- Gardez un `SKILL.md` **court** (~150-250 lignes) qui définit le processus général et sait *quand* consulter chaque référence — c'est ce fichier qui est toujours chargé.
- Placez le détail par sous-thème dans un sous-dossier `reference/` (ex. `reference/security.md`, `reference/performance.md`), que Claude ne lira qu'au moment pertinent.
- Le noyau doit **renvoyer explicitement** vers chaque fichier de référence en précisant la condition de déclenchement ("si le diff touche X, consulte `reference/Y.md`") — il ne doit **jamais résumer** le contenu de la référence, sous peine de la rendre redondante.
- Voir `skills/domains/code-review/` comme exemple de référence pour ce pattern.

## Proposer un prompt `/goal`, un workflow ou une routine

- **`/goal`** : ajoutez votre prompt à `goals/goal-templates.md`, avec le contexte d'usage en une phrase, le prompt complet (plafond de tentatives explicite obligatoire), et un critère de sortie déterministe plutôt que flou.
- **Workflow** : ajoutez votre prompt à `workflows/workflow-prompts.md`, en identifiant clairement le(s) pattern(s) de composition utilisé(s) (voir `docs/guide-complet.md`, Partie 2.5) et une note de budget de tokens recommandé.
- **Routine** : ajoutez votre combinaison à `routines/routine-templates.md`, en listant les skills prérequis et en généralisant tout détail spécifique à un cas d'usage particulier.

## Capitaliser sur les erreurs récurrentes

Principe directeur de ce repo (voir `docs/guide-complet.md`, Partie 1.6) : quand un skill ou un prompt échoue sur un cas particulier, la bonne réaction n'est **pas** de corriger uniquement ce cas isolé dans votre propre usage, mais de proposer une mise à jour de la section Gotchas correspondante (ou du prompt lui-même) via une PR, pour que toutes les itérations futures — et tous les autres utilisateurs du repo — en bénéficient.

## Checklist avant de soumettre une PR

- [ ] Le skill/prompt a été testé dans une session Claude Code réelle.
- [ ] La section `## Gotchas` est présente et non vide (pour un skill).
- [ ] Aucun nom d'entreprise ou de produit fictif/spécifique ne subsiste hors de `docs/guide-complet.md`.
- [ ] Le `README.md` est mis à jour si la structure du repo change.
