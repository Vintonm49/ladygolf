###  Analysis of scraped LPGA data
## Melanie Vinton
## Working file for analysis ideas

######### Regression #############
# Dependent variable is Rank_Money

money_predictors <- select(stats_byname, -c(Official_Money,Name, Aces, Rank_RoY, RoY_Points, Rank_Holes_in_One, Rank_Solheim_Cup, Solheim_Cup_Points))
money_model <- lm(Rank_Money ~ ., money_predictors, na.action = na.omit)
summary(money_model)



########  Geospatial ###########
# map points

us <- qmap("USA", zoom = 3)
us + geom_point(data = tourn, aes(x= lon, y = lat))

us + stat_density2d(data = tourn, aes(x=lon, y = lat, fill = ..level.., alpha = ..level..), 
                    geom = "polygon", show.legend = FALSE)

world_map <- map_data("world")
ggplot()+geom_polygon(data=world_map, aes(x=long,y=lat, group=group),
                      fill="White",colour="black")+
  labs(x="", y="", title="LPGA Events")+ #labels
  theme(axis.ticks.y = element_blank(),axis.text.y = element_blank(), # get rid of x ticks/text
        axis.ticks.x = element_blank(),axis.text.x = element_blank())+ # get rid of y ticks/text
  geom_point(data=tourn,aes(x=lon,y=lat, color = Purse), size = 2)+
  scale_color_gradient2(midpoint = 3000000, low = "red", high = "forest green")
