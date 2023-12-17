# Gradient Descent Method
# feature: 
#   cons: require f'(x)
#   pros: for n-D
#         converges usually fast
#
# see https://en.wikipedia.org/wiki/Newton%27s_method
# see https://en.wikipedia.org/wiki/Rosenbrock_function 
#     for why this method cannot perform well with Rosenbrock (aka banana) function sometimes

######################Formulation and Preparation######################

rm(list=ls())


# Objective function
f = function(x, y) { # Define function z = f(x, y).
  return(-(cos(x)^2 + cos(y)^2)^2)
}

# Its 1st-order gradient f'(x)
gradient.f = function(x, y) { # Define function grad(z) = (df.dx, df.dy).
  df.dx = -2 * (cos(x)^2 + cos(y)^2) * (2 * cos(x) * (-sin(x)))
  df.dy = -2 * (cos(x)^2 + cos(y)^2) * (2 * cos(y) * (-sin(y)))
  return(c(df.dx, df.dy))
}



##############################Visulization#############################

# Plot function, z = f(x, y) over the region -pi/2 <= x, y <= pi/2.
grid.n = 20
limit = pi/2

grid.x = seq(-limit, limit, length.out=grid.n)
grid.y = grid.x
grid.z = outer(grid.x, grid.y, f)
persp.out = persp(grid.x, grid.y, grid.z, theta = 45, phi = 60,
  main="Gradient descent", ticktype="detailed",
  xlab="x", ylab="y", zlab="z")
legend.gradient = expression(gamma %.% (partialdiff * f / partialdiff * x
    * ", " * partialdiff * f / partialdiff * y))
legend(x = "topright", 
       legend = c("(x, y)", legend.gradient, "(x, y, z = f(x, y))"),
          pch = c(16, NA, 16), 
          lty = c(0, 1, 0), 
          col = c("blue", "green", "red"))



###############################Searching###############################

x = -.98 * limit # Starting x
y =   .7 * limit # Starting y
old.x = x
old.y = y
n = 20
gamma = .1 # Step size parameter. (Or, better: vary gamma with a line search.)

for(i in seq_len(n)) {
  g = gradient.f(x, y)
  x = x - gamma * g[1]
  y = y - gamma * g[2]
  if (TRUE) { # This block is not part of the algorithm. It just draws.
    z = f(x, y)
    points(trans3d(x = x,           y = y,           z = 0,       pmat = persp.out), col = "blue", pch = 16)
    points(trans3d(x = x,           y = y,           z = z,       pmat = persp.out), col = "red",  pch = 16)
     lines(trans3d(x = c(x, x),     y = c(y, y),     z = c(0, z), pmat = persp.out), col = "red")
     lines(trans3d(x = c(old.x, x), y = c(old.y, y), z = c(0, 0), pmat = persp.out), col = "green")
    old.x = x
    old.y = y
    scan(what = character(), n = 1, quiet = TRUE) # Require "Enter" to move.
  }
}

cat(sep = "", "f(", x, ", ", y, ") = ", f(x, y), ", gradient.f() = (", g[1], ", ", g[2], ")\n")



###############################Recoding################################

# ----------------------------------------------------------------------
# Now convert the code above into a function in the style of R's optim():

# Description: gradient.descent minimizes a function whose gradient is given
# Usage: gradient.descent(par, gr, gamma=.1, epsilon=.01, n=20, verbose=FALSE, ...)
# Parameters:
#   par: a vector of initial values for the function to be minimized
#   gr: gradient function to be evaluated at par
#   gamma: step size parameter
#   epsilon: stop the algorithm as converged when the gradient
#     (as measured by the sum of the absolute values of its components)
#     is smaller than this value
#   n: stop after executing n iterations (to prevent an infinite loop)
#   verbose: if true, print x and |x_{i+1} - x_i| on each iteration
#   ...: additional arguments to be passed to gr()
# Details: gradient.descent iteratively steps in the direction
#   opposite the gradient, quitting after convergence or n iterations
# Value: the value of par at convergence or n iterations
#

gradient.descent = function(par, gr, gamma = .1, epsilon = .01, n = 30, verbose = FALSE, ...) {
  for (i in seq_len(n)) {
    gradient = gr(par, ...)
    par = par - gamma * gradient
    gradient.size = sum(abs(gradient))
    if (verbose) {
      cat(sep = "", "i = ", i, ", par = c(", paste(signif(par, 4), collapse = ","),
          "), gradient = c(", paste(signif(gradient, 4), collapse = ","),
          "), size = ", signif(gradient.size, 4), "\n")
    }
    if (gradient.size < epsilon) {
      break
    }
  }
  return(par)
}

# Test it on the simple function
f = function(x) x^2
# which has a minimum at x=0. Use x=1 as the starting point.
g = function(x) 2*x
gradient.descent(par = c(1), gr = g, verbose = TRUE)

# Test it on the cosine mess above. First convert its gradient
# function to receive the current location as a vector "par", not as x
# and y.

gradient.f.using.par = function(par) { # Define gradient(z) = (df.dx, df.dy).
  x = par[1]
  y = par[2]
  df.dx = -2 * (cos(x)^2 + cos(y)^2) * (2 * cos(x) * (-sin(x)))
  df.dy = -2 * (cos(x)^2 + cos(y)^2) * (2 * cos(y) * (-sin(y)))
  return(c(df.dx, df.dy))
}

gradient.descent(par = c(.98 * limit, .7 * limit), gr = gradient.f.using.par, verbose = TRUE)