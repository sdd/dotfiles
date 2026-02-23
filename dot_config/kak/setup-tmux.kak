# tmux integration

try %{ declare-user-mode tmux }
map global user t ':enter-user-mode tmux<ret>' -docstring 'tmux…'
map global normal <c-k> ':enter-user-mode tmux<ret>' -docstring 'tmux…'

define-command -docstring "tmux-split-vertical: split pane side-by-side and attach to current session." tmux-split-vertical %{
  evaluate-commands %sh{
    if [ -z "${kak_client_env_TMUX:-}" ] || ! command -v tmux >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'tmux not available'"
      exit 0
    fi

    session="$kak_session"
    bufname="$kak_bufname"
    buffile="$kak_buffile"
    cwd="$PWD"
    if [ -n "$buffile" ]; then
      cwd=$(dirname "$buffile")
      open_cmd="edit -existing -- $buffile"
    else
      open_cmd="buffer $bufname"
    fi
    session_esc=$(printf "%q" "$session")
    open_cmd_esc=$(printf "%q" "$open_cmd")

    tmux split-window -h -c "$cwd" "kak -c $session_esc -e $open_cmd_esc"
  }
}

define-command -docstring "tmux-split-horizontal: split pane top/bottom and attach to current session." tmux-split-horizontal %{
  evaluate-commands %sh{
    if [ -z "${kak_client_env_TMUX:-}" ] || ! command -v tmux >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'tmux not available'"
      exit 0
    fi

    session="$kak_session"
    bufname="$kak_bufname"
    buffile="$kak_buffile"
    cwd="$PWD"
    if [ -n "$buffile" ]; then
      cwd=$(dirname "$buffile")
      open_cmd="edit -existing -- $buffile"
    else
      open_cmd="buffer $bufname"
    fi
    session_esc=$(printf "%q" "$session")
    open_cmd_esc=$(printf "%q" "$open_cmd")

    tmux split-window -v -c "$cwd" "kak -c $session_esc -e $open_cmd_esc"
  }
}

define-command -docstring "tmux-split-vertical-fzf: split pane side-by-side and open fzf-file." tmux-split-vertical-fzf %{
  evaluate-commands %sh{
    if [ -z "${kak_client_env_TMUX:-}" ] || ! command -v tmux >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'tmux not available'"
      exit 0
    fi

    session="$kak_session"
    cwd="$PWD"
    if [ -n "$kak_buffile" ]; then
      cwd=$(dirname "$kak_buffile")
    fi

    session_esc=$(printf "%q" "$session")
    cmd_esc=$(printf "%q" "require-module fzf; require-module fzf-file; fzf-file")
    tmux split-window -h -c "$cwd" "kak -c $session_esc -e $cmd_esc"
  }
}

define-command -docstring "tmux-split-horizontal-fzf: split pane top/bottom and open fzf-file." tmux-split-horizontal-fzf %{
  evaluate-commands %sh{
    if [ -z "${kak_client_env_TMUX:-}" ] || ! command -v tmux >/dev/null 2>&1; then
      printf "%s\n" "echo -debug 'tmux not available'"
      exit 0
    fi

    session="$kak_session"
    cwd="$PWD"
    if [ -n "$kak_buffile" ]; then
      cwd=$(dirname "$kak_buffile")
    fi

    session_esc=$(printf "%q" "$session")
    cmd_esc=$(printf "%q" "require-module fzf; require-module fzf-file; fzf-file")
    tmux split-window -v -c "$cwd" "kak -c $session_esc -e $cmd_esc"
  }
}

map global tmux '"' ':tmux-split-vertical<ret>' -docstring 'split vertical (same buffer)'
map global tmux '=' ':tmux-split-horizontal<ret>' -docstring 'split horizontal (same buffer)'
map global tmux 'v' ':tmux-split-vertical-fzf<ret>' -docstring 'split vertical (fzf file)'
map global tmux 's' ':tmux-split-horizontal-fzf<ret>' -docstring 'split horizontal (fzf file)'
