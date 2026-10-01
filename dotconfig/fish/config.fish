if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test "$TERM" = xterm-kitty
    set -x TERM xterm-256color
end

init_functions
init_aliases

fetch
