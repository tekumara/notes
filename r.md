# R

## Install Mac OS X

```
brew install r
```

## Packages

eg: to install and read Excel files using [openxlsx](https://www.rdocumentation.org/packages/openxlsx/versions/4.2.3)

```
install.packages("openxlsx", dependencies = TRUE)
library("openxlsx")
xlsxFile <- "https://github.com/awalker89/openxlsx/raw/master/inst/readTest.xlsx"
head(read.xlsx(xlsxFile))
```

## Repo setup

In `%R_HOME%\etc\Rprofile.site`:

```
 local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.stat.auckland.ac.nz"
       options(repos=r)})
```

Make sure there isn't any code following yours that sets the repo after you do.

## Comparing floating point values

`all.equal(floating1,floating2)`

The function all.equal() compares two objects using a numeric tolerance of `.Machine$double.eps ^ 0.5`
(from [FAQ 7.31](http://cran.r-project.org/doc/FAQ/R-FAQ.html))

## in

```
> 1 %in% c(2,2,3)
[1] FALSE
> c(1,2) %in% c(2,2,3)
[1] FALSE  TRUE
```

[More info](http://markmail.org/message/ndc2ahydcbq45vmz)

## Loading data

`bf <- read.table("data.csv",header=T,sep=",",quote="")`

same as

`bf <- read.csv("data.csv")`

Interactive file choosing (Windows / Mac)
`read.csv(file.choose())`

Interactive file choosing (Linux)

```
require(tcltk)
read.csv(tk_choose.files())
```

## misc

`sum(patients$totalVisits > 0) #count number of TRUEs`

```
search()  	# list search path ie: loaded packages
ls()	  	# list objects
typeof()
mode()
class()		# display class of object
getClasses()
str()	 	# display structure of object
```

```
all(matrix) #test if all values are true
```

## str

`str(patients1, max.level=1)`

Only display vars to the first level (eg: don't go into any lists in the dataframe)

## Convert a list of vectors into an array/matrix

Suppose you have the following list:

```
> mylist
[[1]]
 [1]  81.63172   0.00000   0.00000   0.00000   0.00000  81.63172

[[2]]
 [1]    0.0000    0.0000  471.2628    0.0000    0.0000  471.2628

[[3]]
 [1]    0.0000    0.0000    0.0000    0.0000 1515.9390 1515.9390
```

To convert this into a matrix:

```
>  t(array(unlist(mylist), dim=c(length(mylist[[1]]),length(mylist))))
         [,1] [,2]     [,3] [,4]     [,5]       [,6]
[1,] 81.63172    0   0.0000    0    0.000   81.63172
[2,]  0.00000    0 471.2628    0    0.000  471.26278
[3,]  0.00000    0   0.0000    0 1515.939 1515.93900
```

## Workspace options

Max number of lines printed.

`options(max.print=256)`
`getOption("max.print")`

## Timing statements

`system.time(expr)`
