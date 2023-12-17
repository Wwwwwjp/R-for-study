rm(list = ls()) # initialization



##############If you have prior programming experience##############
# read http://pages.stat.wisc.edu/~byang/304/bored
# try to solve some problems at https://projecteuler.net/archives in R


#########################Programming Basics#########################
# see http://www.programmingbasics.org/en/

# Important Tips:
# 1. Programming style: neatness, simplicity, meaningful names, comments, indentations and spacing
# 2. Data structure and type
# 3. Control flow and block diagram/flow chart
# 4. Debugging (troubleshooting): always check the values and structures of the variables
# 5. Scope of variable



# Subtle Example: Testing numeric functions; always be careful about the type
# test the equivalence of two decimals, instead of two integers
(1/49)*49 == 1 # TRUE or FALSE?
(1/49)*49 # Looks like 1!
1-(1/49)*49 # Unexpected error appears!

# Type does matter!
(48/6)*6 == 48 # why?

# Use a function to do the test
?all.equal
all.equal((1/49)*49, 1) # TRUE!
all.equal((1/49)*48, 1) # not FALSE!
all.equal(0, 1) # not FALSE!

?isTRUE # returns TRUE if x is TRUE, and FALSE otherwise.
isTRUE(all.equal((1/49)*49, 1)) # TRUE!
isTRUE(all.equal((1/49)*48, 1)) # finally done!

?stopifnot
stopifnot(0 < 1) # OK since nothing is FALSE.
stopifnot(0 < 1, 1:3 < 3) # 0 < 1 is TRUE while 1:3 < 3 is not TRUE (last entry).

stopifnot(isTRUE(all.equal(1.414, sqrt(2)))) # good for debugging
# use stopifnot(isTRUE(all.equal(answer, f(ARGUMENT.LIST)))) 
# to check whether a function call f(ARGUMENT.LIST) returns the expected answer



##############################Function##############################
# Define a new function
# FUNCTION.NAME = function(PARAMETER.LIST) { # input
#   BODY                                     # output
# }


letterhead = function() { 
# define new function "letterhead" with no arguments
# just print out the desired letterhead
# no input/parameter, no output/return value

  cat(sep = "", "1300 University Avenue\n")
  cat(sep = "", "Madison WI 53706\n")
}
letterhead() # call letterhead()


standardize = function(x, mu = 0, sigma = 1) { # define "standardize" with 3 args.
  z = (x - mu) / sigma # local variable, only exists when standardize() is called
  return(z)
}

z = 3 # global variable, independent of standardize()
standardize(x = 10, mu = 6, sigma = 2) # call standardize()
z # standardize() did not change z

z = standardize(4, mu = 6) # now z changes by assigning the return value of standardize() to it
z

z = letterhead() # letterhead() returns NULL since the printout is not a return value!
z



#!!!!!!!!!!!!!How to debug the code inside a function?!!!!!!!!!!!!!#
# You could comment out the beginning and the ending line
# and replace all the return(value) with value.
# Then, assign some testing values to the parameters.
# Some advanced methods should be discussion in the advanced section.


# Description: baby.t.test performs a one-sample t-test and computes a
#   confidence interval for an unknown mean.
# Usage: baby.t.test(x, mu = 0, conf.level = .95)
#
# Parameters:
#   x: a numeric vector of data values (must have at least two values)
#   mu: the hypothesised true mean
#   conf.level: confidence level of the interval (must be in (0, 1))
#
# Details: the test is for the null hypothesis that the true mean is
#   mu against the alternative that the true mean is not mu
#
# Value: a list containing these components:
#   $statistic: the t statistic
#   $parameter: degrees of freedom for the t statistic
#   $p.value: probability of a t statistic more extreme than the one computed
#   $conf.int: a confidence interval for the true mean using
#     confidence level conf.level
#   $estimate: the estimated (sample) mean
#   $null.value: the specifited hypothesized value of the mean (mu)
#
# (In this exercise, we won't use the real t.test().)

baby.t.test = function(x, mu = 0, conf.level = .95) {
  # test whether the input is correct
  stopifnot(length(x) >= 2)
  stopifnot((0 < conf.level) & (conf.level < 1))
  
  # calculations from the given formulas
  n = length(x)
  x.bar = mean(x)
  s.x = sd(x)
  t = (x.bar - mu) / (s.x / sqrt(n))
  
  # set up r as return value
  r = list() 
  r$statistic = t # t score
  r$parameter = n - 1 # degrees of freedom
  r$p.value = 2*pt(q = -abs(t), df = n-1) # p-value
  alpha = 1 - conf.level
  t.for.conf.level = -qt(p = alpha/2, df = n-1)
  error.margin = t.for.conf.level * s.x / sqrt(n)
  r$conf.int = c(x.bar - error.margin, x.bar + error.margin) # confidence interval
  r$estimate = x.bar # point estimate
  r$null.value = mu # null value
  
  # return r as a list and quit
  return(r)
}


# test the output of our baby.t.test function
baby.t = baby.t.test(x = 1:10, mu = 5, conf.level = .90)
t = t.test(x = 1:10, mu = 5, conf.level = .90) # call the real function to check baby.test

# Note: as.numeric(), below, removes names from components of t
stopifnot(isTRUE(all.equal(baby.t$statistic, as.numeric(t$statistic))))
stopifnot(isTRUE(all.equal(baby.t$parameter, as.numeric(t$parameter))))
stopifnot(isTRUE(all.equal(baby.t$p.value, as.numeric(t$p.value))))
stopifnot(isTRUE(all.equal(baby.t$conf.int, as.numeric(t$conf.int))))
stopifnot(isTRUE(all.equal(baby.t$estimate, as.numeric(t$estimate))))
stopifnot(isTRUE(all.equal(baby.t$null.value, as.numeric(t$null.value))))



# Advanced topics
# The beginner could skip the remaining part
# Example: scopes of variables, how to pass parameters by name or by position, default values
# also: difference between return() and cat()
square.a = function(a = 1, b = 2) {# input with default values
  # printing the value of parameters/local variables by cat() is good for debugging!
  cat(sep = "", " square.a(a=", a, ", b=", b, ")\n") 
  b = 100 # local variable, only exists when square.a() is called
  c = a*a # local variable, only exists when square.a() is called
  return(c)
}

square.a(a = 3, b = 4) # passing by name in a default order, the best way to call a function
square.a(b = 4, 3) # identical call, but in a confusing order. To make worse, passing by position for the 2nd parameter.

a = 5; b = 6; c = 7 # global variable
square.a(b) # which parameter?! A really bad call!
# passing the value of b to the 1st parameter a by position
# the 2nd parameter chooses the default value 2

# equivalent code 1 
square.a(a = 6, b = 2)
# equivalent code 2
square.a(a = b, b = 2)
cat(sep = "", "a=", a, ", b=", b, ", c=", c, "\n")
# Only the values of parameters are transferred to the function!