# Open Broadcaster Software (OBS)

[OBS Studio](https://obsproject.com/) is a video compositing and streaming application. It allows you to combine input from your camera with screen sharing, images overlays and other sources, and then stream the output to Twitch, YouTube and other streaming services.

For a good overview, see this video - [In-Depth: How to setup OBS Studio with overlays and TwitchAlerts](https://www.youtube.com/watch?v=dk4ykvUVd2M)

## Install OBS
```
brew cask install obs
```

When you first run OBS you'll see the message "OBS would like to receive keystrokes from any application". This allows you to use OBS hotkeys when other applications have focus.

You can ignore the auto-configuration wizard if you don't want to set up a streaming destination eg: Twitch, Youtube.

## Virtual cam on Mac OS

The [johnboiles/obs-mac-virtualcam](https://github.com/johnboiles/obs-mac-virtualcam) OBS plugin allows you to start a virtual camera from with OBS. This allows the OBS output to be piped to video conferencing software and other apps.

Installing the virtual cam requires building OBS from source. It's not as terrifying as it sounds.

The virtual cam is temporary and doesn't persist when OBS is closed. This is a little bit painful because you have to start the virtual cam before you start your application, eg: Chrome.

## Mirror text

To mirror text (if your video conferencing software does this automatically): Select the text source, Transform -> Flip Horizontal 

## Troubleshooting window capture

If the dropdown doesn't list your windows (or their name is null), make sure you have allowed OBS access in Security & Privacy - Privacy - Screen Recording ([ref](https://obsproject.com/forum/threads/solved-window-capture-list-not-showing-all-windows.114449/))

If you can see the window in the Window Capture dialog box, but not on the scene, try Transform - Reset Transform.

If that doesn't work, double click on the Window Capture source, and then click OK. It might refresh.