# Name: znote
# Description: cli note manager with fuzzy matching
# Original Author: github.com/poxar
# Original script: https://github.com/poxar/dotfiles/blob/master/base/.zsh.d/notes.zsh
# Modified by: jsks
###

## Wrapper function
function __znote {
    [[ -z $_ZN_EARGS ]] && _ZN_EARGS=('+set autowriteall' '+set ft=markdown')
    : ${_ZN_DIR:=$HOME/notes}
    : ${_ZN_MD:=markdown}
    : ${_ZN_MD_DIR:=.html}
    : ${_ZN_HTML2TXT:=html2text}

    for i in "tree" "fzf" ${_ZN_MD[(ws. .)1]} ${_ZN_HTML2TXT[(ws. .)1]}; do
        __util:check $i || return 1
    done

    mkdir -p $_ZN_DIR &>/dev/null
    cd $_ZN_DIR

    if ! git status &>/dev/null; then 
        git init
        print $_ZN_MD_DIR >> .gitignore
        for i in ".gitignore" ./**/*(.Nr); do
            git add $i
            git commit -m "added/modified -> '${i:t}'"
        done
    fi

    case $1 in
        ("add")
            __z:add ${@[2,-1]};;
        ("rm")
            __z:rm ${@[2,-1]};;
        ("cat")
            __z:cat ${@[2,-1]};;
        ("compile")
            __z:compile ${@[2,-1]};;
        ("ls")
            __z:list;;
        ("search")
            __z:search ${@[2,-1]};;
        ("diff")
            __z:diff ${@[2,-1]};;
        ("mv")
            __z:mv ${@[2,-1]};;
        ("restore")
            __z:restore ${@[2,-1]};;
        (*)
            __z:help;;
    esac

    cd - >/dev/null
}

## Utility functions
function __util:check {
    if ! whence $1 >/dev/null; then
        print "Could not find $1...aborting"
        return 1
    fi
}

function __util:md {
    local i

    for i in "$1"*(Nr); do
        if [[ -d "$i" ]]; then
            INDEX+="<li>$i/<ul>"
            mkdir -p "$_ZN_MD_DIR/$i" &>/dev/null
            __util:md "$i/"

            INDEX+="</ul></li>"
            continue
        fi

        if [[ ! -f "$_ZN_MD_DIR/$i.html" || "$_ZN_MD_DIR/$i.html" -ot "$i" ]]; then
            ${(z)_ZN_MD} "$i" > "$_ZN_MD_DIR/$i.html"
        fi

        INDEX+="<li><a href="$i.html">${i:t}</a></li>"
    done
}

## Main functions
function __z:add {
    mkdir ${*:h} &>/dev/null || { print "Could not create ${*:h}"; return 1 }

    local f="$(fzf -1 -0 -q "$*")"
    ${EDITOR:-vim} ${_ZN_EARGS[@]} -- "${f:-$*}"

    git add "${f:-$*}"
    git commit -m "added/modified -> '${f:-$*}'"
}

function __z:cat {
    setopt local_options multios

    local f="$(fzf -1 -0 -q "$*")"
    [[ -z $f ]] && return

    if [[ -f "$_ZN_MD_DIR/$f.html" && "$_ZN_MD_DIR/$f.html" -nt $f ]]; then
        ${(z)_ZN_HTML2TXT} "$_ZN_MD_DIR/$f.html"
    else
        ${(z)_ZN_MD} "$f" > "$_ZN_MD_DIR/$f.html" | ${(z)_ZN_HTML2TXT}
    fi
}

function __z:compile {
    mkdir $_ZN_MD_DIR &>/dev/null
    if [[ -n $* ]]; then
        for i in $@; do
            local f="$(fzf -1 -0 -q "$i")"
            [[ -z $f ]] && continue

            mkdir -p $_ZN_MD_DIR/${f:h} &>/dev/null
            ${(z)_ZN_MD} "$f" > "$_ZN_MD_DIR/$f.html"
        done

        return
    fi

    local INDEX="<!DOCTYPE html><html><head><title>znote</title></head><body><h3>Notes</h3><ul>"
    __util:md
    INDEX+="</ul></body></html>"

    print $INDEX > $_ZN_MD_DIR/index.html
}

function __z:diff {
    git log -p "$(fzf -1 -0 -q "$*")"
}

function __z:help {
<<EOF
znote commands
zn  :   add/edit a note
zrm :   delete a note/folder
zl  :   list all notes
zd  :   view git log of note
zmz :   move note(s) within $_ZN_DIR (same arg order as mv)
zs  :   search notes using grep
zc  :   compile given/all notes from markdown to html
zu  :   restore a deleted note
zo  :   convert (md->html->txt) & print note to stdout; if an up-to-date html 
        version exists, use that as a cache file
EOF
}

function __z:list { 
    =tree -DFCt --noreport $_ZN_DIR
}

function __z:mv {
    local i

    for i in ${@[1,-2]}; do
        local f="$(fzf -1 -0 -q $i)"
        [[ -z $f ]] && continue

        git mv "$f" ${@[-1]}
        git commit -m "moved -> '$f'"
    done
}

function __z:restore {
    local commit

    commit=$(git rev-list -n 1 HEAD -- "$*")
    [[ -z $commit ]] && { print "Deleted file not found"; return }

    git checkout "$commit^" -- "$*"

    git add "$*"
    git commit -m "restored -> '$*'"
}

function __z:rm {
    local f="$(fzf -1 -0 -q "$*")"
    [[ -z $f ]] && return

    git rm -r "$f" >/dev/null
    git commit -m "deleted -> '$f'"
}

function __z:search {
    =grep -inr --color=always -- "$*" *
}

## File/dir completion
compdef "_path_files -W ${_ZN_DIR:-$HOME/notes}" __znote

## Happy aliases are happy
alias zn="__znote add $*"
alias zrm="__znote rm $*"
alias zo="__znote cat $*"
alias zl="__znote ls $*"
alias zd="__znote diff $*"
alias zmz="__znote mv $*"
alias zs="__znote search $*"
alias zc="__znote compile $*"
alias zu="__znote restore $*"
alias zh="__znote help"
