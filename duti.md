# duti

`duti -d public.mp3` list default handler for uti  
`duti -l public.mp3` list all handlers for uti  
`duti -x .mp3` list default handler for extension mp3  
`duti -s org.videolan.vlc public.mp3 all` set VLC as the default handler for the MP3 MIME type
`mdls -name kMDItemContentType <filename>` show the uti for a give file

Get the app id (ie: bundle_id) of vscode:

```
osascript -e 'id of app "Visual Studio Code"'
```

See also:

- [moretension/duti](https://github.com/moretension/duti)
- [Introduction to Uniform Type Identifiers Overview](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_intro/understand_utis_intro.html)

## Troubleshooting

[Finder still shows old default #38](https://github.com/moretension/duti/issues/38)

After applying a change Finder may still show the old default. However both Finder and `open` will use the new default handler.
