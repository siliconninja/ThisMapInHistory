# This Map In History

A Ruby backend server template that allows a user to view events in the USA by state and by date.

Uses Sinatra for the backend, and Nokogiri for web scraping.

# Sources for historical information
Wikipedia's [On this day](https://en.wikipedia.org/wiki/Wikipedia:On_this_day/Today) and [US History Timeline](https://en.wikipedia.org/wiki/Timeline_of_United_States_history) (may take more work for scraping dates and states; license - [CC BY-SA 3.0 Unported](https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported_License))

Unfortunately, I cannot include the data from OnThisDay.com, formerly Historyorb ([OnThisDay.com](http://www.onthisday.com/countries/usa)) as a source of these events because it is licensed under copyright. They do not have an official API or similar that I can use.

# Release Information

Project is currently released (version 1.0 with complete documentation).

# Instructions/documentation for running the app (client-side, Linux/Mac/Windows)

## Windows
**NOTE**: Running this app on Windows requires extra steps and different command-line syntax. (This tutorial *might* work with [Win10 Linux Subsystem and Ubuntu](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide), this is unconfirmed)

Systemctl will NOT work because Windows uses a different startup technique (try a batch script instead).

It will also not work in Windows Subsystem for Linux (https://github.com/Microsoft/BashOnWindows/issues/994#issuecomment-252482274).

Therefore, if using Windows, instructions in the [Run This Map In History at Startup](#Run-This-Map-In-History-at-Startup) section do not apply.

### Download Ruby for Windows

Download binaries for the executable installer: https://rubyinstaller.org/

Source code: https://github.com/oneclick/rubyinstaller2

**Intel/AMD/other CPU architecture 64-bit systems: use the x64 download.**

### Windows Subsystem for Linux

NOTE THE FOLLOWING DIFFERENCES with Windows Subsystem for Linux:

> After installation your Linux distribution will be located at: %localappdata%\lxss\.
> Avoid creating and/or modifying files in %localappdata%\lxss\ using Windows tools and apps! If you do, it is likely that your Linux files will be corrupted and data loss may occur.

(https://msdn.microsoft.com/en-us/commandline/wsl/install_guide)

Install git using apt or apt-get and use git clone on this repository in this case.

## Linux/Mac Client-side Instructions (for testing or demo purposes)
**YOU MUST HAVE** `ruby` and `ruby-bundler` **INSTALLED ON YOUR SERVER OR CLIENT MACHINE**.

Install Ruby Gems from the Gemfile:

```shell
bundle install
```

Run the server application:

Run locally on a given port:

```shell
ruby application_controller.rb -o 127.0.0.1
```

Go to 127.0.0.1:4567 in your web browser to launch the application.

Press `Ctrl`+`C` at any time to stop the server application.

## On a server (for production use/production purposes)

You can also configure whether you want the app to run under a reverse proxy or open via your server's IP address and Nginx as a webserver using default config.

### Reverse proxy

[Nginx configuration proxy-pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) and using mydomain.com (firewall note - port 443 or 80 depending on your Nginx HTTP/HTTPS config needs to be opened) or my.server.ip.address:anotherportnumber - note that your server's firewall needs the specified port number open if using this approach)

#### Example Nginx Configuration for proxy_pass

Use the following configuration inside a server block - i.e. inside **server** { ... } but **after** whatever server_name [ip or domain] and listen [port] combination and (HTTPS only - SSL configuration) you have - in this case, order does matter, but [order for Nginx config lines can sometimes not matter in different situations, explanation of this here](https://serverfault.com/questions/836504/does-order-of-lines-matter-in-nginx))

```nginx
location / {
    proxy_pass       http://localhost:4567;
    proxy_set_header Host      $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### Server's IP using Nginx in default config

This will allow your server's IP address to access the webapp using Nginx's default config: (i.e. using my.server.ip.address:4567 - note that your server's firewall needs this port open if using this approach).

If you want to use your server's IP address as to where people will access the web app, use

```shell
ruby application_controller.rb -o 0.0.0.0
```

Press `Ctrl`+`C` at any time to stop the server application.

## Run This Map In History at Startup

If you want This Map In History to run at startup of your web server using systemd .service files, download the master branch of [systemd-example-startup](https://github.com/arjun024/systemd-example-startup). Nginx will usually be automatically set to run on startup. To check, type the `sudo systemctl enable nginx.service` command. If a "symlink created" message pops up, it has not been configured to run on startup. If it is, it not show any extra output, but it will still be enabled.

In the **example.service** file, rename it to **this-map-in-history.service** and use the following configuration. Afterwards, follow the README.md (copy the this-map-in-history.service file to /etc/systemd/system - Ubuntu 16.04 LTS/Debian 9 or similar location) and enable it using `sudo systemctl enable this-map-in-history.service`:

```markdown
# location: /etc/systemd/system/
[Unit]
Description = This Map In History - Ruby webapp
After       = syslog.target

[Service]
# make sure the shell script is executable (chmod +x $1)
# and it begins with a shebang (#!/bin/bash)
# (it does not need to be a shell script, it can be a command also)
ExecStart   = ruby application_controller.rb -o 0.0.0.0

# In this script TMIH is run and the file /run/this-map-in-history-webapp.pid is created.
# This tells the service how to kill it / reload using the /run/this-map-in-history-webapp.pid file.
ExecStop    = kill -INT `cat /run/this-map-in-history-webapp.pid`
ExecReload  = kill -TERM `cat /run/this-map-in-history-webapp.pid`

# In case if it gets stopped, restart it immediately
Restart     = always


# With notify Type, service manager will be notified
# when the starting up has finished
Type        = notify

# Since Type is notify, notify only service updates
# sent from the main process of the service
NotifyAccess = main

# systemd gets to read the PID of daemon's main process
# see ExecStop and ExecReload
PIDFile     = /run/this-map-in-history-webapp.pid

[Install]
# multi-user.target corresponds to run level 3
# roughtly meaning wanted by system start
WantedBy = multi-user.target
```

# License

MIT License

Collaborators: Clink123, dankong
