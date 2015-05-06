library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(ggmap)
library(dplyr)
library(scales)

crimes <- read.csv('Chicago Crimes (subset).csv', stringsAsFactors=F)
crimes$lat <- crimes$Location %>%
  sapply(function(z) strsplit(z, ',')[[1]][1]) %>% unlist() %>%
  gsub('\\(', '', .) %>% as.numeric()

crimes$lon <- crimes$Location %>%
  sapply(function(z) strsplit(z, ',')[[1]][2]) %>% unlist() %>%
  gsub('\\)', '', .) %>% as.numeric()

beats <- readOGR('.', 'chiBeats')
beats <- fortify(beats)

chicago <- get_map('Chicago', maptype='roadmap', color='color',
                   source='google', zoom=11)
p <- ggmap(chicago)

plotData <- crimes %>% filter(Year==2014, Crime=='BATTERY')

p + geom_path(data=beats, aes(x=long, y=lat, group=group)) +
  geom_point(data=plotData, aes(x=lon, y=lat), color='red') +
  coord_equal() +
  theme(panel.background=element_blank(),
        axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank()) +
  labs(title='2014 Battery Charges')
