# markdown

Image resize:

[<img src="https://www.runatlantis.io/hero.png" width="35" height="35"/>](https://www.runatlantis.io/)

## Convert HTML to Markdown (macOS)

1. Copy from Google Doc and paste as html:

   ```
   osascript -e 'the clipboard as «class HTML»' | perl -ne 'print chr foreach unpack("C*",pack("H*",substr($_,11,-3)))' > /tmp/def.html
   ```

1. Convert html to table, serve the html using: `(cd /tmp && python -m http.server 10000)` then use [HTML Table to Markdown](https://chromewebstore.google.com/detail/html-table-to-markdown/ghcdpakfleapaahmemphphdojhdabojj?pli=1). Doesn't work with all tables.
