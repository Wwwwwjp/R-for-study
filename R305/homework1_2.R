require(datasets)
str(nhtemp)

Y = nhtemp
n = length(Y)

FE <- function(beta) {

  Y_hat = numeric(n)
  Y_hat[1] = Y[1]
  for (i in 2:n) {
    Y_hat[i] = beta * Y[i - 1] + (1 - beta) * Y_hat[i - 1]
  }
  
  fe = sum((Y[-1] - Y_hat[-1])^2) / n
  
  return(fe)
}

beta = optimize(FE, interval = c(0, 1))$minimum

Y_hat_optimal = numeric(n)
Y_hat_optimal[1] = Y[1]
for (i in 2:n) {
  Y_hat_optimal[i] = beta * Y[i - 1] + (1 - beta) * Y_hat_optimal[i - 1]
}

plot(1912:1971, Y, type = "l", col = "black", xlab = "Year", ylab = "Temperature",
     main = "Yearly average measurements of temperature for New Hampshire")
lines(1912:1971, Y_hat_optimal, col = "red")

legend("topleft", legend=c("plot of yearly average measurements of temperature", 
                           "exponential smoothing of it"), 
       col=c("black", "red"), lty=c(1, 1), cex = 0.8)



beta_values = c(0.1, 0.5, 0.9)
colors <- c("orange", "purple", "blue")
plot(1912:1971, Y, type = "l", col = "black", xlab = "Year", ylab = "Temperature",
     main = "Yearly average measurements of temperature for New Hampshire")

for (j in 1:length(beta_values)){
  beta = beta_values[j]
  Y_hat_optimal = numeric(n)
  Y_hat_optimal[1] = Y[1]
  for (i in 2:n) {
    Y_hat_optimal[i] = beta * Y[i - 1] + (1 - beta) * Y_hat_optimal[i - 1]
  }
  lines(1912:1971, Y_hat_optimal, col = colors[j])
}

legend("topleft", legend=c("plot of yearly average measurements of temperature", 
                           "exponential smoothing of it(Beta=0.1)",
                           "exponential smoothing of it(Beta=0.5)",
                           "exponential smoothing of it(Beta=0.9)"), 
       col=c("black", "orange", "purple", "blue"), lty=c(1, 1), cex = 0.8)
