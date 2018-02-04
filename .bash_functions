#-*- mode: sh -*-

whichcat ()
{
    cat "$(which "${1?}")"
}

whichless ()
{
    local path="$(which "${1?}")"
    less "${path:?}"
}

whichfile ()
{
    file "$(which "${1?}")"
}

whichll ()
{
    ls -l "$(which "${1?}")"
}

whichcd ()
{
    cd "$(dirname "$(which "${1?}")")"
}

lesshelp ()
{
    if type "${1?}" > /dev/null; then
        if [ $(type -t "$1") = "builtin" ]; then
            help "$@" |& less
        else
            "$@" --help |& less
        fi
    fi
}

alias lh=lesshelp

slice ()
{
    head -n "${2?}" "${3--}" | tail -n "+${1?}"
}

status ()
{
    eval "$@"
    echo $?
}

bool ()
{
    eval "$@" && echo true || echo false
}

rand ()
{
    head -c "${1-64}" /dev/urandom
}

arand ()
{
    if [ "$1" = "-n" ]; then
        nl arand "${@:2}"
        return
    fi
    n=${1-10}
    rand $(((n+1)*3/4)) | base64 -w 0 | head -c "$n"
}

ediff() {
    if [ "X${2}" = "X" ]; then
        echo "USAGE: ediff <FILE 1> <FILE 2>"
    else
        # The --eval flag takes lisp code and evaluates it with EMACS
        emacs --eval "(ediff-files \"$1\" \"$2\")"
    fi
}

count ()
{
    ls "$@" 2>/dev/null | wc -l
}

isset ()
{
    [ -n "${!1+x}" ]
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
        nl hex "${@:2}"
        return
    fi
    hexdump -v -e '/1 "%02x"' "$@"
}

nl () {
    "$@"
    echo
}
