znote
=====

cli note manager with fuzzy matching
- *Original script authored by __@poxar__: [notes.zsh](https://github.com/poxar/dotfiles/blob/master/base/.zsh.d/notes.zsh)*

---
znote provides a series of functions to write, manage, and compile plain text notes written in markdown. It automatically creates a git repository and commits any changes as they occur.

### Dependencies
- `tree`
- `fzf`
- markdown implementation (`markdown.pl`, `discount`, etc etc)
- html-\>text converter (html2text, lynx -dump, etc etc)

### Installation
Add the commands to source the script and reload your zsh configs

```
$ print ". /path/to/znote.zsh" >> $ZDOTDIR/.zshrc
$ . $ZDOTDIR/.zshrc
```


### Configuration
znote can be configured using the following global vars
- `_ZN_EARGS`: cli arguments passed to $EDITOR (default: "'+set autowriteall' '+set ft=markdown'"). *Must be set as an array.*
- `_ZN_DIR`: directory containing all notes (default: ~/notes)
- `_ZN_MD: markdown command (default: `markdown`)
- `_ZN_MD_DIR`: directory containing converted html files (default '$_ZN_DIR/.html/')
- `_ZN_HTML2TXT`: command to convert html to text (default: `html2text`)

### Usage
Any command will automatically create $_ZN_DIR and initialise an empty git repository.

```
znote commands
zn  :   add/edit a note
zrm :   delete a note/folder
zl  :   list all notes
zd  :   view git log of note
zmz :   move note(s) to folder in $_ZN_DIR (same arg order as mv)
zs  :   search notes using grep
zc  :   compile given notes, or if none specified all notes, from md to html
zo  :   convert (md->html->txt) and print note to stdout; if an up-to-date html
        version exists, use that as a cache file
```


