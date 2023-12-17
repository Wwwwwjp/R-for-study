# Goal: to improve the bottleneck further for speeding up a program after profiling. 
# Please refer to NFL web scraping in STAT304 with STAT304.Web_Scraping.R.

# General idea:
#   Multicore programming for embarrasslingly parallel problems (see its definition and examples on the handout).
#   It is like a group practice and every core in CPU is a group member.

# Procedure: still focus on the bottleneck!
#   Step 1. If you use the loop, define a new function based on the loop body.
#   Step 2. Replace the loop with apply functions. It's usually easy for embrassingly parallel problems.
#   Step 3. Replace the apply functions with multicore apply function.

rm(list = ls()) #initialization

if (!require("XML")) {
  install.packages("XML")
  stopifnot(require("XML"))
}

if (!require("curl")) {
  install.packages("curl") # do this once per lifetime
  stopifnot(require("curl")) # do this once per session
}

if (!require("parallel")) { # for multicore computing functions
  install.packages("parallel")
  stopifnot(require("parallel"))
}

#############################Web Scraping###########################
#install & load package XML for readHTMLTable(), reading some tables in a webpage

# Multicore programming step 1: Define a new function based on the loop body
get.yards = function(team.stat.link, table.index1, table.index2) {
  
  # Optional code for multicore programming for Windows PC:
  #   Loading XML inside the definition of get.yards().
  #
  # if (!require("XML")) { 
  #   install.packages("XML")
  #   stopifnot(require("XML"))
  # }
  #
  # Otherwise, readHTMLTable() is not available for all the processes of multicore programmings below.
  
  # Alternative way is to use:
  #   clusterEvalQ(cl = cluster, expr = require("XML"))
  # before using the multicore apply functions on Windows PC. (see below)

  print(team.stat.link)
  cat("index =", table.index1, table.index2, "\n")
  
  tables = readHTMLTable(readLines(curl(team.stat.link)), stringsAsFactors = FALSE, which = c(table.index1, table.index2))
  # tables = readHTMLTable(link, skip.rows = 1, colClasses = c("character", rep("numeric", 5)), which = c(3, 4))  

  rushing = max(as.numeric(as.character(tables[[1]]$YDS)))
  receiving = max(as.numeric(as.character(tables[[2]]$YDS)))  
  
  return(c(rushing, receiving))
}

# compare with the original loop incl. the bottleneck.
#
# for (i in 1:n.teams) {
#   # assemble a link like
#   # https://www.packers.com/team/stats/
#   link = paste0(team.links[i], "/team/stats/")
#   
#   # choose which two of the tables to load
#   table.index = c(8, 9)
#   if (i == 12) {table.index = c(7, 8)}
#   if (i == 7 ||i == 19 || i == 26) {table.index = c(2, 3)}
#   cat("table.index =", table.index, "\n")
#   
#   tables = readHTMLTable(readLines(curl(link)), stringsAsFactors = FALSE, which = table.index) # load ONLY two tables from the link, instead of all the tables, to speed up
#   
#   
#   # tables = readHTMLTable(link, colClasses = c("character", rep("numeric", 5)), which = c(3, 4)) # new parameters help read the 3rd & 4th tables from the webpage
#   # check str(tables) to know its structure, which leads to the following code:
#   
#   rushing[i] = max(as.numeric(as.character(tables[[1]]$YDS)))
#   receiving[i] = max(as.numeric(as.character(tables[[2]]$YDS)))
# }




# Step 1. Get a list including all teams' names and links.

TEAMS = "https://www.nfl.com/teams/"

lines = readLines(TEAMS)
team.info = grep(pattern="Full Site\" data-link_url=", x=lines, value=TRUE)

link.lines = unlist(strsplit(x = team.info, split = "Full")) 
team.link.lines = grep(pattern="Site\" data-link_url=", x=link.lines, value=TRUE)
team.links = sub(pattern=".*data-link_url=\"(.*.com)/\" class=.*", replacement="\\1/team/stats/", x=team.link.lines)

# rushing & receiving.index from the output of nflProfile1.R
receiving.index = scan(file = "NFLReceivingIndex.txt", what = integer())
rushing.index   = scan(file = "NFLRusingIndex.txt"   , what = integer())



#Step 2. Using team.names and team.abbreviations, assemble the links to collect some data for each team.

#initialization
n.teams = length(team.links)
rushing = numeric(n.teams)
receiving = numeric(n.teams)

# Multicore programming step 2: 
#   go to each team's website to find the tables including rushing and receiving
#   by apply functions, instead of for loop

# or equivalently, multiple lists => mapply()
print(system.time(l1 <- mapply(FUN = get.yards, team.links, rushing.index, receiving.index)))
dimnames(l1) = list(c("rushing", "receiving"),
                    NULL)
str(l1)
print(l1)


# Multicore programming step 3: Replace the apply functions with multicore apply function.
#
# Note: It depends on your computer platform: Windows PC vs Mac or Linux.
#       A branch shown below can be used to handle all the cases.

# multiple lists => multicore mapply()

n.cores = detectCores() # How many cores does the CPU of your computer have?

if (.Platform$OS.type == "windows") { 
  
  # on Windows PC
  cluster = makePSOCKcluster(names = n.cores)
  
  clusterEvalQ(cl = cluster, expr = {require("XML"); require("curl")}) 
  # Run the setup code:
  #   require("XML") & require("curl"), on each cluster node/process, which, in Windows, 
  #   has a fresh R session; otherwise, readHTMLTable() is unavailable.
  #
  # clusterEvalQ() can be skipped as long as require("XML") & require("curl")
  # in the definition of get.yards(). See above.
  
  cat(sep = "", "Timing clusterMap(), ", n.cores, " cores ...")
  print(system.time(l <- clusterMap(cl = cluster, fun = get.yards, team.links, rushing.index, receiving.index)))
  stopCluster(cl = cluster)
  
} else { 
  
  # easier on Mac or Linux.
  cat(sep = "", "Timing mcmapply(), ", n.cores, " cores ...")
  print(system.time(l <- mcmapply(FUN = get.yards, team.links, rushing.index, receiving.index, mc.cores = n.cores)))
}


#Step 3. Further data analysis: linear regression (rushing vs receiving for all teams)
m = matrix(data = unlist(l), nrow = 2, ncol = 32)
best.rushing = m[1, ]
best.receiving = m[2, ]
print(best.rushing)
print(best.receiving)

plot(x = best.rushing, y = best.receiving)
abline(lm(best.receiving ~ best.rushing))
cor(best.rushing, best.receiving)



# Conclusion:
#
# Multicore programming is quite effective for web scraping since it is embrassingly parallel.
# It can be verified by comparing the running time with the old ones.
# The code depends on platforms currently. Please includes both ways in a branch to make the code platform-independent.
# Using multicore m/l/sapply depends on the number of the changing parameters. 