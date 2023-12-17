# Name: Jiapeng Wang
# Email: jwang2928@wisc.edu

setwd('E:/stat-visp/R304')
rm(list = ls())

#Important note!!!
#When I start doing this homework, I forgot that there's some helper 
#functions to complete. So, I just followed the tic-tac-toe code and programmed 
#the game according to my understanding. Thus, I did not use these helper functions
#in my code. When I finished my code, I realized that I needed to complete the 
#functions for HW2test, so I completed them but I did not have time to use these functions
#in my own code. Instead, you will find some functions written by my own after the helper functions


#Besides, about the logic of the computer player, I just wrote some code for it to 
#try to block the opponent's connection. It is a very simple and useless strategy, 
#just a little better than random selection. I also considered other strategies, 
#such as assigning a score to each possible choice. But I ultimately didn't have 
#time to complete such code.



# Implement Connect Four in the same manner that we
# implemented tic-tac-toe in lecture. Start by implementing
# the helper functions, below, and testing them by running
#   source("HW2test.R")
# Then write code for the game itself.
#
# You can read my lecture code Day 7-Connect4.R for more discusssions,
# especially about how to handle an annoying bug between R and RStudio on Windows PC
# and the difference between tic-tac-toe and Connect 4.
#
# We'll test your code by running
#   source("HW2.R")
# We might also play Connect Four, read your code, and do other tests.

# Returns TRUE if vector v (of character strings) contains
# (at least) four in a row of player (character string). e.g.
#   four.in.a.row("X", c("O","X","X","X","X","O"))
# is TRUE, while
#   four.in.a.row("O", c("O","X","X","X","X","O"))
# is FALSE.
four.in.a.row = function(player, v, debug=FALSE) {
  if (debug) {
    cat(sep="", "four.in.a.row(player=", player, ", v=", v, ")\n")
  }
  if (length(v) >= 4){
    for (i in 1:(length(v)-3)) {
      if (!any(is.na(v[i:(i+3)])) && all(v[i:(i+3)] == player)) {
        return(TRUE)
      }
    }
  }
  return(FALSE)
}

# Returns TRUE if (matrix) board (of character strings)
# contains at least four in a row of (string) player, who
# just played in position (r, c). (Here "r" means "row" and
# "c" means "column").
#
# Hint: this function should call four.in.a.row() four times, once
# each for the current row, column, diagonal, and reverse diagonal.
won = function(player, board, r, c, debug=FALSE) {
  if (debug) {
    cat(sep="", "won(player=", player, ", board=\n")
    cat(sep="", ", r=", r, ", c=", c, ")\n")
  }
  rows = nrow(board)
  cols = ncol(board)
  
  if (four.in.a.row(player, board[r, ])) {
    return(TRUE)
  }
  
  if (four.in.a.row(player, board[ ,c])) {
    return(TRUE)
  }
  
  for (i in 0:3) {
    if (r-i >= 1 & c-i >= 1 & r-i+3 <= rows & c-i+3 <= cols){
      v = c(board[r-i,c-i],board[r-i+1,c-i+1],board[r-i+2,c-i+2],board[r-i+3,c-i+3])
      if (four.in.a.row(player, v)) {
        return(TRUE)
      }
    }
  }
  
  for (i in 0:3) {
    if (r+i <= rows & c-i >= 1 & r+i-3 >= 1 & c-i+3 <= cols){
      v = c(board[r+i,c-i],board[r+i-1,c-i+1],board[r+i-2,c-i+2],board[r+i-3,c-i+3])
      if (four.in.a.row(player, v)) {
        return(TRUE)
      }
    }
  }
  
  return(FALSE) # correct this return() statement
}

# Returns largest index of an empty position in column col
# of (matrix) board. If there is no such empty position in
# board, return value is NULL.
largest.empty.row = function(board, col, debug=FALSE) {
  if (debug) {
    cat(sep="", "largest.empty.row(board=\n")
    cat(sep="", ", col=", col, ")\n")
  }
  
  for (row in nrow(board):1) {
    if (board[row, col] == "") {
      return(row)
    }
  }
  
  return(NULL)
}

source("HW2test.R") # Run tests on the functions above.

# ... your code to implement Connect Four using the
# functions above ...


rm(list = ls()) # initialization


won = function(vec, player, debug = FALSE) {
  
  stopifnot(player %in% c("X", "O"))
  stopifnot(board %in% c(" ", "X", "O"))
  stopifnot(dim(board)[1] == 6, dim(board)[2] == 7)
  
  if (debug) { 
    cat(sep = "", "player = ", player, ", vector = ", "\n") 
  }
  
  player.index = which(vec == player) 
  win = FALSE
  if (length(player.index) > 0) {
    player.valid.index = player.index[player.index+4-1 <= length(vec)]
    for (i in player.valid.index) { 
      if (all(vec[i:(i+4-1)] == player)) { 
        win = TRUE; break
      }
    }
  } 
  return(win)
  
}

safe.sample = function(x, ...) x[sample.int(length(x), ...)]

x = rep(1:7, each = 6)  # x-coordinates;
y = rep(1:6, times = 7) # y-coordinates; 

if (.Platform$OS.type == "windows") windows() 

plot(x, y, type = "n",                          
     xlab = "",                                  
     xlim = c(0, 8), ylim = c(7, 0), xaxt = "n")
axis(3, 0:8)                                         
mtext(text = "x", side = 3, line = 2.5)   


segments(x0 = c(0.5, 0.5, 0.5, 0.5, 0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5), 
         y0 = c(1.5, 2.5, 3.5, 4.5, 5.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
         x1 = c(7.5, 7.5, 7.5, 7.5, 7.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5), 
         y1 = c(1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 6.5, 6.5, 6.5, 6.5, 6.5))  

board = matrix(data = rep(" ", times = 42), nrow = 6, ncol = 7)
player = "X"
winner = " "


for (i in 1:42) {
  if (player == "X"){
    repeat { 
      index = identify(x, y, n = 1, tolerance = 1, plot = FALSE)
      col = x[index] 
      row = 6
      while (board[row, col] != ' '){
        row = row - 1
        if(row == 0) {
          break
        }
      }
      if (row > 0) { 
        rect(1, 3.55, 3, 4, col = par("bg"), border = par("bg")) 
        break 
      } else {
        text(x = 4, y = 7, labels = "Do not add elements to an already full column", col = "red") 
      }
    }
  } else{
    
    index = safe.sample(x = which(c(board) == " "), size = 1)
    #A function that tries to block the opponent's connection    
    for (j in 1:42){
      
      board_c = board
      
      s = x[j]
      t = 6
      while (board_c[t, s] != ' '){
        t = t - 1
        if(t == 0) {
          break
        }
      }
      board_c[t,s] = 'X'
      
      vec1 = board_c[t,]
      vec2 = board_c[,s]
      vec3 = board_c[col(board_c) - row(board_c) == s - t]
      vec4 = board_c[col(board_c) + row(board_c) == s + t]
      
      flag = FALSE
      
      if ((won(vec1, 'X', debug = FALSE))|(won(vec2, 'X', debug = FALSE))|
          (won(vec3, 'X', debug = FALSE))|(won(vec4, 'X', debug = FALSE))){
        index = j
        flag = TRUE
        break
      }
      if (flag) {
        break  
      }
    }
    
    col = x[index] 
    row = 6
    while (board[row, col] != ' '){
      row = row - 1
      if(row == 0) {
        break
      }
    }
  }
  
  board[row, col] = player
  text(x = col, y = row, labels = player)
  
  #for debug
  cat(sep = "", "i = ", i, ", player = ", player, ", index = ", index,
      ", row = ", row, ", col = ", col, ", board:", "\n")
#  print(board) 
  
  vec1 = board[row,]
  vec2 = board[,col]
  vec3 = board[col(board) - row(board) == col - row]
  vec4 = board[col(board) + row(board) == col + row]
  
  #  print(vec3)
  #  print(vec4)
  
  if (won(vec1, player, debug = FALSE)) { 
    winner = player
    break
  }
  if (won(vec2, player, debug = FALSE)) { 
    winner = player
    break
  }
  if (won(vec3, player, debug = FALSE)) {
    winner = player
    break
  }
  if (won(vec4, player, debug = FALSE)) { 
    winner = player
    break
  }
  
  player = ifelse(test = (player == "X"), yes = "O", no = "X") 
}

announcement = ifelse(winner == " ", "Draw!", paste(winner, " won!"))
text(x = 4, y = 1/5, labels = announcement, col = "red")

invisible(readline(prompt="Press [enter] to proceed")) 
if (.Platform$OS.type == "windows") {
  while (!is.null(dev.list()))  dev.off()
} # close the Windows graphics device(different from tic-tac-toe code, but this works better)



# Hint: this program is modeled on the tic-tac-toe program we did in
# lecture, so studying the latter program is worthwhile.

# Note that a user click in a column indicates that a checker should
# go to that column's lowest empty row (unless the column is full).

# Note that you should implement a computer player. At the least, it
# should choose randomly from among the non-full columns. (Feel free
# to do much more!)
