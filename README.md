# sth-harness

A Claude Code, Codex, Pi, GitHub Copilot CLI, and Google Antigravity CLI
plugin/package that installs and drives the model-agnostic **ai-harness**
(spec-driven, hexagonal, stateful, resumable development in folders + Markdown).

## Commands
Claude Code exposes slash commands:

- `/sth-harness:init [feature-name]` — copy the harness into this repo, interview
  to fill `context/project.md`, then create your first feature's `spec.md` +
  `state.md`.
- `/sth-harness:add-spec [feature-name]` — in an initialized repo, interview for a
  new feature and create its files.
- `/sth-harness:implement-next-spec` — pick the next pending spec (you confirm) and
  implement it through the harness until blocked, a decision is needed, or it is done.

Codex exposes the `sth-harness` skill instead of slash commands. Ask Codex to:

- "Initialize this repo with the ai-harness."
- "Add a new ai-harness spec for <feature>."
- "Implement the next pending ai-harness spec."

Pi exposes prompt templates:

- `/sth-harness-init [feature-name]`
- `/sth-harness-add-spec [feature-name]`
- `/sth-harness-implement-next-spec`

GitHub Copilot CLI exposes the `sth-harness` skill. Ask Copilot CLI to:

- "Initialize this repo with the ai-harness."
- "Add a new ai-harness spec for <feature>."
- "Implement the next pending ai-harness spec."

Google Antigravity CLI (`agy`) exposes the `sth-harness` skill. Ask AGY to:

- "Initialize this repo with the ai-harness."
- "Add a new ai-harness spec for <feature>."
- "Implement the next pending ai-harness spec."

## What it ships
- `template/ai-harness/` — the harness payload, copied verbatim on `init`.
- `scripts/copy-harness.sh` — deterministic, no-clobber install.
- `scripts/link-codex.sh` — idempotent `AGENTS.md` wiring for Codex.
- `scripts/link-pi.sh` — idempotent `AGENTS.md` wiring for Pi.
- `scripts/link-copilot-cli.sh` — idempotent `AGENTS.md` wiring for Copilot CLI.
- `scripts/link-agy.sh` — idempotent `AGENTS.md` wiring for Google Antigravity CLI.
- `skills/` — the interview and implementation logic the commands and skills rely on.
- `prompts/` — Pi prompt templates for the three harness workflows.

The copied folder is always named `ai-harness/`; this plugin is `sth-harness`.

## Install (local dev)
For Claude Code, add this directory as a plugin (plugin marketplace/local path),
then run `/sth-harness:init` in a target repo.

For Codex, install this directory as a local plugin. Codex reads
`.codex-plugin/plugin.json`, loads the bundled `skills/`, and exposes the
`sth-harness` skill.

For Pi, install this directory as a local package:

```bash
pi install /path/to/sth-harness-plugin
```

Pi reads `package.json`, loads the bundled `skills/` and `prompts/`, and exposes
the namespaced prompt templates above.

For GitHub Copilot CLI, install this directory as a local plugin:

```bash
copilot plugin install /path/to/sth-harness-plugin
```

Copilot CLI reads `plugin.json` and loads the bundled `skills/`. Direct local
installs are useful for development; Copilot CLI warns that marketplace installs
will be the supported path for durable distribution.

For Google Antigravity CLI, install this directory as a local plugin:

```bash
agy plugin install /path/to/sth-harness-plugin
```

Antigravity CLI reads `plugin.json`, loads the bundled `skills/`, and converts
the bundled `commands/` into skills. You can check the package with
`agy plugin validate /path/to/sth-harness-plugin`.
