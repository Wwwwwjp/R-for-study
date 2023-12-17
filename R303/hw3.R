require("MASS")
?Boston
Boston$chas
Boston$chas <- factor(Boston$chas, levels = c(0, 1), labels = c("off", "on"))
Boston$chas
length(Boston)
nrow(Boston)
cat('The rows in the Boston data frame is', nrow(Boston), '\n')
cat('The columns in the Boston data frame is', length(Boston), '\n')
plot(density(Boston$tax), 
     main = 'density plot of tax rates in Boston',
     xlab = 'tax rates',
     ylab = 'Frequency')
rug(Boston$tax) 
hist(Boston$tax, breaks="Sturges", freq=NULL,
     main = 'histogram of the tax rates in Boston',
     xlab = 'tax rates',
     ylab = 'Frequency')
print(Boston$tax[Boston$tax >= 650 & Boston$tax <= 800])
hist(Boston$tax[Boston$tax < 650],
     main = 'density plot of tax rates (<650) in Boston',
     xlab = 'tax rates',
     ylab = 'Frequency')


barplot(table(Boston$chas),
        main = 'Barplot of chas',
        xlab = 'chas',
        ylab = 'Frequency',
        ylim = c(0, 500))

cat('The number of neighborhoods on the Charles River is', sum(Boston$chas == 'on'))

m = matrix(data=c(2, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 4, 3, 3, 3), nrow=4, ncol=4, byrow=TRUE)
layout(m)
plot(Boston$dis, Boston$nox,
     xlab = 'dis',
     ylab = 'nox',
     type = "p") 
boxplot(Boston$nox, axes = FALSE)
boxplot(Boston$dis, horizontal = TRUE, axes = FALSE)
title("scatterplot and boxplot of nox and dis")

r <- which.max(Boston$crim)
par(mfrow = c(3, 1)) 
plot(density(Boston$crim), 
     main = 'density plot of crim in Boston',
     xlab = 'crim',
     ylab = 'Frequency')
rug(Boston$crim) 
max_crim <- max(Boston$crim)
points(max_crim, 0, col = "red", pch = 20)

plot(density(Boston$medv), 
     main = 'density plot of medv in Boston',
     xlab = 'medv',
     ylab = 'Frequency')
rug(Boston$medv) 
points(Boston$medv[r], 0, col = "red", pch = 20)

plot(density(Boston$ptratio), 
     main = 'density plot of ptratio in Boston',
     xlab = 'ptratio',
     ylab = 'Frequency')
rug(Boston$ptratio) 
points(Boston$ptratio[r], 0, col = "red", pch = 20)

