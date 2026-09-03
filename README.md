<p align="center">
  <img
    src="docs/mimoji-laptop.png"
    alt="John Costanzo Mimoji of him holding a laptop"
    width="220"
  />
</p>

<p align="center">
  <b>:sparkles: John's Dotfiles :sparkles:</b>
</p>

<br />

# Thanks for dropping by!

This repository contains my personal dotfiles, which are configuration files and scripts that customize various aspects of my system. By keeping my dotfiles under version control, I can easily synchronize them across multiple machines and ensure consistency in my development environment.

# Tested OS

- Mac OSX
- Omarchy (Arch + Hyprland)

# Installation

```bash
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)
```

The installer asks which OS to set up: `[1] Mac OSX` or `[2] Omarchy / Arch`.

## Omarchy notes

- **Shell:** stays on Omarchy's bash. `bash/omarchy.bash` is sourced from `~/.bashrc`;
  it pulls in `shell/common.sh` — the portable aliases/functions shared with `.zshrc`.
  Shell-specific bits (p10k, zap, Mac paths) stay in each shell's own rc file.
- **Packages:** `pacman` + `yay` instead of Homebrew; language runtimes via `mise`
  (`pnpm`, `go`, `rust`) instead of Volta.
- **Neovim:** Omarchy's own config stays as the default `nvim`. This repo's config
  is linked to `~/.config/ownnvim` — launch it with `vim2` (`NVIM_APPNAME=ownnvim`).
- **Kept as-is:** Omarchy's `ghostty`, `lazygit`, and `tmux` configs are not
  overwritten (stow skips them). `bin/update` is cross-platform.
- **git:** `credential.helper` is written to `~/.gitconfig.local` per platform
  (`osxkeychain` on Mac, `git-credential-libsecret` on Omarchy).

### Personal tweaks to Omarchy-managed configs

Omarchy owns `~/.config/hypr/*`, `~/.config/omarchy/*`, `~/.config/mise/config.toml`
etc. and **rewrites them** on `omarchy update` (migrations) and `omarchy-refresh-*`.
Symlinking them from `files/` would break. Instead:

- Personal copies live in `omarchy/` (mirroring their `$HOME` path). `bin/omarchy-config`
  manages them: `capture` (`~/` → repo), `apply` (repo → `~/`, backs up differing
  files), `diff` (list drift). `setupOmarchyOverlay` runs `omarchy-config apply`.
- After editing a live Omarchy config: `omarchy-config capture ~/.config/<path>`, then commit.
  Periodically / after `omarchy update`: `omarchy-config diff` to spot drift.
- mise: personal `[settings]` go in `omarchy/.config/mise/conf.d/personal.toml`
  (mise merges `conf.d/*.toml`; Omarchy never touches `conf.d/`).
- Omarchy's own override dirs (`~/.config/omarchy/themes/<name>/`,
  `~/.config/omarchy/hooks/`) are yours by design.

### Installed by hand (not the installer)

- **1Password** — deliberately left out of `setupOmarchyApps`. There is no package
  in the Arch official repos, and installing a password manager through a
  `yay -S` batch invites skimming past the `PKGBUILD`. Install it on its own and
  review the build script first:

  ```bash
  yay -G 1password && $EDITOR 1password/PKGBUILD   # confirm URL is 1password.com + signature check intact
  yay -S 1password 1password-cli
  ```

  The AUR packages pull AgileBits-signed binaries and verify the GPG signature
  (`3FEF9748469ADBE15DA7CA80AC2D62742012EA22`). For a smaller trust surface on the
  GUI, use the 1Password-published Flathub build instead:
  `flatpak install flathub com.onepassword.OnePassword` (no Flatpak for the CLI).

# Customize and Extend

Feel free to modify and customize these dotfiles to suit your needs. Add your own configurations, aliases, and functions, or remove those that you don't find useful. Don't forget to keep your modifications under version control to track your changes.

If you come across useful improvements or additions that you think would benefit others, please consider contributing them back to the repository through pull requests. Sharing your knowledge and enhancements with the community is highly appreciated.

# Acknowledgements

I would like to acknowledge the open-source community and the countless developers who have shared their dotfiles, tips, and tricks. Your contributions have been invaluable in shaping and improving my own setup.

- [Nick Nisi](https://github.com/nicknisi/dotfiles)
- [Christian Chiarulli](https://www.chrisatmachine.com/)
- [Dorian Karter](https://github.com/dkarter/dotfiles)
