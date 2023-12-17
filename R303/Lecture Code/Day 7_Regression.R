rm(list = ls()) # initialization



######################Simple Linear Regression######################
# see http://stattrek.com/regression/linear-regression.aspx

# cars: a built-in data frame
?cars
cars
head(cars)
str(cars)

# scatterplot
plot(x = cars$speed, y = cars$dist)

# correlation
r <- cor(x = cars$speed, y = cars$dist); r # two vectors; the outcome is a number

head(mtcars[ , 1:4]); cor(mtcars[ , 1:4]) # one data frame; the outcome is a matrix
cor(mtcars) # cf. pairs()


# linear regression model
?lm

# input: formula, data
# lm(y ~ x, data)

# Output as a list
# coefficients:      a named vector of coefficients
# residuals:         the residuals - response minus fitted values.
# fitted.values:     the fitted mean values.

# model
(m <- lm(dist ~ speed, data = cars)) # "m" is for "model"
str(m) # long
summary(m) # short summary
anova(m) # ANOVA table, see https://www.youtube.com/watch?v=PONDefIRF5g

# coefficients
y.intercept <- m$coefficients[1]
slope <- m$coefficients[2]

# abline: add a best fitting line y = bx + a
abline(a = y.intercept, b = slope) # add the regression line; long
abline(reg = m) # short! same as previous line
abline(a = mean(cars$dist), b = 0, lty = "dashed") # horizontal (b = 0) line through mean y


# easiest prediction by a simple plug-in
(speed <- seq(from = 5, to = 25, by = 5))
y.intercept + slope * speed # good for simple linear regression, not good for multiple linear regression

# prediction by using predict(model, newdata)
# especially good for multiple linear regression
d <- data.frame(speed = seq(from = 5, to = 25, by = 5)); d # newdata is a data frame with one column called speed matching the original independent variable
y.hat <- predict(m, newdata = d)
# add (x, y) pairs to graph with plotting character 19 (solid circle), scaled by 3
points(x = d$speed, y = y.hat, pch = 19, cex = 3)


# residual plot for testing the assumptions of simple linear regression
# see details at https://sphweb.bumc.bu.edu/otlt/MPH-Modules/BS/R/R5_Correlation-Regression/R5_Correlation-Regression4.html#:~:text=There%20are%20four%20assumptions%20associated,are%20independent%20of%20each%20other.

plot(m$fitted.values, m$residuals)
abline(0, 0) #y = 0; errors should have mean 0

# QQ plot for testing the normality
# general case of QQ plot
x <- rnorm(n = 100); qqnorm(x); qqline(x) # 100 random N(0, 1) points; along a line
w <- rexp(100); qqnorm(w, ylim = c(-1, 5)); qqline(w) # 100 random Exp(1) points; curved off a line

# specific case for residuals in our simple linear regression model
qqnorm(m$residuals); qqline(m$residuals) # our "dist vs. speed" model

# shortcut by multiple plots
layout(matrix(data = 1:4, nrow = 2, ncol = 2, byrow = TRUE))
layout.show(layout(matrix(data = 1:4, nrow = 2, ncol = 2, byrow = TRUE))) # demo
plot(m)
layout(matrix(data = 1, nrow = 1, ncol = 1)) # reset graphics device


#####################Multiple Linear Regression#####################
# see https://www.youtube.com/watch?v=G4ZlC9zKfII

# input: formula, data
# lm(y ~ x1 + x2 + x1*x1 + ..., data)

# Output as a list
# coefficients:                a named vector of coefficients
#                              estimates - estimated coefficients
#                              standard error - estimated standard deviations of coeffiecients
#                              t values & probabiilties: t statistic and P-value for H0: ai = 0
# residuals:                   the residuals - response minus fitted values.
# Residual standard error:     coefficient of determination, R squared
# F statistics & P-value:      for H0: a1 = ? ? ? = ap = 0

n <- 100 # simulate n points, (y, x1, x2, x3), for a "sanity check" example
x1 <- rnorm(n = n, mean = 0, sd = 1); x2 = rnorm(n); x3 = rnorm(n) # three demo independent/predictor data

# ideal case
y <- 3 + 4*x1 + 5*x2 + 6*x3 + 7*x1*x1 - 3*x1*x2 # demo dependent/response data
m <- lm(y ~ x1 + x2 + x3 + I(x1^2) + x1*x2); m # discover coefficients from data
summary(m)

# more realistic case
y <- 3 + 4*x1 + 5*x2 + 6*x3 + 7*x1*x1 - 3*x1*x2 + rnorm(n) # add noise to make it harder
m2 <- lm(y ~ x1 + x2 + x3 + I(x1^2) + x1*x2); m2
summary(m2)

# real data
m3 <- lm(mpg ~ hp + wt + gear, data = mtcars); m3 # real data from mtcars
summary(m3)
anova(m3) # ANOVA table

# confidence intervals for coefficients
confint(m, level = .95)



#################################HW4################################

# Download hw4.Rmd & label.Rmd 
# Double check its suffix after saving it into your working directory
# The suffix MUST be .Rmd, instead of .rmd!

# Click and read hw4.html and label.html carefully, instead of hw4.Rmd, 
# because the math expression is difficult to read in .Rmd file.
# Then, fill in all the blanks as required.

# Part 1.
# Adding a beautiful mathematical label is a little hard. Please check
# label.html or hint on labels.
# ?plotmath is also helpful.

# Part 2.
# beef.txt is a data file with header. How to read the data from it correctly
# is kind of tricky. Use read.table, instead of read.csv, with a suitable
# separator (not "," by default!).
# You could use ?read.table for more helps.
# ALWAYS double check your data after the reading!

# Part 3.
# confidence band: 
# see https://en.wikipedia.org/wiki/Confidence_and_prediction_bands#/media/File:Regression_confidence_band.svg
#     https://en.wikipedia.org/wiki/Confidence_and_prediction_bands
# Then, follow the instructions to translate math formula into math expression in R.
# Don't use any loop or branch. All the things could be done by 
# some simple vector operations, which also works in Quiz 4. 

# please surround your English text with doubled asterisks (`**...**`) 
# to highlight them. Then, it is easy for our grader to find your text.

# You can try to knit your .Rmd file into .html file to double check 
# your output. Then, just submit your .Rmd file. We will generate
# your .html from your submission.