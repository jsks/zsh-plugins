zerve
=====

zsh httpd plugin

**zerve** is a spinoff from [czhttpd](http://github.com/jsks/czhttpd) and was inspired by the approach taken from [zshttpd](http://zshwiki.org/home/code/scripts/zshttpd). It's meant to do one thing and one thing only: easily share files on a local network from the commandline. It supports dynamic directory listing and uses zle as a non-blocking event handler.

####To install:
- Source the script in your `.zshrc`. E.g.:
```
. ~/.config/zsh/scripts/zerve.zsh
```
- For proper mime-type support also install `file`

####Usage:
- Simply issue the command **zerve** within the directory you wish to serve or optionally specify the location of document root:
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
export _ZRV_PROMPT="H:$_ZRV_DOCROOT[$_ZRV_PORT]-$PROMPT"
```

#### Caveats
- Although zle is non-blocking, the handler used to deal with each incoming request is not. To lessen the amount of time that input in the terminal is blocked **zerve** closes each connection connection after every request.
- There is no limit to the number of concurrent connections.


