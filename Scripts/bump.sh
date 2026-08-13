#!/usr/bin/env bash
# Points the cask at a new release: downloads the published zip, hashes what actually
# arrived, and patches the two lines that change. Hashing the download rather than a
# local dist/ copy is the point — the checksum has to describe the bytes users get.
set -euo pipefail

VERSION="${1:?usage: Scripts/bump.sh <version>    e.g. Scripts/bump.sh 0.3.0}"
CASK="$(cd "$(dirname "$0")/.." && pwd)/Casks/your-turn.rb"
URL="https://github.com/himynameisben/your-turn/releases/download/v${VERSION}/YourTurn-${VERSION}.zip"

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

# -f turns a not-yet-published tag into a non-zero exit instead of hashing GitHub's
# 404 page, which would otherwise commit cleanly and fail on every user's machine.
curl -fsSL --retry 3 -o "${TMP}/app.zip" "${URL}"
SHA="$(shasum -a 256 "${TMP}/app.zip" | cut -d' ' -f1)"

/usr/bin/sed -i '' \
  -e "s|^  version \".*\"$|  version \"${VERSION}\"|" \
  -e "s|^  sha256 \".*\"$|  sha256 \"${SHA}\"|" \
  "${CASK}"

echo "your-turn → ${VERSION}"
echo "sha256    → ${SHA}"
echo
echo "next: brew audit --cask --online --new ${CASK}"
