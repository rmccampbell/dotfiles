#-*- mode: sh -*-

whichcat ()
{
    cat "$(which "$@")"
}

whichfile ()
{
    file "$(which "$@")"
}

whichcd ()
{
    cd "$(dirname "$(which "${1?}")")"
}

lesshelp ()
{
    "$@" --help | less
}

slice ()
{
    head -n "${2?}" "${3--}" | tail -n "+${1?}"
}

retval ()
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
