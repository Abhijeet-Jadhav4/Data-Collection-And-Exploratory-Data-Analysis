install.packages("data.table", dependencies=TRUE)
require(data.table)
library(maps)
library(ggplot2)
citation("ggmap")
library("maptools")
gpclibPermit()
library("maps")
library("ggmap")
register_google(key = " ") 
library('revgeo')
library(twitteR)
library(mapproj)
library(fiftystater)
library(plyr)
library(dplyr)

consumer_key <- ''
consumer_secret <- ''
access_token <- ''
access_secret <- ''
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

fifty_states$group <- ifelse(fifty_states$group == "Alabama.1", 1, fifty_states$group)

flufevertweet.tweets = searchTwitter("high fever sick",n=5000)
fluvaccinetweet.tweets = searchTwitter("flu vaccine",n=1000)
flutweet.tweets = searchTwitter("flu",n=2000)
flushottweet.tweets = searchTwitter("flushot",n=1500)
influenzatweet.tweets = searchTwitter("influenza",n=5000)

flutweet.df <-twListToDF(flutweet.tweets)
flutweet.df <- flutweet.df[(flutweet.df$isRetweet) != 'TRUE',]
flutweet.df <- unique(flutweet.df)

#all.df <- twListToDF(c(flutweet.tweets,flushottweet.tweets,influenzatweet.tweets,flufevertweet.tweets))
#all.df <- allTweets.df[(all.df$isRetweet) != 'TRUE',]
#all.df <- unique(all.df)

#influenzaflufevertweet.df <- twListToDF(c(influenzatweet.tweets,flufevertweet.tweets))
#influenzaflufevertweet.df <- influenzaflufevertweet.df[(influenzaflufevertweet.df$isRetweet) != 'TRUE',]
#influenzaflufevertweet.df <- unique(influenzaflufevertweet.df)

write.csv(flutweet.df, "C:\\Users\\abhijadhav777\\Desktop\\part3\\Data.csv")

uInfo <- lookupUsers(flutweet.df$screenName)
#uInfo <- lookupUsers(allTweets.df$screenName)
#uInfo <- lookupUsers(influenzaflufever.df$screenName)
 
uFrame <- twListToDF(uInfo)

locatedUsers <- !is.na(uFrame$location)

locations <- geocode(uFrame$location[locatedUsers])

colnames(locations) <- c("long","lat")

locs <- locations
locations <- locations[!is.na(locations$long) & !is.na(locations$lat) ,]

state_names <- revgeo(longitude= locations$long, latitude= locations$lat, output="frame")
state_names <- state_names[(state_names$country) == "United States of America",]

conti <- as.data.frame(table(state_names$state))

colnames(conti) <- c("id", "count")
conti$id <- tolower(conti$id)



choro <- left_join(fifty_states, conti)

ggplot(choro, aes(x=long,y=lat,group=group))+
  geom_polygon(aes(fill=count))+
  geom_path()+ 
  scale_fill_gradientn(colours=rev(heat.colors(10)),na.value="grey76")+
  coord_map()+
  theme(legend.position = "bottom",panel.background = element_blank())
