rm(list = ls())

if (!require("Rcpp")) { # for embedding/calling C++ code in R
  install.packages("Rcpp")
  stopifnot(require("Rcpp"))
}



#   4. To use longer C++ code from R,
#        - put the C++ code in a ".cpp" file that begins with
# 
#          #include <Rcpp.h>
#          using namespace Rcpp;
#
#        - make a C++ function visible in R by preceding it with
#
#          // [[Rcpp::export]]
#
#        - call sourceCpp(file), where file is the name of the ".cpp" file



escape.time = function(x, y, limit = 256) { # for Mandelbrot's fractal
  z0 = complex(real = x, imaginary = y)
  z = z0
  for (i in 0:limit) {
    if (abs(z) > 2) {
      break
    }
    z = z^2 + z0
  }
  return(i)
}

n = 400 # Set up (x, y) pairs in region defined by -2 <= x, y <= 2.
interval = seq(from = -2, to = 2, length.out = n)
x = rep(interval, each  = n)
y = rep(interval, times = n)

print("Timing R function escape.time() ...")
print(system.time(v <- mapply(FUN = escape.time, x, y)))



sourceCpp("day9.1.escapeTime.cpp") # This line gives access to the C++ function.
print("Timing C++ function escapeTime() ...")
print(system.time(v2 <- mapply(FUN = escapeTime, x, y)))
stopifnot(all(v == v2))

m = matrix(data = unlist(v), nrow = n, ncol = n, byrow = TRUE)
image(x = interval, y = interval, z = m, col = rainbow(256))



#   5. Translating R to basic C++:
#      - for basic rules, see the 2nd page of the handout
#      - for more details, see http://adv-r.had.co.nz/Rcpp.html