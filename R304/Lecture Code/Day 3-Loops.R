rm(list = ls()) # initialization


############################Flow Control############################
################################Loop################################

# Implementations taught in STAT303:
# recycling rule for vectors
# replicate() (especially for simulation)


# Three general implementations
# for()
# for (VARIABLE in SEQUENCE) { # for i = 1, 2, 3, ..., n
#   EXPRESSION
# }

# for() loop through sequence
list.files()
for (file.name in list.files()) { # sequence is all the file names) 
                                  # in your working directory
                                  # list.files() gives all file names
                                  # in your working directory
  cat("file.name =", file.name,"\n") # always use cat() to print
}


# factorial function
baby.factorial = function(n) {
  stopifnot(n >= 0) # test parameter
                    # test integer???
  
  product = 1
  for (i in seq_len(n)) {
    product = product * i
  }
  
  return(product)
}
baby.factorial(3)


# subtle example
n = 3
seq_len(n) # test seq_len(n) for the sequence, important debugging skill!
1:n # same sequence

for (i in seq_len(n)) { # same line when n = 3: for (i in 1:n) {
  even.or.odd = ifelse(i %% 2 == 0, "even", "odd")
  cat(i, "is", even.or.odd, "\n")
}

n = 0
seq_len(n) # integer(0) means empty sequence
1:n # 1:0 is not empty!
for (i in seq_len(n)) { # The empty sequence implies that express inside the loop won't be run!
                        # So, no output! Different from other programming language!
  even.or.odd = ifelse(i %% 2 == 0, "even", "odd")
  cat(i, "is", even.or.odd, "\n")
}
for (i in 1:n) { # The express inside the loop will be run twice: one for i=1 and another for i=0!
  even.or.odd = ifelse(i %% 2 == 0, "even", "odd")  
  cat(i, "is", even.or.odd, "\n") # two output totally
}


# Important debugging skill:
# print out the sequence first!
# If you are not sure, always cat(i) inside the loop!

# sum
x = c(2, 3, 5)
total = 0 # initial value for the total sum
for (x.i in x) { # loop through values
  total = total + x.i # by entry
  # If you are not sure
  # cat(x.i,"\n") # for debugging
}
total
sum(x) # same result, need to call a base function


# alternative way, not recommended in most cases, but lots of students always use it.
x = c(2, 3, 5)
total = 0 # initial value for the total sum
for (i in 1:3) { # loop through indices 
  total = total + x[i] # not elegant
  # If you are not sure
  # cat(x[i],"\n") # for debugging
}
total
sum(x) # same result


# product
product = 1 # initial value for the total product
for (i in seq_len(length(x))) {
  product = product * x[i] # by indices
  # If you are not sure
  cat(sep="", "x[", i, "]: ",x[i],"\n") # debugging
}
product
prod(x) # same result, need to call a base function
# Can you rewrite it as a loop through values?



# while()
# while (CONDITION) { # When the condition is TRUE, run the expression repeatedly.
#   EXPRESSION        # Zero (since we test the condition at the beginning) or more times or never quit!
# }
x = 1
while (x < 10) {
  cat("x =", x, "\n")
  x = 2*x
}

x = 10
while (x < 10) { # The condition is FALSE at the beginning. 
                 # So, no expression inside the loop will be run. No output.
  cat("x =", x, "\n") # good for debugging
  x = 2*x
}

x = 0
while (x < 10) { # The condition is always TRUE. 
                 # The loop cannot stop. Press ESC to quit.
  cat("x =", x, "\n") # good for debugging
  x = 2*x # x = 0 always! Inside the loop, you need to make changes for the condition.
          # Otherwise, a deadlock.
}

# Two more examples
# Show progress of an investment receiving annual compound interest 
# as it grows to $100.
balance = 50
interest.rate = 0.07
n.years = 0
while (balance < 100) {
  balance = balance * (1 + interest.rate)
  n.years = n.years + 1
  cat(sep = "", "After ", n.years, " years, balance is ", balance, "\n")
}

# The second way to find n! = n(n ??? 1)(n ??? 2)? ? ?(3)(2)(1).
baby.factorial.while = function(n) {
  stopifnot(n >= 0)
  product = 1
  while (n >= 1) {
    product = product * n
    n = n - 1
  }
  return(product)
}
baby.factorial.while(3)



# repeat()
# repeat { # Repeat until until the condition is true (one or more times or never quit) 
           # since we test the condition at the end.
#   EXPRESSION
#   if (CONDITION) {
#     break # quit
#   }
# }
# Good for waiting for some response from the user.

# Say 'Yes' example: Keep asking you until you have to say 'Yes'. 
# Good for Valentine's Day!
repeat {
  cat("Do you love me? Please answer 'Yes' or 'No':")
  decision = scan(what = character(), n = 1, quiet = TRUE) # ?scan. Actually, get your input on the console.
  if (decision == "Yes") { # You have to set up a way to quit. Otherwise, a deadlock!
    break # A must! Otherwise, endless loop!
  }
}

# another funny example
repeat {
  cat("Pete and Repeat were sitting on fence. Pete fell off. Who was left?\n")
  answer = scan(what=character(), n = 1)
  if (answer != "Repeat") { # You have to set up a way to quit. Otherwise, a deadlock!
    break # A must!
  }
}

# next: skip the remaining expression and go to next round directly.
repeat {
  cat("Are you goint to skip my next question?\n")
  answer = scan(what = character(), n = 1)
  if (answer == "Yes") {
    next
  }
  cat("Pete and Repeat were sitting on fence. Pete fell off. Who was left?\n")
  answer = scan(what = character(), n = 1)
  if (answer != "Repeat") {
    break
  }
}


# indentation
# "{" does not get a new line
# "}" is on a line by itself, indented like the line containing the corresponding "{"
# {}, (), [], '', "" must be matched usually. The edit can help you somehow.
# code inside braces is indented two spaces
# In RStudio, use "Code > Reindent Lines"


# comparing for(), while() and repeat

# Note that the "while" loop is all we really need. The other two are
# for convenience. e.g. Here's the "for" loop for iterating through a
# known sequence:
#
# for (VARIABLE in SEQUENCE) {
#   EXPRESSION
# }
#
# and here's how to do (almost) the same thing with "while":
#
# i = 1
# while (i <= length(SEQUENCE)) {
#   VARIABLE = SEQUENCE[i]
#   EXPRESSION
#   i = i + 1
# }
#
# The "for" version is easier to write and read!
#
# e.g. Here's a "repeat" loop for running EXPRESSION one or more times:
#
# repeat {
#   EXPRESSION
#   if (CONDITION) {
#     break
#   }
# }
#
# and here's how to do the same thing with "while":
#
# EXPRESSION
# while (!CONDITION) {
#   EXPRESSION
# }
#
# The "repeat" version is better because having two copies of
# "EXPRESSION" is hard to maintain.


# example with a matrix
# Play with matrices to see some standard loops. (There are easier ways
# to do many of these things, e.g. set first row to 1's with "m[ ,1] = 1",
# but these make nice loop exampes.)

n = 3
M = matrix(rep(x = 0, times = n^2), nrow = n, ncol = n) # M is a nxn matrix of zeros
M

m = M # m is a copy I'll mess with
# Set first row to 1's.
for (col in 1:n) {
  m[1, col] = 1
}
m
m[1, ] = 1 # the same, without for loop

m = M
# Set first column to 1's.
for (row in 1:n) {
  m[row, 1] = 1
}
m

m = M
# Set diagonal to 1's.
for (i in 1:n) {
  m[i, i] = 1
}
m

m = M
# Set reverse diagonal to 1's.
for (i in 1:n) {
  m[i, n-i+1] = 1
}
m

m = M
# Use simple nested loops to set all to 1's!
for (row in 1:n) {
  for (col in 1:n) {
    m[row, col] = 1
  }
}
m

m = M
# Use more complicated nested loops to set upper triangle to 1's!
for (row in 1:n) {
  for (col in row:n) {
    m[row, col] = 1
  }
}
m


# Matrix Multiplication (nested loop)
matrix.multiply = function(A, B, debug = FALSE) {
  a = dim(A)
  n = a[1] # Number of rows of A.
  m = a[2] # Number of columns of A.
  b = dim(B)
  stopifnot(m == b[1]) # Otherwise A and B cannot be multiplied.
  
  p = b[2] # Number of columns of B.
  C = matrix(data = rep(x = 0, times = n*p), nrow = n, ncol = p) # n by p zeros.
  for (i in 1:n) { # For each row in C.
    if (debug) {
      cat(sep = "", "i=", i, "\n") # for debugging
    }
    for (j in 1:p) { # For each column in C.
      if (debug) {
        cat(sep = "", " j=", j, "\n") # for debugging
      }
      # Set C[i, j] to dot product of ith row of A and jth column of B.
      for (k in 1:m) {
        C[i, j] = C[i, j] + A[i, k] * B[k, j]
        if (debug) {
          cat(sep = "", " C[", i, ", " , j, "]=", C[i, j], "\n") # for debugging
        }
      }
    }
  }
  return(C)
}

A = matrix(data = 1:6, nrow = 2, ncol = 3)
B = matrix(data = 1:6, nrow = 3, ncol = 2)
A
B
matrix.multiply(A, B)
A %*% B # Does our function give same results as R's operator?
matrix.multiply(A, B, debug = TRUE) # Note debugging output.
matrix.multiply(B, A, debug = TRUE) # Commutative law doesn't hold!


# summary
# 1. Always test the sequences before for() for debugging.
# 2. Always print some variable by cat() inside the loop for debugging.
# 3. Focus on one of loop forms first, like for() or while().
# 4. You need to change the condition somehow inside the loop to quit the loop.
# 5. Indentation is useful for improving readability and debugging.