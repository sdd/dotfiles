# Bootstrap helpers for kak-bundle.

# Bootstrap missing bundles on first startup and provide lightweight status.
hook global KakBegin .* %{
  evaluate-commands %sh{
    marker="$kak_opt_bundle_path/.bootstrap-ok"
    fail_marker="$kak_opt_bundle_path/.bootstrap-failed"
    needs_install=0
    if [ -f "$fail_marker" ]; then
      needs_install=1
    fi
    for plug in $kak_opt_bundle_plugins; do
      if [ ! -d "$kak_opt_bundle_path/$plug" ]; then
        needs_install=1
        break
      fi
      case "$plug" in
        kak-bundle|one.kak) continue ;;
      esac
      if [ ! -f "$kak_opt_bundle_path/$plug-load.kak" ]; then
        needs_install=1
        break
      fi
    done

    if [ "$needs_install" -eq 1 ]; then
      printf "%s\n" "echo -markup {yellow}kak-bundle: installing missing plugins...{default}"
      printf "%s\n" "bundle-install"
      exit 0
    fi

    if [ ! -f "$marker" ]; then
      touch "$marker"
    fi

    if ! command -v kak-lsp >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'kak-lsp not found (LSP disabled until installed)'"
    fi
    if ! command -v rust-analyzer >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'rust-analyzer not found (Rust LSP may not start)'"
    fi
  }
}

# After bundle-install completes, load new plugins in this session.
hook global User bundle-after-install %{
  evaluate-commands %sh{
    marker="$kak_opt_bundle_path/.bootstrap-ok"
    fail_marker="$kak_opt_bundle_path/.bootstrap-failed"
    if [ -z "$kak_opt_bundle_plugins_to_install" ]; then
      exit 0
    fi
    if [ "$kak_opt_bundle_succeeded" = "true" ]; then
      touch "$marker"
      rm -f "$fail_marker"
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
      rm -f "$marker"
      touch "$fail_marker"
      printf "%s\n" "info -title 'kak-bundle' 'Install/update failed. See *bundle-status*.'"
    fi
  }
}
