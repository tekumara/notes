<div title="x11vnc" creator="YourName" modifier="YourName" created="201711111049" modified="201806160446" changecount="9">
<pre>[[x11vnc|http://www.karlrunge.com/x11vnc/]] allows you to connect to an existing x11 display over vnc

!Starting VNC

To access an x11vnc server from OS X Screen Sharing app, you cannot use the -ncache option and have to set a password. Recommended command line params ([[ref|https://benjaminknofe.com/blog/2014/06/23/osx-compatible-x11vnc-start-up-command/]])

{{{
x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -passwd pw
}}}

{{{-forever}}} remain running after the client disconnects

The password above is not secured; anyone who can run ps on the machine will see it.

!Connecting using Mac OS X built in Screen Sharing app

Either:
* Open the Screen Sharing app and enter the host and port
* From the command line run {{{open vnc://&lt;host&gt;:&lt;port&gt;}}}

!Black screen when connected to locked XFCE

If [[light-locker|https://github.com/the-cavalry/light-locker]] has locked the screen after the X11 screen saver has kicked in, display :0 will be blank, and display :1 will have the login window.

{{{loginctl list-sessions}}} will show {{{lightdm}}} if the login window is present, and {{{loginctl session-status `loginctl list-sessions | grep lightdm | awk '{print $1}'`}}} will show which display it is using, which may be {{{:1}}} or {{{:2}}}

Connect to the display as root using {{{-auth guess}}} to guess the location of lightdm's MIT-MAGIC-COOKIE file (normally {{{/var/run/lightdm/root/:1}}}, which you can find from {{{ps -Af | grep auth | grep light}}}), eg:

{{{
sudo x11vnc -display :1 -noxrecord -noxfixes -noxdamage -forever -passwd pi -auth guess
}}}

Connect with your VNC client and login to lightdm, which will cause display :1 and x11vnc to close.

Restart x11vnc on display :0 (doesn't need to be as root, or require auth)

{{{
x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -passwd pi
}}}

Reconnect with your VNC client and you should now see your desktop.

See also [[#1287171 light-locker breaks x11vnc as service|https://bugs.launchpad.net/ubuntu/+source/light-locker/+bug/1287171]]

!References

https://wiki.archlinux.org/index.php/x11vnc
https://askubuntu.com/questions/229989/how-to-setup-x11vnc-to-access-with-graphical-login-screen</pre>
</div>
