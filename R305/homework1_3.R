data(mtcars)
x = mtcars$mpg
n = length(x) 

log_likelihood = function(parameters) {
  mu <- parameters[1]
  sigma <- parameters[2]
  ss = sum((x - mu)^2)
  log_sum = n * log(1 / sqrt(2 * pi) / sigma) - 1 / 2 / sigma^2 * ss
  
  return(-log_sum)
}

opt_parameters = optim(par = c(1, 1), fn = log_likelihood, method = "Nelder-Mead")$par
cat("Optimal estimates:\n")
cat("μ =", opt_parameters[1], "\n")
cat("σ =", opt_parameters[2], "\n")

cat("\nSample mean:", mean(x), "\n")
cat("Sample standard deviation:", sd(x), "\n")



require("MASS")
menarche[c(1, 10, 25), ]

success.indices = rep(x=seq_len(nrow(menarche)), times=menarche$Menarche)
success.ages = menarche$Age[success.indices]
success = data.frame(age=success.ages, reached.menarche=1)
failure.indices = rep(x=seq_len(nrow(menarche)), times=menarche$Total - menarche$Menarche)
failure.ages = menarche$Age[failure.indices]
failure = data.frame(age=failure.ages, reached.menarche=0)
menarche.cases = rbind(success, failure)
menarche.cases = menarche.cases[order(menarche.cases$age), ]
rownames(menarche.cases) = NULL # Remove incorrectly ordered rownames; they get restored correctly.

menarche.cases[c(1000, 1500, 2000), ]

x = menarche.cases$age
y = menarche.cases$reached.menarche

logistic = function(parameters) {
  beta0 = parameters[1]
  beta1 = parameters[2]
  y_hat = beta0 + beta1 * x
  logis = -log(1 + exp(y_hat)) + y * y_hat
  return(-sum(logis))  
}


opt_parameters <- optim(par = c(0, 0), fn = logistic, method = "Nelder-Mead")$par

cat("beta0 =", opt_parameters[1], "\n")
cat("beta1 =", opt_parameters[2], "\n")

jittered_age <- jitter(x)
plot(jittered_age, y, col = "blue", main = "Logistic Regression", xlab = "Age", ylab = "Reached Menarche")
proportions = tapply(y, x, mean)
points(unique(x), proportions, pch = 16, col = "red")

curve(1 / (1 + exp(-(opt_parameters[1] + opt_parameters[2] * x))), add = TRUE, col = "black")

legend("topleft", legend = c("Jittered Points", "Proportions", "Fitted Curve"),
       col = c("blue", "red", "black"), pch = c(1, 16, NA), cex = 0.8)