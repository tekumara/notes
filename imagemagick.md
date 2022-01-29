<div title="Convert PDF to/from image using ImageMagick" modifier="YourName" created="201107160846" modified="201301272315" tags="journal" changecount="1">
<pre>!Convert PDF to image

http://www.imagemagick.org/discourse-server/viewtopic.php?f=2&amp;t=18241

To convert to 200dpi
{{{
convert -units PixelsPerInch -density 200 319_Beaumont_flyer_A5.pdf 319_Beaumont_flyer_A5.jpg
}}}

NB: to identify existing format
{{{
identify -format &quot;%x x %y&quot; 319_Beaumont_flyer_A5.pdf
}}}

!Convert multiple images to PDF

{{{
convert *.jpg image.pdf
}}}

To convert to 100dpi
{{{
convert -units PixelsPerInch -density 100 *.jpg image.pdf
}}}


!Resize image

Shrink by 50%
{{{
convert example.png -resize 50% example.png
}}}

Resize to 1024x760, keeping aspect ratio:
{{{
convert  -resize 1024X768  source.png dest.jpg
}}}

Resize an image to a width of 200:
{{{
    convert example.png -resize 200 example.png
}}}
Resize an image to a height of 100:
{{{
    convert example.png -resize x100 example.png
}}}

!Convert image to PDF and rotate 180 degrees

{{{
convert -rotate 180 image.jpg image.pdf
}}}

Rotate and resize:
{{{
convert -rotate 180 -resize 50% image3.jpg image3b.jpg
}}}

[[Convert man page|http://linux.die.net/man/1/convert]]</pre>
</div>
