rm(list = ls())

# Goal: Embedding/calling C++ from R via Rcpp. Remember C++ is the fastest.

# Procedure:
#   1. install/require/library package "Rcpp";
#   2. install a C++ compiler:
#       - Windows: Rtools (http://cran.r-project.org/bin/windows/Rtools)
#       - Mac:     Xcode  (https://developer.apple.com/xcode/downloads)
#   3. To include a short C++ function within a ".R" file, 
#      use cppFunction(code), where code is a character string containing the C++ function.
#
#      For example,

if (!require("Rcpp")) { # for embedding/calling C++ code in R
  install.packages("Rcpp")
  stopifnot(require("Rcpp"))
}



# A recursive function in R code, needing > fibonacci(n) calls:
fibonacci = function(n) { 
  if (n == 0) return(0)
  if (n == 1) return(1)
  return(fibonacci(n-1) + fibonacci(n-2))
}

system.time(f <- fibonacci(30))
print(f)



# Its C++ code by cppFunction(code)
cppFunction("
  int Fibonacci(int n) { // This is a C++ version.
    if (n == 0) return 0;
    if (n == 1) return 1;
    return(Fibonacci(n-1) + Fibonacci(n-2));
  }
")

system.time(F <- Fibonacci(30))
stopifnot(f == F)



#   4. To be continued in another file.