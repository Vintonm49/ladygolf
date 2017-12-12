install.packages("rvest")
library(rvest)

lpga <- html("http://www.lpga.com/tournaments/")
tourn <- html_nodes(lpga, ".tournament-title")
tourn <- html_text(tourn)
month <- html_nodes(lpga, ".month")
month <- html_text(month)
day <- html_nodes(lpga,".day")
day <- html_text(day)
dates <- as.data.frame(day)
dates2 <- as.data.frame(month)
dates <- cbind(dates2, dates)
dates <- dates[1:34,]
tourn2 <- as.data.frame(tourn)
tourn2 <- cbind(tourn2, dates)
winner <- html_nodes(lpga,"figcaption")
winner <- html_text(winner)
winner <- as.data.frame(winner)
winner <- winner[3:36,]
winner <- as.data.frame(winner)
tourn2 <- cbind(tourn2, winner)

info <- html_nodes(lpga,".tournament-info")
info <- html_text(info)
info2 <- as.data.frame(info)

# fix strings
info_fix <- gsub("[\r\n]", "", info)
info_fix <- gsub("[\t]", ";", info_fix)
info_fix <- gsub("  ", "", info_fix)
location <- sapply(strsplit(info_fix,";"), `[`, 1)
location <- location[1:34]
location <- as.data.frame(location)

tourn2 <- cbind(tourn2, location)
colnames(tourn2)[5]<- "location"
tourn2$winner <- gsub("[\r\n\t]","",tourn2$winner)  #fix winner strings
tourn2$winner <- gsub("  ","",tourn2$winner)

#geocode
library(ggmap)
tourn2$location <- as.character(tourn2$location)
latlon<- geocode(tourn2$location)
tourn2 <- cbind(tourn2, latlon)

library(leaflet)
#install.packages("leaflet")
leaflet(data = tourn2) %>% addTiles() %>% 
  setView(lng = tourn2$lon[1], lat = tourn2$lat[1], zoom = 6) %>%
  addMarkers(lat = ~lat, lng = ~lon, popup=~as.character(tourn))
