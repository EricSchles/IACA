library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(ggmap)
library(dplyr)
library(scales)


shapes <- readShapePoly('chiBeats.shp')
coords <- data.frame()
coords <- shapes@polygons %>%
  lapply(function(z) z@Polygons) %>%
  lapply(function(z) z[[1]]@coords)
t.1 <- coords[[1]]
for (i in 2:length(coords)) {
  t.1 <- rbind(t.1, coords[[i]])
}
coords <- data.frame('lon'=t.1[, 1], 'lat'=t.1[,2])

chicago <- get_map('Chicago', maptype='roadmap', color='color',
                   source='osm', zoom=10)
p <- ggmap(chicago)
p + geom_polygon(data=coords)


colours <- brewer.pal(9, 'Blues')