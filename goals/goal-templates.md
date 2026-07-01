# Templates de prompts `/goal`

> Rappel de principe (voir `docs/guide-complet.md`, Partie 6, Tutoriel 2) : un **critère déterministe** (nombre de tests qui passent, score numérique, absence d'erreurs) est toujours préférable à un **critère flou** ("le code est propre", "les perfs sont meilleures"). Un critère flou empêche le modèle évaluateur de juger objectivement si l'objectif est atteint.
>
> | Mauvais critère | Bon critère |
> |---|---|
> | "Le code est propre" | "0 warning ESLint sur le dossier `src/`" |
> | "Les perfs sont meilleures" | "Le score Lighthouse Performance ≥ 90" |
> | "Les tests marchent" | "100% des tests de `tests/checkout/` passent" |
>
> Chaque prompt ci-dessous fixe systématiquement un **plafond de tentatives** (`stop after N tries`) pour éviter une boucle qui consomme des tokens sans converger.

---

## Prompts issus de cas d'usage métier (vague 1)

> Ces prompts illustrent le pattern à partir de scénarios concrets (checkout, migration, tests d'un module précis) — adaptez les placeholders `<TODO: ...>` à votre propre domaine avant usage.

## 1. Tests — faire passer une suite de tests au vert

**Contexte d'usage** : vous avez une suite de tests qui échoue partiellement après un refactor ou une nouvelle fonctionnalité.

```
/goal fais passer tous les tests du dossier <TODO: chemin des tests>
au vert, stop after 6 tries.
```

## 2. Performance — atteindre un score Lighthouse cible

**Contexte d'usage** : une page a une régression de performance ou n'a jamais été optimisée.

```
/goal get the <TODO: nom de la page> Lighthouse Performance score to
90 or above, stop after 5 tries.
```

## 3. Migration — porter un module avec parité de comportement

**Contexte d'usage** : vous migrez un module d'un langage/framework vers un autre et voulez garantir une parité fonctionnelle vérifiable.

```
/goal porte <TODO: chemin du module source> vers <TODO: stack cible>,
toutes les fixtures de tests existantes doivent produire une sortie
identique avant/après, stop after 8 tries.
```

## 4. Sécurité — zéro vulnérabilité détectée par le scanner

**Contexte d'usage** : après un audit de sécurité automatique ayant remonté des vulnérabilités à corriger.

```
/goal corrige toutes les vulnérabilités de sévérité "high" ou
"critical" remontées par <TODO: nom du scanner, ex. npm audit,
Snyk...> sur ce dépôt, stop after 6 tries.
```

## 5. Qualité de code — zéro erreur de lint

**Contexte d'usage** : une base de code accumule des erreurs de lint après plusieurs contributions rapides.

```
/goal fais en sorte que <TODO: commande de lint, ex. npm run lint>
retourne 0 erreur et 0 warning sur l'ensemble du dépôt, stop after 5
tries.
```

## 6. Couverture de tests — atteindre un seuil de couverture

**Contexte d'usage** : un module critique manque de couverture de tests et doit atteindre un seuil avant merge.

```
/goal fais passer la couverture de tests de <TODO: chemin du module>
à 85% ou plus selon <TODO: outil de couverture utilisé>, stop after 6
tries.
```

---

## Prompts génériques développeur (vague 2)

> Ces prompts s'appliquent tels quels à n'importe quel projet, sans connaissance préalable d'un domaine métier particulier — utilisables dès le premier coup d'œil.

## 7. Compilation/typecheck — zéro erreur sur tout le repo

**Contexte d'usage** : un projet typé (TypeScript, Rust, Go, Java...) accumule des erreurs de compilation ou de typecheck après plusieurs changements en parallèle.

```
/goal fais en sorte que la commande de build/typecheck du projet
(détectée automatiquement à partir de package.json, Makefile,
pyproject.toml ou équivalent) retourne 0 erreur sur l'ensemble du
dépôt, stop after 6 tries.
```

## 8. Non-régression — 100% des tests unitaires existants passent

**Contexte d'usage** : après toute modification non triviale, vous voulez garantir qu'aucun test préexistant n'a régressé, indépendamment du projet.

```
/goal après cette modification, fais en sorte que 100% des tests
unitaires déjà existants avant le changement passent toujours, stop
after 5 tries.
```

## 9. Sécurité des dépendances — zéro CVE haute/critique

**Contexte d'usage** : un audit de dépendances (quel que soit l'écosystème : npm, pip, cargo, maven...) doit être nettoyé avant une release.

```
/goal fais en sorte que l'audit de dépendances du projet (outil
détecté automatiquement selon l'écosystème) ne remonte plus aucune
vulnérabilité connue de sévérité "high" ou "critical", stop after 6
tries.
```

## 10. Linter — zéro nouveau warning introduit par une PR

**Contexte d'usage** : vous voulez garantir qu'une PR n'introduit aucun nouveau warning de linter, sans exiger de nettoyer toute la dette de lint préexistante du projet.

```
/goal fais en sorte que le linter du projet ne signale aucun nouveau
warning sur les fichiers modifiés par cette branche par rapport à sa
base, stop after 5 tries.
```

## 11. Couverture de tests — ne pas régresser après un changement

**Contexte d'usage** : un changement ne doit pas faire baisser la couverture de tests globale du projet, quel que soit le seuil actuel.

```
/goal fais en sorte que la couverture de tests globale du projet
mesurée après ce changement soit supérieure ou égale à la couverture
mesurée avant, stop after 6 tries.
```

---

## Suivi d'une boucle en cours

```
/goal
```

Sans argument, cette commande affiche le nombre de tours et l'usage de
tokens de l'objectif en cours (voir `docs/commandes-utiles.md`).

## Si le plafond est atteint sans succès

Regardez ce qui bloque : souvent, soit le critère était mal formulé,
soit la tâche nécessite un découpage préalable — auquel cas un workflow
dynamique (voir `workflows/workflow-prompts.md`) devient pertinent.
