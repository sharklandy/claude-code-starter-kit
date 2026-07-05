#!/usr/bin/env bash
set -euo pipefail

# Self-test du validateur : prouve que scripts/validate-skills.sh
# attrape réellement chaque classe d'erreur qu'il prétend couvrir —
# en particulier la classe de bug corrigée en 2a7e1c8 (commentaire HTML
# avant le frontmatter), reconstruite ici à l'identique en fixture.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="${SCRIPT_DIR}/validate-skills.sh"
FAILED=0

expect() {
  # expect <succès|échec> <motif-attendu-dans-la-sortie> <nom-du-cas>
  local expected="$1" pattern="$2" label="$3" output status=0
  output="$(bash "$VALIDATOR" "$FIXTURE" 2>&1)" || status=$?
  if [[ "$expected" == "échec" && $status -eq 0 ]]; then
    echo "✗ $label : le validateur aurait dû échouer et a passé"; FAILED=1; return
  fi
  if [[ "$expected" == "succès" && $status -ne 0 ]]; then
    echo "✗ $label : le validateur aurait dû passer et a échoué :"; echo "$output"; FAILED=1; return
  fi
  if [[ -n "$pattern" ]] && ! grep -q "$pattern" <<<"$output"; then
    echo "✗ $label : sortie sans le motif attendu « $pattern » :"; echo "$output"; FAILED=1; return
  fi
  echo "✔ $label"
}

make_fixture() {
  FIXTURE="$(mktemp -d)"
  mkdir -p "$FIXTURE/skills/process/good-skill"
  cat > "$FIXTURE/skills/process/good-skill/SKILL.md" <<'EOF'
---
name: good-skill
description: >
  A valid fixture skill. Trigger on nothing, this is a test.
---
<!-- commentaire correctement placé SOUS le frontmatter -->

# Good skill

Corps du skill.

## Gotchas

- Un gotcha réel, non vide.
EOF
}

cleanup() { rm -rf "$FIXTURE"; }

# --- Cas 0 : une fixture saine passe -----------------------------------
make_fixture
expect succès "Validation passée" "fixture saine → validation passée"
cleanup

# --- Cas 1 : LA classe de bug 2a7e1c8 ----------------------------------
# Reproduction exacte : un commentaire HTML avant le --- d'ouverture.
# Avant le fix 2a7e1c8, les 21 SKILL.md du repo avaient cette forme :
# skill enregistré mais description non parsée, déclenchement cassé
# silencieusement.
make_fixture
mkdir -p "$FIXTURE/skills/process/broken-skill"
cat > "$FIXTURE/skills/process/broken-skill/SKILL.md" <<'EOF'
<!-- Skill générique de la "vague 2" -->
---
name: broken-skill
description: >
  This description will never be parsed because of the comment above.
---

# Broken skill

## Gotchas

- Non vide.
EOF
expect échec "octet 0" "bug 2a7e1c8 (commentaire avant frontmatter) → détecté"
cleanup

# --- Cas 2 : name incohérent avec le dossier ---------------------------
make_fixture
sed -i 's/^name: good-skill$/name: other-name/' "$FIXTURE/skills/process/good-skill/SKILL.md"
expect échec "diffère du nom du dossier" "name ≠ dossier → détecté"
cleanup

# --- Cas 3 : description absente ----------------------------------------
make_fixture
sed -i '/^description: >$/,/^---$/{/^description: >$/d; /^  A valid fixture/d;}' "$FIXTURE/skills/process/good-skill/SKILL.md"
expect échec "'description' absent" "description absente → détecté"
cleanup

# --- Cas 4 : Gotchas vide ------------------------------------------------
make_fixture
sed -i '/^- Un gotcha réel/d' "$FIXTURE/skills/process/good-skill/SKILL.md"
expect échec "Gotchas' absente ou vide" "Gotchas vide → détecté"
cleanup

# --- Cas 5 : TODO dans un skill non -template ---------------------------
make_fixture
printf -- '- <TODO: à compléter>\n' >> "$FIXTURE/skills/process/good-skill/SKILL.md"
expect échec "suffixe -template" "<TODO:> hors -template → détecté"
cleanup

# --- Cas 6 : TODO autorisé dans un -template ----------------------------
make_fixture
mkdir -p "$FIXTURE/skills/process/demo-template"
sed 's/^name: good-skill$/name: demo-template/' "$FIXTURE/skills/process/good-skill/SKILL.md" > "$FIXTURE/skills/process/demo-template/SKILL.md"
printf -- '- <TODO: à compléter>\n' >> "$FIXTURE/skills/process/demo-template/SKILL.md"
expect succès "" "<TODO:> dans un -template → toléré"
cleanup

# --- Cas 7 : subagent avec frontmatter décalé ---------------------------
make_fixture
mkdir -p "$FIXTURE/.claude/agents"
cat > "$FIXTURE/.claude/agents/bad-agent.md" <<'EOF'

---
name: bad-agent
description: Frontmatter précédé d'une ligne vide — même classe de bug.
---
Corps.
EOF
expect échec "octet 0" "subagent avec frontmatter décalé → détecté"
cleanup

# --- Cas 8 : marketplace.json pointant vers un skill inexistant ---------
make_fixture
mkdir -p "$FIXTURE/.claude-plugin"
cat > "$FIXTURE/.claude-plugin/marketplace.json" <<'EOF'
{
  "name": "fixture-marketplace",
  "owner": { "name": "fixture" },
  "plugins": [
    { "name": "fixture-plugin", "source": "./", "strict": false,
      "version": "1.0.0",
      "skills": ["./skills/process/does-not-exist"] }
  ]
}
EOF
expect échec "introuvable(s) sur le disque" "marketplace → chemin de skill inexistant → détecté"
cleanup

# --- Cas 9 : version marketplace ≠ dernière release du CHANGELOG --------
# La classe d'oubli du finding 01 : release datée sans bump du marketplace.
make_fixture
mkdir -p "$FIXTURE/.claude-plugin"
cat > "$FIXTURE/.claude-plugin/marketplace.json" <<'EOF'
{
  "name": "fixture-marketplace",
  "owner": { "name": "fixture" },
  "plugins": [
    { "name": "fixture-plugin", "source": "./", "strict": false,
      "version": "1.0.0",
      "skills": ["./skills/process/good-skill"] }
  ]
}
EOF
cat > "$FIXTURE/CHANGELOG.md" <<'EOF'
# Changelog

## [1.1.0] - 2026-07-05

### Ajouté

- Une release datée sans bump du marketplace.
EOF
expect échec "dernière release du CHANGELOG" "version marketplace ≠ CHANGELOG → détecté"
cleanup

# --- Cas 10 : lien relatif cassé dans un README --------------------------
make_fixture
cat > "$FIXTURE/README.md" <<'EOF'
# Fixture

Voir [le guide](./docs/does-not-exist.md) pour le détail.
EOF
expect échec "lien relatif cassé" "README → lien relatif cassé → détecté"
cleanup

# --- Cas 11 : agent préchargeant un skill inexistant ---------------------
make_fixture
mkdir -p "$FIXTURE/.claude/agents"
cat > "$FIXTURE/.claude/agents/preload-agent.md" <<'EOF'
---
name: preload-agent
description: Agent de fixture qui précharge un skill absent.
skills:
  - ghost-skill
---
Corps.
EOF
expect échec "skill préchargé 'ghost-skill' introuvable" "agent → préchargement d'un skill absent → détecté"
cleanup

# --- Verdict -------------------------------------------------------------
echo ""
if [[ $FAILED -ne 0 ]]; then
  echo "✗ Self-test du validateur : au moins un cas a échoué."
  exit 1
fi
echo "✔ Self-test du validateur : 12/12 cas passés."
