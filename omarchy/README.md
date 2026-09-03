# Omarchy config overlay

Personal tweaks to **Omarchy-managed** config files (`~/.config/hypr/*`,
`~/.config/omarchy/*`, `~/.config/mise/*`, terminal configs, ...).

These are **copied** into `$HOME`, not symlinked, because Omarchy rewrites these
files: `omarchy update` migrations `sed`/`mv` them, and `omarchy-refresh-*`
overwrites them wholesale. A symlink would get clobbered and the repo would
silently stop tracking the live file.

## Layout

Files mirror their path under `$HOME`:

```
omarchy/.config/hypr/bindings.lua        -> ~/.config/hypr/bindings.lua
omarchy/.config/mise/conf.d/personal.toml -> ~/.config/mise/conf.d/personal.toml
```

## `omarchy-config` (in `bin/`)

| command | direction | use |
|---|---|---|
| `omarchy-config diff` | — | list tracked files that differ from `~/` (exit 1 if any) |
| `omarchy-config capture` | `~/` -> repo | refresh every already-tracked file from live |
| `omarchy-config capture <path>...` | `~/` -> repo | start tracking (or update) specific file(s) |
| `omarchy-config apply` | repo -> `~/` | copy tracked files into place (backs up differing files) |

`install.sh` -> `setupForOmarchy` -> `setupOmarchyOverlay` runs `omarchy-config apply`
after Omarchy is installed.

## Workflow

- **New tweak:** edit the live file, then `omarchy-config capture ~/.config/<path>`, commit.
- **Ongoing:** `omarchy-config capture` (no args) re-pulls everything tracked; review `git diff`, commit.
- **After `omarchy update`:** `omarchy-config diff` to see what Omarchy changed upstream, then reconcile.
- **New machine / after `git pull`:** `omarchy-config apply` (or just run `./install.sh`).

## What belongs here vs elsewhere

- **Here:** files Omarchy ships and may rewrite.
- **`files/` (stow):** files Omarchy never touches (e.g. `~/.config/gh`, and
  `~/.config/mise/conf.d/` would be safe too, but it is kept here for one clear
  "personal Omarchy tweaks" location).
- **Omarchy's own override dirs:** custom themes go in
  `~/.config/omarchy/themes/<name>/`, hooks in `~/.config/omarchy/hooks/` -
  those are yours by design; track them wherever is convenient.
