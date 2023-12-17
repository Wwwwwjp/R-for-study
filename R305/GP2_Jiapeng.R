# This form takes (x, y) as the 2-vector x and k as a second parameter.
f = function(x, k) {
  ifelse (test=((abs(x[1]) > k) | (abs(x[2]) > k)),
          yes=0,
          no=(1 - x[1]/k)*(1 - x[2]/k)*(1 + x[1]/k)*(1 + x[2]/k)*
            (-(x[2] + 47) * sin(sqrt(abs(x[2] + x[1]/2 + 47))) - x[1]*sin(sqrt(abs(x[1] - (x[2] + 47)))))
  )
}

k_value <- 120

lower_bounds <- c(-k_value, -k_value)  
upper_bounds <- c(k_value, k_value) 


grid_size <- 100#这里不知道应该取什么值比较好
x_grid <- seq(-k_value, k_value, length = grid_size)
y_grid <- seq(-k_value, k_value, length = grid_size)


local_maxima <- matrix(NA, ncol = 3, nrow = 0)

for (x_start in x_grid) {
  for (y_start in y_grid) {
    res <- optim(c(x_start, y_start), f, k=k_value, method = "Nelder-Mead") 
    if (res$par[1] > -k_value && res$par[1] < k_value && res$par[2] > -k_value && res$par[2] < k_value) {
      local_maxima <- rbind(local_maxima, c(res$par, res$value))
    }
  }
}

local_maxima <- unique(round(local_maxima, 2))
n <- nrow(local_maxima)
cat(" the number of distinct local maxima is", n)
