# Contribuer

Merci de vouloir contribuer à ce starter kit ! Ce document décrit comment proposer un nouveau skill, un nouveau prompt `/goal`/workflow/routine, et les conventions attendues.

## Proposer un nouveau skill

1. Créez un dossier sous `skills/` en respectant la convention de nommage :
   - **kebab-case** pour le nom du dossier.
   - Suffixe **`-template`** si le skill est générique et destiné à être adapté (contient des placeholders `<TODO: ...>`), pas de suffixe s'il est directement utilisable tel quel.
2. Le dossier doit contenir au minimum un fichier `SKILL.md` avec :
   - Un frontmatter `name` (kebab-case, identique au nom du dossier) et `description`.
   - La `description` doit dire **quand déclencher** le skill (mots-clés, types de fichiers concernés, contexte d'usage), pas résumer ce qu'il fait — voir `docs/guide-complet.md`, Partie 3.3.
   - Un corps de skill clair, sans énoncer l'évident (ce que Claude ferait déjà par défaut).
   - Une section `## Gotchas` **non vide** — même si elle contient des placeholders `<TODO: ...>` à compléter par l'utilisateur final, elle ne doit jamais être totalement absente.
3. Si le skill est généralisé à partir d'un cas d'usage réel ou fictif, retirez tout nom d'entreprise, de produit ou détail non réutilisable, et remplacez les valeurs spécifiques par des placeholders `<TODO: description de ce qu'il faut adapter>`.
4. Testez que le skill se déclenche correctement dans une session Claude Code réelle avant de soumettre votre PR.

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
