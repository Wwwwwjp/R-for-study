# Write a program in several steps to graph the pairs
#   (best rusher's yardage, best receiver's yardage)
# across the 32 NFL teams.
# 
# 1. Start by reading a single team's statistics page.
# 2. Get the team links
#    (e.g. "www.packers.com" for "Green Bay Packers") for each NFL team.

rm(list = ls())

if (!require("rvest")) { # the best R web scraping package I've found so far, and the part of tidyverse
  install.packages("rvest") # do this once per lifetime
  stopifnot(require("rvest")) # do this once per session 
}

TEAMS = "https://www.nfl.com/teams/" # hub web page including all the links somewhere
# To get the above link, start with https://www.nfl.com/ > "Teams" in Navigation Bar

# find all the team links by right-clicking the link "VIEW PROFILE" of any team > Inspect, similar to finding all the tables in nfl
link.class = ".d3-o-media-object__link.d3-o-button.nfl-o-cta.nfl-o-cta--primary" 
# the original class name "d3-o-media-object__link d3-o-button nfl-o-cta nfl-o-cta--primary" has " " inside, meaning AND
# when you use it in the following line, " " is replaced by "." plus a starting "." (see above and below).

team.links = TEAMS %>% read_html() %>% html_elements(link.class) %>% html_attr("href") # html_attr("href") extracts any links
team.links # exactly 64 links. Half of them are good.
(team.links = team.links[seq(2, 64, 2)]) # exactly 32 good links for each NFL team after this trimming

# or, equivalently, using %>% for everything,
# links = url %>% read_html() %>% html_elements(link.class) %>% html_attr("href") %>% .[seq(2, 64, 2)]

# The remaining code is optional, only for advanced students
# we get all the team names in a similar way. Good for debugging.
name.class = ".d3-o-media-object__body.nfl-c-custom-promo__body" # " " => "." meaning AND
team.names = TEAMS %>% read_html() %>% html_elements(name.class) %>% html_text2() %>%
  gsub(pattern = "(.*)\\n\\n.*", replacement = "\\1", x = .) # "." means the argument passed from the front part
team.names # 32 NFL team names

for (i in 1:32) cat(sep = "\t", team.names[i], team.links[i], "\n") 
# The team links match the team names perfectly.