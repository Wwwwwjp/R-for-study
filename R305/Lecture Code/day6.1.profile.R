rm(list=ls())

######################### Time a code fragment #########################

# common sense about the computer hierarchy
# which parts take more time?
# Network I/O >> Local File I/O >> Memory  >> CPU

# using system.time
#
# system.time(expr) runs expr and shows the CPU time spent in user instructions (our code),
# the CPU time spent in operating system instructions (for I/O and other things) on behalf of
# expr, and the elapsed (stopwatch) time.

system.time(Sys.sleep(3)) # for verification

system.time(readLines("https://www.imdb.com/chart/top")) # usually the slowest
system.time(readLines("day5.1.profile.R")) # a little slower
system.time({n = 1000000; x = rnorm(n); y = 2 * x + 3 + rnorm(n, 0, .1); m = lm(y ~ x)}) # slow with one million loops 

x = runif(50)
system.time(sqrt(x))

n = 1000000
system.time({for (i in seq_len(n)) {sqrt(x)}})



# using microbenchmark with more accuracy and statistics, requiring the package "microbenchmark"
# 
# microbenchmark(..., times = 100) runs the expressions in ..., repeating each one times
# times. It returns data (a data.frame / microbenchmark object) on the run time. It has its
# own loop and uses greater precision than system.time(), so no explicit loop is needed.

if (!require("microbenchmark")) {
  install.packages("microbenchmark")
  stopifnot(require("microbenchmark"))
}

if (!require("ggplot2")) { # ggplot2 is a powerful graphics package
  install.packages("ggplot2")
  stopifnot(require("ggplot2"))
}

a = 2
b = microbenchmark(2+2, 2+a, sqrt(x), x^.5)    # why not the same?! 2+2 vs 2+a; sqrt(x) vs x^.5
b
str(b)
head(as.data.frame(b), n = 15)

tapply(X = b$time, INDEX = b$expr, FUN = summary)
b
autoplot(b)




############################ Code effciency ############################
#
# key idea: speed up the bottleneck!
#
# Q: How to find the bottleneck?
# A: 1. Try loops or frequently used functions.
#    2. Try the lines involved with the slowest part: Network I/O or Local File I/O.
#    3. Profiling a program: see nflprofile1.R and nflprofile2.R.



# basic tricks:

# 1. Improve algothm & data structure: Learn "CS 367: Data Structures" and "CS 577: Algorithms" for much deeper improvements.



# 2. Compilation (C++'s default) is faster than interpretation (R's default way).

baby.sapply = function(X, FUN) { # run by line-by-line interpretation 
  n = length(X)
  values.FUN = numeric(n)
  for (i in seq_len(n)) {
    values.FUN[i] = FUN(X[i])
  }
  return(values.FUN)
}
x = rnorm(n = 10000)
microbenchmark(baby.sapply(X = x, FUN = abs))

baby.sapply.compiled = compiler::cmpfun(baby.sapply) # Compile a whole function
microbenchmark(baby.sapply.compiled(X = x, FUN = abs)) # a little faster in the long run



# 3. Write the slow part in C++ (fast) and call it from R.
# covered in the future class.



# 4. Vectorize, where possible, by coding in terms of a vector, not a scalar.

n = 10000; m = matrix(data = as.numeric(1:(n^2)), nrow = n, ncol = n)
system.time(s <- apply(m, 1, sum))
system.time(rs <- rowSums(m)) # faster



# 5. Avoid unnecessary copying, especially in loops: see loopTiming.R.



# 6. Avoid gathering data repeatedly

# for example, in HW3 of STAT304

x.file = "x.RData"
if (file.exists(x.file)) { # For the saved data, load it from the local drive, instead of loading from the internet.
  print("loading")
  load(file = x.file)
} else {
  x = data.frame(height = 1:3, weight = 4:6) # ... or read 250 web pages, etc., pretty slow ...
  save(x, file = x.file) # save it to the local drive for the future use.
}