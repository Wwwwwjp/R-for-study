#######################Creating an R package########################

rm(list = ls()) #initialization

# An R "package" facilitates the organization and sharing of R code, 
# its user manual, data, and tests. It facilitates open and reproducible research.
#
# Three parts:
# 1. function/method definition;
# 2. dataset;
# 3. manual/description/help.
#
# Making-a-package Procedure: 
# Preparation ==> Programming/Documentation ==> Building the package ==> Publishing



# To create a package, the procedure is: (similar to create a R markdown)

# Step 1. Preparation: Install software
# install.packages("devtools") to get access to create(), check(), and build()
if (!require("devtools")) {
  install.packages("devtools")
  stopifnot(require("devtools"))
}

# install.packages("roxygen2") to get access to document(), which is also called by check()
if (!require("roxygen2")) {      
  install.packages("roxygen2")   
  stopifnot(require("roxygen2"))
}

# Windows users: install Rtools from http://cran.r-project.org/bin/windows/Rtools.
version # find your R version in the console
# then, pick Rtools35.exe (or the latest) to download and install according to your R version



# Step 2. Make a framework: Creates a skeleton package
# consisting of the new folders path 
# and path/R (for".R" code files); 
# and the new files path/DESCRIPTION (for package metadata like title, author, version, dependencies)
create("jgUtilities")



# Step 3. Revise package metadata: Revise the metadata file: path/DESCRIPTION (like copyright statement)
# Use files pane on the right.
# You can edit it for title, author, version, dependencies.



# Step 4. Programming: Write functions (with help documentation on the top), one per ".R" file, in your path/R folder
# Put a function f() in the file f.R.
# Write f()'s user manual (visible via ?f) by pasting these comments above f()'s code as a head part
# and revising them: see handout or check any help in help pane

# For demo,
# copy random.sort.R and baby.factorial.R into jgUtilities/R
# and read their code carefully.

# Or, define your own functions with the following head, 
# whose syntax is self-explanatory below and somehow similar to R markdown.

#' (title at top of help page)
#' 
#' (Description paragraph)
#' @param x (description of x; one line per parameter: Arguments section)
#' @return (Value section)
#' @details (Details section)
#' @export
#' @examples
#' # (Examples section)
#' f(x)

# Also, refer to random.sort.R and baby.factorial.R.
# See more details at https://kbroman.org/pkg_primer/pages/docs.html
# and http://r-pkgs.had.co.nz/man.html (quite comprehensive).



# Step 5. Saving dataset: Include data, if any
# Create a path/data folder via the "New Folder" button on RStudio's "Files" pane on the right.
# Save a data object x (a placeholder) via save(x, file = "path/data/x.RData"), like
x = data.frame(height = 1:3, weight = 4:6); save(x, file = "jgUtilities/data/x.RData")


# Step 6. Adding help for dataset: Document data object x by pasting these comments into 
# path/R/x.R and revising

#' This Is A One-line Title Describing x
#'
#' This is the Description paragraph. x is my favorite data set. Blah, blah,
#' blah.
#'
#' @format x is a data frame with 3 rows and 2 variables:
#' \describe{
#' \item{h}{height (inches)}
#' \item{w}{weight (pounds)}
#' }
#' @source
#' These data are from an experiment I did with my friend William
#' (\url{http://en.wikipedia.org/wiki/William_Sealy_Gosset})
#' at the Guiness Brewery in Dublin in 1908.
"x"



# Step 7. Preparation for building: Generating documentation and check the mistakes: 

document(pkg = "jgUtilities") 
# creates a path/man folder (for user "manual" file output) 
# and writes ".Rd" (for "R documentation" help) files in it, 
# one for each ".R" file, from your function comments (Never change it).

check(pkg = "jgUtilities") # checks best practices. Fix errors and most warnings



# Step 8. Building: build(pkg = ".") creates a ".tar.gz" file from the directory pkg 
# that can be shared with other R users.

build(pkg = "jgUtilities")
# pkgs filename might be slightly different, like "jgUtilities_0.0.0.9000.tar.gz".



# Using-a-package Procedure:
# Search/Download/Installation ==> Loading into memory ==> Using

# Step 9. Search/Download/Installation: 
# install.packages(pkgs, repos = getOption("repos"), type = getOption("pkgType"))
# installs the package on to your hard drive; 
# using repos = NULL and type = "source" allows the use of your ".tar.gz" file for pkgs.

install.packages(pkgs = "jgUtilities_0.0.0.9000.tar.gz", repos = NULL, type = "source") 
# pkgs filename might be slightly different!



# Step 10. Loading: require/library(package) loads package into the R session.
# Note: Restart R before require().
# "Session > Restart R" (Ctrl+Shift+F10), then
require("jgUtilities")
# or,  library("jgUtilities")


# Step 11. Using it now: Ready to use functions and data from the loaded package 
?x
x

?baby.factorial
baby.factorial(3)
example("baby.factorial") # remember restart R before require/library()

?random.sort
random.sort(8:0)
example("random.sort") # remember restart R before require/library()



# For more, see
# the "R packages" online book by Hadley Wickham at http://r-pkgs.had.co.nz
# the "PACKAGE DEVELOPMENT" section of https://support.rstudio.com/hc/en-us
# http://cran.r-project.org/web/packages/roxygen2/vignettes/formatting.html




################################HW2#################################

# Part 1. Programming with generic functions
# 1) In the definition of lad(), remember to return a list of class "lad"
# as described in the instruction exactly.
#
# 2) The objective function SAD() is involved with abs(). 
# So, it is not differentiable everywhere. Don't use any optimization
# methods requiring the derivatives.
#
# 3) You'd better compare lad() with simple linear regression and robust 
# regression in HW1 part1.
#
# 4) There is no dependence on "farmLandArea.csv" in the definition of lad().


# Part 2. Creating a package with three parts:
# 1) function/method definition: lad(), print.lad(), coef.lad(), predict.lad().
#
# 2) dataset: area extracted from "farmLandArea.csv".
#
# 3) manual/description/help: follow the demo above and the instrcutions about example for lad()
# in the statement of HW2.


# Verify your code by running the following code:
# Rename your package filename to "robust_0.1.tar.gz" manually.
install.packages(pkgs = "robust_0.1.tar.gz", repos = NULL, type = "source")
require("robust")
# Don't forget to restart R here!
example(lad)
?lad
?area
?print.lad
?coef.lad
?predict.lad


# Part 3. optional, 5pt bonus