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

# Get names and links (e.g. "www.packers.com" and "Green Bay Packers") for each team.
TEAMS = "https://www.nfl.com/teams/"
# (With browser, view page source (HTML) for TEAMS page, search for
# "www.packers.com", note "data-link_url".)

lines = readLines(TEAMS) # thousands of lines of HTML
lines = lines[3365:3787] # truncate
team.link.lines = grep(pattern="data-link_url=", x=lines, value=TRUE) # 32 team link lines,
team.name.lines = grep(pattern="data-link_name=", x=lines, value=TRUE) # 32 team name lines,
team.links = sub(pattern=".*data-link_url=\"(.*.com).*", replacement="\\1", x=team.link.lines)
team.names = sub(pattern=".*data-link_name=\"(.*)\".*", replacement="\\1", x=team.name.lines)

# Get best rusher's yardage and best receiver's yardage for each team.
n.teams = length(team.links)
rushing = numeric(n.teams) # 32 zeros
receiving = numeric(n.teams)
for (i in 1:n.teams) {
  # assemble a link like
  # https://www.packers.com/team/stats/
  link = paste0(team.links[i], "/team/stats/")
  tables = readHTMLTable(readLines(curl(link)), stringsAsFactors = FALSE)
  
  # read the dimensions (# of columns) of each table
  tables.dim = c()
  for (j in 1:length(tables)){
    tables.dim = c(tables.dim, dim(tables[[j]])[2])
  }
  
  rushing.index = which(tables.dim == 6)[1] # the 1st table with 6 columns
  receiving.index = which(tables.dim == 6)[2] # the 2nd table with 6 columns
  
  rushing[i] = max(as.numeric(tables[[rushing.index]]$YDS))
  receiving[i] = max(as.numeric(tables[[receiving.index]]$YDS))
  cat(sep="", "i=", i, ", team.names[", i, "]=", team.names[i], ", rushing=", rushing[i], ", receiving=", receiving[i], "\n")
  cat(sep="", "  link=", link, "\n")
}


plot(x=rushing, y=receiving, xlim=c(0, max(rushing)), ylim=c(0, max(receiving)))
m = lm(receiving ~ rushing)
abline(m)
print(summary(m))
