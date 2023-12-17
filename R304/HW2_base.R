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
  print(board) 
  
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

