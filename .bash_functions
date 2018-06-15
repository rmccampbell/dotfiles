#-*- mode: sh -*-

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

whichfile () {
    file "$(which "${1?}")"
}

whichll () {
    ls -l "$(which "${1?}")"
}

whichcd () {
    cd "$(dirname "$(which "${1?}")")"
}

whichreal () {
    realpath "$(which "${1?}")"
}

whichlib () {
    ldconfig -p | grep --color=never -F "$1";
}

lesshelp () {
    if type "${1?}" > /dev/null; then
        if [ $(type -t "$1") = "builtin" ]; then
            help "$@" |& less
        else
            "$@" --help |& less
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
    return "${@}"
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

showcolors () {
    sed 's/[0-9]{2}(;[0-9]{2})*/\x1b[\0m\0\x1b[0m/g';
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

add_to_path () {
    if [ "$1" = "-a" ]; then
        shift
        local append=true
    fi
    if [[ ! "$PATH" =~ (^|:)${1}($|:) ]]; then
        if [ "$append" = true ]; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi
}

# add_to_path () {
#     if [[ "$1" = "-a" ]]; then
#         shift
#         local append=true
#     fi
#     local pathvar="${2:-PATH}"
#     if [[ ! "${!pathvar}" =~ (^|:)${1}($|:) ]]; then
#         if [[ "$append" = true ]]; then
#             declare "$pathvar"="${!pathvar}:$1"
#         else
#             declare "$pathvar"="$1:${!pathvar}"
#         fi
#     fi
# }
