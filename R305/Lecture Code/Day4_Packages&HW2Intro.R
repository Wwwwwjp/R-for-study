#######################Creating an R package########################

rm(list = ls()) # initialization

# An R "package" facilitates the organization and sharing of R code, 
# its user manual, data, and tests. It facilitates open and reproducible research.
#
# Three parts:
# 1. function/method definition;
# 2. dataset;
# 3. manual/description/help/example.
#
# Making-a-package Procedure: 
# Preparation ==> Program with Documentation ==> Build the package ==> Publish



# To create a package, the procedure is: (similar to create a R markdown)

# Step 1. Preparation: Install software
# install.packages("devtools") to get access to create(), check(), and build().
# The aim of devtools is to make your life as a package developer easier 
# by providing R functions that simplify many common tasks.
if (!require("devtools")) {
  install.packages("devtools")
  stopifnot(require("devtools"))
}

# install.packages("roxygen2") to get access to document(), which is also called by check().
# The goal of roxygen2 is to make documenting your code as easy as possible.
if (!require("roxygen2")) {      
  install.packages("roxygen2")   
  stopifnot(require("roxygen2"))
}

# Windows users: install Rtools from http://cran.r-project.org/bin/windows/Rtools.
version # find your R version in the console
# then, pick RTools (e.g. 4.3, by Jul. 2023) to download and install 
# according to your R version (e.g. 4.3.1, by Jul. 2023)



# Step 2. Make a framework: Creates a skeleton package
# consisting of the new folders path 
# and path/R (for".R" code files); 
# and the new files path/DESCRIPTION (for package metadata like title, author, version, dependencies)

package.name = "jgUtilities" # choose the package name here
# Remove the subfolder "jgUtilities" if it already exists
# because we need to get started from scratch
if (dir.exists(package.name)) unlink(package.name, recursive = TRUE)

# Let's make the subfolder "jgUtilities" and other subfolders for our package 
create(package.name)



# Step 3. Revise package metadata: Revise the metadata file: path/DESCRIPTION (like copyright statement)
# Use files pane on the right.
# You can edit it for title, author, version, dependencies. It's optional.
# See more explanations at https://r-pkgs.org/description.html.
file.edit(paste0(package.name, "/DESCRIPTION"))



# Step 4. Programming: Write functions (with help documentation on the top), one per ".R" file, in your path/R folder.
# Usually, put a function f() in the namesake file f.R.
# Write f()'s user manual (visible via ?f) by pasting these comments above f()'s code as a head part
# and revising them: see handout or check any help in help pane

# For demo, suppose we have written two R scripts, 
# Day4.1_baby.factorial (for baby.factorial()) 
# and Day4.2_random.sort.R (for random.sort()), 
# in another place.

# Copy them into jgUtilities/R
# Rename them as baby.factorial.R and random.sort.R (namesake) 
# by the following code or by any file manager
# and read their code carefully, especially their head parts with roxygen tags, 
# similar to R markdown tags.

new.folder = paste0(package.name, "/R") # function/method source code's destination subfolder
if (length(list.files(new.folder)) > 0) unlink(paste0(new.folder, "/*")) # delete files in jgUtilities/R, if any
# removing files or folders can be done by another function file.remove()

# copy, rename, and revise #1 file
file.copy("Day4.1_baby.factorial.R", new.folder) # suppose the source code is saved in your working dir 
file.rename(from = paste0(new.folder, "/Day4.1_baby.factorial.R"), # use the namesake filename
            to = paste0(new.folder, "/baby.factorial.R"))
file.edit(paste0(new.folder, "/baby.factorial.R")) # revise it

# copy, rename, and revise #2 file
file.copy("Day4.2_random.sort.R", new.folder)
file.rename(from = paste0(new.folder, "/Day4.2_random.sort.R"),
            to = paste0(new.folder, "/random.sort.R"))
file.edit(paste0(new.folder, "/random.sort.R"))

# Or, define your own functions with the following head, 
# whose syntax is self-explanatory below and somehow similar to R markdown tags.
# In fact, they are called roxygen tags, whose documentation is 
# at https://roxygen2.r-lib.org/articles/rd.html.
# 

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



# Step 5. Generate, collect, or store the dataset to the package, if any.
# First, create a subfolder called path/data folder by a file manager or by the following code.

# Create the data subfolder to store the dataset, if necessary
if (!dir.exists(paste0(package.name, "/data"))) dir.create(paste0(package.name, "/data")) 

# Then, save a data object x (or any other placeholder) via save(x, file = "path/data/x.RData"), like
x = data.frame(height = 1:3, weight = 4:6) # a demo dataset
save(x, file = paste0(package.name, "/data/x.RData")) # the contents of the dataset is here.



# Step 6. Add the documentation for the dataset: Document data object x by writing code shown in  
# path/R/Day4.3_x.R and revising it, especially its head parts with roxygen tags, 
# similar to R markdown tags.

# copy, rename, and revise #3 file (dataset doc, not its contents)
file.copy("Day4.3_x.R", new.folder)
file.rename(from = paste0(new.folder, "/Day4.3_x.R"),
            to = paste0(new.folder, "/x.R"))
file.edit(paste0(new.folder, "/x.R"))

# Now, after the above programming and documentation, we're ready to build our package.



# Step 7. Preparation for building: Generating documentation and check the mistakes 
# by document() from roxygen2 and check() from devtools devtools: 

document(pkg = package.name) 
# creates a path/man folder (for user "manual" file output) 
# and writes ".Rd" (for "R documentation" help) files in it, 
# based on each ".R" file's function head (never change it).

check(pkg = package.name) 
# checks best practices. Fix any errors and most warnings



# Step 8. Building: build(pkg = ".") from devtools in creates a ".tar.gz" file from the directory pkg 
# that can be shared with other R users.

package.file.name = build(pkg = package.name, )
# Every important file in this folder will be packed into a file called "jgUtilities_0.0.0.9000.tar.gz".
# pkgs filename will have a version number, like "jgUtilities_0.0.0.9000.tar.gz" by default.
# It is editable in "jgUtilities/DESCRIPTION". This change is optional.

# Now, your package is ready for distribution.






# Using-a-package Procedure:
# Search/Download/Installation ==> Load into memory ==> Use it

# Step 9. Search/Download/Installation: 
# First, restart R by click the menu Session > Restart R
# Or, using the following command
.rs.restartR()

# installs the package from  on to your hard drive; 
# using repos = NULL and type = "source" allows the use of your ".tar.gz" file for pkgs.

install.packages(pkgs = package.file.name, repos = NULL, type = "source") 
# pkgs filename, especially version part, might be slightly different! It doesn't matter.



# Step 10. Loading: require/library(package) loads package into the R session.
# Note: Restart R before require().
# "Session > Restart R" (Ctrl+Shift+F10), then
require(package.name, character.only = TRUE)
# or,  library(package.name, character.only = TRUE)


# Step 11. Using it now: Ready to use functions and data from the loaded package 
?x # check the dataset x's documentation
x # check its contents

?baby.factorial # check the function baby.factorial()'s documentation
baby.factorial(3) # check its function by running it
example("baby.factorial") # Run its examples. 
# Again, remember restart R before require/library(). Otherwise, example() may not run properly.

?random.sort
random.sort(8:0)
example("random.sort") # Run its examples. 
# Again, remember restart R before require/library(). Otherwise, example() may not run properly.



# For more, see
# the "R packages" online book by Hadley Wickham at https://r-pkgs.org/
# the "PACKAGE DEVELOPMENT" section of https://support.rstudio.com/hc/en-us
# http://cran.r-project.org/web/packages/roxygen2/vignettes/formatting.html
# https://kbroman.org/pkg_primer/




################################HW2#################################

# Part 1. Programming with generic functions
# 1) In the definition of lad() (together with SAD() inside), remember to return a list of class "lad"
# as described in the instruction exactly.
#
# 2) The objective function SAD() is involved with abs(). 
# So, it is not differentiable everywhere. Don't use any optimization
# methods requiring the derivatives.
#
# 3) You'd better compare lad() with simple linear regression and robust 
# regression in HW1 part1.
#
# 4) There is no dependence on "farmLandArea.csv" in the definition of lad() or the dataset area.


# Part 2. Creating a package with three parts:
# 1) function/method definition: lad(), print.lad(), coef.lad(), predict.lad().
#
# 2) dataset: area extracted from "farmLandArea.csv".
#
# 3) manual/description/help: follow the demo above and the instructions about example for lad()
# in the statement of HW2.


# Verify your code by running the following code:
# Rename your package filename to "robust_0.1.tar.gz" manually.
.rs.restartR() # restart R
install.packages(pkgs = "robust_0.0.0.9000.tar.gz", repos = NULL, type = "source")
require("robust")

example(lad)
?lad
?area
?print.lad
?coef.lad
?predict.lad


# Part 3. optional, 5pt bonus