# pdf extraction and search

Install [pdftotest](https://github.com/freedesktop/poppler) - NB: requires qt (500mb)

```
brew install poppler
```

Install [ripgrepa](https://github.com/phiresky/ripgrep-all)

```
brew install rga poppler
```

Extract to std out, preserving layout

```
pdftotext -layout table.pdf -
```

Search for the string "text" in /tmp/pdfs using pdftext

```
rga test /tmp/pdfs
```
