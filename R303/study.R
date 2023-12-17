setwd('E:/stat-visp/303')
1003 / 19
1003 %% 19
?pnorm
pnorm(13.8, mean = 14, sd = 5)
qnorm(0.3, mean = 14, sd = 5)
?pt
1 - pt(-0.2, 9)
qt(0.965, 9)
?dbinom
pbinom(13, 27, 0.5)
?qnorm


v <- c(7,4,10,8,11,16,2,26,1,7,18,23,8,0,24,24,12,27,20,0,20,4,10,23,23,13,21,27)
length(v)
result <- (v < 12); result
sum(v < 9)
mean(v)
median(v)
sd(v)
min(v)
sum(v[v < 9])
sum(v)
sum(v[9:19])
sum(v[(v %% 2) == 0])
sum(v[seq(0,28,5)])
sum(v[v >=9 & v <= 19])
v >=9 & v <= 19
3+5+6+11+17+23+26
sum(v)
seq(0,23,5)
seq(0,23,5)
v[5]+v[10]+v[15]+v[20]
v[11]
v[23]
v[seq(0,28,5)]
?rnorm
rnorm(1, mean = 0, sd = 1)



x = c(25,16,22,14,11,28,27,23,17,13,6,4,29,3,20,7,26,17,27,2,10,25,8,1,4,22,24,10,7,9)
a = seq(0,length(x),2)
sum(x[a])
y = c(15,6,9,26,13,25,20,23,4,0,4,17,19,14,23)
sum(x[x %in% y])
c = sort(x)
sum(c[1:3])
rank(x, ties.method = "first")
sum(order(x, decreasing = FALSE)[1:3])
sum(quantile(x, probs = seq(0, 1, 0.2))[2:5])

text_vector = scan(file = "E:/stat-visp/303/Hamlet.txt", what = "character", sep = "\n", quiet = TRUE)

# Initialize a count variable for "murder"
murder_count <- 0

# Step 3: Loop through each line of text and count "murder"
for (line in text_vector) {
  words <- unlist(strsplit(line, "\\s+"))  # Split text into words
  murder_count <- murder_count + sum(words == "murder")
}

# Step 4: Print the count of "murder"
print(murder_count)

g = list(fruit="apple", dairy=c("milk", "eggs"), lotto = c(4,2,1,7))
g$dairy <- c(g$dairy, "butter")
g$snacks <- "popcorn"
g$lotto[g$lotto == 7] <- 6
x = list(name=c("Alex","Betty","Chen","David","Eleanor"), score=c(88,93,76,91,80))
x$name[order(x$score,decreasing = TRUE)][1]




m = mtcars
str(m)
table(m$gear, m$cyl)


table = read.csv('E:/stat-visp/303/jwang2928Q4.csv')
mean(table$age[table$sex=='F'])
mean(table$age[table$sex=='M'&table$eye.color=='brown'])
length(table$age[table$hair.color=='brown'|table$hair.color=='blond'|table$hair.color=='black'])
length(table$age[table$eye.color=='hazel'&!table$hair.color=='grey'])
table[order(table$weight,decreasing = TRUE),][3,1]
sorted = table[order(table$eye.color, table$weight*(-1)),]
sorted$age[sorted$sex == "M"][3]
c = CO2
c
summary(c)
mean(c$uptake[c$Type=='Quebec'])
sd(c$uptake[c$Type=='Quebec'])
mean(c$uptake[c$Type=='Mississippi'])
sd(c$uptake[c$Type=='Mississippi'])
boxplot(c$uptake)
boxplot(c$uptake~ c$Type)




?points
boxplot(mtcars$mpg~mtcars$gear, main="Gas mileage", ylab="miles per gallon", ylim=c(0,40))
boxplot(iris$Petal.Length~iris$Species, main="Petal.Length", ylab="Species")
stripchart(iris$Petal.Length~iris$Species, main="Petal.Length", ylab="Species")
hist(iris$Petal.Length, breaks=seq(0,7,1))
plot(density(iris$Petal.Length))
legend("top", legend=c(expression(a %~~% b), "x"), col=c("black", "red"), lty=c(1, 1))
pairs(iris[1:4])
barplot(table(chickwts$feed))

png("my_plot.png", width = 800, height = 600)  # 打开PNG设备
m = matrix(data=c(1, 0, 2, 3, 3, 3), nrow=2, ncol=3, byrow=TRUE)
layout(m)
layout.show(3)
hist(mtcars$mpg) # 1st plot: (frequency) histogram alone
plot(density(mtcars$mpg)) # 2nd plot: density plot alone
hist(mtcars$mpg, freq=FALSE) # 3rd plot: density histogram
lines(density(mtcars$mpg)) # add density plot to (3rd plot) histogram
# 生成或绘制你的图形
dev.off()  # 关闭设备，保存图像到文件





x = c(8.4, 12.2, 11.8, 9.3, 11.3, 13, 7.6, 12.7, 7, 14.3, 10.4, 12.7, 4.8, 9.6, 8.6, 10.5, 8.9, 12.3, 9.9, 8.2, 11.6, 9.2)
out = t.test(x, y = NULL, alternative = "greater", mu = 9, conf.level = .9)
out$statistic
out$p.value
out$conf.int

X = c(5.8, 1.2, 3.2, 0.7, 0.2, 9.1)
Y = c(-1.5, 3.8, 7.5, 4.6, 2.6, 4.1, 2.8, -1.4, 1.8)
out = var.test(X, Y, ratio = 1, alternative = "two.sided", conf.level = .95)
out$statistic
out$p.value

x = matrix(data = c(18, 19, 14, 14, 15, 12, 10, 18, 15), nrow=3, ncol=3)
out = chisq.test(x)
out$statistic
out$p.value
x = 38; n = 56; p0 = .5; 
out = prop.test(x, n, p0, correct=FALSE)
out$statistic
out$p.value






x = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28)
y = c(0,3.5,6,4.5,3,2.5,5,8.5,5,5.5,10,7.5,9,6.5,11,13.5,14,14.5,12,11.5,14,12.5,15,16.5,15,16.5,19,18.5,16)
plot(x, y)
cor(x, y)
m = lm(y ~ x)
m$coefficients
d = data.frame(x = seq(from=13, to = 15, by = 1))
predict(m, newdata = d)
m = lm(mtcars$qsec ~ mtcars$disp + mtcars$hp)
m$coefficients


seed = 23
set.seed(seed)
sum(rnorm(3))

seed = 7
set.seed(seed)
N = 100
variance_estimates <- numeric(N)

for (i in 1:N) {
  # Generate a random sample of size n from the standard normal distribution
  x = replicate(n=4, expr=rnorm(1))
  
  # Calculate the sample mean
  sample_mean <- mean(x)
  
  # Calculate the squared deviations from the mean
  squared_deviations <- (x - sample_mean)^2
  
  # Calculate the sample variance
  sample_variance <- sum(squared_deviations) / 4
  
  # Store the sample variance estimate
  variance_estimates[i] <- sample_variance
}
average_variance_estimate <- mean(variance_estimates)
average_variance_estimate

mu = 7; sigma = 3
mean(x <- rnorm(n=1000, mean=mu, sd=sigma))
sd(x)

seed = 3
set.seed(seed)
x = c(118, 121, 113, 116, 117, 112, 113)
mu = 119.5
sigma = sd(x)
n = length(x) # sample size
N = 10000 # number of replicates
t = replicate(N, { x=rnorm(n, mean=mu, sd=sigma); (mean(x) - mu)/(sd(x)/sqrt(n)) })
out = t.test(x, mu=119.5)
more.extreme = (abs(t) > abs(out$statistic))
simulated.p.value = sum(more.extreme) / N
out$p.value
plot(density(t), main=bquote(.(N) * " Simulated t statistics")) # visualize P-value
rug(t)
points(x=out$statistic, y=0, pch=19, col="red")
text(x=out$statistic, y=.02, labels="out$statistic")