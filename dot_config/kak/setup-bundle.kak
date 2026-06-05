# kak-bundle bootstrap and plugin declarations that rarely change.

evaluate-commands %sh{
  # We're assuming the default bundle_path here...
  plugins="$kak_config/bundle"
  mkdir -p "$plugins"
  [ ! -e "$plugins/kak-bundle" ] && \
    git clone -q https://codeberg.org/jdugan6240/kak-bundle "$plugins/kak-bundle"
  printf "%s\n" "source '$plugins/kak-bundle/rc/kak-bundle.kak'"
}

bundle-noload kak-bundle https://codeberg.org/jdugan6240/kak-bundle

bundle-theme one.kak https://codeberg.org/raiguard/kak-one.git
bundle-install-hook one.kak %{
  mkdir -p "${kak_config}/colors"
  # Keep the symlink to the repo (not required, but convenient for discovery).
  rm -rf "${kak_config}/colors/one.kak"
  ln -s "${kak_opt_bundle_path}/one.kak" "${kak_config}/colors/one.kak"
  # Expose actual theme files where Kakoune expects them.
  for file in "${kak_opt_bundle_path}/one.kak/colors/"*.kak; do
    [ -e "$file" ] || continue
    ln -sf "$file" "${kak_config}/colors/$(basename "$file")"
  done
}
bundle-cleaner one.kak %{
  rm -rf "${kak_config}/colors/one.kak"
  for file in "${kak_config}/colors/one-"*.kak; do
    [ -e "$file" ] || continue
    rm -f "$file"
  done
}

# best default colorscheme
# colorscheme desertex
# Try to load the theme if already installed; otherwise defer until after bootstrap.
try %{
    colorscheme one-dark
}

bundle powerline https://github.com/andreyorst/powerline.kak %{
    try %{
        require-module powerline
        powerline-theme gruvbox
        powerline-separator arrow
        powerline-toggle-module client
        powerline-start
    }
}

bundle kakoune-snippets https://github.com/occivink/kakoune-snippets
bundle kakoune-vertical-selection https://github.com/occivink/kakoune-vertical-selection
bundle-customload kakoune-mouvre https://github.com/krornus/kakoune-mouvre %{
  # Minimal load: needed for search-no-wrap (kakoune-cargo dependency).
  source "%opt{bundle_path}/kakoune-mouvre/mouvre.kak"
}
bundle-customload kakoune-cargo https://github.com/krornus/kakoune-cargo %{
  source "%opt{bundle_path}/kakoune-cargo/cargo.kak"
  # Make cleanup hooks resilient when no highlighters exist.
  try %{ remove-hooks global cargo-compiler }
  hook -group cargo-compiler global WinSetOption compiler=(?!cargo).* %{
    try %{ remove-highlighter window/cargo }
    remove-hooks window cargo-hooks
  }
}
