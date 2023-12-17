rm(list = ls())

# Define the function
z <- function(x) {
  x1 <- x[1]
  x2 <- x[2]
  y <- -(7.9 + 0.13*x1 + 0.21*x2 - 0.05*x1*x1 - 0.016*x2*x2 - 0.007*x1*x2)
  return(y)
}

gr <- function(x) {
  x1 <- x[1]
  x2 <- x[2]
  dz_dx1 <- -0.13 + 0.1*x1 + 0.007*x2
  dz_dx2 <- -0.21 + 0.032*x2 + 0.007*x1
  return(c(dz_dx1, dz_dx2))
}


optim <- optim(par = c(0,0), fn = z, gr = gr, method = "BFGS")

stopifnot(optim$convergence == 0)

optim$par
paste("The optim() makes", optim$counts["function"], "function calls to fn in this case.")
paste("The optim() makes", optim$counts["gradient"], "gradient calls to gr in this case.")

#below is the graph
grid.n = 20

z <- function(x1, x2) {
  return((7.9 + 0.13*x1 + 0.21*x2 - 0.05*x1^2 - 0.016*x2^2 - 0.007*x1*x2))
}
grid.x = seq(-10, 10, length.out = grid.n)
grid.y = seq(0, 20, length.out = grid.n)
grid.z = outer(grid.x, grid.y, z)
persp.out = persp(grid.x, grid.y, grid.z, theta = 30, phi = 60,
                  main = "BFGS", ticktype = "detailed",
                  xlab = "x", ylab = "y", zlab = "z")
legend(x = "topright", legend = c("xy plane", "xyz surface", "peak"),
       pch = c(2, 2, 16), col = c("blue", "red", "red"))
points(trans3d(x = optim$par[1], y = optim$par[2], z = z(optim$par[1], optim$par[2]), 
               pmat = persp.out), col = "red",  pch = 16)