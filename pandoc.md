# pandoc

## Install on Mac OS X

```
brew install pandoc

# for generating PDFs
brew cask install basictex
```

Add `/Library/TeX/texbin/` to your path.

## Install on Ubuntu

Install with latex support (needed to convert to PDF):

```
sudo apt-get install pandoc texlive
```

For the xelatex engine:

```
sudo apt-get install texlive-xetex
```

## Install on Amazon Linux 2

```
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum-config-manager --enable epel
sudo yum install -y pandoc
```

## Usage

To convert a Markdown file to a PDF:

```
pandoc test.md -V geometry:margin=1in -o test.pdf
```

To convert markdown to pdf, setting the marin to 1 inch (by default they are quite large):

```
pandoc readme.md -V geometry:margin=1in --latex-engine=pdflatex -o readme.pdf
```

Or using xelatex (uses system fonts, not specially installed latex fonts, which results in a smaller pdf file size) and colour links blue so they can be seen

```
pandoc readme.md -V geometry:margin=1in --latex-engine=xelatex --variable urlcolor=blue -o readme.pdf
```
