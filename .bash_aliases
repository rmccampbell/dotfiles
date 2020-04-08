#-*- mode: sh -*-

alias sudo='sudo '

alias lld='ls -ldF'
alias lsd='ls -d'

alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'

# alias grep='grep -E --color=auto'
# alias sed='sed -r'
alias esed='sed -r'

export LESS='-R -i'
alias cless='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less'
alias pless='LESSOPEN="| pygmentize -g %s" less'
alias lless='LESSOPEN="| ls -alF --color %s" less'

alias cats='tail -v -n +1'
alias table="column -s $'\\t' -t -n"
alias diffs='diff -s'
alias up='cd ..'
alias c='clear'
ldiff () { diff "$@" | less; }

if type xdg-open &> /dev/null; then
    alias open='xdg-open'
    alias start='xdg-open'
fi

alias py='python3'
alias ipy='ipython3'

alias gitp='git --no-pager'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --cached'
alias ga='git add -A'

p () {
    if [ $# -eq 0 ]; then
        less
    else
        "$@" |& less
    fi
}

whichdo () {
    local path="$(which "${2?}")"
    "$1" "${path:?}" "${@:3}"
}

whichcat () {
    cat "$(which "${1?}")"
}

whichless () {
    local path="$(which "${1?}")"
    less "${path:?}"
}

whichedit () {
    local path="$(which "${1?}")"
    $VISUAL "${path:?}"
}

whichfile () {
    file "$(which "${1?}")"
}

whichll () {
    ls -l "$(which "${1?}")"
}

whichreal () {
    realpath "$(which "${1?}")"
}

whichcd () {
    cd "$(dirname "$(which "${1?}")")"
}

whichlib () {
    ldconfig -p | grep --color=never -F "$@";
}

whichheader () {
    if [ "$1" = "-f" ]; then
        echo "#include <${2:?}>" | cpp -H -x c++ -o /dev/null 2>&1
    else
        echo "#include <${1:?}>" | cpp -H -x c++ -o /dev/null 2>&1 | head -n 1 | sed 's/\.* //'
    fi
}

alias wcat=whichcat
alias wless=whichless
alias wedit=whichedit
alias wfile=whichfile
alias wll=whichll
alias wreal=whichreal
alias wcd=whichcd

lesshelp () {
    if type "${1?}" > /dev/null; then
        if [[ $(type -t "$1") =~ ^(builtin|keyword)$ ]]; then
            help "$@" |& less
        else
            { "$@" --help || "$@" -help || "$@" -h; } |& less
        fi
    fi
}

alias lh=lesshelp

slice () {
    head -n "${2?}" "${3--}" | tail -n "+${1?}"
}

_get_status () {
    local st=$?
    if [ "$1" = "-e" ]; then
        eval "${@:2}"
        st=$?
    elif [ "$#" -ne 0 ]; then
        "$@"
        st=$?
    fi
    return $st
}

status () {
    _get_status "$@"
    echo $?
}

bool () {
    _get_status "$@" && echo true || echo false
}

ret () {
    return "$@"
}

rand () {
    if [ "$1" = "-" ]; then
        cat /dev/urandom
    else
        head -c "${1-64}" /dev/urandom
    fi
}

arand () {
    if [ "$1" = "-n" ]; then
        arand "${@:2}"; echo
    elif [ "$1" = "-" ]; then
        base64 -w 0 /dev/urandom
    else
        local n=${1-100}
        rand $(((n+1)*3/4)) | base64 -w 0 | head -c "$n"
    fi
}

ediff() {
    if [ "X${2}" = "X" ]; then
        echo "USAGE: ediff <FILE 1> <FILE 2>"
    else
        # The --eval flag takes lisp code and evaluates it with EMACS
        emacs --eval "(ediff-files \"$1\" \"$2\")"
    fi
}

count () {
    ls "$@" 2>/dev/null | wc -l
}

isset () {
    if [ "$1" = "-q" ]; then
        [ -n "${!2+x}" ]
    else
        bool isset -q "$@"
    fi
}

settitle () {
    echo -e "\e]0;$1\a"
}

setfg () {
    echo -e "\e]10;$1\a"
}

setbg () {
    echo -e "\e]11;$1\a"
}

hex () {
    if [ "$1" = "-n" ]; then
        hex "${@:2}"; echo
        return
    fi
    hexdump -v -e '/1 "%02x"' "$@"
}

nl () {
    "$@"
    echo
}

# Use to visualize dircolors -p
showcolors () {
    sed -r 's/\b[0-9]{1,2}(;[0-9]{1,2})*\b/\x1b[\0m\0\x1b[0m/g'
}

typewrite () {
    d="${1-.05}"
    while IFS='' read -r -d '' -n 1 char; do
        printf "%c" "$char"
        sleep "$d"
    done
}

cds () {
    cd "$*"
}

# add_to_path () {
#     if [[ "$1" = "-a" ]]; then
#         shift
#         local append=true
#     fi
#     if [[ ! "$PATH" =~ (^|:)${1}($|:) ]]; then
#         if [ "$append" = true ]; then
#             PATH="$PATH:$1"
#         else
#             PATH="$1:$PATH"
#         fi
#     fi
# }

add_to_path () {
    if [[ "$1" = "-a" ]]; then
        shift
        local append=true
    fi
    local pathvar="${2:-PATH}"
    if [[ ! "${!pathvar}" =~ (^|:)${1}($|:) ]]; then
        if [[ "$append" = true ]]; then
            declare -g "$pathvar"="${!pathvar}:$1"
        else
            declare -g "$pathvar"="$1:${!pathvar}"
        fi
    fi
}

# https://unix.stackexchange.com/questions/388519/bash-wait-for-process-in-process-substitution-even-if-command-is-invalid
waitbg () {
    { { eval "$@"; } 3>&1 >&4 4>&- | cat; } 4>&1
}

setdisplay() {
    # export DISPLAY=':0.0'
    export DISPLAY='localhost:0.0'
}

showtoiletfonts ()
{
    for i in "${TOILET_FONT_PATH:=/usr/share/figlet}"/*.{t,f}lf; do
        j=${i##*/}
        j=${j%.*}
        echo "$j:"
        toilet -d "${i%/*}" -f "$j" "$j" "$@"
    done
}
