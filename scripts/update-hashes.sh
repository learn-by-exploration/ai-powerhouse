#!/usr/bin/env bash
# Update submodule-hashes.lock with current HEAD commits
# Run after: git submodule update --remote --merge

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - <<PYEOF
import json, subprocess, datetime, os

repo = "$REPO_ROOT"
lock_file = os.path.join(repo, 'submodule-hashes.lock')

submodules = ['awesome-claude-code','claude-mem','everything-claude-code',
              'get-shit-done','pm-workspace','ruflo','superpowers','ui-ux-pro-max-skill']

hashes = {}
for m in submodules:
    path = os.path.join(repo, m)
    if not os.path.isdir(path): continue
    sha = subprocess.run(['git','-C',path,'rev-parse','HEAD'],
                         capture_output=True, text=True).stdout.strip()
    hashes[m] = sha
    print(f"  {m}: {sha[:12]}")

data = {
    '_comment': 'Pinned submodule commit hashes. Run scripts/verify-submodules.sh to validate.',
    '_updated': datetime.date.today().isoformat(),
}
data.update(hashes)

with open(lock_file, 'w') as f:
    json.dump(data, f, indent=2)

print(f"\nUpdated {lock_file}")
print("Review the diff, then commit:")
print("  git add submodule-hashes.lock && git commit -m 'chore: update submodule hashes'")
PYEOF
