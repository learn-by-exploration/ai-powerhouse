#!/usr/bin/env bash
# Verify all submodule SHAs match submodule-hashes.lock
# Exits non-zero if any mismatch is found (use --warn-only for advisory mode)
#
# Usage:
#   bash scripts/verify-submodules.sh             # strict — exits 1 on mismatch
#   bash scripts/verify-submodules.sh --warn-only # advisory — logs warnings only

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$REPO_ROOT/submodule-hashes.lock"
WARN_ONLY=false

for arg in "$@"; do
  [[ "$arg" == "--warn-only" ]] && WARN_ONLY=true
done

if [[ ! -f "$LOCK_FILE" ]]; then
  echo "ERROR: $LOCK_FILE not found. Run scripts/update-hashes.sh first." >&2
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  echo "ERROR: python3 required." >&2
  exit 1
fi

LOCK_FILE="$LOCK_FILE" REPO_ROOT="$REPO_ROOT" WARN_ONLY="$WARN_ONLY" python3 - <<'PYEOF'
import json, subprocess, sys, os

lock_path  = os.environ['LOCK_FILE']
repo       = os.environ['REPO_ROOT']
warn_only  = os.environ.get('WARN_ONLY') == 'true'

lock = json.load(open(lock_path))
mismatches = []
missing    = []

for name, expected in lock.items():
    if name.startswith('_'): continue
    path = os.path.join(repo, name)
    if not os.path.isdir(path):
        missing.append(name)
        continue
    r = subprocess.run(['git','-C',path,'rev-parse','HEAD'], capture_output=True, text=True)
    actual = r.stdout.strip()
    if not actual:
        missing.append(name)
    elif actual != expected:
        mismatches.append((name, expected, actual))

ok = True

if missing:
    print(f"[verify] ⚠️  Not initialized (run git submodule update --init):")
    for m in missing: print(f"  {m}")
    ok = False

if mismatches:
    print(f"[verify] ⚠️  Hash mismatches ({len(mismatches)}):")
    for name, exp, got in mismatches:
        print(f"  {name}: lock={exp[:12]}  actual={got[:12]}")
    print("[verify]    Run: bash scripts/update-hashes.sh  to accept new commits")
    ok = False

if ok:
    print(f"[verify] ✓ All {len(lock) - sum(1 for k in lock if k.startswith('_'))} submodule hashes match.")
elif not warn_only:
    sys.exit(1)
PYEOF
