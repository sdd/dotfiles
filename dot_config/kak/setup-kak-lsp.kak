# kak-lsp bundle + config

bundle kak-lsp https://github.com/kak-lsp/kak-lsp %{
    try %{ declare-user-mode lsp }
    map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
    map global lsp d ':lsp-definition<ret>' -docstring 'definition'
    map global lsp r ':lsp-references<ret>' -docstring 'references'
    map global lsp t ':lsp-type-definition<ret>' -docstring 'type definition'
    map global lsp i ':lsp-implementation<ret>' -docstring 'implementation'
    map global lsp h ':lsp-hover<ret>' -docstring 'hover docs'
    map global lsp R ':lsp-rename<ret>' -docstring 'rename'
    map global lsp n ':lsp-find-error --include-warnings<ret>' -docstring 'next diagnostic'
    map global lsp p ':lsp-find-error --previous --include-warnings<ret>' -docstring 'prev diagnostic'

    set-option global lsp_diagnostic_line_error_sign '!'
    set-option global lsp_diagnostic_line_warning_sign '?'
    set-option global lsp_diagnostic_line_info_sign 'i'
    set-option global lsp_diagnostic_line_hint_sign 'h'

    lsp-enable
    lsp-diagnostic-lines-enable global
    lsp-inline-diagnostics-enable global
    hook -always global KakEnd .* lsp-exit
}

bundle-install-hook kak-lsp %{
  cargo install --locked --force --path .
}

bundle-cleaner kak-lsp %{
  rm ~/.cargo/bin/kak-lsp
}
