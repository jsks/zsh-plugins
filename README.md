zerve
=====

zsh httpd plugin

**zerve** is a spinoff from [czhttpd](http://github.com/jsks/czhttpd) and was inspired by the approach taken from [zshttpd](http://zshwiki.org/home/code/scripts/zshttpd). It's meant to do one thing and one thing only: easily share files on a local network from the commandline. It does so by using zle as a non-blocking event handler which allows us to easily deal with multiple concurrent requests.

####To install:
- Source the script in your `.zshrc`. E.g.:
```
. ~/.config/zsh/scripts/zerve.zsh
```
- For proper mime-type support also install `file`

####Usage:
- Simply issue the command **zerve** within the directory you wish to serve or optionally specifcy the location of document root.
```
zerve ~/
```
- To stop zerve:
```
zerve stop
```

####Configuration:
- To change the tcp port zerve listens on use the global variable _ZRV_PORT:
```
export _ZRV_PORT=8000
```
- Similarly, to edit the string added to $PROMPT:
```
export _ZRV_PROMPT="H-$PROMPT"
```
