# Nelder-Mead (N-M) Method
# feature: default method in optim()
#   cons: convergence might have oscillations
#   pros: for n-D
#         converges usually fast
#         doesn't require f'(x) (kind of using the triangle to approximate the tangent plane)
#
# see https://en.wikipedia.org/wiki/Newton%27s_method

######################Formulation and Preparation######################

rm(list=ls())

# objective function z = f(x, y), where x and y are scalar arguments.
f.no.vector = function(x,y) {
  return(-(cos(x)^2 + cos(y)^2)^2)
}

# Here's another function to try. Maybe mess with its minimum.
# f.no.vector = function(x, y) {
#   x0 = 0
#   y0 = 0
#   return((x-x0)^2 + (y-y0)^2)
# }

# Define function z = f(x), where x is a vector.
f = function(x) { 
  return(f.no.vector(x[1], x[2]))
}



##############################Visulization#############################

# Plot function, z = f(x, y) over the region -pi/2 <= x, y <= pi/2.
grid.n = 20
limit = pi/2

grid.x = seq(-limit, limit, length.out = grid.n)
grid.y = grid.x
grid.z = outer(grid.x, grid.y, f.no.vector)
persp.out = persp(grid.x, grid.y, grid.z, theta = 100, phi = 60,
                  main = "Nelder-Mead", ticktype = "detailed",
                  xlab = "x", ylab = "y", zlab = "z")
legend(x = "topright", legend = c("xy plane", "xyz surface"),
       pch = c(2, 2), col = c("blue", "red"))


distance = function(a, b) {
  return(sum(abs(a-b)))
}



###############################Searching###############################

start.x = -.98 * limit
start.y =   .7 * limit
x1 = c(start.x, start.y)
x2 = x1 + c(.1 * limit, 0       )
x3 = x1 + c(         0, .1*limit)
x = cbind(x1, x2, x3)
n = 2

nm = function(par, f, n.iterations = 100,
              alpha = 1, gamma = 2, rho = 1/2, sigma = 1/2, epsilon = 0.01,
              draw = FALSE, debug = FALSE) {
  x = par
  n = dim(x)[2] - 1
  old.x = x
  for(i in seq_len(n.iterations)) {
    f.x = apply(X = x, MARGIN = 2, FUN = f)
    x = x[ , order(f.x)] # Order points according to f() (wiki step 1).
    d = distance(x, old.x)
    if (debug) {
      cat(sep = "", "i = ", i, ", x = \n")
      print(x)
      cat(sep = "", "f.x = \n")
      print(f.x)
      cat(sep = "", "d = ", d, "\n")
    }
    if (d < epsilon) {
      break
    }
    old.x = x
    x.0 = rowSums(x[ , 1:n]) / n # Calculate centroid (wiki step 2).
    x.reflected = x.0 + alpha * (x.0 - x[ , n + 1]) # Relection (wiki step 3).
    if ((f(x[ , 1]) <= f(x.reflected)) && (f(x.reflected) < f(x[ , n]))) {
      x[ , n + 1] = x.reflected
    } else if (f(x.reflected) < f(x[ , 1])) { # Expansion (wiki step 4).
      x.expanded = x.0 + gamma * (x.reflected - x.0)
      if (f(x.expanded) < f(x.reflected)) {
        x[ , n + 1] = x.expanded
      } else {
        x[ , n + 1] = x.reflected
      }
    } else { # Contraction (wiki step 5).
      stopifnot(f(x.reflected) >= f(x[ , n]))
      x.contracted = x.0 + rho * (x[ , n + 1] - x.0)
      if (f(x.contracted) < f(x.reflected)) {
        x[ , n + 1] = x.contracted
      } else { # Shrink (wiki step 6).
        x[ , -1] = x[ , 1] + sigma * (x[ , -1] - x[ , 1])
      }
    }
    if (draw && (n == 2)) { # This block is not part of the algorithm. It just draws.
      x.2d = matrix(data = 0, nrow = 2, ncol = 3)
      x.2d.z0 =x.2d
      for (j in 1:(n+1)) {
        p.x = x[1, j]
        p.y = x[2, j]
        z = f.x[j]
        x.2d[ , j]    = unlist(trans3d(x = p.x, y = p.y, z = z, pmat = persp.out))
        x.2d.z0[ , j] = unlist(trans3d(x = p.x, y = p.y, z = 0, pmat = persp.out))
      }
      polygon(x = x.2d   [1, ], y = x.2d   [2, ], border = "black", col="red")
      polygon(x = x.2d.z0[1, ], y = x.2d.z0[2, ], border = "blue")
      Sys.sleep(1)
    }
  }
  return(x)
}


#demo

best.x = nm(x, f, draw = TRUE, debug = TRUE)
cat("best.x = \n")
print(best.x)