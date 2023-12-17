rm(list = ls()) # initialization



# hypothesis test:       http://stattrek.com/hypothesis-test/hypothesis-testing.aspx 
# confidence interval:   http://stattrek.com/estimation/confidence-interval.aspx



###########################One/Two Means############################
##############################by T test#############################

?t.test # general help
# see http://stattrek.com/hypothesis-test/mean.aspx#
#     http://stattrek.com/hypothesis-test/difference-in-means.aspx#
#     https://en.wikipedia.org/wiki/Welch%27s_t-test
#     http://www.statsdirect.com/help/parametric_methods/unpaired_t.htm

# Input as parameters
# t.test(x, y = NULL, alternative = "two.sided",
#        mu = 0, paired = FALSE, var.equal = FALSE,
#        conf.level = 0.95, ...)

# optional y:   y is the 2nd sample data
#               If given, two means test
#               Otherwise, one mean test

# Output as a list
# parameter:    df
#               length(x) - 1, if one mean test
#               a mess if two means test
# statistics:   t score
# p.value:      p-value
# conf.int:     confidence interval
# estimate:     sample mean of x or sample means of both

# one mean
# see http://stattrek.com/hypothesis-test/mean.aspx#
# H0: population mean = mu (= 0 by default)

x <- rnorm(10, mean = 0, sd = 1); x # artificial or demo data from rnorm; real data loaded from the given files
(out <- t.test(x)) # retain H0
str(out)
out$p.value

# To observe a type I error: p-value < 0.05 by a chance of 1 out of 20
# you can try running the same code in one single line as below:
x <- rnorm(10, mean = 0, sd = 1); (out <- t.test(x)) 

x <- rnorm(10, mean = 0, sd = 1) # demo data from rnorm
(out <- t.test(x, mu = 2)) # reject H0


# two means
# see http://stattrek.com/hypothesis-test/difference-in-means.aspx#
#     https://en.wikipedia.org/wiki/Welch%27s_t-test
#     http://www.statsdirect.com/help/parametric_methods/unpaired_t.htm
# H0: the difference between two population means equal to mu (= 0 by default)

x <- rnorm(10, mean = 0, sd = 1); y <- rnorm(10, mean = 2, sd = 1) # demo data from rnorm
(out <- t.test(x, y)) # reject H0

x <- rnorm(10, mean = 0, sd = 1); y <- rnorm(10, mean = 2, sd = 1) # demo data from rnorm
(out <- t.test(x, y, mu = -2)) # retain H0


# How about z test? 
# We can create a function on our own! Coming soon in the next section.

# Or, see http://www.r-tutor.com/elementary-statistics/interval-estimation/interval-estimate-population-mean-known-variance
# install.packages("TeachingDemos")
# library(TeachingDemos)
# ?z.test



########################Equality of Variances#######################
##############################by F test#############################

?var.test # general help
# see http://stattrek.com/probability-distributions/f-distribution.aspx
# H0: the ratio of two sample variance = the given ratio (= 1 by default)

# Input as parameters
# var.test(x, y, ratio = 1, alternative = "two.sided", conf.level = .95)

# Output as a list
# parameter:    numerator/denominator df's
# statistics:   f score
# p.value:      p-value
# conf.int:     confidence interval
# estimate:     see handout

x <- rnorm(100, 0, 1); y <- rnorm(10, 0, 2) # demo data from rnorm; real data loaded from the given files
(out <- var.test(x, y, ratio = 1)) # reject H0

x <- rnorm(100, 0, 1); y <- rnorm(10, 0, 2) # demo data from rnorm
(out <- var.test(x, y, ratio = .25)) # retain H0



###########################Chi-Squared test#########################

?chisq.test # general help
# see http://stattrek.com/probability-distributions/chi-square.aspx?Tutorial=Stat


# Goodness-of-fit
# see http://stattrek.com/chi-square-test/goodness-of-fit.aspx?Tutorial=AP
# H0: counts came from a distribution with probabilities probs

# Input as parameters
# chisq.test(x = counts, p = probs)

# Output as a list
# parameter:    df = #categories - 1
# statistics:   chi-squared score
# p.value:      p-value

counts <- c( 12,  15,  17,   6) # counts, maybe obtained from a table
probs  <- c(.20, .25, .40, .15) # probabilities, their total sum = 1
(out <- chisq.test(x = counts, p = probs)) # retain H0
str(out)

# verification
counts; out$observed
n <- sum(counts)
probs
(expected <- n * probs); out$expected
(counts - expected) / sqrt(expected); out$residuals
(counts - expected)^2 / expected
sum((counts - expected)^2 / expected); out$statistic


# Independence/Homogeneity
# see http://stattrek.com/chi-square-test/independence.aspx?Tutorial=AP
#     http://stattrek.com/chi-square-test/homogeneity.aspx?Tutorial=AP
# H0: row and column variables are independent / homogenerous

# Input as parameters
# chisq.test(x)
# x is a contingency table

# Output as a list
# parameter:    df = (#rows - 1) x (#columns - 1)
# statistics:   chi-squared score
# p.value:      p-value
# expected:     expected counts under H0

(x <- matrix(data = c(56, 37, 53,  
                      54, 43, 28,  
                      41, 27, 36,  
                      36, 32, 16), nrow = 4, ncol = 3, byrow = TRUE)) # a 4x3 contingency table, maybe obtained from table() 
(out <- chisq.test(x)) # reject H0
str(out)


# how to get a counts or contingency table from a data frame?
table(mtcars$cyl) # counts
table(mtcars$cyl, mtcars$gear) # contingency table
# another way is using a factor, check ?chisq.test



########################One/Two Proportions#########################
#######################by Chi-Squared/Z test########################

?prop.test # general help
# see http://stattrek.com/hypothesis-test/proportion.aspx?Tutorial=AP
#     http://stattrek.com/hypothesis-test/difference-in-proportions.aspx?Tutorial=AP


# one proportion
# see http://stattrek.com/hypothesis-test/proportion.aspx?Tutorial=AP
# H0: population proportion = p

# Input as parameters
# prop.test(x, n, p, alternative = "two.sided", conf.level = .95)

# x:            #successes
# n:            #trials
# p:            given success rate

# Output as a list
# parameter:    df = 2 - 1 = 1
# statistics:   chi-squared score
# p.value:      p-value
# conf.int:     confidence interval
# estimate:     sample proportion

x <- 800 # successes
n <- 1000 # trials
p0 <- .77 # given success rate
(out <- prop.test(x, n, p0, correct = FALSE)) # reject H0
#                           correct = FALSE disables a good continuity correction
str(out)
out$p.value

# verification by an equivalent Z test
# see https://www.tutorialspoint.com/statistics/one_proportion_z_test.htm
phat <- x / n # observed proportion
z <- (phat - p0) / sqrt(p0 * (1-p0) / n) # z-score
(p.value <- 2 * pnorm(-abs(z))); out$p.value # p-value
z^2; out$statistic


# two proportions
# see http://stattrek.com/hypothesis-test/difference-in-proportions.aspx?Tutorial=AP
# H0: two population proportions are equivalent

# Input as parameters
# out = prop.test(x, n, alternative = "two.sided", conf.level = .95)

# x:            #pair of #successes
# n:            #pair of #trials

# Output as a list
# parameter:    df = (2-1) * (2-1) = 1
# statistics:   chi-squared score
# p.value:      p-value
# conf.int:     confidence interval
# estimate:     a pair of sample proportions

x <- c( 40,  87) # pair of #successes
n <- c(244, 245) # pair of #trials
(out <- prop.test(x, n, correct = FALSE)) # reject H0

# verification by an equivalent Z test
# see http://www.socscistatistics.com/tests/ztest/
#     http://www.statisticshowto.com/z-test/

p1 <- x[1]/n[1]; p2 <- x[2]/n[2]; p <- sum(x)/sum(n) # observed proportions
z <- (p1 - p2) / sqrt(p * (1-p)*(1/n[1] + 1/n[2])) # z-score
(p.value <- 2 * pnorm(-abs(z))); out$p.value # p-value
z^2; out$statistic