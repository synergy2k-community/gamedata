#!/usr/bin/env bash
# Purge files from jsDelivr's CDN edge so a push to @main is served fresh.
#
# jsDelivr caches the floating @main ref (~12h edge), so without a purge an
# update lags. This hits the purge API (https://purge.jsdelivr.net), which
# evicts each path across jsDelivr's providers and forces a re-fetch from GitHub.
#
# Usage:
#   scripts/purge-jsdelivr.sh <path> [<path> ...]   # purge specific files
#   scripts/purge-jsdelivr.sh                       # no args → purge whole repo @main
#
# REPO env var overrides the target repo (default: synergy2k-community/gamedata).
# manifest.json is always included — it's the pointer clients revalidate.
set -euo pipefail

REPO="${REPO:-synergy2k-community/gamedata}"
REF="${REF:-main}"
BASE="https://purge.jsdelivr.net/gh/${REPO}@${REF}"

# Collect targets: args + the manifest, deduped; empty → the whole ref.
paths=("$@" "manifest.json")
mapfile -t paths < <(printf '%s\n' "${paths[@]}" | sed '/^$/d' | sort -u)
[ "${#paths[@]}" -eq 0 ] && paths=("")

fail=0
for p in "${paths[@]}"; do
  url="${BASE}/${p}"
  echo "→ purging ${p:-<entire ref>}"
  if ! curl -fsS "$url"; then
    echo "  ✗ purge request failed for ${p}" >&2
    fail=1
  fi
  echo
done

exit "$fail"
