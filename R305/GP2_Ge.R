rm(list = ls())
if (!require(rgl)) install.packages("rgl")
library(rgl)
k = 120
f <- function(x, y) {
  (1-x/k)*(1+x/k)*(1-y/k)*(1+y/k)*(-(y+47)*sin(sqrt(abs(y+x/2+47)))-x*sin(sqrt(abs(x-y-47))))
}
k <- 120
x <- seq(-k, k, length = 100)
y <- seq(-k, k, length = 100)
z <- outer(x, y, f)


k <- 120
f <- function(x) {
  (1-x[1]/k)*(1+x[1]/k)*(1-x[2]/k)*(1+x[2]/k)*(-(x[2]+47)*sin(sqrt(abs(x[2]+x[1]/2+47)))-x[1]*sin(sqrt(abs(x[1]-x[2]-47))))
}

grid_size <- 50
x_grid <- seq(-k, k, length = grid_size)
y_grid <- seq(-k, k, length = grid_size)


local_maxima <- matrix(NA, ncol = 3, nrow = 0)

for (x_start in x_grid) {
  for (y_start in y_grid) {
    res <- optim(c(x_start, y_start), f, control = list(fnscale = -1)) # 使用-f寻找最大值
    if (res$par[1] >= -k && res$par[1] <= k && res$par[2] >= -k && res$par[2] <= k) {
      local_maxima <- rbind(local_maxima, c(res$par, res$value))
    }
  }
}

local_maxima <- unique(local_maxima)


print(local_maxima)


k <- 120
x <- seq(-k, k, length = 100)
y <- seq(-k, k, length = 100)
z <- outer(x, y, Vectorize(f))


persp3d(x, y, z, col = "lightblue")


for (i in 1:nrow(local_maxima)) {
  points3d(local_maxima[i, 1], local_maxima[i, 2], local_maxima[i, 3], color = "red", size = 3)
}
