
load("~/dash-boardd/apps/data/WDI_Countries.Rda")
load("~/dash-boardd/apps/data/WDI_Indicators.Rda")

WB_CountryPolygons <-
  geojson_read("~/dash-boardd/apps/data/WB_countries_Admin0_lowres.geojson",
               what = "sp")

WB_CountryPolygons<-WB_CountryPolygons[WB_CountryPolygons$ISO_A3 %in% WDI_Countries$Country.iso3c,]
WDI_Countries <- WDI_Countries[WDI_Countries$Country.iso3c %in% WB_CountryPolygons$ISO_A3,]

countryName<-function(x){WDI_Countries[WDI_Countries$Country.iso3c == x,1]}

WB_CountryPolygons$NAME_EN<- as.character(lapply(WB_CountryPolygons$ISO_A3,function(x){WDI_Countries[WDI_Countries$Country.iso3c == x,1]}))

