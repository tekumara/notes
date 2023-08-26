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

## Exceptions

When the file has an invalid crc, [convert will fail](https://github.com/ImageMagick/ImageMagick/issues/5329):

```
❯ pngcheck bad-crc.png
bad-crc.png  EOF while reading CRC value
ERROR: bad-crc.png
❯ convert bad-crc.png -resize 80%
convert: Expected 4 bytes; found 2 bytes `bad-crc.png' @ warning/png.c/MagickPNGWarningHandler/1526.
convert: Read Exception `bad-crc.png' @ error/png.c/MagickPNGErrorHandler/1492.
convert:  `80%' @ error/convert.c/ConvertImageCommand/3351.
```

## References

- [Convert man page](http://linux.die.net/man/1/convert)
- [density and resampling](http://www.imagemagick.org/discourse-server/viewtopic.php?f=2&t=18241)
