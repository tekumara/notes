# ImageMagick

Install:

```
brew install imagemagick
```

To identify existing format

```
identify -format "%x x %y" flyer.pdf
```

## Convert PDFs

Convert PDF to 200dpi image

```
convert -units PixelsPerInch -density 200 flyer.pdf flyer.jpg
```

Convert multiple images to PDF

```
convert *.jpg image.pdf
```

Convert multiple images to PDF at 100dpi

```
convert -units PixelsPerInch -density 100 *.jpg image.pdf
```

## Resize image

Shrink by 50%

```
convert example.png -resize 50% example.png
```

Resize to 1024x760, keeping aspect ratio:

```
convert  -resize 1024X768  source.png dest.jpg
```

Resize an image to a width of 200:

```
convert example.png -resize 200 example.png
```

Resize an image to a height of 100:

```
convert example.png -resize x100 example.png
```

Convert image to PDF and rotate 180 degrees

```
convert -rotate 180 image.jpg image.pdf
```

Rotate and resize:

```
convert -rotate 180 -resize 50% image3.jpg image3b.jpg
```

## References

- [Convert man page](http://linux.die.net/man/1/convert)
- [density and resampling](http://www.imagemagick.org/discourse-server/viewtopic.php?f=2&t=18241)
