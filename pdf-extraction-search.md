# pdf

## extraction and search

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

## unlock

To remove printing/editing/copying restrictions on PDFs without a password:

With qpdf (`brew install qpdf`):

```
qpdf --decrypt restricted_file.pdf free_file.pdf
```

With pdftk:

```
pdftk in.pdf output out.pdf allow AllFeatures
```
