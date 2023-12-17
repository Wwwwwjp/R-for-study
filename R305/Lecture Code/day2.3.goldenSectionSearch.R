# Golden Section Method
# feature: used in optimize() partially
#   cons: only for 1-D
#         only for unimodal f(x)
#   pros: converges fast (golden ratio takes advantage of the result from the preceding step in iterations)
#         doesn't require f'(x) (kind of using the secant line to approximate the tangent line)
#
# see https://en.wikipedia.org/wiki/Golden-section_search

######################Formulation and Preparation######################

rm(list=ls())


# Find the minimum of f(x) = x^2/10 - 2*sin(x) in [0, 4].
f = function(x) {
  return(x^2/10 - 2*sin(x))
}



########################Visulization & Searching#######################

# Golden section search minimizes a function f() whose opposite -f()
# is unimodal over an interval [lower, upper]. That is, there exists
# some minimizing value m such that x <= m implies f() is decreasing
# and x >= m implies f() is increasing. This search finds m.
#
# Here is the code without any graphing.

golden.section.search = function(f, lower, upper, tol = 0.001, ...) {
  phi = (1 + sqrt(5))/2 # golden.ratio (allows cutting 1/2 of calls to f())
  repeat {
    range = upper - lower
    lower.middle = upper - (phi - 1)*range
    upper.middle = lower + (phi - 1)*range
    if (range < tol) {
      return(lower)
    }
    if (f(lower.middle, ...) < f(upper.middle, ...)) {
      upper = upper.middle
    } else {
      lower = lower.middle
    }
  }
}


# Here is the code again, this time code added to make a graph and
# show the progress of the search.

golden.section.search = function(f, lower, upper, tol = 0.001, ...) {
  phi = (1 + sqrt(5))/2 # golden.ratio (allows cutting 1/2 of calls to f())
  curve(f, lower, upper) # for graph
  i = 0 # for graph
  repeat {
    range = upper - lower
    lower.middle = upper - (phi - 1)*range
    upper.middle = lower + (phi - 1)*range
    if (i < 4) { # for graph
      points(x = c(lower, lower.middle, upper.middle, upper), y = c(i,i,i,i), col = i + 1)
    }
    if (range < tol) {
      abline(v = lower, col="orange") # for graph
      return(lower)
    }
    cat(sep = "", "lower = ", lower, ", lower.middle = ", lower.middle,
        ", upper.middle = ", upper.middle, ", upper = ", upper, "\n")
    if (f(lower.middle, ...) < f(upper.middle, ...)) {
      upper = upper.middle
    } else {
      lower = lower.middle
    }
    i = i + 1 # for graph
    scan(what = character(), n = 1, quiet = TRUE) # Require "Enter" to move.
  }
}


# demo

g = golden.section.search(f, 0, 4)
print(g)