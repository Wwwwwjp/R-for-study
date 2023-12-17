rm(list = ls())


# see the backgrounds at https://en.wikipedia.org/wiki/Mandelbrot_set.

if (!require("parallel")) { # for multicore computing functions
  install.packages("parallel")
  stopifnot(require("parallel"))
}



escape.time = function(x, y, limit = 256) { # for Mandelbrot's fractal set
  # e.g. Algorithm is easy to see with
  #   z0 = -1 + 1i
  #   z_{i+1} = (z_i)^2 + z_0
  # Calculate and draw z0, z1, z2. z2 is outside circle,
  # so, escape time for z0 is 2.
  
  z0 = complex(real = x, imaginary = y) # z and z0 are complex numbers
  z = z0
  
  for (i in 0:limit) { # try limited iterations
    if (abs(z) > 2) { # abs() calculate the distance from the origin. Escapes from circle?
      break
    }
    z = z^2 + z0 # nonlinear but simple iteration
  }
  return(i)
}

n = 400 # Set up (x, y) pairs in region defined by -2 <= x, y <= 2.
interval = seq(from = -2, to = 2, length.out = n) # make n*n grids in the region
x = rep(x = interval, each  = n) # all the z0's from (x, y)
y = rep(x = interval, times = n)

# Find escape time of all  (x, y) pairs. The next line uses only one core.
print("Timing mapply(), one core ...")
print(system.time(v <- mapply(FUN = escape.time, x, y)))

# Uses several cores, if available.
n.cores = detectCores()

if (.Platform$OS.type == "windows") {
  cluster = makePSOCKcluster(names = n.cores)
  cat(sep = "", "Timing clusterMap(), ", n.cores, " cores ...")
  print(system.time(v <- clusterMap(cl = cluster, fun = escape.time, x, y)))
  stopCluster(cluster)
  
  # This procedure is exactly correct (good enough for HW). 
  # But the weird thing happens here.
  # Indeed, it is much much slower than what we expected.
  #
  # Suggestions:
  #   1. One changing parameters is simpler than more changing parameters.
  #   2. Use Mac or Linux to avoid such an embarrassment.
  #   3. If you stick to PC and know more subtleties, see some advanced discussion below.
  
} else {
  cat(sep = "", "Timing mcmapply(), ", n.cores, " cores ...")
  print(system.time(v <- mcmapply(FUN = escape.time, x, y, mc.cores = n.cores)))
}

m = matrix(data = unlist(v), nrow = n, ncol = n, byrow = TRUE) # make a pixel matrix
image(x = interval, y = interval, z = m, col = rainbow(256)) # draw the graph from the matrix


# Some advanced discussions (optional)

# ----------------------------------------------------------------------
# Ok, let's try to do better on Windows. I'm concerned that the
# parallel package didn't do a smart job of allocating jobs to
# processors (maybe, did it create 400^2 = 160000 jobs? How embarrassing!), 
# and that that's what killed performance on my Windows computer. 
# A knowledgeable student suggested, instead, that it's communication 
# between the original process and four new processes that is killing
# performance. Here I'll try partitioning the data into n.cores parts,
# and then shipping each part to a processor, hoping to minimize the
# overhead of job allocation.

# This function returns the escape time for the ith of n.cores parts
# of the ordered pairs represented in vectors x and y. (I'm using
# parameter name "xx" instead of "x" because parLapply() and its
# relatives use a parameter "x", which prevents me from passing "x = x"
# as an additional parameter for "..." in parLapply() call, below.)
# (JG: clusterSplit() can do some of this work for me.)

escape.time.ith.part = function(i, n.cores, xx, y) { # manual wise allocation

  # Loading escape.time() inside the definition of escape.time.ith.part().
  escape.time = function(x, y, limit = 256) { # for Mandelbrot's fractal

    z0 = complex(real = x, imaginary = y) # z and z0 are complex numbers
    z = z0
    
    for (i in 0:limit) { # try limited iterations
      if (abs(z) > 2) { # escape from circle?
        break
      }
      z = z^2 + z0 # iteration, nonlinear but simple
    }
    return(i)
  }  
  # Otherwise, escape.time() is not available for all the processes of multicore programmings below.

  
  n = length(xx)
  stopifnot(n == length(y))
  
  # partition of the whole area
  ends = c(0, floor((1:n.cores) * n / n.cores)) 
  start = ends[i] + 1
  end = ends[i + 1]
  
  # blockwise apply escape.time() with one changing parameter i
  times = mapply(FUN = escape.time, x = xx[start:end], y = y[start:end]) 
  return(times)
}


if (.Platform$OS.type == "windows") {
  cluster = makePSOCKcluster(names = n.cores)
  
  # clusterEvalQ(cl = cluster, expr = source("day7.3.escape.time.R"))
  # optional setup code (with an external file "day7.3.escape.time.R" containing only the definition of escape.time()):
  #   source("day7.3.escape.time.R"), on each cluster node/process, which, in Windows, 
  #   has a fresh R session; otherwise, escape.time() is unavailable.
  #
  # Another alternative for the previous line is probably clusterExport(cl = cluster, varlist = "escape.time").
  
  # using multicore lapply, instead of multicore mapply!
  cat(sep = "", "Timing parLapply(), ", n.cores, " cores ...")
  print(system.time(v <- parLapply(cl = cluster, X = 1:n.cores, fun = escape.time.ith.part, n.cores = n.cores, xx = x, y = y)))
  stopCluster(cluster)
} else {
  cat(sep = "", "Timing mclapply(), ", n.cores, " cores ...")
  print(system.time(v <- mclapply(X = 1:n.cores, FUN = escape.time.ith.part, mc.cores = n.cores, n.cores = n.cores, xx = x, y = y)))
}


# Yes! It works! we got an improvement on Windows.