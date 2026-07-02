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
  echo "Usage: $0 --global | --local <chemin>"
  echo ""
  echo "  --global          installe les skills dans ~/.claude/skills/"
  echo "  --local <chemin>  installe les skills dans <chemin>/.claude/skills/"
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
      echo "Erreur : --local nécessite un chemin." >&2
      usage
    fi
    TARGET_DIR="$2"
    if [[ ! -d "${TARGET_DIR}" ]]; then
      echo "Erreur : le chemin '${TARGET_DIR}' n'existe pas ou n'est pas un répertoire." >&2
      exit 1
    fi
    DEST="${TARGET_DIR}/.claude/skills"
    AGENTS_DEST="${TARGET_DIR}/.claude/agents"
    ;;
  -h|--help)
    usage
    ;;
  *)
    echo "Erreur : option inconnue '$1'." >&2
    usage
    ;;
esac

if [[ ! -d "${SKILLS_SRC}" ]]; then
  echo "Erreur : dossier source '${SKILLS_SRC}' introuvable." >&2
  exit 1
fi

if ! mkdir -p "${DEST}" 2>/dev/null; then
  echo "Erreur : impossible de créer le répertoire de destination '${DEST}' (permissions ?)." >&2
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
    read -r -p "Le skill '${skill_name}' existe déjà dans ${DEST}. L'écraser ? [y/N] " reply
    case "${reply}" in
      [yY]|[yY][eE][sS])
        rm -rf "${dest_path}"
        ;;
      *)
        echo "  -> ignoré : ${skill_name}"
        SKIPPED+=("${skill_name}")
        continue
        ;;
    esac
  fi

  if ! cp -r "${skill_path}" "${dest_path}"; then
    echo "Erreur : échec de la copie de '${skill_name}' vers '${dest_path}'." >&2
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
    echo "Erreur : impossible de créer le répertoire de destination '${AGENTS_DEST}' (permissions ?)." >&2
    exit 1
  fi

  while IFS= read -r -d '' agent_md; do
    agent_file="$(basename "${agent_md}")"
    agent_name="${agent_file%.md}"
    agent_dest="${AGENTS_DEST}/${agent_file}"

    if [[ -e "${agent_dest}" ]]; then
      read -r -p "Le subagent '${agent_name}' existe déjà dans ${AGENTS_DEST}. L'écraser ? [y/N] " reply
      case "${reply}" in
        [yY]|[yY][eE][sS])
          rm -f "${agent_dest}"
          ;;
        *)
          echo "  -> ignoré : ${agent_name}"
          AGENTS_SKIPPED+=("${agent_name}")
          continue
          ;;
      esac
    fi

    if ! cp "${agent_md}" "${agent_dest}"; then
      echo "Erreur : échec de la copie de '${agent_name}' vers '${agent_dest}'." >&2
      exit 1
    fi

    AGENTS_INSTALLED+=("${agent_name}")
  done < <(find "${AGENTS_SRC}" -mindepth 1 -maxdepth 1 -type f -name "*.md" -print0 | sort -z)
fi

echo ""
echo "Résumé de l'installation :"
echo "  Destination : ${DEST}"
if [[ ${#INSTALLED[@]} -gt 0 ]]; then
  echo "  Skills installés (${#INSTALLED[@]}) :"
  for s in "${INSTALLED[@]}"; do
    echo "    - ${s}"
  done
else
  echo "  Aucun skill installé."
fi
if [[ ${#SKIPPED[@]} -gt 0 ]]; then
  echo "  Skills ignorés (${#SKIPPED[@]}) :"
  for s in "${SKIPPED[@]}"; do
    echo "    - ${s}"
  done
fi
if [[ ${#AGENTS_INSTALLED[@]} -gt 0 ]]; then
  echo "  Subagents installés (${#AGENTS_INSTALLED[@]}) dans ${AGENTS_DEST} :"
  for a in "${AGENTS_INSTALLED[@]}"; do
    echo "    - ${a}"
  done
fi
if [[ ${#AGENTS_SKIPPED[@]} -gt 0 ]]; then
  echo "  Subagents ignorés (${#AGENTS_SKIPPED[@]}) :"
  for a in "${AGENTS_SKIPPED[@]}"; do
    echo "    - ${a}"
  done
fi
