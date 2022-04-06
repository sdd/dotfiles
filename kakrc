map global normal v :select-down<ret>
map global normal <a-v> :select-up<ret>
map global normal V :select-vertically<ret>
map global normal <a-f> ": phantom-sel-iterate-next<ret>"
map global normal <a-F> ": phantom-sel-select-all; phantom-sel-clear<ret>"

map global goto f '<esc>Lgoto-file<ret>' -docstring 'file'
map global goto F f -docstring 'file (legacy)'

# use # to comment line and a-# to comment block
map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal '<a-#>' :comment-block<ret> -docstring 'comment block'

# copy selection to system clipboard on yank / cut / cut-replace (y/c/d)
hook global NormalKey y|d|c %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

# user-p and user-P: paste after/before from sys clipboard
map global user P '!xsel --output --clipboard<ret>'
map global user p '<a-!>xsel --output --clipboard<ret>'

# alt-p paste at current position in insert mode
map global insert <a-p> '<a-;>P'

map global insert <tab>   '<a-;><gt>'
map global insert <s-tab> '<a-;><lt>'
set global indentwidth 4
set global tabstop 4
set global ui_options ncurses_assistant=none

addhl global/ number-lines
addhl global/ show-matching

hook global InsertCompletionShow .* %{
     try %{
            # this command temporarily removes cursors preceded by whitespace;
            # if there are no cursors left, it raises an error, does not
            # continue to execute the mapping commands, and the error is eaten
            # by the `try` command so no warning appears.
            execute-keys -draft 'h<a-K>\h<ret>'
            map window insert <tab> <c-n>
            map window insert <s-tab> <c-p>
            #map window insert <ret> <right>
      }
}

hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
    unmap window insert <ret> <right>
}


### TODO: get tjhe below working as per https://github.com/mawww/kakoune/wiki/Ranger
def ranger-sus -docstring 'Open files previously chosen by ranger' %{ %sh{
  while read f; do
    echo "edit $f;"
  done < '/tmp/ranger-files'
}}

def suspend -params 2 %{ %sh{
  nohup sh -c "sleep 0.2; xdotool type '$1'; xdotool key Return" > /dev/null 2>&1 &
  /usr/bin/kill -SIGTSTP $PPID
  echo "$2"
}}

map global user r ':suspend "ranger --choosefiles=/tmp/ranger-files &&fg;history -d $(history 1)" buffer-next<ret>'
