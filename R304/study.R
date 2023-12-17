# Description: Convert Fahrenheit temperature to Celsius.
# Usage: Celsius(Fahrenheit)
# Arguments:
# Fahrenheit: the temperature in degrees Fahrenheit
# Value: the equivalent temperature in degrees Celsius
Celsius = function(Fahrenheit) {
  Celsius_temp = (Fahrenheit - 32) * 5/9
  return(Celsius_temp)
}
stopifnot(isTRUE(all.equal(Celsius(32), 0))) # test cases
stopifnot(isTRUE(all.equal(Celsius(212), 100)))

# Description: Find a probability associated with a Binomial distribution.
# Usage: baby.dbinom(x, size, prob)
# Arguments:
#   x: the number of successes, one of 0, 1, ..., size
#   size: the number of trials (nonnegative)
#   prob: the probability of success in any given trial (between 0 and 1)
# Value: P(X = x), where X is the random variable giving the number of successes
#   in n=size independent Bernoulli trials, each resulting in either success
#   or failure, and each having the same probability, prob, of success.
# Note: this function is a baby version of the built-in dbinom() function.
baby.dbinom = function(x, size, prob) {
  value = prob^x * (1 - prob)^(size - x) * factorial(size) / factorial(x) / factorial(size - x)
  return(value)
}
# test cases
stopifnot(isTRUE(all.equal(.25, baby.dbinom(0, 2, .5), dbinom(0, 2, .5))))
stopifnot(isTRUE(all.equal(.50, baby.dbinom(1, 2, .5), dbinom(1, 2, .5))))
stopifnot(isTRUE(all.equal(.25, baby.dbinom(2, 2, .5), dbinom(2, 2, .5))))



# Description: baby.Welch runs a Welch's t test and finds a
#   confidence interval for an unknown difference of two means.
#   (It implements part of R's t.test().)
# Usage: baby.Welch(x, y, mu=0, conf.level=.95)
# Parameters:
#   x: a numeric vector of data values (must have at least two values)
#   y: a numeric vector of data values (must have at least two values)
#   mu: the hypothesised difference of true means
#   conf.level: confidence level of the interval (must be in (0, 1))
# Details: the test is for the null hypothesis that the
#   difference of true means is mu against the alternative
#   that the true mean is not mu.
# Value: a list containing these components (in this order):
#   $statistic: the t statistic
#   $parameter: degrees of freedom for the t statistic (not always an integer)
#   $p.value: probability of a t statistic more extreme than the one computed
#   $conf.int: a confidence interval for the true mean
#   $estimate: the estimated (sample) difference in means (Note: this corresponds
#     to the documentation in ?t.test, but not to the behavior of t.test().)
#   $null.value: the specifited hypothesized value of the difference in means (mu)
#
# (You may not use the real t.test() or related functions.)
baby.Welch = function(x, y, mu=0, conf.level=.95) {
  stopifnot(length(x) >= 2)
  stopifnot(length(y) >= 2)
  stopifnot((0 < conf.level) & (conf.level < 1))
  n.x = length(x)
  n.y = length(y)
  x.bar = mean(x)
  y.bar = mean(y)
  s.x = sd(x)
  s.y = sd(y)
  t = (x.bar - y.bar - mu) / sqrt(s.x^2 / n.x + s.y^2 / n.y)
  df = (s.x^2 / n.x + s.y^2 / n.y)^2 / ((s.x^2 / n.x)^2 / (n.x - 1) + (s.y^2 / n.y)^2 / (n.y - 1))
  r = list() 
  r$statistic = t 
  r$parameter = df
  r$p.value = 2*pt(q = -abs(t), df = df) # p-value
  alpha = 1 - conf.level
  t.for.conf.level = -qt(p = alpha/2, df = df)
  error.margin = t.for.conf.level * sqrt(s.x^2 / n.x + s.y^2 / n.y)
  r$conf.int = c(x.bar - y.bar - error.margin, x.bar - y.bar + error.margin) # confidence interval
  r$estimate = x.bar - y.bar 
  r$null.value = mu 
  
  return(r)
}
# test cases
baby.Welch.t = baby.Welch(x=1:10, y=11:20, mu=5, conf.level=.90) # compare my function to real t.test()
t = t.test(x=1:10, y=11:20, mu=5, conf.level=.90) # as.numeric(), below, strips names
stopifnot(isTRUE(all.equal(baby.Welch.t$statistic, as.numeric(t$statistic))))
stopifnot(isTRUE(all.equal(baby.Welch.t$parameter, as.numeric(t$parameter))))
stopifnot(isTRUE(all.equal(baby.Welch.t$p.value, as.numeric(t$p.value))))
stopifnot(isTRUE(all.equal(baby.Welch.t$conf.int, as.numeric(t$conf.int))))
stopifnot(isTRUE(all.equal(baby.Welch.t$estimate, as.numeric(t$estimate[1] - t$estimate[2]))))
stopifnot(isTRUE(all.equal(baby.Welch.t$null.value, as.numeric(t$null.value))))





# Returns TRUE if the (character string) is a lower-case vowel
# (a, e, i, o, or u), or FALSE otherwise.
isLowerVowel = function(letter) {
  if (letter %in% c("a", "e", "i", "o", "u")){
    return(TRUE)
  } else{
    return(FALSE)
  }
}



# Returns the smaller of x and y (both scalars).
baby.min = function(x, y) {
  if(x <= y){
    return(x)
  } else{
    return(y)
  }
}


# Given a nonnegative integer, age, returns a character string,
# one of "child" (0-14 years), "youth" (15-24 years),
# "adult" (25-64 years) or "senior" (65 or older).
ageCategory = function(age) {
  if (age >= 0 && age <= 14) {
    return("child")
  } else if (age >= 15 && age <= 24) {
    return("youth")
  } else if (age >= 25 && age <= 64) {
    return("adult")
  } else {
    return("senior")
  }
}


# Returns a vector whose ith element is the smaller of x[i] and y[i].
baby.min.vector = function(x, y) {
  return(ifelse(test = (x > y), yes = y, no = x))
}
x = c(3, 3); y = c(4, -4); m = baby.min.vector(x, y) # Type
x > y
stopifnot(isTRUE(all.equal(c(3, -4), m)))



# For numeric vector X and function FUN, baby.sapply(X, FUN)
# returns a vector whose ith value is FUN(X[i]).
# e.g. baby.sapply(X=c(1, 4, 9), FUN=sqrt) finds
# c(sqrt(1), sqrt(4), sqrt(9))
# and returns
# c(1, 2, 3).
#
# Note: This is a small version of R's built-in function sapply(), which
# applies FUN to each element of X. We'll study sapply() later.
baby.sapply = function(X, FUN) {
  result <- numeric(length(X))  # Create an empty numeric vector to store the results
  
  for (i in 1:length(X)) {
    result[i] <- FUN(X[i])  # Apply FUN to each element of X and store the result
  }
  
  return(result)
}


# For numeric vector X, factor INDEX, and function FUN that returns
# a single number, baby.tapply(X, INDEX, FUN) applies FUN to a subset of X
# for each level in in INDEX (having the same length as X), returning a
# vector of length(levels(factor(INDEX))) values.
# e.g. baby.tapply(X=mtcars$mpg, INDEX=mtcars$cyl, FUN=mean)
# gives a vector of three means, one each for 4-, 6-, and 8-cylinder cars.
#
# Note: This is a small version of R's function tapply(), which we'll study later.
baby.tapply = function(X, INDEX, FUN) {
  unique_levels <- levels(factor(INDEX))  # Get unique levels of INDEX
  result <- numeric(length(unique_levels))  # Create an empty numeric vector to store the results
  
  for (i in 1:length(unique_levels)) {
    level <- unique_levels[i]  # Get the current level
    subset_X <- X[INDEX == level]  # Subset of X corresponding to the current level
    result[i] <- FUN(subset_X)  # Apply FUN to the subset and store the result
  }
  
  return(result)
}



# Returns the sum of the even numbers in vector x.
# e.g. sumEven(c(2, 5, 10, 11)) returns 12.
sumEven = function(x) {
  even_numbers <- x[x %% 2 == 0]  # Filter even numbers using a logical expression
  result <- sum(even_numbers)  # Sum the even numbers
  return(result)
}

# Returns the sum of the even numbers in vector x.
sumEven = function(x) {
  if (length(x) == 0) {
    return(0)  # Return 0 for an empty vector
  }
  
  sum_even <- 0  # Initialize the sum of even numbers
  
  for (i in 1:length(x)) {
    if (x[i] %% 2 == 0) {  # Check if the current element is even
      sum_even <- sum_even + x[i]  # Add even number to the sum
    }
  }
  
  return(sum_even)
}


# Example usage:
result <- sumEven(c(2, 5, 10, 11))
print(result)



# Returns index of first occurrence of target in x, or 0 if target is not in x.
# e.g. For x = c(8, 7, 6),
# linearSearch(x=x, target=7) returns 2,
# linearSearch(x=x, target=5) returns 0, and
# linearSearch(x=NULL, target=5) returns 0.
linearSearch = function(x, target) {
  if (is.null(x) || length(x) == 0) {
    return(0)  # Return 0 if x is NULL or empty
  }
  
  for (i in 1:length(x)) {
    if (x[i] == target) {
      return(i)  # Return the index of the first occurrence of the target
    }
  }
  
  return(0)  # Return 0 if the target is not found in x
}

# Example usage:
x <- c(8, 7, 6)
result1 <- linearSearch(x = x, target = 7)
result2 <- linearSearch(x = x, target = 5)
result3 <- linearSearch(x = NULL, target = 5)

print(result1)  # Should return 2
print(result2)  # Should return 0
print(result3)  # Should return 0



# Uses binary search to return the index of an occurrence of target in x,
# where x is a vector sorted in increasing order, or 0 if target is not in x.
binarySearch = function(x, target) {
  if (length(x) == 0) {
    return(0)  # Return 0 if the vector is empty
  }
  
  left <- 1  # Initialize the left pointer
  right <- length(x)  # Initialize the right pointer
  
  while (left <= right) {
    mid <- left + (right - left) %/% 2  # Calculate the middle index
    
    if (x[mid] == target) {
      return(mid)  # Target found, return the index
    }
    
    if (x[mid] < target) {
      left <- mid + 1  # Target is in the right half of the current range
    } else {
      right <- mid - 1  # Target is in the left half of the current range
    }
  }
  
  return(0)  # Target not found in x
}

# Example usage:
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
target1 <- 7
target2 <- 11

result1 <- binarySearch(x = x, target = target1)
result2 <- binarySearch(x = x, target = target2)

print(result1)  # Should return 7 (index of 7 in x)
print(result2)  # Should return 0 (target not in x)



# Prompts user for a character string, one of "child", "youth", "adult", or "senior";
# reads the user input, and returns it if the user cooperates. The prompt/input process
# is repeated until the user cooperates.
# (This function might be useful in a web form: it will not let the user leave a text box until
# that box is filled in correctly.)
ageCategoryFromUser = function() {
  age_categories <- c("child", "youth", "adult", "senior")
  
  repeat {
    cat("Enter your age category (child, youth, adult, or senior): ")
    user_input <- tolower(readline())  # Read user input and convert it to lowercase
    
    if (user_input %in% age_categories) {
      return(user_input)  # Return the input if it matches one of the categories
    } else {
      cat("Invalid input. Please enter a valid age category.\n")
    }
  }
}

age = ageCategoryFromUser()
child
stopifnot(age =="child")
age = ageCategoryFromUser()
youth
stopifnot(age =="youth")
age = ageCategoryFromUser()
adult
stopifnot(age =="adult")
age = ageCategoryFromUser()
badInput
badInput
senior
stopifnot(age =="senior")

red.density = function(x, ...) { # (Try it without "..." parameter too.)
  plot(density(x), col="red", ...) # Pass extra arguments to plot().
}
red.density(x=rnorm(100), main="Two extra arguments", lty="dashed")


mean.and.sd = function(x) { return(c(mean=mean(x), sd=sd(x))) }
lapply(X=mtcars, FUN=mean.and.sd)
min(sapply(X=mtcars, FUN=mean.and.sd)[1,])
       

scoreCar = function(mpg, hp) { return(20*mpg + hp) }
m = mtcars
m$score = mapply(scoreCar, m$mpg, m$hp)
which.max(m$score)

m = matrix(data=1:6, nrow=2, ncol=3)
rowSums(m)
colSums(m)

# Returns a vector of standard deviations, one for each row of matrix x.
rowStandardDeviations = function(x) {
  return(apply(x, 1, FUN=sd))
}


tapply(iris$Petal.Length, INDEX=iris$Species, FUN = mean)


# Calls hist() on the given arguments x, main, xlab,
# ylab, along with unspecified additional arguments
# received by the ... argument.
h = function(x, main="", xlab="", ylab="", ...) {
  hist(x, main = main, xlab = xlab, ylab = ylab, ...)
}
hist(mtcars$mpg)
h(mtcars$mpg)
h(mtcars$mpg, main="mileages", breaks=seq(from=0, to=40, by=5))






a = array(data=1:12, dim=c(3, 2, 2))
a = array(data=a, dim=c(2,6,1))
a = array(data=1:12, dim=c(3, 2, 2)); a
sum(a[1,,])
sum(a[,1,])
sum(a[,,1])
a[3, 2, 1] + a[2, 2, 2]
sum(a[(a %% 2) == 1])
m = matrix(data=c(2,8,6,2), nrow=2, ncol=2, byrow=TRUE)
new_matrix <- rbind(c(1, 1, 1, 1), cbind(1, m, 1), c(1, 1, 1, 1))
sum(new_matrix)
m <- matrix(c(2, 8, 6, 2, 9, 8, 8, 8, 0), nrow = 3, byrow=TRUE)
sum(m[row(m) - col(m) == 1])
sum(m[row(m) + col(m) == 5])

matrix1 <- matrix(c(2, 8, 6, 2, 9, 8), nrow = 2, byrow = TRUE)
matrix2 <- matrix(c(8, 8, 0, 2, 8, 6), nrow = 3, byrow = TRUE)
result_matrix <- matrix1 %*% matrix2
sum_of_elements <- sum(result_matrix)
sum_of_elements

vector.sum = function(x) {
  result <- 0
  if (length(x) == 0) {
    return(0)
  }
  for (element in x) {
    result <- result + element
  }
  return(result)
}
setMatrixValues = function(A, rows, columns, values) {
  # Check if the input vectors have the same length
  if (length(rows) != length(columns) || length(rows) != length(values)) {
    stop("Input vectors must have the same length.")
  }
  
  # Loop through the elements to set the values
  for (i in 1:length(rows)) {
    A[rows[i], columns[i]] <- values[i]
  }
  
  return(A)
}

# Example usage:
# Create a sample matrix A
A <- matrix(data = 1:6, nrow = 2, ncol = 3)

# Define the vectors rows, columns, and values
rows <- c(2, 1)
columns <- c(3, 2)
values <- c(7, 8)

# Update the matrix A with the specified values
updated_matrix <- setMatrixValues(A, rows, columns, values)
print(updated_matrix)





v = readLines(con="jwang2928Q6.txt")
head(v)
grep(pattern = "A", x = v)
grep(pattern = "[1-3] [abc]", x = v)
grep(pattern = "^[A-C]", x = v) 
grep(pattern = "[aeiou] ", x = v) 
grep(pattern = "[aeiou]\\s", x=v)

count = 0
for (line in v) {
  word <- gsub("^[A-Za-z]+ [0-5]{4} ", "", line) # Extracting the WORD section
  if (grepl('[aeiou][aeiou]', word)) {
    count <- count + 1
    print(line)
  }
}
count


