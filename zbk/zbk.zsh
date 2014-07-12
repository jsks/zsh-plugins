# Initialize our plugin
if ! whence colors; then
    autoload -U colors && colors
else
    [[ -z $fg ]] && colors
fi

: ${_ZBK_FILE:=$ZDOTDIR/bookmarks}
: ${_ZBK_COLOR_VAR:="$fg_bold[blue]"}
: ${_ZBK_COLOR_VAL:="$fg[yellow]"}


if [[ ! -f $_ZBK_FILE ]]; then
    touch $_ZBK_FILE
else
    . $_ZBK_FILE
fi

function zbk {
    case ${(L)1} in
        ("d"|"delete")
            __zbk:delete $2;;
        ("a"|"add")
            __zbk:add $@[2,-1];;
        ("h"|"help")
            __zbk:help;;
        ("l"|"list")
            __zbk:list;;
        ("ll"|"longlist")
            __zbk:list "ll";;
        (*)
            if [[ -d "$@[2,-1]" ]]; then
                __zbk:add $*
            else
                print "Invalid command" >&2
                __zbk:help
                return 113
            fi;;
    esac
}

function __util:hl {
    local i

    print -n "$_ZBK_COLOR_VAR"
    for i in ${(s..)*}; do
        case $i in
            (=)
                print -n " $_ZBK_COLOR_VAL";;
            (*)
                print -n "$i";;
        esac
    done
    print "$reset_color"
}

function __zbk:add {
    hash -d -m "${(q)1}" && { print "\'$1\' already set"; return }

    if [[ -d "$@[2,-1]" || -f "$@[2,-1]" ]]; then
        print "hash -d $1=\"$@[2,-1]:A\"" >> $_ZBK_FILE
        hash -d $1="$@[2,-1]:A"
    else
        print "Invalid directory" >&2
    fi
}

function __zbk:delete {
    unhash -d $1 2>/dev/null && sed -i '' "/$1=*/d" $_ZBK_FILE
}

function __zbk:help {
<<EOF
zbk - zsh bookmark manager
USAGE: zbk [COMMAND] <bookmark> <file/dir>

Commands:
    a  | add      :   add a bookmark (default command)
    d  | delete   :   delete a bookmark
    l  | list     :   list all bookmarks
    ll | longlist :   list bookmarks and their dir/file values

Note: If no command is given, zbk defaults to 'add'
EOF
}

function __zbk:list {
    local line

    for line in $(<hash -d -m); do
        if [[ $1 != "ll" ]]; then
            __util:hl ${line%=*}
        else
            __util:hl $line
        fi
    done
}