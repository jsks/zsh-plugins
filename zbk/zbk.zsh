# Initialize our plugin
if ! whence colors >/dev/null; then
    autoload -U colors && colors
else
    [[ -z $fg ]] && colors
fi

[[ -f ${_ZBK_FILE:=$ZDOTDIR/bookmarks} ]] && . $_ZBK_FILE

function zbk {
    : ${_ZBK_FILE:=$ZDOTDIR/bookmarks}
    : ${_ZBK_COLOR_VAR:="$fg_bold[blue]"}
    : ${_ZBK_COLOR_VAL:="$fg[yellow]"}

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
    [[ -n $(hash -d -m "${(q)1}") ]] && { print "\'$1\' already set"; return }

    if [[ -d "$@[2,-1]" || -f "$@[2,-1]" ]]; then
        print "hash -d $1=\"$@[2,-1]:A\"" >> $_ZBK_FILE
        hash -d $1="$@[2,-1]:A"
    elif [[ -z $1 || -n $2 ]]; then
        print "Invalid directory" >&2
    else
        print "hash -d $1=\"$PWD\"" >> $_ZBK_FILE
        hash -d $1="$PWD"
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

# Use our file cache rather than `hash -d` so that we filter
# only the named dirs we've explicitly defined
function __zbk:list {
    local line

    for line in $(<$_ZBK_FILE); do
        case $line in
            ("hash"|"-d")
                continue;;
            (*)
                if [[ $1 != "ll" ]]; then
                    __util:hl ${line%=*}
                else
                   __util:hl $line
                fi;;
        esac
    done
}
