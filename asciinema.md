# asciinema

For best rendering as an svg, set your terminal (eg: iterm2) to about 100x20 then record using [asciinema](https://github.com/asciinema/asciinema):

```
asciinema rec my.cast
```

Covert to gif using [agg](https://github.com/asciinema/agg):

```
agg my.cast my.gif --font-size 32
```

Convert to svg using [svg-term](https://github.com/marionebl/svg-term-cli):

```
cat my.cast | svg-term --out my.svg --window true
```
