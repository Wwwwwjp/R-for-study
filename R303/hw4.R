m = matrix(data=c(1, 1, 1, 2, 2, 2, 3, 3, 3), nrow=3, ncol=3, byrow=TRUE)
layout(m)

median_hp = median(mtcars$hp)
lower_mpg_mean <- mean(mtcars$mpg[mtcars$hp < median_hp])
upper_mpg_mean <- mean(mtcars$mpg[mtcars$hp >= median_hp])

plot(density(mtcars$mpg), 
     main = 'density plot of mpg',
     xlab = 'mpg',
     ylab = 'Frequency',
     xlim=c(0, 40), 
     ylim=c(0, 0.15))
rug(mtcars$mpg) 

plot(density(mtcars$mpg[mtcars$hp < median_hp]), 
     main = 'density plot of mpg for cars with lower-than-median horsepower',
     xlab = 'mpg',
     ylab = 'Frequency',
     xlim=c(0, 40), 
     ylim=c(0, 0.15))
rug(mtcars$mpg[mtcars$hp < median_hp]) 
points(lower_mpg_mean, 0, col = "red", 
       pch = 19,
       cex = 2)
text(lower_mpg_mean, 0.01, labels=bquote(bar(x) == .(round(lower_mpg_mean, 2))), col="red")

plot(density(mtcars$mpg[mtcars$hp >= median_hp]), 
     main = 'density plot of mpg for cars with higher-than-or-equal-to-median horsepower',
     xlab = 'mpg',
     ylab = 'Frequency',
     xlim=c(0, 40), 
     ylim=c(0, 0.15))
rug(mtcars$mpg[mtcars$hp >= median_hp]) 
points(upper_mpg_mean, 0, col = "red", 
       pch = 19,
       cex = 2)
text(upper_mpg_mean, 0.01, labels=bquote(bar(x) == .(round(upper_mpg_mean, 2))), col="red")


beef = read.table('E:/stat-visp/303/beef.txt', comment.char = "%", header=TRUE)

lm_clf = lm(PBE ~ YEAR + CBE + PPO + CPO + PFO + DINC + CFO + RDINC + RFP, data = beef)
summary(lm_clf)

plot(lm_clf$fitted.values, lm_clf$residuals,
     main = 'Beef: residual plot',
     ylab = expression(italic(e[i])),
     xlab = expression(italic(hat(y[i]))))
abline(0, 0) 

m = matrix(data=c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow=3, ncol=3, byrow=TRUE)
layout(m)
vars = c('YEAR', 'CBE', 'PPO', 'CPO', 'PFO', 'DINC', 'CFO', 'RDINC', 'RFP')
for (i in vars) {
  plot(beef[, i], lm_clf$residuals, main = NULL, xlab = i, ylab = expression(e[i]))
  title(main = plot_name)
}

print('The x variable whose model coefficient is most significantly different from 0 is DINC')
lm_clf_2 = lm(PBE ~ DINC, data = beef)
plot(beef$DINC, beef$PBE, main = 'scatterplot of PBE vs. DINC', 
     xlab = 'DINC', ylab = 'PBE')
abline(a = lm_clf_2$coefficients[1], b = lm_clf_2$coefficients[2], col='red') 

n = 100
x = replicate(n=100, expr=rnorm(1))
x = sort(x)#Sorted here for ease of drawing.
eps = replicate(n=100, expr=rnorm(1, mean = 0, sd = 2))
y = 2 + 3 * x + eps 

lm_clf_3 = lm(y ~ x)
summary(lm_clf_3)
print('the estimated coefficients are near the true value')

y_hat = fitted(lm_clf_3)
e = y - y_hat
s = sqrt(sum(e^2) / (n - 2))
s_y = s * sqrt(1 / 100 + ((x - mean(x))^2 / sum((x - mean(x))^2)))
alpha <- 0.05
t_alpha <- qt(1 - alpha / 2, df = n - 2)
y_lower = y_hat - t_alpha * s_y
y_upper = y_hat + t_alpha * s_y

plot(x, y, main = 'scatterplot of the data', 
     xlab = 'x', ylab = 'y')
abline(a = lm_clf_3$coefficients[1], b = lm_clf_3$coefficients[2], col='black') 
abline(a = 2, b = 3, col='red', lty = 2) 
lines(x, y_lower, col='blue', lty = 3)
lines(x, y_upper, col='blue', lty = 3)
legend("topleft", 
       cex = 0.5,
       title = "legend",
       legend=c("estimated regression line", "y = 2 + 3x", "95% pointwise confidence bands"), 
       col=c("black", "red", "blue"), 
       lty = c(1, 2, 3))
