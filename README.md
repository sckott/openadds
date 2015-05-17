openadds
========



[![Build Status](https://travis-ci.org/sckott/openadds.svg)](https://travis-ci.org/sckott/openadds)

`openadds` is an R client for data from [Openaddresses.io](http://openaddresses.io/). Data comes from 

## Install


```r
install.packages("devtools")
devtools::install_github("rstudio/leaflet")
devtools::install_github("sckott/openadds")
```


```r
library("openadds")
```

## List datasets


```r
dat <- list_data()
head(dat)
#> [1] "/openaddresses-complete.zip"                                                    
#> [2] "http://data.openaddresses.io.s3.amazonaws.com/20150511/au-tas-launceston.csv"   
#> [3] "http://s3.amazonaws.com/data.openaddresses.io/20141127/au-victoria.zip"         
#> [4] "http://data.openaddresses.io.s3.amazonaws.com/20150511/be-flanders.zip"         
#> [5] "http://data.openaddresses.io.s3.amazonaws.com/20150417/ca-ab-calgary.zip"       
#> [6] "http://data.openaddresses.io.s3.amazonaws.com/20150511/ca-ab-grande_prairie.zip"
```

## Get data


```r
(out1 <- oa_get(dat[5]))
#> <Openaddresses data> ~/.openadds/ca-ab-calgary.zip
#> Dimensions [350962, 13]
#> 
#>    OBJECTID ADDRESS_TY                 ADDRESS    STREET_NAM STREET_TYP STREET_QUA HOUSE_NUMB
#> 0    757023     Parcel  249 SAGE MEADOWS CI NW  SAGE MEADOWS         CI         NW        249
#> 1    757022     Parcel           2506 17 ST SE            17         ST         SE       2506
#> 2    757021     Parcel     305 EVANSPARK GD NW     EVANSPARK         GD         NW        305
#> 3    757020     Parcel     321 EVANSPARK GD NW     EVANSPARK         GD         NW        321
#> 4    757019     Parcel   204 EVANSBROOKE LD NW   EVANSBROOKE         LD         NW        204
#> 5    757018     Parcel   200 EVANSBROOKE LD NW   EVANSBROOKE         LD         NW        200
#> 6    757017     Parcel 219 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD         NW        219
#> 7    757016     Parcel 211 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD         NW        211
#> 8    757015     Parcel 364 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD         NW        364
#> 9    757014     Parcel 348 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD         NW        348
#> ..      ...        ...                     ...           ...        ...        ...        ...
#> Variables not shown: HOUSE_ALPH (fctr), SUITE_NUMB (int), SUITE_ALPH (fctr), LONGITUDE (dbl),
#>      LATITUDE (dbl), COMM_NAME (fctr)
```

## Combine multiple datasets


```r
out2 <- oa_get(dat[32])
(alldat <- combine(out1, out2))
#> Source: local data frame [418,623 x 3]
#> 
#>          lon      lat                 address
#> 1  -114.1303 51.17188  249 SAGE MEADOWS CI NW
#> 2  -114.0190 51.03168           2506 17 ST SE
#> 3  -114.1175 51.17497     305 EVANSPARK GD NW
#> 4  -114.1175 51.17461     321 EVANSPARK GD NW
#> 5  -114.1212 51.16268   204 EVANSBROOKE LD NW
#> 6  -114.1213 51.16264   200 EVANSBROOKE LD NW
#> 7  -114.1107 51.14784 219 HIDDEN VALLEY LD NW
#> 8  -114.1108 51.14768 211 HIDDEN VALLEY LD NW
#> 9  -114.1121 51.14780 364 HIDDEN VALLEY LD NW
#> 10 -114.1117 51.14800 348 HIDDEN VALLEY LD NW
#> ..       ...      ...                     ...
```

## Map data

Get some data


```r
(out <- oa_get(dat[400]))
#> <Openaddresses data> ~/.openadds/us-ca-sonoma_county.zip
#> Dimensions [217243, 5]
#> 
#>          LON      LAT  NUMBER          STREET POSTCODE
#> 1  -122.5327 38.29779 3771  A       Cory Lane       NA
#> 2  -122.5422 38.30354   18752 White Oak Drive       NA
#> 3  -122.5412 38.30327   18749 White Oak Drive       NA
#> 4  -122.3997 38.26122    3552       Napa Road       NA
#> 5  -122.5425 38.30404    3998 White Oak Court       NA
#> 6  -122.5429 38.30434    4026 White Oak Court       NA
#> 7  -122.5430 38.30505    4039 White Oak Court       NA
#> 8  -122.5417 38.30504    4017 White Oak Court       NA
#> 9  -122.5409 38.30436   18702 White Oak Drive       NA
#> 10 -122.5403 38.30392   18684 White Oak Drive       NA
#> ..       ...      ...     ...             ...      ...
```

Make an interactive map (not all data)


```r
library("leaflet")
small <- out$data[1:10000L, ]
leaflet(small) %>%
   addTiles() %>%
   addCircles(lat = ~LAT, lng = ~LON,
      popup = unname(apply(small[, c('NUMBER', 'STREET')], 1, paste, collapse = " ")))
```

![map1](inst/img/map.png)
