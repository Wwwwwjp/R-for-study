rm(list=ls())

# Avoid unnecessary copying. e.g. Are loops slow in R? 

# R's loops are not terribly slow. However, incrementally growing a data structure in a loop
# causes wasteful copying and can turn a O(n) algorithm into O(n^2). Be wary of this with []
# (above), c(), cbind(), paste(), etc.. Instead, allocate the data structure before the loop.
# One of the reasons R is slow is that it copies data in many more subtle situations.

n = 100000
system.time({
  v1 = NULL               # or "v1 = 0", etc.: bad.
  for (i in seq_len(n)) {
    v1[i] = i^2           # how many copies are required?
  }
})

system.time({
  v2 = numeric(n)         # pre-allocate the required space, a little better.
  for (i in seq_len(n)) {
    v2[i] = i^2
  }
})

system.time({             # apply function, a little better.
  v2 = sapply(X = seq_len(n), FUN = function(x) {return(x^2)})
})

system.time({
  v3 = seq_len(n)^2       # vectorize, elegant and fastest, highly recommended!
})
