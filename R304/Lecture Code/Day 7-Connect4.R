rm(list = ls()) # initialization

# HW2: Connect Four
# https://en.wikipedia.org/wiki/Connect_Four
# In app store, search "four in a row" or "connect 4"
# For Android: https://play.google.com/store/search?q=four%20in%20a%20row
# For iPhone: https://itunes.apple.com/us/app/four-in-a-row/id292882605?mt=8

# If you use a Windows PC, please refer to Day 4-tic3_move.R to handle the identify() issue with RStudio.
# To be precise, just insert windows() before any plotting.



# Difference 1
# Different dimensions
# tic-tac-toe is 3x3
# Connect 4 is 6x7



# Difference 2
# let the stone of Connect Four fall down to the floor, instead of floating at the click position
# you could use max() 



# Difference 3
# regular testing four in a row by all/for-loop and which()/match(), basic but not recommended
x <- c("O", "O", "X", "X", "X", "X", "E", "X", "X"); x # a column or row or diagonal line extracted from the chessboard
player.index = which(x == "X") # all the indices of the first "X" in x
                               # if none, return an empty index vector
# match() is also good. Return the first index of "X" in x as a vector. If none, return NA.

win = FALSE
if (length(player.index) > 0) { # or, if (!is.na(beginning)))
  player.valid.index = player.index[player.index+4-1 <= length(x)]
  for (i in player.valid.index) { # i is the beginning testing index, i+3 is the ending testing index
    if (all(x[i:(i+4-1)] == "X")) { # this is an internal loop actually, testing the existence of the substring
      win = TRUE; break
    }
  }
} 
if (win) print("win") else print("no winner")
# You can test it with other vectors.


# Shortcut 1
# testing four in a row with a new function rle(), instead of using a loop
?rle # run length encoding
     # check the meaning of the run
x <- rev(rep(6:10, 1:5)); x
rle(x)

x <- c("O", "O", "X", "X", "O", "X", "E", "X", "X"); x # from each column or row or diagonal
rle(x)
str(rle(x))

# Watching and analyzing the output of the above code, please write testing code based on it.


# Shortcut 2
# testing four in a row with the regular expression (regex, which will be taught soon) easily, like this:
strrep("X", 4) # get "XXXX" by string repeating function strrep()
paste(x, collapse = "") # combine the char vector x into a single string
grep(pattern = strrep("X", 4), paste(x, collapse = "")) # use regex to find a given substring
                                                        # if no, return integer(0), whose length is 0!
                                                        # if yes, return 1

if (length(grep(pattern = strrep("X", 4), paste(x, collapse = ""))) > 0) print("Win!")
# Or, 
if (!identical(grep(pattern = strrep("X", 4), paste(x, collapse = "")), integer(0))) print("Win!")


# the best way:
grepl(pattern = strrep("X", 4), paste(x, collapse = "")) # use grepl(), where l means a logical output
                                                         # return TRUE or FALSE
if (grepl(pattern = strrep("X", 4), paste(x, collapse = ""))) print("Win!")



# Difference 4
# There is no need to test all the rows, columns, and diagonal lines after the move
# Just test the row, column, diagonal line related to the current move



# Difference 5
# testing four in a row diagonally
m = matrix(data = 1:12, nrow = 3, ncol = 4, byrow = TRUE)
m

row(m); col(m) # like y, x coordinates, but y is from top to bottom
row(m) == col(m) # element-wise comparison, cf y = x
row(m) - col(m) == 0 # y - x = 0, the same equation

m[row(m) == col(m)] # main diagonal in a matrix
m[row(m) - col(m) == 0] # the same main diagonal


# with shifts or intercepts
r = 2; c = 3 # y0, x0

# slope = 1
m[row(m) - col(m) == r - c] # diagonal through (r, c), cf y - x = y0 - x0
m[row(m) == col(m) + (r - c)] # the same diagonal through (r, c) cf y = x + (y0 - x0)

# slope = -1
m[row(m) + col(m) == r + c] # reverse diagonal through (r, c), cf y + x = y0 + x0
m[row(m) == - col(m) + (r + c)] # the same reverse diagonal through (r, c) cf y = - x + (y0 + x0)


# summary
# 1. It is a very long project. Do it step by step by following the tic-tac-toe code from tic1 to tic7.
# 2. Haste makes waste. Don't skip any steps.
# 3. Debugging becomes tougher. Don't guess the outcome from the code unless you are a guru. Always use printouts.
# 4. Always print out the values of some variables to help you track the program. The more, the better.
# 5. Insert some necessary space in each line or some empty lines to separate each block. 