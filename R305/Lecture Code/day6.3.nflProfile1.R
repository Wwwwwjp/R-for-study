# Goal: to find the bottleneck for speeding up a program by profiling. 
# Please refer to NFL web scraping in STAT304.

# General procedure:
#   Add Rprof(filename = "Rprof.out", line.profiling = TRUE) to myScript.R to turn on line profiling:
#     every interval= .02 seconds, R will record in filename which code line is running. See lines with # <============= Insert Switch
#   Add Rprof(NULL) to myScript.R to turn profiling off. See lines with # <============= Insert Switch
#   Run myScript.R via source(file = "myScript.R", keep.source = TRUE). 
#   Run summaryRprof(filename = "Rprof.out", lines = "show") on the profiling output.


 
# This program is copied from NFL web scraping code in STAT304, except the lines mentioned above

# Write a program in several steps to graph the pairs
#   (best rusher's yardage, best receiver's yardage)
# across the 32 NFL teams.
# 
# 1. Start by reading a single team's statistics page.
# 2. Start again by getting the link's team part
#    (e.g. "www.packers.com" and "Green Bay Packers") for each of the 32 teams.
# 3. Combine (1) and (2), enclosing (1) in a loop.
# 4. Add scatterplot of (x=rushing, y=receiving) with regression line.

rm(list=ls())

if (!require("XML")) { # for readHTMLTable()
  install.packages("XML")
  stopifnot(require("XML"))
}

if (!require("curl")) {
  install.packages("curl") # do this once per lifetime
  stopifnot(require("curl")) # do this once per session
}



# ----- turn profiling on -----
Rprof(line.profiling = TRUE)                               # <============= Insert Switch
# ----- turn profiling on -----



TEAMS = "https://www.nfl.com/teams/"

lines = readLines(TEAMS)
team.info = grep(pattern="Full Site\" data-link_url=", x=lines, value=TRUE)

link.lines = unlist(strsplit(x = team.info, split = "Full")) 
team.link.lines = grep(pattern="Site\" data-link_url=", x=link.lines, value=TRUE)
team.links = sub(pattern=".*data-link_url=\"(.*.com)/\" class=.*", replacement="\\1", x=team.link.lines)

# Get best rusher's yardage and best receiver's yardage for each team.
n.teams = length(team.links)
rushing = numeric(n.teams) # 32 zeros
receiving = numeric(n.teams)
rushing.index = integer(n.teams)
receiving.index = integer(n.teams)


for (i in 1:n.teams) { # all the 32 teams now
  # assemble a link like
  # https://www.packers.com/team/stats/
  link = paste0(team.links[i], "/team/stats/")
  tables = readHTMLTable(readLines(curl(link)), stringsAsFactors = FALSE) # <============= Bottle Neck
  
  tables.dim = c()
  for (j in 1:length(tables)){
    tab.dim = dim(tables[[j]])[2]
    real.dim = ifelse(is.null(tab.dim), yes = 0, no = tab.dim)
    tables.dim = c(tables.dim, real.dim)
  }
  
  rushing.index[i] = which(tables.dim == 6)[1]
  receiving.index[i] = which(tables.dim == 6)[2]
  
  
  rushing[i] = max(as.numeric(tables[[rushing.index[i]]]$YDS))
  receiving[i] = max(as.numeric(tables[[receiving.index[i]]]$YDS))
  cat(sep="", "i=", i, ", rushing=", rushing[i], ", receiving=", receiving[i], "\n")
  cat(sep="", " link=", link, " (rushing.index, receiving index) = (", receiving.index[i], ", ", rushing.index[i], ")\n") 
}



# ----- turn profiling off -----
Rprof(NULL)                                                # <============= Insert Switch
# ----- turn profiling off -----

# save receiving and rush indices for the future use
write(receiving.index, file = "NFLReceivingIndex.txt")
write(rushing.index, file = "NFLRusingIndex.txt")



plot(x=rushing, y=receiving, xlim=c(0, max(rushing)), ylim=c(0, max(receiving)))
m = lm(receiving ~ rushing)
abline(m)
print(summary(m))



# ----- read the log file -----
su = summaryRprof(filename = "Rprof.out", lines = "show")  # <===================================
su$by.total
# ----- read the log file -----



# Conclusion:
#
# The bottleneck is found clearly.
# It can be verified by the facts: it is involved with network I/O and is in a loop.



# run the code by source(file = "day6.3.nflProfile1.R", keep.source = TRUE)
# or click Source button on the upper-right corner of the editor.