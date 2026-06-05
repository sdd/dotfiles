# Bootstrap missing kak-bundle plugins on startup.
hook global KakBegin .* %{
  evaluate-commands %sh{
    plugins_to_install=""
    for plug in $kak_opt_bundle_plugins; do
      if [ ! -d "$kak_opt_bundle_path/$plug" ]; then
        plugins_to_install="$plugins_to_install $plug"
        continue
      fi
      case "$plug" in
        kak-bundle|one.kak) continue ;;
      esac
      if [ ! -f "$kak_opt_bundle_path/$plug-load.kak" ]; then
        plugins_to_install="$plugins_to_install $plug"
        continue
      fi
    done

    if [ ! -f "$kak_config/colors/one-dark.kak" ]; then
      case " $plugins_to_install " in
        *" one.kak "*) ;;
        *) plugins_to_install="$plugins_to_install one.kak" ;;
      esac
    fi

    if [ -n "$plugins_to_install" ]; then
      printf "%s\n" "echo -markup {yellow}kak-bundle: installing missing plugins...{default}"
      printf "%s\n" "bundle-install$plugins_to_install"
      exit 0
    fi

    if ! command -v kak-lsp >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'kak-lsp not found; run :bundle-install kak-lsp'"
    fi
    if ! command -v rust-analyzer >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'rust-analyzer not found (Rust LSP may not start)'"
    fi
  }
}

# After bundle-install completes, load new plugins in this session.
hook global User bundle-after-install %{
  evaluate-commands %sh{
    if [ -z "$kak_opt_bundle_plugins_to_install" ]; then
      exit 0
    fi
    if [ "$kak_opt_bundle_succeeded" = "true" ]; then
      for plug in $kak_opt_bundle_plugins_to_install; do
        case "$plug" in
          kak-bundle|one.kak|kak-lsp) continue ;;
        esac
        load="$kak_opt_bundle_path/$plug-load.kak"
        if [ -f "$load" ]; then
          printf "try %%{ source '%s' }\n" "$load"
        fi
      done
      if [ -f "$kak_config/colors/one-dark.kak" ]; then
        printf "%s\n" "colorscheme one-dark"
      fi
      printf "%s\n" "echo -markup {green}kak-bundle: plugins ready.{default}"
    else
      printf "%s\n" "info -title 'kak-bundle' 'Install/update failed. See *bundle-status*.'"
    fi
  }
}
