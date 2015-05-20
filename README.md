openadds
========



[![Build Status](https://travis-ci.org/sckott/openadds.svg)](https://travis-ci.org/sckott/openadds)

`openadds` is an R client for data from [Openaddresses.io](http://openaddresses.io/). Data comes from [http://data.openaddresses.io](http://data.openaddresses.io). 

The reason for creating this R client is that the data coming from OpenAddresses is heterogenous in many ways:

* File types: sometimes provided as a csv, sometimes as a Shape file
* Data fields: columns in each dataset vary. Some have no lat/long data, or if present are variously labeled `LON`/`LONGITUDE/LNG` etc., and address fields are especially variable

This pacakge tries to make it easy to retreive the data, as well as combine data sets, and visualize. 

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
dat <- oa_list()
dat[2:6]
#> [1] "http://data.openaddresses.io.s3.amazonaws.com/20150511/au-tas-launceston.csv"   
#> [2] "http://s3.amazonaws.com/data.openaddresses.io/20141127/au-victoria.zip"         
#> [3] "http://data.openaddresses.io.s3.amazonaws.com/20150511/be-flanders.zip"         
#> [4] "http://data.openaddresses.io.s3.amazonaws.com/20150417/ca-ab-calgary.zip"       
#> [5] "http://data.openaddresses.io.s3.amazonaws.com/20150511/ca-ab-grande_prairie.zip"
```

## Search for datasets


```r
oa_search(country = "us", state = "ca")
#> Source: local data frame [68 x 5]
#> 
#>    country state             city  ext
#> 1       us    ca san_mateo_county .zip
#> 2       us    ca   alameda_county .zip
#> 3       us    ca   alameda_county .zip
#> 4       us    ca           amador .zip
#> 5       us    ca           amador .zip
#> 6       us    ca      bakersfield .zip
#> 7       us    ca      bakersfield .zip
#> 8       us    ca         berkeley .zip
#> 9       us    ca         berkeley .zip
#> 10      us    ca     butte_county .zip
#> ..     ...   ...              ...  ...
#> Variables not shown: url (chr)
```

## Get data

Passing in a URL


```r
(out1 <- oa_get(dat[5]))
#> <Openaddresses data> ~/.openadds/ca-ab-calgary.zip
#> Dimensions [350962, 13]
#> 
#>    OBJECTID ADDRESS_TY                 ADDRESS    STREET_NAM STREET_TYP
#> 0    757023     Parcel  249 SAGE MEADOWS CI NW  SAGE MEADOWS         CI
#> 1    757022     Parcel           2506 17 ST SE            17         ST
#> 2    757021     Parcel     305 EVANSPARK GD NW     EVANSPARK         GD
#> 3    757020     Parcel     321 EVANSPARK GD NW     EVANSPARK         GD
#> 4    757019     Parcel   204 EVANSBROOKE LD NW   EVANSBROOKE         LD
#> 5    757018     Parcel   200 EVANSBROOKE LD NW   EVANSBROOKE         LD
#> 6    757017     Parcel 219 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> 7    757016     Parcel 211 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> 8    757015     Parcel 364 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> 9    757014     Parcel 348 HIDDEN VALLEY LD NW HIDDEN VALLEY         LD
#> ..      ...        ...                     ...           ...        ...
#> Variables not shown: STREET_QUA (fctr), HOUSE_NUMB (int), HOUSE_ALPH
#>      (fctr), SUITE_NUMB (int), SUITE_ALPH (fctr), LONGITUDE (dbl),
#>      LATITUDE (dbl), COMM_NAME (fctr)
```

First getting URL for dataset through `as_openadd()`, then passing to `oa_get()`


```r
(x <- as_openadd("us", "nm", "hidalgo"))
#> <<OpenAddreses>> 
#>   <<country>> us
#>   <<state>> nm
#>   <<city>> hidalgo
#>   <<extension>> .csv
```


```r
oa_get(x)
#> <Openaddresses data> ~/.openadds/us-nm-hidalgo.csv
#> Dimensions [170659, 37]
#> 
#>    OBJECTID Shape ADD_NUM ADD_SUF PRE_MOD PRE_DIR PRE_TYPE         ST_NAME
#> 1         1    NA     422                       S                      2ND
#> 2         2    NA    1413                       S                      4TH
#> 3         3    NA     412                       E                 CHAMPION
#> 4         4    NA     110                       E                   SAMANO
#> 5         5    NA    2608                       W          FREDDY GONZALEZ
#> 6         6    NA    2604                       W          FREDDY GONZALEZ
#> 7         7    NA    1123                       W                      FAY
#> 8         8    NA     417                       S                      2ND
#> 9         9    NA    4551                       E                    TEXAS
#> 10       10    NA     810                                        DRIFTWOOD
#> ..      ...   ...     ...     ...     ...     ...      ...             ...
#> Variables not shown: ST_TYPE (chr), POS_DIR (chr), POS_MOD (chr), ESN
#>      (int), MSAG_COMM (chr), PARCEL_ID (chr), PLACE_TYPE (chr), LANDMARK
#>      (chr), BUILDING (chr), UNIT (chr), ROOM (chr), FLOOR (int), LOC_NOTES
#>      (chr), ST_ALIAS (chr), FULL_ADDR (chr), ZIP (chr), POSTAL_COM (chr),
#>      MUNICIPAL (chr), COUNTY (chr), STATE (chr), SOURCE (chr), REGION
#>      (chr), EXCH (chr), LAT (dbl), LONG (dbl), PICTURE (chr), OA:x (dbl),
#>      OA:y (dbl), OA:geom (chr)
```

## Combine multiple datasets


```r
out2 <- oa_get(dat[32])
(alldat <- oa_combine(out1, out2))
#> Source: local data frame [418,623 x 4]
#> 
#>          lon      lat                 address           dataset
#> 1  -114.1303 51.17188  249 SAGE MEADOWS CI NW ca-ab-calgary.zip
#> 2  -114.0190 51.03168           2506 17 ST SE ca-ab-calgary.zip
#> 3  -114.1175 51.17497     305 EVANSPARK GD NW ca-ab-calgary.zip
#> 4  -114.1175 51.17461     321 EVANSPARK GD NW ca-ab-calgary.zip
#> 5  -114.1212 51.16268   204 EVANSBROOKE LD NW ca-ab-calgary.zip
#> 6  -114.1213 51.16264   200 EVANSBROOKE LD NW ca-ab-calgary.zip
#> 7  -114.1107 51.14784 219 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> 8  -114.1108 51.14768 211 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> 9  -114.1121 51.14780 364 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> 10 -114.1117 51.14800 348 HIDDEN VALLEY LD NW ca-ab-calgary.zip
#> ..       ...      ...                     ...               ...
```

## Map data

Get some data


```r
x <- oa_get(oa_search(country = "us", city = "boulder")[1,]$url)
y <- oa_get(oa_search(country = "us", city = "gunnison")[1,]$url)
```

Make an interactive map


```r
library("leaflet")
oa_combine(x, y) %>% 
  leaflet() %>%
  addTiles() %>%
  addCircles(lat = ~lat, lng = ~lon, popup = ~address)
```

![map1](inst/img/map.png)
