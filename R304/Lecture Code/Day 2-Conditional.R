rm(list = ls()) #initialization


##############If you have prior programming experience##############
# read http://pages.stat.wisc.edu/~byang/304/bored
# try to solve some problems at https://projecteuler.net/archives in R


#########################Programming Basics#########################
# see http://www.programmingbasics.org/en/

# Important Tips:
# 1. Programming style: neatness, simplicity, meaningful names, comments, indentations and spaces
# 2. Data structure and type
# 3. Control flow and block diagram/flow chart
# 4. Debugging (troubleshooting): always check the values and structures of the variables
# 5. Scope of variable



###############################Branch###############################

# example: set x to |x|
x = -3
x < 0
if (x < 0) {
  # cat(x) #: for debugging
  x = -x
}
x


# example: two branches, even or odd
x = 3
x %% 2 # for debugging
x %% 2 == 0 # for debugging
if ((x %% 2) == 0) { # even or odd
  parity = "even" # indentation is good for debugging!
} else { # "} else" should be on a single line, unlike C++!
  parity = "odd"
}
parity
# You can try x = 100 to re-run the lines above.

# shortcut for two branches
?ifelse
x = 100
parity = ifelse(test = (x %% 2) == 0, yes = "even", no = "odd")
parity


# else if for more branches
# example: three or more branches based on temperature
water.state = function(temperature) { # example within a function
  if (temperature < 32) {
    state = "frozen"
  } else if (temperature > 212) {
    state = "boiling"
  } else {
    state = "liquid"
  }
  
  return(state)
}

# Or, use switch(): 
# water.state = function(temperature) {
#   state = switch(sum(temperature >= 32, temperature > 212) + 1, "frozen", "liquid", "boiling")
#   return(state)
# }

water.state(20)
water.state(60)
water.state(220)



is.heads = function() { # Return TRUE or FALSE to simulate a coin flip.
  r = rnorm(1)
  if (r < 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

x = is.heads() # test cases

N = 100; coins = replicate(N, is.heads()); mean(coins) # see STAT303 or use ?replicate



# shorter version
is.heads = function() { 
  r = rnorm(1)
  return(r < 0)
}

# Even shorter
is.heads = function() { 
  return(rnorm(1) < 0)
}

# Making code shorter doesn't mean to sacrifice its readability!


# Return maximum of a and b. 
# Implements part of R's max() function
baby.max = function(a, b) { 
  # good for any scalar input
  # BUG!!!: fails for vector input
  # print(a > b) # for debugging
  if (a > b) {
    return(a)
  } else {
    return(b)
  }
}

# works for scalar input
stopifnot(isTRUE(all.equal(4, baby.max(3,  4))))
stopifnot(isTRUE(all.equal(3, baby.max(3, -4))))

x = c(3, 3); y = c(4, -4); m = baby.max(x, y) # Type of arguments!

stopifnot(isTRUE(all.equal(c(4, 3), m))) # BUG revealed.

# debugging test line for the error above
c(3, 1) < c(2, 3) # element-wise comparison
if (c(3, 4) > c(2, 3)) { # vector comparison in if confuses R, so an error message comes out
  print(1)
} else {
  print(2)
}




baby.max = function(a, b) { # Improved to work for vector input, instead of only integer input.
  return(ifelse(test = (a > b), yes = a, no = b))
}

stopifnot(isTRUE(all.equal(4, baby.max(3, 4))))
stopifnot(isTRUE(all.equal(3, baby.max(3, -4))))

x = c(3, 3); y = c(4, -4); m = baby.max(x, y) # Type
x > y
stopifnot(isTRUE(all.equal(c(4, 3), m))) # elementwise result is correct now!



# You can use cat() to print the different stuff in each branch
# to help you debug!



# Use of switch(), for advanced students only

temperature = c(20, 60, 220) 

# three branches need two ifelse()'s
water.state = function(temperature) { # example within a function
  return(ifelse(test = temperature < 32, "frozen", ifelse(temperature > 212, "boiling", "liquid")))
}
water.state(c(20, 60, 220)) # OK with vector input
# switch() doesn't work.

# Any universal method? Yes, using apply() below, see it in the following lecture
sapply(c(20, 60, 220), water.state)



# summary
# 1. "} else" or "} else if" should be on a single line, unlike C++!
# 2. Always print some output in each branches by cat() or print() for debugging.
# 3. Comparison is subtle sometimes, especially for numeric values. Remember stopifnot(isTRUE(all.equal())).
# 4. Always call a function with PARAMETERS = VALUES in a good order.
# 5. Always print the values of parameters/local variables inside the function for debugging.
# 6. You could comment out the beginning and the ending line of the function for debugging.
# 7. Remember the scope of global/local variables. Local variables cannot exist outside the function.
# 8. Print the condition of comparison and insert some printouts in each branch if you have trouble with if ... then ...