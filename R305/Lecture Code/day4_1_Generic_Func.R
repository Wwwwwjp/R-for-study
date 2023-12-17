####################Generic Function Programming####################

rm(list = ls()) # initialization

# more flexibilities and expandabilities from object-oriented programming, especially polymorphism
# https://en.wikipedia.org/wiki/Object-oriented_programming#Polymorphism
#
# Main idea:
# Many methods having the similar functionality in the different forms for different classes of variables.
#
# For example, all kind of methods can be combined into one generic function func()
# func.classOne(t)   ---
# func.classTwo(u)     |
# func.classThree(v)   |
# func.classFour(w)    |==> one func(any var t~z of diff classes)
# func.classFive(x)    |
# func.classSix(y)     |
# func.classSeven(z) ---
#
# Conclusion: 
# When you are going to implement the detailed print procedure for each class of var,
# you need to define each corresponding methods explicityly and separately. However, once they 
# are defined, never call each method directly. Always call func() to save the 
# hassles to memorize so many different method names. This also improves the flexibility
# and expandability of the existing generic function (see below).
#
# When R encounter a generic function with an argument, R will first find its argument's class
# and look up the corresponding method under the generic function by its class name. Then, R 
# simply calls the corresponding method.
#
# method: GENERIC_FUNCTION_NAME.CLASS_NAME()

# Let's try print() first

x = 3.14
class(x) # similar to type
print(x) 
print.default(x) # the same
# Ideally, it should be print.numeric(x).
# However, for some very basic classes, the corresponding methods name is different by some reason.

y = "test"
class(y)
print(y) 
print.default(y) # the same
# Ideally, it should be print.character(x).
# However, for some very basic classes, the corresponding methods name is different by some reason.

class(mtcars)
print(mtcars) 
print.data.frame(mtcars) # the same

m = lm(mpg ~ wt, mtcars)
class(m)
print(m) 
print.noquote(m) # the same
# In the older version of R, it should be print.lm(x).
# However, in the newest version of R, print.lm(x) has been discarded by some reason.


# summary
methods(print) # lists all the methods available for generic functions

# NOTE:
# Users are not encouraged to call these methods directly.
# Always call the generic function with an argument directly.
# Ususally, don't change the definition of all the existing methods.



# Example:
# To expand the functionability of the generic function print(),
# we can assign a new class to some data and define the corresponding method for print().
#
# new class: girl
# new print method: print.girl

g = list(name = "Margaret", age = 2) # data, its original class = list
class(g)
print(g)

class(g) = "girl" # new class
class(g)
print(g) # default output

methods(print)
# define a new method for girl
print.girl = function(x) {
  cat(sep = "", toupper(x$name), ", ", x$age, "\n") #girl's name in the upper case
}
# This is the only place to use print.girl() explicitly.
methods(print) # one more method in the list
print(g) # print g in the defined way by print.girl()



# new class: boy
# new print method: print.boy

b = list(name = "Philip", age = 11) # data, its original class = list
class(b)
print(b)
 
class(b) = "boy"
class(b)
print(b) # default output

methods(print)
#define a new method for boy
print.boy = function(x) {
  cat(sep = "", tolower(x$name), ", ", x$age, "\n") # boy's name in the lower case
}
methods(print) # one more method in the list
print(b) # print b in the defined way by print.boy()



# Example:
# We can define new coef methods for passing the parameters to some function implicitly.
# For example,

plot(x = 0:3, y = 3:0)
#draw a line y = a + bx
?abline
# default way: abline(a, b), using two parameters a and b, like 
abline(2, 0)
# or equivalently, use the parameter reg: reg = c(a, b)
abline(reg = c(2, 0))
# It is not always convenient because it requires a conversion or extraction
# to get a and b explicitly from the given data.
# However, reg is "an object with a coef method", 
# which gives us an interface to insert a code to extract data implicitly.
?coef


g # data
# Goal: extract girl's age as a with b = 0 in abline().

plot(x = 0:3, y = 3:0)
abline(g) # It doesn't work right now, but its form looks convenient.
abline(g$age, 0) # = g(2, 0), requiring an explicit extraction g$age to get a from g.


# Define a method under this special generic function coef for the class girl in abline()
# to extract a and b implicitly from g.

methods(coef) #lists available methods for generic.function or class
# new coef method: coef.girl
# return c(a, b) from girl class, which can be used in abline()
coef.girl = function(object, ...) { #extract useful data from girl class as a parameter in a good format
  return(c(object$age, 0)) # horizontal line with y-intercept age
}
methods(coef)
plot(x = 0:3, y = 3:0)
abline(g) # = abline(2, 0) or abline(reg = c(2, 0))


# Search methods:
methods(coef) # list by generic function
methods(class = "girl") # list by class


# For more, see 
# http://adv-r.had.co.nz/OO-essentials.html and
# Section 7 "Generic functions and methods" 
# in http://cran.r-project.org/doc/manuals/r-release/R-exts.html