
#WDI datasets
load(url("http://github.com/olesia-brusentceva/dash-boardd/blob/main/apps/data/WDI_Countries.Rda?raw=true"))
load(url("https://github.com/olesia-brusentceva/dash-boardd/blob/main/apps/data/WDI_Indicators.Rda?raw=true"))

#WB Polygons
WB_CountryPolygons <-
  geojson_read("https://github.com/olesia-brusentceva/dash-boardd/blob/main/apps/data/WB_countries_Admin0_lowres.geojson?raw=true",
               what = "sp")

WB_CountryPolygons<-WB_CountryPolygons[WB_CountryPolygons$ISO_A3_EH %in% WDI_Countries$Country.iso3c,]
WDI_Countries <- WDI_Countries[WDI_Countries$Country.iso3c %in% WB_CountryPolygons$ISO_A3_EH,]

WB_CountryPolygons$NAME_EN<- as.character(lapply(WB_CountryPolygons$ISO_A3_EH,function(x){WDI_Countries[WDI_Countries$Country.iso3c == x,1]}))


#education indicators
education.indicators.list <- c("SE.TER.CUAT.DO.ZS","SE.TER.CUAT.MS.ZS","SE.TER.CUAT.BA.ZS","SE.TER.CUAT.ST.ZS","SE.SEC.CUAT.PO.ZS","SE.SEC.CUAT.UP.ZS","SE.SEC.CUAT.LO.ZS","SE.PRM.CUAT.ZS")
education.names.list <- c("PhD","MA", "BA", "Tertiary","Post-secondary", "Upper Secondary", "Lower Secondary",  "Primary")
Education_Indicators <- data.frame(indicator = education.indicators.list, name = education.names.list)

#countries of interest 
countries.of.interest <- c("DEU", "FRA", "ITA", "GBR", "ESP", "UKR", "POL", "ROU", "NLD", "GRC", "BEL", "CZE", "PRT", "SWE", "HUN", "AUT", "SRB", "SVK", "SVN", "CHE", "BGR", "DNK", "FIN", "NOR", "IRL", "HRV", "MDA", "BIH", "ALB", "LTU", "MKD", "LVA", "EST", "MNE", "LUX", "MLT", "ISL", "AND", "MCO", "LIE", "SMR")

polygons.of.interest <- WB_CountryPolygons[WB_CountryPolygons$ISO_A3_EH %in% countries.of.interest,]
#data to plot on the map
map.data <- WDI(country = countries.of.interest, indicator = "SE.XPD.TOTL.GB.ZS", latest = 1)

gdp.data <- na.omit(WDI(country = countries.of.interest, indicator = c("NY.GDP.MKTP.KD","SE.XPD.TOTL.GB.ZS")))

country.data <- na.omit(melt(setDT(WDI(country = countries.of.interest, indicator = education.indicators.list, latest = 1)),id.vars = c("country","iso2c","iso3c","year"), variable.name = "indicator"))
country.data$indicator<-sapply(country.data$indicator, function(x){Education_Indicators[Education_Indicators$indicator == x,2]})
country.data$indicator <- factor(country.data$indicator, levels = unique(country.data$indicator))


min.expenditure <- floor(min(map.data$SE.XPD.TOTL.GB.ZS, na.rm = TRUE))
max.expenditure <- ceiling(max(map.data$SE.XPD.TOTL.GB.ZS, na.rm = TRUE))


polygons.of.interest$EDUC <- map.data[match(polygons.of.interest$ISO_A3_EH, map.data$iso3c), "SE.XPD.TOTL.GB.ZS"]
polygons.of.interest$EDUC.YEAR <- map.data[match(polygons.of.interest$ISO_A3_EH, map.data$iso3c), "year"]
polygons.of.interest <- polygons.of.interest[order(polygons.of.interest$EDUC, decreasing = TRUE),]

palette <- colorBin(palette = "Greens", domain = c(min.expenditure, max.expenditure), bins = seq(min.expenditure, max.expenditure, by = 0.01), na.color = "#f8f4f4")