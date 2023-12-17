rm(list = ls()) 
data <- read.csv("boxers.csv", header = TRUE, sep = ",")
x = data$reach
y = data$height
model = lm(y ~ x)
row1 <- rep(1, 19)
X1 <- rbind(row1, data$reach)
X1 = t(X1)
L <- t(X1) %*% X1
y_hat = fitted(model)
e = y - y_hat
s = sqrt(sum(e^2) / (19 - 2))

beta_hat = c(model$coefficients[1], model$coefficients[2])
beta_0 <- seq(30, 65, length.out = 500)

F_value <- qf(0.95, df1=2, df2=17, lower.tail=TRUE)

s_y = 2 * s^2 * F_value
y_lower = rep(0,500)
y_upper = rep(0,500)

#Solve quadratic equations with one variable
getroot = function(a,b,c){
  x1 = (-b + (b^2 - 4 * a * c)^0.5) / 2 / a
  x2 = (-b - (b^2 - 4 * a * c)^0.5) / 2 / a
  ans=c(x1,x2)
  return(ans)
}

for (i in 1:500) {
  solutions <- getroot(L[2,2], (L[1,2] + L[2,1]) * (beta_hat[1] - beta_0[i]), L[1,1] * (beta_hat[1] - beta_0[i])^2 - s_y)
  y_lower[i] = beta_hat[2] - max(solutions)
  y_upper[i] = beta_hat[2] - min(solutions)
}

plot(beta_hat[1], beta_hat[2], 
     main = expression(paste('95% confidence region for (', beta[0], ',', beta[1], ") from fitting height vs reach in boxer data")),
     xlab = expression(paste(beta[0])),
     ylab = expression(paste(beta[1])),
     xlim = c(30,65),
     ylim = c(0.15,0.55))
lines(beta_0, y_lower, col='red', lty = 1)
lines(beta_0, y_upper, col='red', lty = 1)