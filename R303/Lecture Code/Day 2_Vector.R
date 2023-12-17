rm(list = ls()) # initialization



###############################Vector###############################
#############All the elements must be of the same type!#############
######################Like a column of a table######################

# var: choose meaningful names
# type: very important!!! like a format to save the data on a computer
# vector: multiple values of the same type, with indices, like a column in an excel table

v <- c(2.71, 5, 3.14) # case sensitive! num vector
                      # <-: Alt + - in RStudio
length(v)
v # also watch Global Environment on the right
  # always pay attention to its type
str(v) # check its type, good for debugging
v[3] # index starts from 1, instead of 0, unlike most programming languages
# index vs value like position/address vs content/inhabitant 

words <- c("tree", "ant", "chainsaw", "stats") # char vector
length(words)
words
str(words)
words[1]



############################Vector Type#############################

# numeric = decimal
3.1415927e7; 3.1415927E7 # = 3.1415927*10^7 (scientific notation, check https://en.wikipedia.org/wiki/Scientific_notation)
3.14e-2; 3.14E-2; 3.14*10^(-2) # the same


# character/string, " or ' always encloses a character string
quotation <- c("\\stat\\", "", "\"love\"") 
quotation[1]; cat(quotation[1]) # cat() shows the "interpreted" characters stored on the computer
nchar(quotation[1]) # count the characters in quotation[1] => 6, not 8
quotation[2]; cat(quotation[2]) # empty string
nchar(quotation[2]) # 0 characters, empty
quotation[3]; cat(quotation[3]) # one more example
nchar(quotation[3])
# escape character, led by \, a character that invokes an alternative interpretation 
# on the following characters in a string
# see more details in https://www.w3schools.com/r/r_strings_esc.asp#:~:text=To%20insert%20characters%20that%20are,character%20you%20want%20to%20insert.

# one more example about escape character
oak <- 70
text <- paste(sep = "", "Oak weighs", oak, "lbs/ft^3.") # observe the output and check ?paste
text

text <- paste("Oak weighs", oak, "lbs/ft^3.") # sep (separator) = " " by default
text

text <- paste(sep = "\n", "Oak weighs", oak, "lbs/ft^3.")
text

# cat() shows the real printout of the string with some escape characters
oak <- 7.4e-3
cat(sep = "",   "\"Oak\" weighs", oak, "lbs/ft^3.")
cat(sep = "\n", "\"Oak\" weighs", oak, "lbs/ft^3.") # \n = new line => multiple-line printout
cat(sep = "\t", "\"Oak\" weighs", oak, "lbs/ft^3.") # \t = TAB
cat(sep = "\\", "\"Oak\" weighs", oak, "lbs/ft^3.") # You can try all the others listed in our handout on your own!

cat("I ");   cat("love ");   cat("R.\n") # single-line printout
cat("I \n"); cat("love \n"); cat("R.\n") # multiple-line printout

text <- cat(sep="\n", "Oak weighs", oak, "lbs/ft^3.")
text # It shows NULL!
# cat() only prints, cannot be used for the assignment


# logical: TRUE (T for short, or = 1) and FALSE (F, or = 0)
v <- c(2.71, 5, 3.14)
result <- (v > 3); result
v > 3
sum(v > 3) # counting, cf. sum(result)
sum(v)

words <- c("tree", "ant", "chainsaw", "stats")
words == "ant" # == for comparison, =/<- for assignment
sum(words == "ant") # counting


# set up a vector
vector(mode = "logical", length = 5) # mode define type
w <- vector(mode = "logical",   length = 5); w # default = FALSE
w <- vector(mode = "numeric",   length = 5); w # default = 0
w <- vector(mode = "character", length = 5); w # default = ""


# conversion
v <- c(2.71, 5, 3.14)
v > 3
as.numeric(v > 3) # logical => numeric, explicit

w <- c("34", "12", "45")
sum(w) # wrong!
w.numbers <- as.numeric(w); w.numbers # character => numeric, explicit
sum(w.numbers); sum(as.numeric(w))


# R can convert the type implicitly, like
c(TRUE, 1, "1")
# Sometimes this implicit conversion is convenient. Sometimes it is trouble maker.
# As a beginner, use explicit conversions, instead of implicit ones.

# three other types: integer, complex, raw. Please use ? to see details.



##########################Names Attribute############################
# textual index, instead of numerical index

v <- c(2.71, 5, 3.14)
str(v)
names(v) <- c("e", "five", "pi")
v
v["e"]
v[2] <- 4; names(v)[2] <- "four"; v
names(v) <- NULL; v # remove names

y <- c(burger = 2.50, fries = 1.50); y # assign with names and values



##########################Vector Functions###########################
# very useful and efficient

x <- c(11, 11, 12, 16)
sum(x)
max(x)
mean(x); sum(x) / length(x) # recycle the shorter one, length(x)
median(x)
sd(x)
var(x); sd(x)^2



########################Element-Wise Operators#######################

# arithmetic: +, -, *, /, ^, %/%, %%, etc
mean(x)
x - mean(x) # signed deviations, sum(x - mean(x)) = ???
(x - mean(x))^2 # squared deviations
sum((x - mean(x))^2 / (length(x) - 1)); var(x) # sample variance by using the divisor n - 1, not n
sqrt(sum((x - mean(x))^2 / (length(x) - 1))); sd(x) # sample sd

# How to boil down the complicated line into the simple lines as shown above is very useful for debugging!


# relation: >, >=, <, <=, == (equal to), != (not equal to)
# logic operator: ! (not), & (and), | (or)
v <- c(2.71, 5, 3.14)
v > 3
!(v > 3)
v <= 3.14
(v > 3) & (v <= 3.14) 
(v > 3) | (v <= 3.14) # ALWAYS use some parentheses if you are confused about the order of all these operators
any(v > 3); all(v > 3) # any = or, all = and


# assignment: <- or = (not ==!)
# <- is NOT equivalent to < -
v < -1; v<-1 # different!



#################################Sequence#############################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# special int vectors


# : (colon)
11:14 # try 14:11
x <- 11:14; y <- c(11, 12, 13, 14); x; y
5*(1:10); 5*1:10 # same output. Which is better?
(5*1):10 # adding parentheses is really necessary!


# seq (a powerful function)
seq(from = 10, to = 15, by = 2); seq(10, 15, 2)
seq(10, 15, length.out = 5)
seq(10, 15, length.out = 30) # good for drawing a graph
?seq


#############################Matching (%in%)##########################

1:8 %in% c(2, 4, 6)
?"%in%"


#######################Indexing/Filtering/Subsetting##################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Procedure:
# 1. Identify the criterion for filtering or indexing or subsetting, 
#    based on index (like I need the 2nd, 3rd, nth entries from a vector)? 
#    or based on value (like I need the entries whose values satisfy some conditions)?
# 2. If based on index, create the needed indices by a sequence (if you can find a simple rule to generate it using seq() or :) 
#    or c() with specific indices inside;
# 3. If based on value, create a comparison equivalent to the conditions to be satisfied.
# 4. Simply put the sequence (from 2.) or the comparison (from 3.) in the [] associated with the given vector.
# Note: Usually, there is no need to use which() for most indexing.

x <- 11:20; x

### Case 1. based on indices

# using a scalar
x[4]


# using a vector
v <- c( 1,  2,  10); x[v] # 1st, 2nd, 10th
v <- c( 10, 9,  8, 7, 6, 3, 4, 3); x[v] # any order, even with repetition
v <- c(-1, -2, -10); x[v] # negative = excluding
# make sure the index is valid.

# Only for advanced students! Pay attention to the range of the index.
# x[0] # no error message, surprising output
# x[20] # no error message, surprising output
# x[1.9]; x[-1.5] # no error message, surprising output

v <- seq(-1, -10, -1); v
w <- x[v]; w # integer(0) = zero integer


### Case 2. based on values

# using which, not very frequently
x != 14 # criterion for which element will be chosen
w <- which(x != 14); w # which() is not necessary!
x[w]


# using a logical filter, even simpler
x != 14
x[x != 14] # like a filter

x[x < 14] # like indices = which(x < 14); x[indices]

x %% 2
(x %% 2) == 0
x[(x %% 2) == 0] # even values


# batch assignment with recycling
x[1:3] <- 101; x # duplicate assignment
x[1:3] <- 101:103; x
x[1:9] <- 101:103; x # cyclic assignment
x[1:3] <- 101:105 # length doesn't match well, but assignments of x[1:3] are done!
x[1:8] <- 101:103; x # length doesn't match well, but cyclic assignments are done!
x[(x %% 2) == 0] <- 0; x # all the even term is set to be zero


# using names
x <- 1:3
names(x) <- c("one", "two", "Fred"); x
v <- c("Fred", "one")
x[v]



#######################R Script (save as test.R)###################

rm(list = ls()) # initialization

radius <- 3 # assignment

# computation
area <- pi * radius^2
circumference <- 2 * pi * radius

# output
cat(sep = "", "area = ", area, ", circumference = ", circumference, "\n")



##############################HW1###################################
# Watch the video of HW1 and read the requirement carefully.
# Then, fill in your name & email (blank 1 & 2) and code (blank 3 & 4).



############################Summary#################################

# Understand var, type, vector, index

# Understand the motivation of the escape character

# Case sensitivity and type sensitivity

# The best way to learn is always trial and error

# Indexing/Filtering: based on indices or values

# Practice indexing of vector on your own

# Debugging is always challenging. Try the following basic tips:
# 1. Boil down a complicated line into several simple lines.
# 2. Getting more output on Console or Global Environment is always good for debugging.
# 3. Keep your code neat and blockwise.
# 4. Always be case-sensitive and type-sensitive for coding.
# 5. Use parentheses if you are not sure about the precedence of the operators.
# 6. For the vector, you need to distinguish its indices and values (address vs resident).
# 7. Don't debug in R markdown. Isolation is important for debugging.