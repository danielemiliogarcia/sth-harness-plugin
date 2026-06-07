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

## Maintaining the bundled payload
`template/ai-harness/` is a **version-pinned snapshot** of the canonical
ai-harness. Bundling (instead of fetching at runtime) keeps `init` offline and
deterministic, but the snapshot does not auto-update — it will drift as the
canonical harness evolves. When you want the plugin to ship a newer harness,
re-bundle deliberately and commit:

```bash
# from the plugin root, with <canonical> = path to the up-to-date ai-harness
rm -rf template/ai-harness
cp -R <canonical>/ai-harness template/ai-harness
git add template/ai-harness && git commit -m "chore: re-bundle ai-harness payload"
```

After re-bundling, run the script tests (`tests/*.test.sh`) to confirm the
install + wiring still pass against the new payload.
