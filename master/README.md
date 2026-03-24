# Master — AI Powerhouse Setup

This folder is the unified entry point for using all tools in the AI Powerhouse collection inside Claude Code.

## What's inside

```
master/
├── CLAUDE.md          # Master instructions — drop into any project
├── install.sh         # Install all tools globally into ~/.claude
└── .claude/
    ├── agents/        # 47 agents (ecc-*, superpowers-*, gsd-*)
    ├── skills/        # 151 skills (ecc-*, superpowers-*, mem-*, uiux-*)
    ├── commands/      # 64 commands (ecc-*, superpowers-*, gsd-*)
    ├── hooks/         # Hooks from ecc, gsd, claude-mem
    └── rules/         # Language rules from ecc
```

All entries are symlinks into the submodules — they stay up to date automatically when you run `git submodule update --remote`.

---

## Option 1 — Use within this repo (automatic)

Just open `ai-powerhouse/` in Claude Code. The `.claude/` directory is already in place — Claude will pick up all agents, skills, and commands automatically.

---

## Option 2 — Install globally (recommended)

Run the install script once to symlink everything into `~/.claude`. After that, all tools are available in **every project** on your machine:

```bash
# Preview first
bash master/install.sh --dry-run

# Install
bash master/install.sh
```

Then restart Claude Code.

---

## Option 3 — Drop CLAUDE.md into any project

Copy `master/CLAUDE.md` into any project's root. It gives Claude full context on what tools are available and how to use them — without needing to install anything.

```bash
cp master/CLAUDE.md /your/project/CLAUDE.md
```

---

## Keeping everything up to date

Update all submodules to the latest upstream versions:

```bash
git submodule update --remote --merge
git add .
git commit -m "Update submodules to latest"
```

Then re-run `bash master/install.sh` to refresh the symlinks.

---

## What you get

| Source | Agents | Skills | Commands |
|--------|--------|--------|----------|
| everything-claude-code | 28 | 130+ | 57 |
| superpowers | 1 | 14 | 3 |
| get-shit-done | 18 | — | 1+ |
| claude-mem | — | 5 | — |
| ui-ux-pro-max | — | 7 | — |
| **Total** | **47** | **151** | **64** |
