rm(list = ls()) # initialization



#######################Pass parameters by ...#######################
# especially for graphics functions

?plot
?par

# wrapper function
# kind of changing the default values of some parameters
# similar to placing an order of burrito at Chipotle with your own wrapper or any other ingredients
red.density = function(x, ...) { # Each of our graphing functions uses a "..." 
                                 # parameter to receive arguments to be passed 
                                 # on to par()
  plot(density(x), col = "red", ...) # pass extra arguments to plot()
}
red.density(x = rnorm(100), main = "Two extra arguments", lty = "dashed") # using default color: red



###########################Apply Functions##########################
##################Pass a function like a parameter##################
# base on functional programming
# do some loops in a breeze

head(mtcars)

# lapply(X, FUN, ...): list apply
(average = lapply(X = mtcars, FUN = mean)) # result in a list
str(average)
(sd = lapply(X = mtcars, FUN = sd))


# sapply(X, FUN, ...): simplified apply
sapply(X = mtcars, FUN = mean) #  in a vector, matrix, or array
str(sapply(X = mtcars, FUN = mean))
sapply(X = mtcars, FUN = quantile) # 5x11 matrix


# mapply(FUN, ...): multiple arguments apply.
# A multivariate version of sapply. mapply applies FUN to the first 
# elements of each ... argument, the second elements, the third 
# elements, and so on.

(x = 1:4)
(y = 5:8)
(z = 9:12)
mapply(FUN = sum, x, y, z) # vector

mapply(FUN = rep, 1:4, 4:1) # from ?mapply and ?rep
str(mapply(FUN = rep, 1:4, 4:1)) # list


# apply(X, MARGIN, FUN, ...): runs FUN on "margins" of array X, keeping those dimensions
# specified in MARGIN
# helpful for a matrix
(m = matrix(data = 1:6, nrow = 2, ncol = 3))
apply(X = m, MARGIN = 1, FUN = sum) # keep dimension 1 (rows)
apply(X = m, MARGIN = 2, FUN = sum) # keep dimension 2 (columns)
str(apply(X = m, MARGIN = 1, FUN = sum)) # vector


# tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE): applies FUN to a subset of vector
# X for each combination in the list of factors INDEX (each having the same length as X)
head(mtcars, 10)

tapply(X = mtcars$mpg, INDEX = mtcars$cyl, FUN = mean)
str(tapply(X = mtcars$mpg, INDEX = mtcars$cyl, FUN = mean)) # vector
tapply(X = mtcars$mpg, INDEX = list(mtcars$cyl, mtcars$gear), FUN = mean)
mtcars[(mtcars$cyl == 6) & (mtcars$gear == 3), ] # check tapply() output
mtcars[(mtcars$cyl == 8) & (mtcars$gear == 4), ] # no need to use which () too often

# use ... to pass extra argument "probs=c(.25, .75))" to FUN=quantile:
tapply(X = mtcars$mpg, INDEX = mtcars$cyl, FUN = quantile, probs = c(.25, .75))



# summary
# 1. Apply functions can implement loops (based on functional programming).
# 2. Code step by step. Rome was not built in one day.
# 3. Always do debugging together with coding.
# 4. Comments, indentation and meaning names can improve readabiity and help debugging.
# 5. The Trial-and-error method always works.
# 6. Prevent some illegal operations.