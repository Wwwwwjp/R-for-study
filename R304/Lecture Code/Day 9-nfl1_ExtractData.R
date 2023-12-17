# Write a program in several steps to graph the pairs
#   (best rusher's yardage, best receiver's yardage)
# across the 32 NFL teams.
# 
# 1. Start by reading a single team's statistics page.

rm(list = ls())

if (!require("rvest")) { # the best R web scraping package I've found so far, and the part of tidyverse
  install.packages("rvest") # do this once per lifetime
  stopifnot(require("rvest")) # do this once per session 
}

# You need to know some basics about HTML first. Please check these links for more details:
# https://r4ds.hadley.nz/webscraping.html#html-basics,
# https://jtr13.github.io/cc19/web-scraping-using-rvest.html#html-basics,
# and https://dcl-wrangle.stanford.edu/rvest.html#web-page-basics


link = "https://www.packers.com/team/stats/" # each team's stat webpage
# To get this link, you need to do some explorations from https://www.nfl.com/.

# There is no standard way for it.
# My tip is to check its navigation bar on the top, especially Teams and Stats. 
# This requires your good searching skills.
# My exploration path to get the link above is: 
#   "Teams" in Navigation Bar -> Any Team's "VIEW PROFILE" 
#   -> "STATS" in Navigation Bar -> "VIEW ALL TEAM STATS" on the bottom
# Then, try a little more teams to find the pattern of the links, 
# "https://www.packers.com/"(should be obtained from a list discussed in nfl2)+"team/stats/" (fixed tail)

# This is not the unique way. You might collect information from stats 
# in nav bar -> Team Stats -> Rushing/Receiving
# If any student can do it in a different way successfully, please let me know to earn some bonus.

table.class = ".nfl-o-teamstats" 
# Q: How to get this information?
# A: I use Chrome for demo. You could google the corresponding operations for other browser. 
#    Actually, they are similar.

#    The key is:
#    1. go through the webpage: https://www.packers.com/team/stats/
#    2. find the tables with the titles you are interested in, like "Rushing" or "Receiving"
#    3. select the table title "Rushing", right-click it, and choose "Inspect"
#    4. move the cursor around (up/down a little) the corresponding highlighted HTML code 
#       on the right web development panel > Elements
#    5. find the line: <div class="nfl-o-teamstats">, which highlights the corresponding elements 
#       on the webpage: a table including the title "Rushing" and its contents
#    6. copy the class name from this line by right-clicking the line > Edit attribute
#    7. Note: The class name must start with ".". Don't forget it.
#    8. Note: Since the commercial website like nfl.com is always changing, 
#             table.class might be different over the time.

tables = link %>% read_html() %>% html_elements(table.class) %>% html_table() 
# choose this type of elements by its class name, then get the tables
# %>% is a very convenient composition operator from rvest
# object %>% f() is equivalent to f(object)

# Get a list of data frames corresponding to the HTML tables.
str(tables) # explore its structure by str(), a very important trick
# Its type is called "tibble" in rvest or tidyverse, 
# which can be treated as "data.frame" in this course.
# See more discussions at https://jtr13.github.io/cc21fall1/tibble-vs.-dataframe.html

tables[[2]] # 2nd & 3rd table for Packers. Compare them with the web page
tables[[3]]
# It looks like we just need to choose the 2nd and 3rd table for the rushing and receiving table.
# Is it true for all the other teams???

# Repeat the above process for another team: Arizona Cardinals at https://www.azcardinals.com/team/stats/
# I give you the code below, but I hope you try all the mouse operation on your own to get better understanding.
link = "https://www.azcardinals.com/team/stats/"
table.class = ".nfl-o-teamstats"
tables = link %>% read_html() %>% html_elements(table.class) %>% html_table()
str(tables)
tables[[2]] # Compare them with the web page
tables[[3]]
# Yes. It is also true for Arizona Cardinals.

# Please try two more teams in the same way to confirm it by yourself.
# This rule is simple and looks good. 
# I even verify it with all the 32 teams in nfl4 
# when I write this version of the code for the NFL web scraping.
# If you are a beginner for web scraping, it is OK. You can do your HW in this naive way.



# But as a mature web scraper, I don't like it. Why???!!!

# Because each team has the different web administrator, 
# they should use the same NFL template to create each team stat webpage 
# (so, the above code to find all the tables for each team stat webpage should be OK).
# However, they might mess up the order of the table (In HW3, we'll encounter some exceptions!).
# You can check the Arizona Cardinals and Green Bay Packers' webpages more carefully. 
# Their layouts are different. Cardinals has "Top Offense" and "Top Defense" before "TEAM STATISTICS".
# It might cause some potential trouble.

# Moreover, each table is clearly bound with its title, 
# which should not be messed up easily by a sloppy admin over the time.
# So, I prefer using the associated title to specify the table.
# This rule is much stabler and more robust, without any potential mismatch.
# In this lecture, I will follow this stable way.

# find all the table titles by right-clicking the title > Inspect, similar to finding all the tables above
title.class = ".nfl-o-teamstats__title"
table.titles = link %>% read_html() %>% html_elements(title.class) %>% html_text2() # by class name again
table.titles # printout for debugging

rushing.index = which(table.titles == "Rushing") # get the rushing index by the table title
receiving.index = which(table.titles == "Receiving") # get the receiving index by the table title
# for the beginner, simply use the observed fixed indices:
# rushing.index = 2 
# receiving.index = 3

# Checking these indices for data integrity: 
# only the 2nd and 3rd tables are what are needed
stopifnot(length(rushing.index) == 1, rushing.index == 2, 
          length(receiving.index) == 1, receiving.index == 3)

rushing.yds = tables[[rushing.index]]$YDS

str(rushing.yds) 
# Always check its type by str(). Its type is integer. 
# Good. We don't need to do any conversion.
# But watch out! It might not always in a decreasing order. We need sorting it or using max().

# So, the best rushing yardage is
rushing = max(tables[[rushing.index]]$YDS)

# Similarly (please do it on your own), the best receiver's season yardage is:
receiving = max(tables[[receiving.index]]$YDS)

cat(sep = "", "rushing = ", rushing, ", receiving = ", receiving, "\n")
# Verify them with the web page. Don't forget to sort the column YDS first.