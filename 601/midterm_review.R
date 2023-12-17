setwd('E:/stat-visp/601')
z = read.csv("boxers.csv", header = TRUE, sep = ",")
model.nor = lm(height ~ chest.nor + chest.exp + reach, data=z)
summary(model.nor)

#par(mfrow=c(2,2))将plot()函数绘制的四幅图形组合在一个大的2×2的图中
par(mfrow=c(2,2))
plot(model.nor)


z = read.csv("diabetes.csv")
names(z)
t.test(A1Cdiff ~ Therapy, data=z, var.equal=TRUE, alternative="two.sided")
summary(lm(A1Cdiff ~ Therapy, data=z))
summary(lm(A1Cdiff ~ .-A1CBase - A1C52, data=z))


m = data.frame(
  a=c(1, 2, 3),
  b=c(1, -1, 10),
  y=c(2, 4, 6),
  stringsAsFactors=FALSE)
summary(lm(y~a, data = m))
summary(lm(y~a+b, data = m))

z = read.csv("blowdown.csv")
m = glm(Y ~ ., data=z, family='binomial')
summary(m)

z = read.csv("crab.csv")
z$color = as.factor(z$color)
z$spine = as.factor(z$spine)
summary(glm(satell ~ .-y, data=z, family = poisson))
#summary(glm(satell ~ .-y-weight, data=z, family = poisson))
#summary(glm(satell ~ .-y-width, data=z, family = poisson))
summary(lm(satell ~ .-y, data=z))
summary(lm(width ~ weight, data=z))
summary(lm(weight ~ width, data=z))
plot(lm(width ~ weight, data=z))
boxplot(z$width)
boxplot(z$weight)
