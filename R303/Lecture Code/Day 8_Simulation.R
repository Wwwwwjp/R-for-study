rm(list = ls()) # initialization



#############################Simulation#############################
####################by Replicating a Calculation####################


###################pseudo-random number generator###################
######################repeatable by set.seed########################
# see https://www.khanacademy.org/computing/computer-science/cryptography/crypt/v/random-vs-pseudorandom-number-generators

(a <- rnorm(1)); (b <- rnorm(1)); a == b # not repeatable

set.seed(0); (a <- rnorm(1)); set.seed(0); (b <- rnorm(1)); a == b # repeatable, good for debugging


#########################repeat calculations########################
###########################by replicate#############################
x <- replicate(n = 4, expr = rnorm(1)); x # 4 random samples of size 1, without set.seed, not repeatable

set.seed(35) # repeatable
y <- replicate(n = 4, expr = rnorm(3)); y # 4 random samples of size 3

set.seed(35) # repeatable
z <- replicate(n = 4, expr = mean(rnorm(3))); z # 4 means of samples of size 3

# verification
y[ , 1]
mean(y[ , 1]); z[1] # same

# {...; ...; ...} contains more commands

w <- replicate(n = 100, 
               expr = {mu = 7; sigma = 3; 
                       x = rnorm(n = 3, mean = mu, sd = sigma); mean(x)}); w # repeat several lines


#####################simulation of distributions####################

?distributions # norm, unif, t, chisq, f, exp
# prefix
# d - density (pdf)
# p - probability (cdf) (which side?)
# q - quartile (critical value, or inverse of cdf) (which side?)
# r - random generating

# one-time simulation N(mu, sigma)
mu = 7; sigma = 3
mean(x <- rnorm(n = 1000, mean = mu, sd = sigma)); sd(x)


# Central Limit Theorem (CLT)
# Population Distribution: U(0, 1) => Sampling Distribution: N(0.5, *) by CLT
# see https://www.khanacademy.org/math/statistics-probability/sampling-distributions-library/sample-means/v/central-limit-theorem

# population distribution
curve(dunif(x, min = 0, max = 1), from = -0.1, to = 1.1, ylim = c(0, 8), lty = 2, n = 500) #U(0,1)
# if n = 101 by default, you can observe some unexpected slant lines at both ends

n <- 50 # sample size, used in rnorm()
N <- 200 # number of samples, used in replicate()

x.bars <- replicate(n = N, expr = mean(runif(n = n, min = 0, max = 1))) # vector of N sample means
mean(x.bars) # should be near 1/2
sd(x.bars) # should be near sqrt(1/12)/sqrt(n), about .0527

curve(dnorm(x, mean = 1/2, sd = sqrt(1/12)/sqrt(n)), from = 0, to = 1, lty = 3, add = TRUE, col = "red") # by CLT

lines(density(x.bars), lty = 1) # sampling distribution of bar(x)
                                # much better than histogram here

rug(x.bars)
legend(x = "topright", legend = c("U(0,1)", "CLT", expression(bar(X))), col = c("black", "red", "black"), lty = c(2, 3, 1))


# sample size matters
curve(dunif(x, min = 0, max = 1), from = -0.1, to = 1.1, ylim = c(0,8), lty = 2, n = 500) # U(0,1)
# if n = 101 by default, you can observe some unexpected slant lines at both ends

n <- 1 # sample size is too small! CLT fail!
N <- 100 # number of samples

x.bars <- replicate(n = N, expr = mean(runif(n = n, min = 0, max = 1))) # vector of N sample means
mean(x.bars) # should be near 1/2
sd(x.bars) # should be near sqrt(1/12)/sqrt(n), about .2887

curve(dnorm(x, mean = 1/2, sd = sqrt(1/12)/sqrt(n)), from = 0, to = 1, lty = 3, add = TRUE, col = "red") # CLT

lines(density(x.bars), lty = 1) # sampling distribution of bar(x)

rug(x.bars)
legend(x = "topright", legend = c("U(0,1)", "CLT", expression(bar(X))), col = c("black", "red", "black"), lty = c(2, 3, 1))


# simulation of t distribution
# normal distribution => t distribution
# see https://www.youtube.com/watch?v=Uv6nGIgZMVw

n <- 6 # sample size
N <- 1000 # number of samples. You can change it to see what will happen.
mu <- 7
sigma <- 3

t <- replicate(N, 
               expr = {x = rnorm(n, mean = mu, sd = sigma); 
                       (mean(x) - mu)/(sd(x)/sqrt(n))}) # normal distribution => t distribution
plot(density(t)) # sampling distribution of T ~ t_{n-1}
rug(t)

curve(dt(x, df = n-1), lty = "dashed", add = TRUE, col = "red") # true t_{n-1}

curve(dnorm(x, mean = 0, sd = 1), lty = "dotted", add = TRUE, col = "blue") # add N(0, 1) for reference

legend(x = "topright", legend = c(expression("true "*t[n-1]), "simulated t", "N(0, 1)"), col = c("red", "black", "blue"), lty = c("dashed", "solid", "dotted"))

# simulation of chi-squared/F distribution: see handout


########################simulation of p-value#######################
# see https://www.youtube.com/watch?v=128yz0OCG-I
# Monte Carlo method: https://en.wikipedia.org/wiki/Monte_Carlo_method

x <- c(118, 121, 113, 116, 117, 112, 113) # real sample data
mu0 <- 119.5

# t test
(out <- t.test(x, mu = mu0)) # get t score & p-value, reject H0

# p-Value simulation
sigma <- sd(x)
n <- length(x) # sample size
N <- 1000 # number of replicates. You can change it to see what will happen.

t <- replicate(N, expr = {x = rnorm(n, mean = mu0, sd = sigma); (mean(x) - mu0)/(sd(x)/sqrt(n))}) # normal distribution => t distribution

more.extreme <- (abs(t) > abs(out$statistic)) # counts
(simulated.p.value <- sum(more.extreme) / N) # proportion as a probability, i.e., simulated p-value
out$p.value # true p-value

plot(density(t), main = bquote(.(N) * " Simulated t statistics")) # visualize p-value
rug(t)
points(x = out$statistic, y = 0, pch = 19, col = "red")
text(x = out$statistic, y = .02, labels = "out$statistic")


################################exam################################
# read the exam rule CAREFULLY on my email!