rm(list = ls())

if (!require("XML")) {
  install.packages("XML") # do this once per lifetime
  stopifnot(require("XML")) # do this once per session
}
if (!require("curl")) {
  install.packages("curl") # do this once per lifetime
  stopifnot(require("curl")) # do this once per session
}

if (!require("rvest")) {
  install.packages("rvest") # do this once per lifetime
  stopifnot(require("rvest")) # do this once per session
}


movie <- "https://www.imdb.com/chart/top"
movie.class = ".ipc-title-link-wrapper"
movie.links = movie %>% read_html() %>% html_elements(movie.class) %>% html_attr("href")
movie.links = movie.links[-251:-257]
movie.links = paste("https://www.imdb.com", movie.links, sep = "")  

producers = list()

movie.fullcredits = sub(pattern = "(.*)[?].*", replacement = "\\1", x = movie.links)
movie.fullcredits = paste(movie.fullcredits, "fullcredits", sep = "")

movie.titleclass = ".ipc-title__text"
movie.titles = movie %>% read_html() %>% html_elements(movie.titleclass) %>% html_text2()
movie.titles = movie.titles[c(-1, -2, -253:-264)]
movie.titles = sub(pattern = "(\\d+). (\\w+)", replacement = "\\2", x = movie.titles)  #movie titles

for (i in 1:250){
  
  subnames = movie.fullcredits[i] %>% read_html() %>% html_elements(".dataHeaderWithBorder") %>% html_text2()
  table = movie.fullcredits[i] %>% read_html() %>% 
    html_elements(".simpleTable.simpleCreditsTable") %>% html_table()
  if ("Produced by " %in% subnames) {
    producer = unlist(table[[3]][, 1], use.names = FALSE)
  } else{
    producer = NA
  }
  producers[[movie.titles[i]]] = producer
}

producers.table = table(unlist(producers))
order.table = order(producers.table, decreasing = TRUE)
top5order = order.table[1:5]
print(names(producers.table)[top5order])
