# x11vnc

[x11vnc](https://github.com/LibVNC/x11vnc) allows you to connect to an x11 display over vnc.

## Install

Ubuntu: `sudo apt-get install x11vnc`

## Starting VNC

```
x11vnc -display :0 -forever -passwd pw
```

`-forever` remain running after the client disconnects.

If you aren't getting screen update try adding `-noxrecord -noxfixes -noxdamage`.

The password above is not secured; anyone who can run `ps` on the machine will see it.

## Creating an X11 Server

By default x11vnc attaches to an existing X Server. `-create` will start a new virtual X server using xvfb if an existing one cannot be found. It's an alias for `-display WAIT:cmd=FINDCREATEDISPLAY-Xvfb`. `WAIT` means x11vnc waits until a VNC client connects before creating the X display.

To create a virtual display before the client connects, create it before running x11vnc using xvfb-run, eg:

```
xvfb-run -f ~/.Xauthority x11vnc -forever -passwd pw &
```

This command places the auth file in the default location so XAUTHORITY doesn't need to be explicitly set for clients.

xvfb-run creates a display on `:99`, so set DISPLAY first, eg:

```
DISPLAY=:99 xterm
```

See [Q-62](https://github.com/LibVNC/x11vnc/blob/master/doc/FAQ.md#q-62-can-i-have-x11vnc-allow-a-user-to-log-in-with-her-unix-username-and-password-and-then-have-it-find-her-x-session-display-on-that-machine-and-then-attach-to-it-how-about-starting-an-x-session-if-one-cannot-be-found)

## SSH Tunnel

Proxy the remote vnc port to localhost

```
ssh -L 5900:localhost:5900 remote
```

See [Tunnelling x11vnc via SSH](https://github.com/LibVNC/x11vnc#tunnelling-x11vnc-via-ssh)

## Connecting using Mac OS X built in Screen Sharing app

Either:

- Open the Screen Sharing app and enter the host and port
- From the command line run `open vnc://<host>:<port>`

To access an x11vnc server from OS X Screen Sharing app, you cannot use the `-ncache` option and have to set a password. Recommended command line params ([ref](https://benjaminknofe.com/blog/2014/06/23/osx-compatible-x11vnc-start-up-command/))

## Black screen when connected to locked XFCE

If [light-locker](https://github.com/the-cavalry/light-locker) has locked the screen after the X11 screen saver has kicked in, display :0 will be blank, and display :1 will have the login window.

`loginctl list-sessions` will show `lightdm` if the login window is present, and `loginctl session-status `loginctl list-sessions | grep lightdm | awk '{print $1}'``will show which display it is using, which may be`:1`or`:2`

Connect to the display as root using `-auth guess` to guess the location of lightdm's MIT-MAGIC-COOKIE file (normally `/var/run/lightdm/root/:1`, which you can find from `ps -Af | grep auth | grep light`), eg:

```
sudo x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -passwd pi -auth guess
```

Connect with your VNC client and login to lightdm, which will cause display :1 and x11vnc to close.

Restart x11vnc on display :0 (doesn't need to be as root, or require auth)

```
x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -passwd pi
```

Reconnect with your VNC client and you should now see your desktop.

See also [#1287171 light-locker breaks x11vnc as service](https://bugs.launchpad.net/ubuntu/+source/light-locker/+bug/1287171)

## References

- [FAQ](https://github.com/LibVNC/x11vnc/blob/master/doc/FAQ.md)
- [ArchLinux Wiki](https://wiki.archlinux.org/title/x11vnc)
- [How to setup x11vnc to access with graphical login screen?](https://askubuntu.com/questions/229989/how-to-setup-x11vnc-to-access-with-graphical-login-screen)
