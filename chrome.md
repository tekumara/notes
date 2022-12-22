# Chrome

## Modifying a Chrome App icon

1. Convert your image to a `.icns`. image2icon (`brew cask install image2icon`) is good and can work with images of any dimensions.
1. Copy your `.icns` file to `~/Applications/Chrome\ Apps.localized/$APP_NAME/Contents/Resources/app.icns`
1. Refresh the icon cache: `touch ~/Applications/Chrome\ Apps.localized/$APP_NAME`
1. Restart the Dock: `sudo killall Dock`

[ref](https://www.sethvargo.com/replace-icons-osx/)

## Deleting a url suggestion from the autocomplete bar

- Select the suggestion
- On a Macbook Pro laptop keyboard: shift - fn - delete
- On an Apple keyboard: shift - delete x

NB: you can't delete suggestions that are bookmarks. Remove the bookmark instead.

## Inspecting shared workers

1. Visit chrome://inspect/#workers
1. Click inspect on the worker
1. Devtools will appear with the worker's console log

You can now navigate to the worker source and place breakpoints.
