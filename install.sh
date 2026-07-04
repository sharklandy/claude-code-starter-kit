#!/usr/bin/env bash
set -euo pipefail

# Installe les skills de ce dépôt dans un répertoire ~/.claude/skills
# (--global) ou <chemin>/.claude/skills (--local <chemin>), et les
# subagents de .claude/agents/ vers ~/.claude/agents ou
# <chemin>/.claude/agents.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/skills"
AGENTS_SRC="${SCRIPT_DIR}/.claude/agents"

usage() {
  echo "Usage: $0 --global | --local <path>"
  echo ""
  echo "  --global          install the skills into ~/.claude/skills/"
  echo "  --local <path>    install the skills into <path>/.claude/skills/"
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage
fi

case "$1" in
  --global)
    DEST="${HOME}/.claude/skills"
    AGENTS_DEST="${HOME}/.claude/agents"
    ;;
  --local)
    if [[ $# -lt 2 ]]; then
      echo "Error: --local requires a path." >&2
      usage
    fi
    TARGET_DIR="$2"
    if [[ ! -d "${TARGET_DIR}" ]]; then
      echo "Error: path '${TARGET_DIR}' does not exist or is not a directory." >&2
      exit 1
    fi
    DEST="${TARGET_DIR}/.claude/skills"
    AGENTS_DEST="${TARGET_DIR}/.claude/agents"
    ;;
  -h|--help)
    usage
    ;;
  *)
    echo "Error: unknown option '$1'." >&2
    usage
    ;;
esac

if [[ ! -d "${SKILLS_SRC}" ]]; then
  echo "Error: source directory '${SKILLS_SRC}' not found." >&2
  exit 1
fi

if ! mkdir -p "${DEST}" 2>/dev/null; then
  echo "Error: could not create destination directory '${DEST}' (permissions?)." >&2
  exit 1
fi

INSTALLED=()
SKIPPED=()

# Chaque skill est un dossier contenant un SKILL.md, rangé sous une
# catégorie (skills/process/<nom>/, skills/domains/<nom>/...). On
# installe chaque dossier de skill trouvé, à plat, sous ${DEST}/<nom>,
# en copiant l'intégralité de son contenu (y compris un éventuel
# sous-dossier reference/).
while IFS= read -r -d '' skill_md; do
  skill_path="$(dirname "${skill_md}")"
  skill_name="$(basename "${skill_path}")"
  dest_path="${DEST}/${skill_name}"

  if [[ -e "${dest_path}" ]]; then
    read -r -p "Skill '${skill_name}' already exists in ${DEST}. Overwrite? [y/N] " reply
    case "${reply}" in
      [yY]|[yY][eE][sS])
        rm -rf "${dest_path}"
        ;;
      *)
        echo "  -> skipped: ${skill_name}"
        SKIPPED+=("${skill_name}")
        continue
        ;;
    esac
  fi

  if ! cp -r "${skill_path}" "${dest_path}"; then
    echo "Error: failed to copy '${skill_name}' to '${dest_path}'." >&2
    exit 1
  fi

  INSTALLED+=("${skill_name}")
done < <(find "${SKILLS_SRC}" -mindepth 3 -maxdepth 3 -type f -name "SKILL.md" -print0 | sort -z)

# Les subagents sont des fichiers Markdown à plat dans .claude/agents/.
# Chacun est installé sous ${AGENTS_DEST}/<nom>.md.
AGENTS_INSTALLED=()
AGENTS_SKIPPED=()

if [[ -d "${AGENTS_SRC}" ]]; then
  if ! mkdir -p "${AGENTS_DEST}" 2>/dev/null; then
    echo "Error: could not create destination directory '${AGENTS_DEST}' (permissions?)." >&2
    exit 1
  fi

  while IFS= read -r -d '' agent_md; do
    agent_file="$(basename "${agent_md}")"
    agent_name="${agent_file%.md}"
    agent_dest="${AGENTS_DEST}/${agent_file}"

    if [[ -e "${agent_dest}" ]]; then
      read -r -p "Subagent '${agent_name}' already exists in ${AGENTS_DEST}. Overwrite? [y/N] " reply
      case "${reply}" in
        [yY]|[yY][eE][sS])
          rm -f "${agent_dest}"
          ;;
        *)
          echo "  -> skipped: ${agent_name}"
          AGENTS_SKIPPED+=("${agent_name}")
          continue
          ;;
      esac
    fi

    if ! cp "${agent_md}" "${agent_dest}"; then
      echo "Error: failed to copy '${agent_name}' to '${agent_dest}'." >&2
      exit 1
    fi

    AGENTS_INSTALLED+=("${agent_name}")
  done < <(find "${AGENTS_SRC}" -mindepth 1 -maxdepth 1 -type f -name "*.md" -print0 | sort -z)
fi

echo ""
echo "Install summary:"
echo "  Destination: ${DEST}"
if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  echo "  Skills installed (${#INSTALLED[@]}):"
  for s in "${INSTALLED[@]}"; do
    echo "    - ${s}"
  done
else
  echo "  No skill installed."
fi
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo "  Skills skipped (${#SKIPPED[@]}):"
  for s in "${SKIPPED[@]}"; do
    echo "    - ${s}"
  done
fi
if [[ ${#AGENTS_INSTALLED[@]} -gt 0 ]]; then
  echo "  Subagents installed (${#AGENTS_INSTALLED[@]}) into ${AGENTS_DEST}:"
  for a in "${AGENTS_INSTALLED[@]}"; do
    echo "    - ${a}"
  done
fi
if [[ ${#AGENTS_SKIPPED[@]} -gt 0 ]]; then
  echo "  Subagents skipped (${#AGENTS_SKIPPED[@]}):"
  for a in "${AGENTS_SKIPPED[@]}"; do
    echo "    - ${a}"
  done
fi
