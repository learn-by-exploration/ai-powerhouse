# Changelog

## [Unreleased]

## [0.0.3] — 2026-03-25

### Fixed — Critical bugs
- `install.sh`: removed `eval` from `action()` helper — replaced with direct quoted `mkdir -p` calls (shell injection risk)
- `install.sh`: fixed `"${@:-}"` arg-parsing loop → `"$@"` (ran loop body once with empty string when no args given)
- `install.sh`: fixed `--local` flag for claude-mem marketplace symlink — was unconditionally writing to `$HOME/.claude`, now uses `$CLAUDE_DIR`
- `install.sh`: removed duplicate manifest-writing block (dead PYEOF that ran with wrong env vars, overwritten by correct PYEOF2)
- `install.sh`: hash verification heredoc now correctly exports `REPO_ROOT` and `LOCK_FILE` before the inline Python
- `uninstall.sh`: fixed same `"${@:-}"` arg-parsing bug; uninstall now uses explicit loops instead of `find -delete 2>/dev/null || true` so failures surface
- `scripts/update-hashes.sh`: fixed heredoc quoting (`<<PYEOF` → `<<'PYEOF'`), passes `REPO_ROOT` via env var instead of shell interpolation into Python source
- `everything-claude-code/rules/common/agents.md`: agent names updated to match installed `ecc-` prefix (were `planner`, `architect` etc. — broke tool invocations)

### Fixed — Agent name collisions
- `install.sh`: added name-collision patch step — `superpowers-code-reviewer`, `ruflo-planner`, `ruflo-reasoning-goal-planner`, `ruflo-github-pr-manager` are now installed as real files (not symlinks) with their `name:` field corrected to match the filename prefix

### Added
- `install.sh --no-ruflo`: excludes all 76 ruflo agents, skills, commands, and hooks (saves ~40-60K context tokens)
- `install.sh --full`: opt-in to full install including language-specific rules; **default is now `--minimal`**
- Unrecognized-flag warnings in both `install.sh` and `uninstall.sh`
- `--dry-run` flag added to `uninstall.sh`
- `scripts/verify-submodules.sh`: standalone hash-verification script (was referenced in lock file comment but missing)
- Comment in `install.sh` explaining why `pm-workspace` and `awesome-claude-code` are not installed

### Changed
- `install.sh`: submodule init guard now checks ALL required submodules (was single-file spot check on one submodule)
- `install.sh`: `rm -rf` before symlink replaced with `rm -f` (only removes symlinks, warns on real dirs)
- `install.sh`: default changed to `--minimal`; use `--full` for language-specific rules
- `install.sh`: `--minimal` token savings claim corrected to `~15-20K` (was inaccurate `~40K`)
- `master/CLAUDE.md`: removed "What's Available" section (~600 tokens/session, redundant with Tool manifest); removed "Installation & Maintenance" block (developer docs, not model context); added MCP dependency note; added missing routing rows (docs, onboarding, PR, migrations, security scan)
- `master/hooks/ruflo-hooks.json`: removed `pre-search`/`post-search` hooks on `Grep|Glob|Read` (was adding 2-4s latency to every file read); added security note to `PermissionRequest` auto-allow block
- `.github/workflows/test-install.yml`: added `macos-latest` matrix; dry-run now asserts no files written; uninstall test now checks agents/skills removed (not just manifest); added idempotency test; added `--no-ruflo` test; added `verify-submodules.sh` step

### Security
- `master/hooks/ruflo-hooks.json`: `PermissionRequest` auto-allow now has explicit documentation warning about the blanket approval scope

## [0.0.2] — 2026-03-24

### Added
- `ruflo` submodule: enterprise multi-agent orchestration (76 agents, 38 skills, 4 commands)
- `master/hooks/ruflo-hooks.json`: version-pinned copy of ruflo hooks (`@3.5.0` not `@alpha`)
- `master/skills/agent-routing/SKILL.md`: decision tree for routing task types to the right tool
- `master/uninstall.sh`: removes everything install.sh placed in `~/.claude`
- `submodule-hashes.lock`: pinned commit SHAs for all 8 submodules (supply chain integrity)
- `scripts/update-hashes.sh`: update lock file after `git submodule update --remote`
- `.github/workflows/test-install.yml`: CI verifying install/uninstall, symlink resolution, agent count, hook JSON validity
- `install.sh --minimal` flag: skips language-specific rules (~40K fewer tokens loaded)
- `install.sh --local` flag: installs to `master/.claude/` instead of `~/.claude`
- `POWERHOUSE_MANIFEST.json`: written to `~/.claude/` on every install, tracks version + submodule hashes + counts

### Changed
- **install.sh**: major rewrite
  - Pre-flight checks: submodule init guard, Node.js ≥18 check, Bun availability warning
  - All symlinks now use **absolute paths** (no more relative symlink breakage on different clone paths)
  - Language-specific rules moved to `--full` mode (default is `--minimal` equivalent for rules)
  - claude-mem marketplace symlink created automatically
  - Writes `POWERHOUSE_MANIFEST.json` on completion
- **master/CLAUDE.md**: rewritten with decision tree, unified testing strategy, routing quick reference, context budget guidance
- **master/.claude/**: all 400 committed symlinks removed from git; directory is now gitignored and regenerated by `install.sh`

### Fixed
- `claude-mem` hooks now work when installed via `install.sh` (not just marketplace)
- Ruflo hooks no longer use `@alpha` (unpinned) npm tag

### Security
- All ruflo hook commands pinned to `claude-flow@3.5.0` (was `@alpha`)
- Submodule hash verification on every install (warns on mismatch)
- Bun install now requires manual opt-in (no silent `curl | bash`)

---

## [0.0.1] — 2026-03-24

### Added
- Initial release with 7 submodules: `awesome-claude-code`, `claude-mem`, `everything-claude-code`, `get-shit-done`, `pm-workspace`, `superpowers`, `ui-ux-pro-max-skill`
- `master/` directory with unified `CLAUDE.md`, `install.sh`, `README.md`
- `master/.claude/` with 284 symlinks across agents/skills/commands/hooks/rules
- `master/install.sh`: installs all tools to `~/.claude`
