rm(list = ls())
library(dplyr)
setwd('E:/stat-visp/601')
data = read.csv("boxers.csv", header = TRUE, sep = ",")
y = data$height
y = y / mean(y)
X = select(data,-c(Name, height))
lambda = seq(-23, 7, length.out = 500)
row1 <- rep(1, 19)
X1 = cbind(row1, X)
X1 = as.matrix(X1)
L = solve(t(X1) %*% X1)
n = nrow(X1)
p = ncol(X1) 
log_l = rep(0,500)



for (i in 1:500){
  y_lambda = 0
  if (lambda[i] == 0){
    y_lambda = log(y)
  }
  else{
    y_lambda = (y^(lambda[i]) - 1) / lambda[i]
  }
  beta_lambda = L %*% t(X1) %*% y_lambda
  sigma_lambda = sqrt((t(y_lambda - X1 %*% beta_lambda) %*% (y_lambda - X1 %*% beta_lambda)) / (n - p - 1))
  l = -1 * n * log(sigma_lambda) + (lambda[i] - 1) * (sum(log(y))) - ((n - p - 1) + n * log(2 * pi)) / 2
  log_l[i] = l
}


g_lambda_hat = max(log_l)
alpha = 0.05
chi <- qchisq(1 - alpha, 1)

minus = rep(0,500)
for (i in 1:500){
  y_lambda = 0
  if (lambda[i] == 0){
    y_lambda = log(y)
  }
  else{
    y_lambda = (y^(lambda[i]) - 1) / lambda[i]
  }
  beta_lambda = L %*% t(X1) %*% y_lambda
  sigma_lambda = sqrt((t(y_lambda - X1 %*% beta_lambda) %*% (y_lambda - X1 %*% beta_lambda)) / (n - p - 1))
  l = -1 * n * log(sigma_lambda) + (lambda[i] - 1) * (sum(log(y))) - ((n - p - 1) + n * log(2 * pi)) / 2
  minus[i] = l - g_lambda_hat + chi / 2
}

min_index <- which.min(abs(minus))
minus_without_min <- minus[-min_index]
second_min_index <- which.min(abs(minus_without_min))
lambda_1 = lambda[min_index]
lambda_2 = lambda[second_min_index]
lambda_hat = lambda[which.max(log_l)]
g_lambda_1 = log_l[min_index]
g_lambda_2 = log_l[second_min_index]

plot(lambda, log_l, main = 'Manual plot for boxer data using all predictors', 
     type = 'l',
     xlab = expression(lambda),
     ylab = 'log-likelihood')
abline(v = lambda_1, lty = 2)
abline(v = lambda_2, lty = 2)
abline(h = g_lambda_1, lty = 2)
abline(v = lambda_hat, lty = 2)

