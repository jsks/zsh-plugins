zerve
=====

zsh httpd plugin

**zerve** is a spinoff from [czhttpd](http://github.com/jsks/czhttpd) and was inspired by the approach taken from [zshttpd](http://zshwiki.org/home/code/scripts/zshttpd). It's meant to do one thing and one thing only - easily share files on a local network from the commandline. It does so by using zle as a non-blocking event handler which allows us to easily deal with multiple concurrent requests.

#### Optional Dependency:

For proper mime-type support:
- `file`

#### Usage:
Place the script wherever is most convenient and source the location of `zerve.zsh` in your `.zshrc`.

```
Usage: zerve [optional command] <file or dir>
Available Commands: stop
```
