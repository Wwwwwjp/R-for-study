x = c(3, 3, NA, 2, 4, NA)
sum(x, na.rm = TRUE)
mean(x, na.rm = TRUE)
x[is.na(x)] = 0
mean(x)

prob = 0
for (i in seq(0, 100, by = 2)){
  prob = prob + dbinom(i, size = 100, prob = 0.6)
}
print(prob)

?mtcars
sort(mtcars$wt[(mtcars$am == 1) & (mtcars$hp > 100)], decreasing = TRUE)[2]
sorted = mtcars[order(mtcars$drat, mtcars$mpg*(-1)), ]
sorted$cyl[2]

rm(list = ls()) # initialization
n <- 50
p <- 0.4 # assignment of n and p
x <- 1:40 # assignment of x values, from 1 to 40
ynorm <- dnorm(x, mean = n * p, sd = sqrt(n * p * (1 - p))) # calculate normal probability density function
ybin <- dbinom(x, n, p) # calculate binomial probability mass function
plot(x, ybin, type="h",main="Normal approximation to binomial",xlab="x",ylab='pmf') # plot the binomial mass function with vertical lines, instead of points, with type h. Keep the main title and labels intact.
lines(x, ynorm, col='red') # plot the normal probability density curve in red
legend("topright", legend = c(paste(sep = "", "binomial(n = ", n, ", p = ", p, ")"),# This legend line is flawless. Keep it intact.
                              paste(sep = "", "normal(", n * p, ", ",  round(sqrt(n * p * (1 - p)), 2), ")")), 
                    col = c("black", "red"), lty = c(1, 1))

fe =  c(99, 96, 95, 93, 95, 98, 96, 100)
ma =  c(89, 96, 90, 91, 92, 93, 94, 90, 95, 92, 91, 93)
out = t.test(fe, ma, alternative = "two.sided", conf.level = .95)
print(out$p.value)

height = c(151, 174, 138, 186, 128, 136, 179, 163, 152, 131)
weight = c(63, 81, 56, 91, 47, 57, 76, 72, 62, 48)
clf = lm(weight ~ height)
cat(clf$coefficients[1], 'is the intercept.', clf$coefficients[2], 'is the slope.')

d = data.frame(height = 170)
print(predict(clf, newdata = d))

seed = 2
set.seed(seed)
N = 1000
t = replicate(N, max(rexp(40, rate = 0.2)))
var_max = var(t)
print(var_max)
              

# Debugging guidelines
# First, I want to remind us of this fact: WE ARE HUMANS and always make mistakes. It is common. Don't be scared of bugs in your code. 
# 
# Secondly, WE ARE NOT COMPUTERS. So, don't stare at your code for hours, try to run it in your mind, and guess what's happening behind the screen. In that way, you treat yourself as a computer wrongly and waste your time. Instead, you need to run your code on your computer (again, not in your mind) LINE BY LINE and let your computer tell you what's going on by some extra printouts. This is the most efficient way of debugging.
# 
# 
# 
# Here are my suggestions for debugging (also shown in my lecture code from Canvas > Files, especially in my comments): 
#   
#   Always boil down a long step into some short and simple steps. Don't write a too-long line if you cannot handle it. Replace it with several short lines, which can be traced more easily.
# Always insert some print() and cat() to print out the doubtful variables and intermediate results at some checkpoints.
# Translate math formulas STEP BY STEP into R.
# Always be TYPE-SENSITIVE, that is, keep the types of variables in mind. Otherwise, there will always be unexpected issues in your code. The best solution is to use str() to know the type of doubtful variables and make sure the variables match others in type.
# After loading data from files to variables, you need to print out the variables to make sure the data is stored correctly in value and in type.
# After writing data to files, you need to open the files with RStudio or other apps to make sure the data is written as expected.
# Divide and conquer. For example, NEVER ever do debug in your R markdown file (for HW), which contains too many things together and is too involved. Copy and paste your troublesome R chunk into a new-opened R script tab in RStudio and do debugging in this isolated tab.
# If you are not sure about the output of some functions or code, cook a chunk of code to test them. There is no need to ask other coders because your computer runs the code and shows the output, which is much better than any human.
# Develop a good coding style and make your code neat and elegant and readable by following my lecture code with appropriate spacing, indentations, and alignments.
# Always use meaningful names for variables and functions.
# Try to make your code readable to yourself and other coders. Always add some comments to improve its readability.
# Relax and do not stick to something for a too-long time. Sometimes, a brief rest can refresh your mind and make debugging much more productive.
# Finding a logical error is muuuuuuuuuuuch more difficult than finding a syntax error.
# Coding is always easy while debugging is always tough. But if you can follow my suggestions above, you might feel better with debugging.
# 
# Hope it helps,
# 
# --Dr. Yang


tail = 0.1
print(qnorm(1 - tail, mean = 3, sd = sqrt(5)))

?mtcars
sort(mtcars$mpg[(mtcars$vs == 0) & (mtcars$hp < 200)], decreasing = FALSE)[3]

posts = c(13.2, 14.5, 16.2, 16.6, 17.5)
Home_Depot_posts = c(13.7, 14.7, 15.8, 17.0)
qqnorm(posts)
qqline(posts)
qqnorm(Home_Depot_posts)
qqline(Home_Depot_posts)

var_test = var.test(posts, Home_Depot_posts,
                    alternative = "two.sided",
                    conf.level = 0.95)
print(var_test$p.value)

sorted = mtcars[order(mtcars$hp * (-1), mtcars$mpg), ]
sorted$disp[sorted$vs == 1][1]

set.seed(5)
n = 50 
N = 1000 
M = replicate(n = N, min(rt(n, 10)))
sd(M) 


rm(list = ls())

m = mtcars # load mtcars into m
m4cyl = m[m$cyl == 4, ]
m6cyl = m[m$cyl == 6, ]
m8cyl = m[m$cyl == 8, ] # divide m into 3 groups of data frames: 4cyl(m4cyl), 6cyl(m6cyl), 8cyl(m8cyl)
n = matrix(data = c(1,2,3,3), nrow = 2) # set up the layout matrix
layout(n) # apply the layout matrix
plot(x = m4cyl$wt, y = m4cyl$mpg, 
     main = "Mileage vs. Weight (4 cyl)",xlab="weight (pounds)",ylab="mileage (mpg)",col='red') # draw the 1st subplot on the upper-left corner. keep the main title and labels intact.
plot(x = m6cyl$wt, y = m6cyl$mpg, 
     main="Mileage vs. Weight (6 cyl)",xlab="weight (pounds)",ylab="mileage (mpg)",col='blue') # draw the 2nd subplot on the lower-left corner. keep the main title and labels intact.
plot(x = m8cyl$wt, y = m8cyl$mpg, 
     main="Mileage vs. Weight (8 cyl)",xlab="weight (pounds)",ylab="mileage (mpg)",col='green') # draw the 3rd subplot on the right. keep the main title and labels intact.
          
layout(matrix(data=1, nrow=1, ncol=1))  

data("mtcars")

# Filter the dataset to include only V-shaped-engine (cylinders equal to 8) cars
v_shaped_cars <- mtcars[mtcars$vs == 0, ]

# Filter further to include only cars with less than 200 gross horsepower
filtered_cars <- v_shaped_cars[v_shaped_cars$hp < 200, ]

# Sort the filtered dataset by gas mileage (mpg) in ascending order
sorted_cars <- filtered_cars[order(filtered_cars$mpg), ]

# Find the third lowest gas mileage among these cars
third_lowest_mileage <- sorted_cars$mpg[3]

# Print the result
third_lowest_mileage
          