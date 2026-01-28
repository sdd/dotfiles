# Dotfiles (chezmoi)

This repository is managed by `chezmoi`. The source state lives in this repo
and is applied into `$HOME` by `chezmoi apply`.

## Setup (new machine)

1) Install chezmoi.
2) Clone this repo and point chezmoi at it:

```sh
git clone git@github.com:sdd/dotfiles.git "$HOME/projects/dotfiles"
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<'EOF'
sourceDir = "/home/you/projects/dotfiles"
EOF
chezmoi apply
```

Use your real home path in `chezmoi.toml` (e.g. `/Users/scott/...`).

## Making changes

- Edit files in the repo (preferred), then `chezmoi apply`.
- Or edit files in `$HOME`, then capture with:

```sh
chezmoi add --follow ~/.zshrc
```

Then commit and push.

## Secrets and machine-specific config

- Secrets are not stored in the repo.
- Store secrets in `~/.config/secrets/env` and source it from shell configs.
- Use `~/.local/bin/refresh-secrets` to generate `env` from 1Password.
- Machine-specific overrides live in local-only files:
  - `~/.zshrc.local`
  - `~/.profile.local`

## Shell file roles and what goes where

General rule: keep shared, portable config in the tracked files, and put
machine-specific bits in the `*.local` files. Avoid secrets in tracked files.

### `~/.zshenv`

- **Status**: managed by chezmoi; do not edit.
- **Purpose**: loaded by *all* zsh invocations (interactive, non-interactive).
- **Behavior**: sources `~/.profile` so all zsh processes get the shared env.

### `~/.profile`

- **Purpose**: shared env setup for both bash and zsh (POSIX).
- **Put here**: portable exports and PATH setup that should apply everywhere.
- **Example**: `path_prepend "$HOME/.local/bin"`

### `~/.profile.local`

- **Purpose**: machine-only overrides shared by bash and zsh.
- **Put here**: host-specific PATH changes, SDK setup, local tool scripts.
- **Example**: `path_prepend "/opt/homebrew/bin"`

### `~/.zprofile`

- **Status**: managed by chezmoi; do not edit. Use `~/.profile`.
- **Purpose**: zsh login stub that sources `~/.profile`.

### `~/.zshrc`

- **Purpose**: interactive shell configuration.
- **Put here**: prompts, aliases, completions, plugins, keybindings.
- **Guard**: tool hooks with `command -v` so a fresh machine doesn’t error.

### `~/.bash_profile`

- **Status**: managed by chezmoi; do not edit. Use `~/.profile`.
- **Purpose**: bash login stub that sources `~/.profile` and `~/.bashrc`.

## zshrc ordering guidelines

- Powerlevel10k instant prompt at the very top.
- Plugin manager bootstrap (zinit) next.
- Plugin loads and plugin config.
- Tool hooks (fnm, direnv) with `command -v` guards.
- Completions/highlighting setup.
- Aliases and small convenience functions.
- Local overrides (`~/.zshrc.local`).
- Secrets import (`~/.config/secrets/env`) last.

Because this repo targets macOS + Linux + Termux, always guard platform- or
tool-specific config with existence checks (e.g. `command -v`, `[ -f ]`),
and prefer zinit-managed installs for missing tools.
