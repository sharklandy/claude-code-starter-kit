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
    # Standard Agent Skills (agentskills.io) : name ≤ 64 caractères.
    [[ ${#name} -le 64 ]] || fail "$rel : 'name' dépasse 64 caractères (standard Agent Skills)"
  fi

  desc="$(fm_field_value "$skill_md" description)"
  [[ -n "$desc" ]] || fail "$rel : champ 'description' absent ou vide (c'est lui qui pilote le déclenchement)"
  # Standard Agent Skills (agentskills.io) : description ≤ 1024 caractères.
  [[ ${#desc} -le 1024 ]] || fail "$rel : 'description' dépasse 1024 caractères (standard Agent Skills)"

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

# --- Évals (format skill-creator, agentskills.io) ----------------------

EVALS_COUNT=0
if command -v python3 >/dev/null 2>&1; then
  echo "Validation des fichiers d'évals (skills/**/evals/evals.json) :"
  while IFS= read -r -d '' evals_json; do
    EVALS_COUNT=$((EVALS_COUNT + 1))
    rel="${evals_json#"$ROOT"/}"
    skill_dir="$(basename "$(dirname "$(dirname "$evals_json")")")"
    if ! err="$(python3 - "$evals_json" "$skill_dir" <<'PYEOF' 2>&1
import json, sys
data = json.load(open(sys.argv[1]))
assert data["skill_name"] == sys.argv[2], f"skill_name '{data['skill_name']}' != dossier '{sys.argv[2]}'"
assert isinstance(data["evals"], list) and data["evals"], "liste 'evals' vide"
for e in data["evals"]:
    for k in ("id", "prompt", "expected_output"):
        assert k in e, f"champ '{k}' manquant dans l'eval {e.get('id','?')}"
PYEOF
)"; then
      fail "$rel : ${err##*AssertionError: }"
    fi
  done < <(find "$ROOT/skills" -mindepth 4 -maxdepth 4 -type f -name "evals.json" -path "*/evals/*" -print0 | sort -z)
  echo "  ${EVALS_COUNT} fichiers d'évals analysés."
fi

# --- Cohérence du repo (marketplace, versions, liens, préchargements) --
# Chaque check ne s'exécute que si le fichier concerné existe : le
# validateur reste utilisable sur une arborescence partielle (fixtures
# du self-test) tout en gardant le repo complet sous surveillance.

if [[ -f "$ROOT/.claude-plugin/marketplace.json" ]] && command -v python3 >/dev/null 2>&1; then
  echo "Validation de .claude-plugin/marketplace.json :"
  if ! err="$(python3 - "$ROOT" <<'PYEOF' 2>&1
import json, os, re, sys
root = sys.argv[1]
m = json.load(open(os.path.join(root, ".claude-plugin/marketplace.json")))
plugins = m["plugins"]

# 1. Tout chemin skills:/agents: déclaré doit exister sur le disque.
missing = []
for p in plugins:
    for path in p.get("skills", []) + p.get("agents", []):
        rel = path[2:] if path.startswith("./") else path
        if not os.path.exists(os.path.join(root, rel)):
            missing.append(f"{p['name']}: {path}")
assert not missing, "chemin(s) déclaré(s) introuvable(s) sur le disque : " + ", ".join(missing)

# 2. Toutes les entrées doivent porter la même version.
versions = {p.get("version") for p in plugins}
assert len(versions) == 1, f"versions divergentes entre les entrées du marketplace : {sorted(versions)}"
mkt_version = versions.pop()

# 3. La version du marketplace doit être celle de la dernière release
#    datée du CHANGELOG (la classe d'oubli du finding 01).
chlog = os.path.join(root, "CHANGELOG.md")
if os.path.exists(chlog):
    versioned = re.findall(r"^## \[(\d+\.\d+\.\d+)\]", open(chlog).read(), re.M)
    if versioned:
        assert mkt_version == versioned[0], (
            f"version du marketplace ({mkt_version}) != dernière release du CHANGELOG ({versioned[0]}) "
            "— bumper marketplace.json ou utiliser scripts/release.sh")
PYEOF
)"; then
    fail ".claude-plugin/marketplace.json : ${err##*AssertionError: }"
  else
    echo "  chemins, versions et cohérence CHANGELOG : OK"
  fi
fi

README_LINKS_CHECKED=0
for readme in "$ROOT/README.md" "$ROOT/README.fr.md"; do
  [[ -f "$readme" ]] || continue
  while IFS= read -r link; do
    README_LINKS_CHECKED=$((README_LINKS_CHECKED + 1))
    if [[ ! -e "$ROOT/${link#./}" ]]; then
      fail "$(basename "$readme") : lien relatif cassé -> $link"
    fi
  done < <(grep -oE '\]\((\./[^)#]+)\)' "$readme" | sed 's/](\(.*\))/\1/' | sort -u)
done
if [[ $README_LINKS_CHECKED -gt 0 ]]; then
  echo "Liens relatifs des README : ${README_LINKS_CHECKED} vérifiés."
fi

# Champs skills: préchargés par les subagents : chaque skill listé doit
# exister sous skills/*/<nom>/SKILL.md, sinon le préchargement échouera
# silencieusement à l'exécution (simple warning côté Claude Code).
if [[ -d "$ROOT/.claude/agents" ]]; then
  while IFS= read -r -d '' agent_md; do
    rel="${agent_md#"$ROOT"/}"
    while IFS= read -r preload; do
      [[ -n "$preload" ]] || continue
      if ! compgen -G "$ROOT/skills/*/$preload/SKILL.md" >/dev/null; then
        fail "$rel : skill préchargé '$preload' introuvable sous skills/*/$preload/"
      fi
    done < <(fm_block "$agent_md" | awk '/^skills:/{f=1;next} f && /^[[:space:]]*-[[:space:]]/{sub(/^[[:space:]]*-[[:space:]]*/,""); print; next} f && /^[a-zA-Z_-]+:/{f=0}')
  done < <(find "$ROOT/.claude/agents" -mindepth 1 -maxdepth 1 -type f -name "*.md" -print0 | sort -z)
fi

# --- Verdict -----------------------------------------------------------

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "✗ ${ERRORS} erreur(s) de validation."
  exit 1
fi
echo ""
echo "✔ Validation passée (${SKILL_COUNT} skills, ${AGENT_COUNT} subagents)."
