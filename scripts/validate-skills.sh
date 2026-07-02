#!/usr/bin/env bash
set -euo pipefail

# Validateur structurel des skills et subagents du starter kit.
# Utilisé par la CI (.github/workflows/validate.yml) et exécutable en
# local : bash scripts/validate-skills.sh [racine-du-repo]
#
# Vérifie, pour chaque SKILL.md et chaque subagent :
#   1. le frontmatter YAML commence à l'octet 0 du fichier — la classe
#      de bug corrigée en 2a7e1c8 (un commentaire HTML avant le `---`
#      d'ouverture casse silencieusement le déclenchement du skill) ;
#   2. `name` présent, en kebab-case, identique au nom du dossier (skill)
#      ou du fichier (subagent) ;
#   3. `description` présente et non vide ;
#   4. section `## Gotchas` présente et non vide (skills uniquement) ;
#   5. aucun placeholder `<TODO:` dans un skill sans suffixe `-template`
#      (la promesse "utilisable tel quel" de la vague 2).

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
ERRORS=0

fail() {
  echo "  ✗ $1"
  ERRORS=$((ERRORS + 1))
}

# --- Helpers -----------------------------------------------------------

frontmatter_at_byte0() {
  # Le frontmatter doit commencer au tout premier octet du fichier : la
  # première ligne doit être exactement `---` (un BOM, une ligne vide,
  # un \r final ou un commentaire la feraient différer).
  [[ "$(head -n 1 "$1")" == "---" ]]
}

fm_block() {
  # Extrait le bloc frontmatter (entre les deux premières lignes `---`).
  awk 'NR==1 && $0!="---" {exit} /^---[[:space:]]*$/ {c++; next} c==1 {print} c>=2 {exit}' "$1"
}

fm_field_value() {
  # Valeur d'un champ du frontmatter, y compris style plié (`key: >`) :
  # concatène les lignes indentées qui suivent la clé.
  fm_block "$1" | awk -v key="$2" '
    found && /^[a-zA-Z_-]+:/ {exit}
    found && /^[[:space:]]+[^[:space:]]/ {sub(/^[[:space:]]+/,""); printf "%s ", $0; next}
    $0 ~ "^"key":" {found=1; sub("^"key":[[:space:]]*",""); sub(/^>[-+]?[[:space:]]*$/,""); if (length($0)) printf "%s ", $0}
  ' | sed 's/[[:space:]]*$//'
}

gotchas_nonempty() {
  # Au moins une ligne non vide entre "## Gotchas" et la section suivante.
  awk '
    /^## Gotchas/ {in_g=1; next}
    in_g && /^## / {exit}
    in_g && NF {found=1; exit}
    END {exit !found}
  ' "$1"
}

is_kebab() { [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; }

# --- Skills ------------------------------------------------------------

echo "Validation des skills (${ROOT}/skills) :"
SKILL_COUNT=0
while IFS= read -r -d '' skill_md; do
  SKILL_COUNT=$((SKILL_COUNT + 1))
  dir_name="$(basename "$(dirname "$skill_md")")"
  rel="${skill_md#"$ROOT"/}"

  frontmatter_at_byte0 "$skill_md" || fail "$rel : le frontmatter ne commence pas à l'octet 0 (classe de bug 2a7e1c8 — rien ne doit précéder le --- d'ouverture)"

  name="$(fm_field_value "$skill_md" name)"
  [[ -n "$name" ]] || fail "$rel : champ 'name' absent du frontmatter"
  if [[ -n "$name" ]]; then
    is_kebab "$name" || fail "$rel : 'name: $name' n'est pas en kebab-case"
    [[ "$name" == "$dir_name" ]] || fail "$rel : 'name: $name' diffère du nom du dossier '$dir_name'"
  fi

  desc="$(fm_field_value "$skill_md" description)"
  [[ -n "$desc" ]] || fail "$rel : champ 'description' absent ou vide (c'est lui qui pilote le déclenchement)"

  gotchas_nonempty "$skill_md" || fail "$rel : section '## Gotchas' absente ou vide (exigence CONTRIBUTING.md)"

  if [[ "$dir_name" != *-template ]] && grep -q '<TODO:' "$skill_md"; then
    fail "$rel : contient '<TODO:' alors que le skill n'a pas le suffixe -template (promesse « utilisable tel quel »)"
  fi
done < <(find "$ROOT/skills" -mindepth 3 -maxdepth 3 -type f -name "SKILL.md" -print0 | sort -z)
echo "  ${SKILL_COUNT} skills analysés."

# --- Subagents ---------------------------------------------------------

echo "Validation des subagents (${ROOT}/.claude/agents) :"
AGENT_COUNT=0
if [[ -d "$ROOT/.claude/agents" ]]; then
  while IFS= read -r -d '' agent_md; do
    AGENT_COUNT=$((AGENT_COUNT + 1))
    file_name="$(basename "$agent_md" .md)"
    rel="${agent_md#"$ROOT"/}"

    frontmatter_at_byte0 "$agent_md" || fail "$rel : le frontmatter ne commence pas à l'octet 0 (classe de bug 2a7e1c8)"

    name="$(fm_field_value "$agent_md" name)"
    [[ -n "$name" ]] || fail "$rel : champ 'name' absent du frontmatter"
    if [[ -n "$name" ]]; then
      is_kebab "$name" || fail "$rel : 'name: $name' n'est pas en kebab-case"
      [[ "$name" == "$file_name" ]] || fail "$rel : 'name: $name' diffère du nom de fichier '$file_name'"
    fi

    desc="$(fm_field_value "$agent_md" description)"
    [[ -n "$desc" ]] || fail "$rel : champ 'description' absent ou vide"
  done < <(find "$ROOT/.claude/agents" -mindepth 1 -maxdepth 1 -type f -name "*.md" -print0 | sort -z)
fi
echo "  ${AGENT_COUNT} subagents analysés."

# --- Verdict -----------------------------------------------------------

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "✗ ${ERRORS} erreur(s) de validation."
  exit 1
fi
echo ""
echo "✔ Validation passée (${SKILL_COUNT} skills, ${AGENT_COUNT} subagents)."
