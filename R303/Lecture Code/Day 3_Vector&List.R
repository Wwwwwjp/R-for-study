rm(list = ls()) # initialization


###############################Vector###############################

# sorting (for a single column)
x <- c(12, 11, 16, 11); x
sort(x) # increasing by default
sort(x, decreasing = TRUE) # decreasing by decreasing = TRUE


# ranking
x
v <- rank(x); v # ties.method = "average" by default. Often used in nonparametric tests.
v <- rank(x, ties.method = "first"); v
v <- rank(x, ties.method = "min"); v # like U.S. News Ranking for Top Universities
?rank


# order: indices for sorting components tied together (similar to spreadsheet), see below.
x; v <- order(x); v
x[v] # like sort(x) by permutation
     # but sort(x) is more straightforward, why bother to use order()? The answer is coming soon.


# structure with type (how it is stored in the memory)
x; str(x) # as shown in Global Environment


# summary
x; summary(x) # good for Boxplot (https://en.wikipedia.org/wiki/Box_plot)


# quantile, similar to qnorm()
x; quantile(x) # default quartiles, like summary(x)
v <- quantile(x, probs = seq(0, 1, length.out = 5)); v # same output by a sequence of cutoffs
v <- quantile(x, probs = c(0.3, 0.8)); v # by a list of cutoffs
v <- quantile(x, probs = c(1/3, 2/3)); v # ternary cuts


# nothing or meaninglessness: NULL, NA, "", NaN, or Inf
x <- c(0/0, 4/0, (-1)/0); str(x); length(x) # undefined values
x <- c(0, NA, 3); str(x); length(x) # missing value in an assigned entry
x[2] # the value is missing but the slot is given
x <- c("stat", "", "311"); str(x); length(x) # empty string in an assigned entry
x <- c(0, NULL, 3); str(x); length(x) # no entry
x[2] # NULL is skipped, i.e., the slot is not given to NULL
x <- c(NULL, NULL, NULL); str(x); length(x) # nothing
x[2] # all the entries of x don't exist
x    # still NULL
# If you are not sure, always test it on the console!

x <- c(12, 11, 16, 11); str(x)
names(x) # no name


# IMPORTANT: how to deal with NA
x[3] <- NA; x # why not NULL?!
sum(x) # NA: error message!
?sum; sum(x, na.rm = TRUE) # ignore NA values


# test NA or NULL
x; x == 11 # NA is contagious
x == NA # wrong command!
is.na(x); !is.na(x)
x[!is.na(x)] # a filter to find non-empty entries

is.null(x) # not == NULL!


# file output for vectors
fifties <- 50:59; fifties
write(fifties, file = "50s.txt") # in your working directory. Always set it up first.
write(fifties, file = "") # like write(fifties), just write to the console (by default)
                          # similar to print() or cat()
v <- c(23, 23, 1, 3, 1, 6, -0.5, -2, 3)
write(v, file = "50s.txt") # WARNING: the old data will be erased


# file input for vectors (used in HW2)
data <- scan() # read data from the console by default (stdin), like data <- scan(file ="")
               # rarely used now
               # Use Ctrl + C to stop
data


fifties <- 50:59
write(fifties, file = "50s.txt")
y <- scan(file = "50s.txt", what = integer()) # read the given type of data from the given file
y # check on the right immediately!!!

v <- c(23, 23, 1, 3, 1, 6, -0.5, -2, 3)
write(v, file = "50s.txt") # WARNING: the old data will be erased
y <- scan(file = "50s.txt", what = integer()) # error message!
y

y <- scan(file = "50s.txt", what = numeric());y # use a general type

# IMPORTANT: Check your vector after loading to make sure the data is loaded correctly.

# IMPORTANT: this is only for vector I/O. For data frame, it is coming soon.



################################List################################
############List can contain elements of different types############
####################Like a row of an Excel table####################

x <- list("rope", 72, c(5, 7, 10), TRUE); x # list: different type
length(x)

x <- c("rope", 72, c(5, 7, 10), TRUE); x # vector: same type
length(x) # larger


y <- list(     self = "John",
             spouse = "Michele",
          kids.ages = c(0, 2, 5, 7, 9, 11),
            address = NA)
y


# filtering by [...] => a sublist with names, similar to indexing a vector
str(y)

str(y[2]) # still a sublist, consisting of 1st, 2nd, 3rd, 4th component

str(y[c(1, 3)]) # sublist: 1st, 3rd

str(y[c(-1, -3)]) # sublist: excluding 1st, 3rd = only 2nd and 4th left

is.na(y)
str(y[!is.na(y)]); # select TRUE, i.e., non-empty components

str(y[c("spouse", "kids.ages")]) # by names


# directing by [[...]] => a single value without its name

x <- list("rope", 72, c(5, 7, 10), TRUE); x

x[3] # still a list
x[[3]] # a vector
str(x[3]) # with $, namely, an empty name
str(x[[3]]) # without $, namely, without a name
x[2:3] # still a list
x[[2:3]] # error message! only single value


y <- list(self = "John",
          spouse = "Michele",
          kids.ages = c(0, 2, 5, 7, 9, 11),
          address = NA
          )
str(y)
str(y[3]) # with a name. y[3] = y["kids.ages"]
str(y[["kids.ages"]]) # without a name. y[["kids.ages"]] = y[[3]]
str(y[1:3]) # with names
str(y[[1:3]]) # error message! only a single value



# Differences between [...] and [[...]]
# [...] means only a sublist (maybe multiple entries) on the same layer.
# [[...]] means a single entry on a lower layer (for the embedded list).
# see details at https://www.geeksforgeeks.org/difference-between-single-and-double-square-brackets-in-r/

# embedded list
z <- list(self = "John",
          spouse = "Michele",
          kids.ages = list(soon = "to be delivered soon",
                           ages = c(2, 5, 7, 9, 11)
          ),
          address = NA
)
str(z)

length(z[3]); str(z[3])
length(z[[3]]); str(z[[3]]) # different size!

z[["kids.ages"]][["ages"]][2] # the 2nd known age of the kids. Quite clumsy
z[[3]][[2]][2] # same output. Still clumsy. We need a shortout, i.e., $. See below.
z[3][2][2] # NULL! Actually wrong. Why?



# indexing by $: a shortcut $... = [["..."]], the most common indexing for list
z
str(z$spouse) # without a name, on the 2nd layer
str(z[["spouse"]]) # same
str(z["spouse"]) # with a name, different output, on the 1st layer


z$kids.ages$ages[2] # cf. z[["kids.ages"]][["ages"]][2], much cleaner


# differences between $ and [[...]] or [...]
str(y)
z <- "spouse"
str(y[[z]]) # correct, like str(y[["spouse"]])
str(y$z) # NULL, because it is explained by R as str(y[["z"]]) and there is no such component.)
         # why not NA?
str(y[["z"]]) # NULL, same output

z <- 1
y[z] # correct, like z[1]
y[[z]] # correct, like z[[y]]
y$z # NULL, because it is explained by R as y[["z"]] and there is no such component.)
    # why not NA?


# add a new component
str(y)
y$kids.names <- c("Teresa", "Margaret", "Monica", "Andrew", "Mary", "Philip"); str(y) # like y[["kids.names"]] = ...
# Only for advanced students!
# y["kids.names"] = c("Teresa", "Margaret", "Monica", "Andrew", "Mary", "Philip"); str(y) #Wrong! Why?


# delete a component
y$self <- NULL; y # deletion = assignment by NULL


# the purpose of order()

(y$kids.ages <- c(0, 2, 5, 7, 9, 11)) # (...) = print(). Like y$kids.ages <- ...; y$kids.ages
(y$kids.names <- c("Teresa", "Margaret", "Monica", "Andrew", "Mary", "Philip")) # tied together

sort(y$kids.names) # sort the names only and break the tie with the ages!
                   # how to keep the tie between the names and the ages after the sorting of the names?

# use the order() to keep the tie
(indices.ordered.by.name <- order(y$kids.names))
(name.sorted <- y$kids.names[indices.ordered.by.name]) # sort the names
(ages.sorted.by.name <- y$kids.ages[indices.ordered.by.name]) # sort the ages by name
                                                              # the tie is kept!

# This trick is also useful to handle the data frames later.


# list => vector
y
(z <- unlist(y)) # vector of character type with the converted names 
(z <- unlist(y, use.names = FALSE)) # vector of character type without the names
z[3] # character after conversion
y$kids.ages[2] # originally numeric


# data frame coming soon 
# see the relationship among vector, list and data frame at
# https://www.programcreek.com/2014/01/vector-array-list-and-data-frame-in-r/



################################HW2#################################

# Watch the HW video and read the requirement carefully! 
# Double check the file suffix after downloading four data files 
# Save it into your WORKING DIRECTORY 
# Delete the suffices if the browser generate them automatically!!!
#
# The two tiny data files are used to verify your calculations 
# by yourself ONLY. There is no need to submit your answers 
# with tiny data files.
#
# You need to run your R script with the two big data files eventually 
# and submit it as "hw2.R"



############################Summary#################################

# Vector: a column of a table, same type, easy indexing by [num]

# List: a row of a table, different type, complicated indexing, 
                                        # $columnname always preferred
                                        # [num], [[num]] can be ignored by beginners

# Double check the loaded variables after reading the files!

# Double check the contents of the files after writing the files!

# NULL, NA, etc. needs some special treatments.

# Sorting a table by order() is a very important technique.

# Trial and error is always strongly recommended!