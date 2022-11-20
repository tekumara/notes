# fonts

## Nerd fonts

[Nerd fonts](https://github.com/ryanoasis/nerd-fonts) are a patched versions of the base font to include additional glyphs/icons for use in shell prompts and development.

## Install

Install [Meslo LG nerd fonts](https://github.com/Homebrew/homebrew-cask-fonts/blob/master/Casks/font-meslo-lg-nerd-font.rb):

```
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
```

The choose `Meslo LGM Nerd Font` in your editor.

## Manual patching

Monaco is an Apple font which can't be redistributed. Instead it can be manually [patched](https://github.com/ryanoasis/nerd-fonts#font-patcher) for personal use.

Use FontForge to adjust the height of a patched font if it ends up different from the original.
