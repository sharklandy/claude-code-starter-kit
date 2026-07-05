#!/usr/bin/env bash
set -euo pipefail

# Release outillée du starter kit : date le CHANGELOG, bumpe les deux
# entrées de marketplace.json, valide, committe, tagge et publie la
# Release GitHub. Refuse de continuer si les versions divergent —
# c'est la contre-mesure structurelle au finding 01 du health-check
# (release datée sans bump => les utilisateurs du plugin ne reçoivent
# jamais la mise à jour).
#
# Usage : scripts/release.sh <X.Y.Z> [--dry-run]
#   --dry-run : effectue datage + bump + validation dans une copie
#               temporaire du repo, n'écrit rien ici, ne tagge pas,
#               ne publie pas.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-}"
DRY_RUN="${2:-}"

die() { echo "release.sh: $1" >&2; exit 1; }

[[ -n "$VERSION" ]] || die "usage: scripts/release.sh <X.Y.Z> [--dry-run]"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "version invalide '$VERSION' (attendu X.Y.Z)"

WORKDIR="$ROOT"
if [[ "$DRY_RUN" == "--dry-run" ]]; then
  WORKDIR="$(mktemp -d)/repo"
  git -C "$ROOT" worktree add --detach "$WORKDIR" HEAD >/dev/null 2>&1 \
    || { cp -r "$ROOT" "$WORKDIR"; }
  echo "[dry-run] copie de travail : $WORKDIR"
else
  [[ -z "$(git -C "$ROOT" status --porcelain)" ]] || die "arbre de travail non propre — committez ou stashez d'abord"
fi

CHANGELOG="$WORKDIR/CHANGELOG.md"
MARKETPLACE="$WORKDIR/.claude-plugin/marketplace.json"

# 1. Dater le CHANGELOG : la section [Non publié] devient [X.Y.Z] - date.
grep -q '^## \[Non publié\]' "$CHANGELOG" \
  || die "pas de section '## [Non publié]' dans le CHANGELOG — rien à releaser"
sed -i "s/^## \[Non publié\]/## [${VERSION}] - $(date +%F)/" "$CHANGELOG"

# 2. Bumper toutes les entrées version du marketplace vers X.Y.Z.
python3 - "$MARKETPLACE" "$VERSION" <<'PYEOF'
import json, sys
path, version = sys.argv[1], sys.argv[2]
m = json.load(open(path))
for p in m["plugins"]:
    p["version"] = version
open(path, "w").write(json.dumps(m, indent=2, ensure_ascii=False) + "\n")
PYEOF

# 3. Garde-fou : versions marketplace == dernière release du CHANGELOG.
latest="$(grep -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$CHANGELOG" | head -1 | tr -d '#[] ')"
mkt="$(python3 -c "import json,sys; vs={p['version'] for p in json.load(open('$MARKETPLACE'))['plugins']}; print(vs.pop() if len(vs)==1 else 'DIVERGENT')")"
[[ "$mkt" == "$latest" && "$mkt" == "$VERSION" ]] \
  || die "divergence après bump : marketplace=$mkt, CHANGELOG=$latest, demandé=$VERSION — release refusée"

# 4. Validation complète.
bash "$WORKDIR/scripts/validate-skills.sh" "$WORKDIR" >/dev/null \
  || die "validate-skills.sh échoue — release refusée"
echo "✔ datage, bump et validation OK (version ${VERSION})"

if [[ "$DRY_RUN" == "--dry-run" ]]; then
  echo "[dry-run] diff qui serait appliqué :"
  git -C "$WORKDIR" --no-pager diff --stat 2>/dev/null || true
  git -C "$ROOT" worktree remove --force "$WORKDIR" >/dev/null 2>&1 || rm -rf "$(dirname "$WORKDIR")"
  echo "[dry-run] terminé — rien n'a été modifié, taggé ni publié."
  exit 0
fi

# 5. Commit + tag + Release GitHub (notes = section CHANGELOG de la version).
git -C "$ROOT" add CHANGELOG.md .claude-plugin/marketplace.json
git -C "$ROOT" commit -m "chore(release): ${VERSION}"
git -C "$ROOT" tag -a "v${VERSION}" -m "v${VERSION}"
NOTES="$(mktemp)"
awk "/^## \[${VERSION}\]/{f=1;next} /^## \[/{f=0} f" "$CHANGELOG" > "$NOTES"
git -C "$ROOT" push && git -C "$ROOT" push origin "v${VERSION}"
gh release create "v${VERSION}" --title "v${VERSION}" --notes-file "$NOTES"
echo "✔ Release v${VERSION} publiée."
