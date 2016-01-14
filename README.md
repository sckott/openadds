openadds
========



[![Build Status](https://travis-ci.org/sckott/openadds.svg)](https://travis-ci.org/sckott/openadds)
[![codecov.io](https://codecov.io/github/sckott/openadds/coverage.svg?branch=master)](https://codecov.io/github/sckott/openadds?branch=master)

`openadds` is an R client for data from [Openaddresses.io](http://openaddresses.io/). Data comes from [http://data.openaddresses.io](http://data.openaddresses.io). 

The reason for creating this R client is that the data coming from OpenAddresses is heterogenous in many ways:

* File types: sometimes provided as a csv, sometimes as a Shape file
* Data fields: columns in each dataset vary. Some have no lat/long data, or if present are variously labeled `LON`/`LONGITUDE/LNG` etc., and address fields are especially variable

This pacakge tries to make it easy to retreive the data, as well as combine data sets, and visualize. 

## Install

CRAN (and get `leaflet`)


```r
install.packages(c("leaflet", "openadds"))
```

Dev version


```r
devtools::install_github("sckott/openadds")
```


```r
library("openadds")
```

## List datasets


```r
(dat <- oa_list())
#> Source: local data frame [1,388 x 14]
#> 
#>                      source
#>                       (chr)
#> 1   ar/ba/buenos_aires.json
#> 2             at/31254.json
#> 3             at/31255.json
#> 4             at/31256.json
#> 5             at/tirol.json
#> 6  au/city_of_canberra.json
#> 7        au/queensland.json
#> 8    au/tas-launceston.json
#> 9          au/tasmania.json
#> 10         au/victoria.json
#> ..                      ...
#> Variables not shown: cache (chr), sample (chr), geometry type (chr),
#>   address count (int), version (chr), fingerprint (chr), cache time (chr),
#>   processed (chr), process time (chr), output (chr), attribution required
#>   (chr), attribution name (chr), share-alike (chr)
```

## Search for datasets


```r
oa_search(country = "us", state = "ca")
#> Source: local data frame [49 x 5]
#> 
#>    country state                  city    id
#>      (chr) (chr)                 (chr) (chr)
#> 1       us    ca               alameda      
#> 2       us    ca                amador      
#> 3       us    ca              berkeley      
#> 4       us    ca                 butte      
#> 5       us    ca   city_of_bakersfield      
#> 6       us    ca        city_of_carson      
#> 7       us    ca     city_of_cupertino      
#> 8       us    ca city_of_mountain_view      
#> 9       us    ca        city_of_orange      
#> 10      us    ca          contra_costa      
#> ..     ...   ...                   ...   ...
#> Variables not shown: url (chr)
```

## Get data

Passing in a URL


```r
(out1 <- oa_get(dat$processed[6]))
#> <Openaddresses data> ~/.openadds/city_of_canberra.zip
#> Dimensions [176130, 9]
#> 
#>         LON       LAT NUMBER           STREET CITY         DISTRICT REGION
#> 1  149.1378 -35.41599     14  Watterson Place   NA      TUGGERANONG     NA
#> 2  149.0442 -35.24584     29 Springvale Drive   NA        BELCONNEN     NA
#> 3  149.1546 -35.24284      8   Andrews Street   NA CANBERRA CENTRAL     NA
#> 4  149.0954 -35.47333    107   Pockett Avenue   NA      TUGGERANONG     NA
#> 5  149.1366 -35.24888     28    Antill Street   NA CANBERRA CENTRAL     NA
#> 6  149.1297 -35.33639     41     Hicks Street   NA CANBERRA CENTRAL     NA
#> 7  149.0971 -35.30245     16     Turner Place   NA CANBERRA CENTRAL     NA
#> 8  149.0744 -35.41209     24   Dalgarno Close   NA      TUGGERANONG     NA
#> 9  149.1665 -35.24748      1    Selwyn Street   NA CANBERRA CENTRAL     NA
#> 10 149.1664 -35.24779    108    Rivett Street   NA CANBERRA CENTRAL     NA
#> ..      ...       ...    ...              ...  ...              ...    ...
#> Variables not shown: POSTCODE (chr), ID (chr)
```

First getting URL for dataset through `as_openadd()`, then passing to `oa_get()`


```r
(x <- as_openadd("us", "nv", "las_vegas"))
#> <<OpenAddreses>> 
#>   <<country>> us
#>   <<state>> nv
#>   <<city>> las_vegas
```


```r
oa_get(x)
#> <Openaddresses data> ~/.openadds/las_vegas.zip
#> Dimensions [159, 10]
#> 
#>          LON      LAT NUMBER                      STREET UNIT CITY
#> 1  -115.0495 36.15995   5638               Vineyard Lane   NA   NA
#> 2  -115.0509 36.15966   6292   West Spring Mountain Road   NA   NA
#> 3  -115.0529 36.16026   5542                Orchard Lane   NA   NA
#> 4  -115.0517 36.15986   5501                Orchard Lane   NA   NA
#> 5  -115.0514 36.16034   9525                Stonily Lane   NA   NA
#> 6  -115.0504 36.16026   5623               Vineyard Lane   NA   NA
#> 7  -115.0522 36.15974   5510                Orchard Lane   NA   NA
#> 8  -115.0514 36.16099   5587                Orchard Lane   NA   NA
#> 9  -115.0525 36.16001   5516                Orchard Lane   NA   NA
#> 10 -115.0529 36.15966     NA Rodriguez-De-Lopez Graciela   NA   NA
#> ..       ...      ...    ...                         ...  ...  ...
#> Variables not shown: DISTRICT (chr), REGION (chr), POSTCODE (chr), ID
#>      (chr)
```

## Combine multiple datasets


```r
out2 <- oa_get(dat$processed[35])
(alldat <- oa_combine(out1, out2))
#> Source: local data frame [735,186 x 4]
#> 
#>         lon       lat             address              dataset
#>       (dbl)     (dbl)               (chr)                (chr)
#> 1  149.1378 -35.41599  14 Watterson Place city_of_canberra.zip
#> 2  149.0442 -35.24584 29 Springvale Drive city_of_canberra.zip
#> 3  149.1546 -35.24284    8 Andrews Street city_of_canberra.zip
#> 4  149.0954 -35.47333  107 Pockett Avenue city_of_canberra.zip
#> 5  149.1366 -35.24888    28 Antill Street city_of_canberra.zip
#> 6  149.1297 -35.33639     41 Hicks Street city_of_canberra.zip
#> 7  149.0971 -35.30245     16 Turner Place city_of_canberra.zip
#> 8  149.0744 -35.41209   24 Dalgarno Close city_of_canberra.zip
#> 9  149.1665 -35.24748     1 Selwyn Street city_of_canberra.zip
#> 10 149.1664 -35.24779   108 Rivett Street city_of_canberra.zip
#> ..      ...       ...                 ...                  ...
```

## Map data

Get some data


```r
x <- oa_get(oa_search(city = "oregon_city")[1,]$url)
```

Make an interactive map


```r
library("leaflet")
leaflet(data = x$data) %>%
  addTiles() %>%
  addCircles(lat = ~LAT, lng = ~LON, popup = ~STREET)
```

![map1](inst/img/map.png)
