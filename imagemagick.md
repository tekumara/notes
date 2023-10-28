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

[Pad image](https://www.imagemagick.org/script/command-line-options.php#extent)

```
convert example.png -gravity center -background white -resize 256x256 -extent 256x256 example.png
```

Extract a circle of radius 128 with a transparent background:

```
magick example.png \( +clone -threshold 101% -fill white -draw 'circle %[fx:int(w/2)],%[fx:int(h/2)] %[fx:int(w/2)],%[fx:128+int(h/2)]' \) -channel-fx '| gray=>alpha' circle.png
```

NB: the circle might have a flat edge if the radius is = half the width. Reduce the radius by one.

## Composites

Create a white image:

```
magick -size 256x256 xc:white bg.png
```

Add the smaller quill4.png onto the white image to make it bigger:

```
magick composite quill4.png bg.png quill5.png
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
- [Composition of Multiple Pairs of Images](https://imagemagick.org/Usage/layers/#composition)
