# Goal: to improve the bottleneck for speeding up a program after profiling. 
# Please refer to NFL web scraping in STAT304 with STAT304.Web_Scraping.R.

# General idea:
#   In Line #71, readHTMLTable(link) reads all the tables from the given webpage unnecessarily.
#   Actually, Only the 8th (rushing) and 9th table (receiving) is needed for most teams (except for No. 7, 12, 19, 26) in our current project.
#   This can be checked by the outcome of Line 81.
#   After checking ?readHTMLTable, it can be done with extra parameters, like which = c(8, 9) and others.
#   So, just change Lines 71~84.



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
Rprof(line.profiling = TRUE)                               # <==================================
# ----- turn profiling on -----




# Step 1. Get a list including all teams' names and links.

TEAMS = "https://www.nfl.com/teams/"

lines = readLines(TEAMS)
team.info = grep(pattern="Full Site\" data-link_url=", x=lines, value=TRUE)

link.lines = unlist(strsplit(x = team.info, split = "Full")) 
team.link.lines = grep(pattern="Site\" data-link_url=", x=link.lines, value=TRUE)
team.links = sub(pattern=".*data-link_url=\"(.*.com)/\" class=.*", replacement="\\1", x=team.link.lines)

n.teams = length(team.links)
rushing = numeric(n.teams) # 32 zeros
receiving = numeric(n.teams)

# rushing & receiving.index from the output of nflProfile1.R
receiving.index = scan(file = "NFLReceivingIndex.txt", what = integer())
rushing.index   = scan(file = "NFLRusingIndex.txt"   , what = integer())


for (i in 1:n.teams) {
  # assemble a link like
  # https://www.packers.com/team/stats/
  link = paste0(team.links[i], "/team/stats/")
  
  # choose which two of the tables to load
  table.index = c(rushing.index[i], receiving.index[i])
  
  tables = readHTMLTable(readLines(curl(link)), stringsAsFactors = FALSE, which = table.index) # load ONLY two tables from the link, instead of all the tables, to speed up
  
  
  # tables = readHTMLTable(link, colClasses = c("character", rep("numeric", 5)), which = c(3, 4)) # new parameters help read the 3rd & 4th tables from the webpage
  # check str(tables) to know its structure, which leads to the following code:
  
  rushing[i] = max(as.numeric(as.character(tables[[1]]$YDS)))
  receiving[i] = max(as.numeric(as.character(tables[[2]]$YDS)))
  
  cat(sep="", "i=", i, ", rushing=", rushing[i], ", receiving=", receiving[i], "\n")
  cat(sep="", "  link=", link, "\n")
}




# ----- turn profiling off -----
Rprof(NULL)                                                # <==================================
# ----- turn profiling off -----




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
# The bottle neck has been improved.
# It can be verified by comparing the new log file with the old one.



# run the code by source(file = "day6.4.nflProfile2.R", keep.source = TRUE)
# or click Source button on the upper-right corner of the editor.