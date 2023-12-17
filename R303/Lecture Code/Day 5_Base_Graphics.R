rm(list = ls()) # initialization



###########################Base Graphics############################
# Using Base R. Don't need to install any extra package


##########################common parameters#########################

?par # general help
     # a large group of parameters to describe a graph
     # https://www.statmethods.net/advgraphs/parameters.html
     # https://www.statmethods.net/advgraphs/axes.html

# main, sub:    main title, subtitle
# xlab, ylab:   x or y-axis labels

# xlim, ylim:   x or y-axis limits

# cex (symbols), cex.axis, cex.lab, cex.main, cex.sub: character expansion (relative to 1)


# pch:  plotting character
?points # more detailed help for pch
        # https://www.statmethods.net/advgraphs/parameters.html


# formula:      y ~ model
# data:         a data frame



############################numeric data############################

head(mtcars)

# boxplot(x) makes a boxplot from vector x.
boxplot(mtcars$mpg, main = "Gas mileage", ylab = "miles per gallon", ylim = c(0,40)) # a boxplot
boxplot(mtcars$mpg)

# boxplot(x ~ g) groups by factor g.
boxplot(mpg ~ factor(cyl), data = mtcars, xlab = "cylinders", ylab = "miles per gallon") # several boxplots by factors


# stripchart(x, method = "overplot") makes a dot plot of x (better than boxplot for small sample).
stripchart(mtcars$cyl[1:10], method = "jitter")

# stripchart(): dot plot, good for small sample.
stripchart(mpg ~ factor(am), data = mtcars, method = "stack")
stripchart(mpg ~ factor(am), data = mtcars) #method = "overplot" by default


# hist(x, breaks="Sturges", freq=NULL) makes a histogram from x,
# where breaks is a vector of bin boundaries (or, as in the default "Sturges", the name of a bin algorithm)
# and freq = FALSE gives density histogram instead of frequency.
hist(mtcars$mpg)
hist(mtcars$mpg, xlab = "Gas mileage (mpg)", sub = "Hello", cex.axis = 2, cex.main = .5, cex.sub = 1.5)

hist(mtcars$mpg) # default breaks is preferred!
hist(mtcars$mpg, breaks = seq(10, 35, by = 0.1)) # too pricky
hist(mtcars$mpg, breaks = seq(10, 35, length.out = 4)) # too bulky
# Conclusion: Usually, let R choose the breaks for you automatically. 

hist(mtcars$mpg, freq = F) # density histogram, not frequency histogram


# plot(x, y) makes a scatterplot from vectors x and y
x = 1:5; y = 2 * x; plot(x, y)
plot(x, y, xlim = c(0, 10), ylim = c(0, 10)) # change the scale of x & y-axis


# points(x, y) adds points to a plot
# lines(x, y) adds line segments
# ONLY adding, not openning a new plot
dev.off() # clear all the plots
points(x, x, pch = 15) # error messages! Why?

plot(x, y, xlim = c(0,10), ylim = c(0,10)) # open and draw a plot
points(x, x, pch = 15) # add a line
?points # pch = 15 means solid squares
lines(x = c(1, 3, 5, 7, 9), 
      y = c(8, 1, 4, 1, 8), col = "red") # color is red


# plot(density(x))
# KDE (Kernel Density Estimation), a usually better estimate of pdf than the histogram
# For more details, check https://en.wikipedia.org/wiki/Kernel_density_estimation
plot(density(mtcars$mpg)) # draw a KDE
rug(mtcars$mpg) # add the data points

d <- density(mtcars$mpg)
str(d)


# pairs(x) makes a matrix of scatterplots of pairs of columns of data frame x
pairs(mtcars) # check the pairwise relationship of mtcars


# curve(expr, from=NULL, to=NULL, n=101, add=FALSE, type="l") draws a curve of expr over [from, to] 
curve(expr = x*sin(1/x), from = -pi/6, to = pi/6, n = 200) # n = 200 is good
curve(expr = x*sin(1/x), from = -pi/6, to = pi/6, n = 10)  # n = 10 is too low and the graph is incorrect

curve(expr = x*sin(1/x), from = -pi/6, to = pi/6, n = 200)
curve(expr = x*1, add = TRUE, col = "red") # add = TRUE means adding to existing plot
curve(expr = x*(-1), add = TRUE, col = "red") # a good example in Calculus I to illustrate the squeeze theorem of limits


###############################legends##############################

# legend(x, y, legend, col=par("col"), lty, pch) makes a legend at (x, y)
?legend
# x, y:      location
# legend:    label
# col:       color
# lty:       line type
# pch:       plotting character
?par # more detailed help for general parameters like lty

legend("top", legend = c("x*sin(1/x)", "x"), col = c("black", "red"), lty = c(1, 1))


###############math expressions in titles and labels################

# expression(...) makes a math expression in R (not very beautiful)
# not in R markdown, where you need to use LaTeX!
?plotmath # search frac
demo(plotmath) # more useful
# How to embed LaTeX in R plot? (for advanced students)
# Check https://stackoverflow.com/questions/1395105/getting-latex-into-r-plots

curve(expr = x*sin(1/x), from = -pi/6, to = pi/6, n = 200)
curve(expr = x*1, add = TRUE, col = "red") # add = TRUE means adding to existing plot
curve(expr = x*(-1), add = TRUE, col = "red") # a good example in Calculus I to illustrate the squeeze theorem of limits
legend("top", legend = c(expression(x * sin(frac(1, x))), "x"), col = c("black", "red"), lty = c(1, 1))
# If there is some proportional issues, zoom the plot first
# Or, use cex.****



##########################categorical data##########################

# barplot(height, names.arg = NULL) makes a barplot of the counts in height, with (optional) bar labels in names.arg
# A barplot is not a histogram!
# check http://stattrek.com/statistics/charts/histogram.aspx?Tutorial=AP
mtcars$cyl
counts = table(mtcars$cyl); counts
barplot(counts)
barplot(mtcars$cyl) # wrong without counting first!
hist(mtcars$cyl) # compare histogram with barplot

barplot(counts, names.arg = c("four", "six", "eight"))
barplot(counts, names.arg = c("four", "six", "eight"), cex.names = 0.8)

# mosaicplot(x) makes a mosaic plot from a table of counts from table()
counts = table(mtcars$cyl, mtcars$gear); counts
mosaicplot(counts) # kind of transposed, compared with the contingency table
                   # no explicit intersection counts



##########################multiple figures##########################
######################by using a layout matrix######################

# matrix(data, nrow, ncol, byrow = FALSE) fills an nrow ? ncol matrix by column from data
m = matrix(data = c(1, 0, 2, 
                    3, 3, 3), nrow = 2, ncol = 3, byrow = TRUE); m
matrix(data = c(1, 0, 2, 3, 3, 3), nrow = 2, ncol = 3)
# see the relationship among vector, list and data frame at
# https://www.programcreek.com/2014/01/vector-array-list-and-data-frame-in-r/

# layout
layout(m)
layout.show(layout(m)) #only for demo/test, it should be commented out finally

# another layout
nf <- layout(matrix(c(2, 2, 2, 0, 
                      1, 1, 1, 3, 
                      1, 1, 1, 3, 
                      1, 1, 1, 3), 4, 4, byrow = TRUE))
layout.show(nf)

# draw multiple figures with a layout matrix

# make your Plots panel large enough
# Otherwise, you might get the error message:
# Error in plot.new() : figure margins too large

hist(mtcars$mpg) # 1st plot: (frequency) histogram alone
plot(density(mtcars$mpg)) # 2nd plot: density plot alone
rug(mtcars$mpg) # add a rug of data points to (2nd plot) density plot
hist(mtcars$mpg, freq = FALSE) # 3rd plot: density histogram
lines(density(mtcars$mpg)) # add density plot to (3rd plot) histogram
rug(mtcars$mpg) # add a rug of data points

# layout persists!

# reset the layout
layout(matrix(data = 1, nrow = 1, ncol = 1))
layout(1) # same


##################write graphical output to a file##################

# step 1. Open a graphical output file with
# pdf("file.pdf"): file.*** is your destination filename
# png("file.png")
# jpeg("file.jpg")
# bmp("file.bmp")
# postscript("file.ps")
# tiff("file.tif")
pdf("junk.pdf")

# step 2. Make graph
x = rnorm(100)
plot(density(x))

# step 3. Close the file with
dev.off()

# open junk.pdf to check the graph.



#################################HW3################################

# Download hw3.Rmd
# Double check its suffix after saving it into your working directory
# The suffix MUST be .Rmd, instead of .rmd!

# Read the comments carefully
# Then, fill in all the blanks as required

# please surround your English text with doubled asterisks (`**...**`)
# to highlight them. Then, it is easy for our grader to find your text.

# You can try to knit your .Rmd file into .html file to double check
# your output. Then, just submit your .Rmd file. We will generate
# your .html from your submission.



############################Summary#################################

# Know how to use R Markdown (as well as LaTeX) for HW3 and HW4.

# How to plot a graph is a very important technique.

# Plotting looks like complicated. You'd better learn it with some examples. Also, try it yourself.

# Go over some statistics to improve the understanding of all kinds of plots. 