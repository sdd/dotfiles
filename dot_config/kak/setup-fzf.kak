# fzf.kak bundle + config

bundle fzf.kak https://github.com/andreyorst/fzf.kak %{
    map global user f %{:fzf-mode <ret>} -docstring "FZF mode"
}

# FZF plugin configuration
evaluate-commands %sh{
  if command -v fzf >/dev/null 2>&1; then
    printf "%s\n" "map global normal <c-p> ': fzf-mode<ret>'"
  else
    printf "%s\n" "echo -debug 'fzf not found (fzf.kak mapping disabled)'"
  fi
}

# FZF performance and filtering tweaks.
hook global ModuleLoaded fzf %{
    # Faster startup: avoid heavy previews by default.
    set-option global fzf_preview false
}

# Options from fzf-file module need the module loaded first.
hook global ModuleLoaded fzf-file %{
    # Use ripgrep for file lists and ignore VCS internals.
    set-option global fzf_file_command "rg --files --hidden -g '!.git/**'"
    set-option global fzf_file_preview false

    # Rust QoL: ignore target/ in fzf file search.
    hook global -group fzf-file-rust BufSetOption filetype=rust %{
        set-option buffer fzf_file_command "rg --files --hidden -g '!.git/**' -g '!target/**' -g '!**/target/**'"
    }
}
