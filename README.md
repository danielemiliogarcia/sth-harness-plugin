# sth-harness

A Claude Code plugin that installs and drives the model-agnostic **ai-harness**
(spec-driven, hexagonal, stateful, resumable development in folders + Markdown).

## Commands
- `/sth-harness:init [feature-name]` — copy the harness into this repo, interview
  to fill `context/project.md`, then create your first feature's `spec.md` +
  `state.md`.
- `/sth-harness:add-spec [feature-name]` — in an initialized repo, interview for a
  new feature and create its files.
- `/sth-harness:execute-next-spec` — pick the next pending spec (you confirm) and
  work it through the harness until blocked, a decision is needed, or it is done.

## What it ships
- `template/ai-harness/` — the harness payload, copied verbatim on `init`.
- `scripts/copy-harness.sh` — deterministic, no-clobber install.
- `skills/` — the interview and execution logic the commands rely on.

The copied folder is always named `ai-harness/`; this plugin is `sth-harness`.

## Install (local dev)
Add this directory as a plugin in Claude Code (plugin marketplace/local path),
then run `/sth-harness:init` in a target repo.
