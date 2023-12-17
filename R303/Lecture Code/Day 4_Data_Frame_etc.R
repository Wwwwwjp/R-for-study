rm(list = ls()) #initialization



##############################Data Frame##############################
#################a list of vectors with the same size#################
##a table with each row being a list and each column being a vector###
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# an example

mtcars # built-in data.frame, like a spreadsheet.
       # Each row is a list, representing an observation, a type of car (all the data collected from a sample)
       # Each column is a vector, representing a variable (all the data collected for one type of measure)
data() # show all the built-in datasets
?mtcars # always use ? to get help
str(mtcars)
mtcars$cyl # cyl column, which is laid down to save space
head(mtcars) # first few rows. Useful for a too long dataset
summary(mtcars) # VS (V-shaped, like v6 or v8 vs Straight engine), am are categorical data
                # The summaries make sense for ONLY the numerical data by default!


# factor for categorical data

m <- mtcars; m # a copy of mtcars to avoid any change to the original dataset. 
# You can see its value in Environment pane by clicking a "form" button.
m$vs <- factor(mtcars$vs, labels = c("V", "straight")) # add a factor for vs, levels = c("0", "1") by default
m                                                      # check its value
m$am <- factor(mtcars$am, levels = c("0", "1", "2"), labels = c("auto", "manual", "CVT")) # add a factor for am
                                                                                          # add level "2" and label "CVT" for possible expansion
m                                                                                         # CVT means continuously variable transmission
str(m)
summary(m) # correct summary for categorical data in vs and am (like counting => proportions)


# table for categorical data

table(m$vs) # simple table
table(m$vs, m$am) # contingency table


# manipulation a data frame by indexing
# IMPORTANT

# one single row/column
m
m$mpg # mpg column which is laid down to save space
m[1] # 1st (mpg) column, which is upright
m[2,] # 2nd row
m[,1] # 1st (mpg) column, which is laid down to save space. m$mpg is preferred.

# one single element/data
m$cyl[1]; m[1,2] # first row and 2nd column. m$cyl[1] is preferred!
m$mpg[2]; m[2,1] # 2nd row and 1st column. m$mpg[2] is preferred!
m$cyl[1] <- 8; m # assignment
m$mpg[2] <- 29; m # assignment

# subset
m[1:3, 1:4] # rows 1:3, columns 1:4
head(m) # first part of m
head(m, 3) # first 3 rows of m
tail(m, 10) # last 10 rows of m

dim(m) # dimension: # of rows, # of columns as a vector
(n.rows <- dim(m)[1]); (n.cols <- dim(m)[2]) # assign the dimension of m to n.rows & n.columns separately
(n.cols <- length(m)) # alternative way for the number of columns

names(m) # column names
rownames(m) # row names
rownames(m)[n.rows-2] <- "Monica's present"; tail(m) # change a row name

(M <- median(m$hp)) # median as a threshold
m$mpg[m$hp > M] # find all high-power cars by using m$hp > M as a index inside [...]
mean(m$mpg[m$hp > M]) # high-power average mileage
mean(m$mpg[m$hp <= M]) # low-power average mileage

m$price <- 1000 * (1:n.rows); tail(m) # add a column called price
m$vs <- NULL; head(m) # remove vs column. Why not NA?

# sort the data frame by the values of some columns
# using the order to tie each column
order(m$cyl, m$disp) #the order by cyl, then by disp
sorted <- m[order(m$cyl, m$disp), ] # m by using the order and keep the connections
                                    # Don't miss the comma after the order
                                    # never sort a single column, which breaks the connections
sorted


# file I/O with .csv for MS Excel
write.table(mtcars, file = "mtcarsMonica.csv") # sep = " " by default
write.csv(m, file = "mtcarsMonica.csv") # sep = "," by fault. write.csv is preferred!
                                        # Old files will be destroyed by default.
                                        # factor columns with double quotes
write.table(m, file = "noHeader.csv", row.names = TRUE, col.names = FALSE, sep=",") # don't use write.csv to write a data file without a header


monica <- read.csv("mtcarsMonica.csv", row.names = 1); head(monica) # monica has a header row of column names and a first column of row names is in 1st column
monica <- read.csv("mtcarsMonica.csv"); head(monica) # Wrong! monica has no row names but has one additional column!
monica <- read.csv("noHeader.csv", row.names = 1); head(monica) # wrong header. First row is considered as column names by mistake.
monica <- read.csv("noHeader.csv", header = F, row.names = 1); head(monica) # F or T is a shorthand of FALSE or TRUE
names(monica) <- c("mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "am", "gear", "carb", "price"); head(monica)
str(monica) # factors are set up automatically
# monica <- read.csv("noHeader.csv", header = F, col.names = c("mpg", ..., "price"), row.names = ("...", ..., "..."))

# double check after the loading or writing



################################Formula###############################
##############################for a model#############################
######################~ means versus or depend on#####################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# box plots
flowers = read.csv("flowers.csv"); flowers # 54 rows, 2 columns: Flower.Length, Species - Bihar, Caribaea Red, Caribaea Yellow
str(flowers) # note the factor
boxplot(flowers$Flower.Length,
        main = "Flower Length Without Regard for Species", ylab = "Length (mm)") # boxplot for all the data
boxplot(flowers$Flower.Length ~ flowers$Species,
        main = "Flower Length by Species", xlab = "Species", ylab = "Length (mm)") # boxplot Flower.Length vs. Species

boxplot(m$disp)
boxplot(m$disp ~ m$am)


# quick introduction to linear regression model
# y ~ x indicates that y depends linearly on x (simple linear regression model)
# y ~ x1 + x2 + x3 + x1*x2 indicates that y depends linearly on x1, x2, x3, and x1 times x2 (multiple linear regression model)



##############################R Markdown##############################
######a container of text, data, R code, and LaTeX math notation######
##################Used for any report like HW3 & HW4##################

# open a new file
# Menu: File > New File > R Markdown .... 
# Choose "Document" page on the left. 
# Choose "HTML" under "Default Output Format:", and click "OK". 
# You might need to install some R packages. Just follow the pop-up instructions.

# Check R Markdown for more details
# Try to write your first .Rmd file.

# LaTeX can provide perfect math expressions, much better than MS Word Equation.
# Check https://en.wikibooks.org/wiki/LaTeX/Mathematics
# https://www.sharelatex.com/learn/Mathematical_expressions
# https://www.sharelatex.com/learn/List_of_Greek_letters_and_math_symbols
# for more details.

# Or, google latex math.



#############################Summary##################################

# Read the hint when you do the quiz.

# R Markdown: a container for your report, including everything.

# LaTeX: to write a beautiful math formula.

# Data Frame: the most important object that we will handle in R. Column - Vector; Row - List.