# Changelog

## [Unreleased]

### Added
- **ponytail (lazy-mode) integration** — Dietrich Gebert's "lazy senior dev" coding posture as a Powerhouse skill pack:
  - `ponytail/` — new submodule pinned to upstream `main` (v4.2.0, MIT). Source reference only — ponytail is a Claude Code plugin, so the runtime hooks and TOML commands need `/plugin marketplace add DietrichGebert/ponytail` for the full experience.
  - `master/install.sh` — new install block walks `ponytail/skills/*/SKILL.md` and symlinks each as `ponytail-<name>` in `~/.claude/skills/`. Installs 4 skills: `ponytail-ponytail` (the lazy-mode, lite/full/ultra/off), `ponytail-ponytail-review` (review code for over-engineering), `ponytail-ponytail-audit` (audit for code to delete), `ponytail-ponytail-help`.
  - `master/uninstall.sh` — added `ponytail-` to cleanup prefix list.
  - `master/CLAUDE.md` — new routing row "Over-engineering review" → `ponytail-ponytail-review` / `ponytail-ponytail-audit`; bumped default counts 309→310 agents, 619→623 skills, sources 16→17.
  - `master/README.md` — directory tree updated, master row bumped to 1 agent / 2 skills, new ponytail row, new "Frameworks & standards" row.
  - `README.md` — ponytail row added to "What gets installed" table, totals bumped to 310/623/284 default and 365/733/332 with-ruflo, new "Frameworks & Standards" section.
  - `USAGE.md` — ponytail row added, totals bumped to 310/623/284 default and 365/733/332 with-ruflo, `ponytail-` added to the source-prefix collision list, "ponytail" entry added to the tool reference table.
  - `.github/workflows/test-install.yml` — `ponytail` added to the agents cleanup regex; `ponytail-` added to the skills cleanup regex.
  - `scripts/update-hashes.sh` — added `ponytail` to the hardcoded submodule list.
  - `submodule-hashes.lock` — pinned ponytail to `e01aa900f7e12e8a4660fb5d757ad016baeffed9`.
  - `master/agents/` and the matching `master/install.sh` block for `master/agents/` were added in the prior 15288 commit, but their outputs weren't separately called out in the changelog.
- **ISO/IEC/IEEE 15288 systems engineering integration**:
  - `docs/se-15288.md` — full reference for the 11 Technical processes, with a mapping table from each 15288 process to the Powerhouse tool that implements it
  - `master/skills/se-lifecycle/SKILL.md` — routing entry point; installed as `master-se-lifecycle`
  - `master/agents/se-systems-engineer.md` — orchestrator that walks a project through the 11 phases in order and gates phase transitions on verification/validation evidence; installed as `master-se-systems-engineer`
  - `master/install.sh` — new loop for `master/agents/` (symlinks every `*.md` in `master/agents/` as `master-<name>.md`)
  - `master/CLAUDE.md` — new "Systems engineering lifecycle" row in the routing table; new philosophy bullet "SE lifecycle first"
  - `master/README.md` — new `master/agents/` entry in the directory tree; master row bumped to 1 agent / 2 skills; new "Frameworks & standards" section
  - `README.md` — new "Frameworks & Standards" section
- **4 new submodules**:
  - `drawio-skill` (Agents365-ai) — single always-installed `drawio-skill` for exportable `.drawio` diagrams (PNG/SVG/PDF)
  - `plantuml-skill` (Agents365-ai) — text-based `.puml` diagrams via Kroki API, no Java needed
  - `anthropics-skills` (★ 150k) — 17 official Anthropic skills: `anthropic-pdf`, `anthropic-docx`, `anthropic-pptx`, `anthropic-xlsx`, `anthropic-mcp-builder`, `anthropic-webapp-testing`, `anthropic-frontend-design`, etc.
  - `alirezarezvani-claude-skills` (★ 18k) — 12 non-engineering domains (`business-growth`, `business-operations`, `c-level-advisor`, `commercial`, `compliance-os`, `finance`, `marketing-skill`, `product-team`, `productivity`, `project-management`, `ra-qm-team`, `research-ops`). Engineering domains deliberately skipped to avoid overlap with `wshobson-agents`.
- `docs/okf-spec.md`: vendored copy of the Open Knowledge Format v0.1 spec (GoogleCloudPlatform/knowledge-catalog). OKF is a markdown + frontmatter format for agent-readable knowledge bundles — could be applied to organize this repo's `master/`, `docs/`, and submodule READMEs.
- `install.sh`: `drawio-skill`, `plantuml-skill` are always installed (no flag needed). `anthropic-*` skills installed from `anthropics-skills/skills/*` with `anthropic-` prefix. `rez-*` skills installed from selected `alirezarezvani-claude-skills` domains with `rez-<domain>-<skill>` prefix.
- USAGE.md and master/CLAUDE.md: added sections for diagram skills, official Anthropic skills, and business skills
- README.md: added badges, source table rows, "What gets installed" table rows, and routing entries for the new submodules

### Fixed — Critical bug
- `install.sh --with-ruflo`: ruflo agents/skills/commands were not being installed — `ruflo/plugin/` (singular, old path) is empty in ruflo v3.7+; everything moved to `ruflo/plugins/` (plural). Rewrote all ruflo install paths to use `find ruflo/plugins -path "*/agents/*" -name "*.md"`. **This means `--with-ruflo` previously installed zero ruflo content** — fixed in this release.

### Fixed
- `master/uninstall.sh`: added `ws-`, `sc-`, `ctm-`, `ponytail-` prefixes to cleanup regex; added explicit removal of `drawio-skill` and `plantuml-skill` skill directories (they were orphaned on uninstall)
- `scripts/update-hashes.sh`: added `drawio-skill`, `plantuml-skill`, `anthropics-skills`, `alirezarezvani-claude-skills`, `ponytail` to the hardcoded submodule list
- `.github/workflows/test-install.yml`: cleanup regex expanded to `^(ecc|gsd|superpowers|ruflo|mem|uiux|master|ws|sc|ctm|ponytail)-`; added `drawio-skill|plantuml-skill` for skills cleanup
- All counts refreshed to reflect actual filesystem: **310 agents, 640 skills, 284 commands** (default); **365 agents, 750 skills, 332 commands** (with `--with-ruflo`). 17 source submodules total. (The 15288 commit's `309/619/284` claim was already off; this commit brings the totals in line with the new ponytail + master agents/skills additions.)

### Changed
- Total submodule count: 12 → 17
- Submodule count documented in README: 13 → 17 (correcting the "13" claim — `alirezarezvani-claude-skills` was the 16th, `ponytail` is the 17th)

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
