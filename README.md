# watcherd

watcherd will look for directory changes (added and deleted directories) under the specified path (`-p`) and will execute specified commands or shell scripts (`-a`, `-d`) depending on the event.
Once all events have happened during one round (`-i`), a trigger command can be executed (`-t`).
Note, the trigger command will only be execute when at least one add or delete command has succeeded with exit code 0.

### Modes

watcherd can either use the native [inotifywait](https://linux.die.net/man/1/inotifywait) implementation or if this is not available on your system use a custom bash implementation. The default is to use bash.

### Examples

Assuming `vhost-add.sh` will add nginx vhost config files and `vhost-del.sh` will remove nginx vhost config files, the following will then be able to create new nginx vhosts on-the-fly, simply by adding or deleting folders in your main www directory. The trigger command will simply force nginx to reload its configuration after directory changes occured.

```shell
watcherd -p /var/www -a vhost-add.sh -d vhost-del.sh -t "nginx -s stop"
```

### Usage

```shell
Usage: watcherd -p <path> -a <cmd> -d <cmd> [-t <cmd> -w <str> -i <int> -v]
       watcherd --help
       watcherd --version

watcherd will look for directory changes (added and deleted directories) under
the specified path (-p) and will execute specified commands or shell scripts
(-a, -d) depending on the event. Once all events have happened during one round
(-i), a trigger command can be executed (-t). Note, the trigger command will
only be execute when at least one add or delete command has succeeded with exit
code 0.

Required arguments:
  -p <path>     Path to directoy to watch for changes.
  -a <cmd>      Command to execute when a directory was added.
                The full path of the new dir will be appended as an argument to
				this command.
  -d <cmd>      Command to execute when a directory was deletd.
                The full path of the new dir will be appended as an argument to
				this command.

Optional arguments:
  -t <cmd>      Command to execute after all directories have been added or
                deleted during one round.
                No argument will be appended.
  -w <str>      The directory watcher to use. Valid values are:
                'inotify': Uses inotifywait to watch for directory changes.
                'bash':    Uses a bash loop to watch for directory changes.
                The default is to use 'bash' as the watcher.
  -i <int>      When using the bash watcher, specify the interval in seconds
                for how often to look for directory changes.
  -v            Verbose output.

Misc arguments:
  --help        Show this help screen.
  --version     Show version information.
```
