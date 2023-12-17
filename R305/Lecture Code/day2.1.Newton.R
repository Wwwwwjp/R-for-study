# Newton's method
# feature: 
#   cons: only for 1-D
#         require f"(x)
#   pros: converges fast
#
# see https://en.wikipedia.org/wiki/Newton%27s_method

######################Formulation and Preparation######################

rm(list=ls())

# Objective function
f = function(x) {
  return (0.5*x*x - cos(x) - 3*x + 3.1)
}

# Its 1st-order derivative f'(x)
f.prime = function(x) {
  return(x + sin(x) - 3)
}

# Its 2nd-order derivative f"(x)
f.double.prime = function(x) {
  return(1 + cos(x))
}

# key idea: find a root of f'(x) = 0 to minimize f(x)



##############################Visulization#############################

curve(f.prime, from = 0, to = 6, xlim = c(0, 6), ylim = c(-.5, 1.5), # Plot f'(x).
      main = "Newton's method for finding a root\n
      f'(x) = x + sin(x) - 3")
curve(f, from = 0, to = 6, xlim = c(0, 6), ylim = c(-.5, 1.5), add = TRUE, col = "blue") # Plot f(x).
abline(h = 0) # x axis
abline(v = 0) # y axis
up.color = "black"
tangent.color = "red"
up.lty = "dotted"
tangent.lty = "dashed"
legend(x = "topleft",
       legend = c("Move from (x, 0) up to (x, f'(x)),",
                  "and back to x axis along tangent.", 
                  "f(x)", "f'(x)"),
       lty = c(up.lty,   tangent.lty,   "solid", "solid"), 
       col = c(up.color, tangent.color, "blue",  "black"))



###############################Searching###############################

# Here is the search code without any graphing.
x = 5 # starting point
for (i in seq_len(6)) {
  y = f.prime(x)
  tangent.slope = f.double.prime(x)
  # The point-slope form of the line through (x0, y0) with slope m is
  #   y - y0 = m(x - x0).
  # Plug in y = 0 to see the x-intercept is x = x0 - y0/m.
  tangent.x.intercept = x - y/tangent.slope
  x = tangent.x.intercept # Prepare to repeat the process.
  cat(sep = "", "x_", i, " = ", x, ", f'(x) = ", y, "\n")
}


# Here is the search code again, this time code added to make a graph
# and show the progress of the search.
x = 5 # starting point
for (i in seq_len(6)) {
  y = f.prime(x)
  tangent.slope = f.double.prime(x)
  # The point-slope form of the line through (x0, y0) with slope m is
  #   y - y0 = m(x - x0).
  # Plug in y = 0 to see the x-intercept is x = x0 - y0/m.
  tangent.x.intercept = x - y/tangent.slope
  text(x = x + .09, y = .05, labels = bquote(x[.(i)])) # x_i label
  segments(x0 = x, y0 = 0, x1 = x, y1 = y, col = up.color, lty = up.lty) # vertical line
  points(x, y, pch=19) # point on curve
  scan(what = character(), n = 1, quiet = TRUE) # Require "Enter" to move.
  segments(x0 = x, y0 = y, x1 = tangent.x.intercept, y1 = 0, col = tangent.color, lty = tangent.lty) # tangent
  x = tangent.x.intercept # Prepare to repeat the process.
  cat(sep = "", "x_", i, " = ", x, ", f'(x) = ", y, "\n")
}