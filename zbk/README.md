zbk
===
bookmark manager

-----
*zbk* provides a simple way to handle dir/file bookmarks in `zsh` using named directories. What makes *zbk* special? Absolutely nothing :), there's loads of bookmark scripts, this is simply what I use.

### Dependencies
- `sed`

### Installation
You know the drill

```
$ print ". /path/to/zbk.zsh" >> $ZDOTDIR/.zshrc
$ . $ZDOTDIR/.zshrc
```

### Configuration
There are 3 global vars:
- `_ZBK_FILE`: file that preserves our named directories to rebuild our hash
- `_ZBK_COLOR_VAR`: color for bookmarks
- `_ZBK_COLOR_VAL`: color for dir/file values

## Usage
```
zbk - zsh bookmark manager
USAGE: zbk [COMMAND] <bookmark> <file/dir>

Commands:
    a  | add      :   add a bookmark (default command)
    d  | delete   :   delete a bookmark
    l  | list     :   list all bookmarks
    ll | longlist :   list bookmarks and their dir/file values
Note: If no command is given, zbk defaults to 'add'
```

Bookmarks are added to `zsh`'s named directory hash and can be accessed by prefixing their name with `~`.  
Ex.:

```
$ zbk a foo $ZDOTDIR
$ cd ~foo
```

Directory paths are always expanded so that the following works:

```
$ zbk a bar .
```
