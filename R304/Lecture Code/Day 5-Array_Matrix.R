rm(list = ls()) # initialization


###############################Matrix###############################
# data with matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE, dimnames = NULL)
# two dimension

m = matrix(data = 1:12, nrow = 3, ncol = 4, byrow = TRUE)
m

kids = matrix(data = c(c(  1,   2,   6,   7,   9,  11), 
                       c(  1,   5, 100, 100, 100, 100)),
              nrow = 2, ncol = 6, byrow = TRUE,
              dimnames = list(c("Age", "#Toys"),
                              c("Teresa", "Margaret", "Monica", "Andrew", "Mary", "Philip")
              )
)
kids # with column/row names


# combine columns with cbind(...) or rows with rbind(...)
cbind(m, 101:103)
rbind(101:104, m)


# Operations of Matrices
A = matrix(data = 1:6, nrow = 3, ncol = 2, byrow = TRUE); A
B = matrix(data = 1:6, nrow = 2, ncol = 3, byrow = TRUE); B
C = matrix(data = 6:1, nrow = 3, ncol = 2, byrow = TRUE); C
x = 1:2

A * B # element-wise product
      # dimensions don't match!
A * C


A %*% B # usual matrix product
A %*% C # dimensions don't match!
A %*% x # usual matrix-vector product


# solve(a = A, b = b) gives the solution x to the system of linear equations, Ax = b; e.g.
A = matrix(data = 1:4, nrow = 2, ncol = 2)
b = c(7, 10)
(x = solve(a = A, b = b))
A %*% x # check: is it b?


# The Matrix package has much more: http://cran.r-project.org/web/packages/Matrix/Matrix.pdf.


################################Array###############################
# more dimension
# a = array(data = NA, dim = length(data), dimnames = NULL)

a = array(data = -(1:24), dim = c(3, 4, 2))
dimnames(a) = list(c("slow", "medium", "fast"), 
                   c("cold", "tepid", "warm", "hot"),
                   c("Monday", "Tuedsay"))
a

dim(a) = c(4, 6) # 4 by 6, a matrix
a

dim(a) = NULL # a becomes a vector
dim(a) = c(24) # same
a

dim(a) = c(2, 3, 2, 2) # 2 by 3 by 2 by 2, 4-D
a

dim(a) = c(3, 4, 2) # back to start, 3-D
a


# indexing
# Important: You need to try it on your own by changing some parameters below.
a[2, 3, 1] # single element (row, column, floor)

a[8] # single element. Treat the array as an regular vector.

a[ , 3:4, 2] # regular subset of an array

(index = matrix(data = c(1, 1, 1, 
                         2, 2, 2), nrow = 2, ncol = length(dim(a)), byrow = TRUE)) # index matrix
a[index] # irregular subset of an array: a[1, 1, 1] & a[2, 2, 2]

# use a logic condition as a criterion
(a %% 2) == 0 # Which values are even?
a[(a %% 2) == 0] # Get even values in form of a vector.
a[(a %% 2) == 0] = -a[(a %% 2) == 0] # Set even values: multiply by -1.
a


# summary
# 1. Indexing is hard. Always use trial-error methods.
# 2. Focus on matrix first. Then try array later.
# 3. see the relationship among vector, array & matrix, list and data frame at
# https://www.programcreek.com/2014/01/vector-array-list-and-data-frame-in-r/