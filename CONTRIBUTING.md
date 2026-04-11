# Contributing to AI Powerhouse

Thanks for your interest in improving the Claude Code community ecosystem.

## Suggest a Repo

Found a high-quality Claude Code repo that should be included? [Open an issue](https://github.com/learn-by-exploration/ai-powerhouse/issues/new?template=suggest-repo.yml) with:

1. Repo URL and verified star count
2. What unique gap it fills (not already covered by the 12 existing submodules)
3. Whether it has active maintenance (commits in the last 60 days)

## Report a Bug

If `install.sh` or `uninstall.sh` isn't working correctly:

1. Run `bash master/install.sh --dry-run` and capture the output
2. Include your OS, bash version (`bash --version`), and Node version (`node -v`)
3. [Open an issue](https://github.com/learn-by-exploration/ai-powerhouse/issues/new?template=bug-report.yml)

## Fix a Bug

1. Fork the repo
2. Create a branch: `git checkout -b fix/description`
3. Make your changes
4. Test: `bash master/install.sh --dry-run` should complete without errors
5. Submit a PR

## Code Style

- Shell scripts: `set -euo pipefail`, quote all variables, use `[[ ]]` for tests
- Markdown: one sentence per line in source (renders as paragraphs)
- Commits: [Conventional Commits](https://www.conventionalcommits.org/) — `fix:`, `feat:`, `docs:`, `chore:`
