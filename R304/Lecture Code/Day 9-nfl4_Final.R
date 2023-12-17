# Write a program in several steps to graph the pairs
#   (best rusher's yardage, best receiver's yardage)
# across the 32 NFL teams.
# 
# 1. Start by reading a single team's statistics page.
# 2. Get the team links for each NFL team.
# 3. Combine (1) and (2), enclosing (1) in a loop.
# 4. Add scatterplot of (x=rushing, y=receiving) with regression line.

rm(list = ls())

if (!require("rvest")) {
  install.packages("rvest")
  stopifnot(require("rvest"))
}

######################################## extracted from nfl3 ########################################
TEAMS = "https://www.nfl.com/teams/" # hub web page

# team links
link.class = ".d3-o-media-object__link.d3-o-button.nfl-o-cta.nfl-o-cta--primary" 
team.links = TEAMS %>% read_html() %>% html_elements(link.class) %>% html_attr("href") %>% .[seq(2, 64, 2)]

# optional team names
name.class = ".d3-o-media-object__body.nfl-c-custom-promo__body"
team.names = TEAMS %>% read_html() %>% html_elements(name.class) %>% html_text2() %>%
  gsub(pattern = "(.*)\\n\\n.*", replacement = "\\1", x = .)


n.teams = length(team.links) # 32
rushing = numeric(n.teams)
receiving = numeric(n.teams)

for (i in 1:n.teams) { # all the 32 teams now
  # assemble a team stat link from its team link
  # e.g. "https://www.packers.com/" => "https://www.packers.com/team/stats/
  team.stat.link = paste0(team.links[i], "team/stats/")
  
  table.class = ".nfl-o-teamstats"
  tables = team.stat.link %>% read_html() %>% html_elements(table.class) %>% html_table()
  
  title.class = ".nfl-o-teamstats__title"
  table.titles = team.stat.link %>% read_html() %>% html_elements(title.class) %>% html_text2()
  
  rushing.index = which(table.titles == "Rushing")
  receiving.index = which(table.titles == "Receiving")
  stopifnot(length(rushing.index) == 1, rushing.index == 2, # checking data integrity
            length(receiving.index) == 1, receiving.index == 3)
  
  rushing[i] = max(tables[[rushing.index]]$YDS)
  receiving[i] = max(tables[[receiving.index]]$YDS)

  cat(sep = "", "i = ", i, ", team.names[", i, "] = ", team.names[i], ", rushing = ", rushing[i], ", receiving = ", receiving[i], "\n")
  cat(sep = "", "  link = ", team.stat.link, "\n") # check the printouts with the actual web pages
}
####################################### extracted from nfl3 #######################################

# All the data is collected. But the loading is kind of slow (from 32 web pages).
# We will continue to discuss and improve its performance in STAT305.


# Data Analysis
plot(x = rushing, y = receiving, xlim = c(0, max(rushing)), ylim = c(0, max(receiving)))
m = lm(receiving ~ rushing)
abline(m)
print(summary(m))