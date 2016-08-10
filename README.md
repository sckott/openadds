openadds
========



[![Build Status](https://travis-ci.org/sckott/openadds.svg)](https://travis-ci.org/sckott/openadds)
[![Build status](https://ci.appveyor.com/api/projects/status/xhn3m4ugungqcbmp?svg=true)](https://ci.appveyor.com/project/sckott/openadds)
[![codecov.io](https://codecov.io/github/sckott/openadds/coverage.svg?branch=master)](https://codecov.io/github/sckott/openadds?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/openadds)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/openadds)](https://cran.r-project.org/package=openadds)


`openadds` is an R client for data from [Openaddresses.io](http://openaddresses.io/). Data comes from <http://data.openaddresses.io>.

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
#> # A tibble: 1,680 x 15
#>                      source
#>                       <chr>
#> 1   ar/ba/buenos_aires.json
#> 2             at/31254.json
#> 3             at/31255.json
#> 4             at/31256.json
#> 5    at/city_of_vienna.json
#> 6             at/tirol.json
#> 7  au/city_of_canberra.json
#> 8       au/countrywide.json
#> 9        au/queensland.json
#> 10   au/tas-launceston.json
#> # ... with 1,670 more rows, and 14 more variables: cache <chr>,
#> #   sample <chr>, geometry type <chr>, address count <int>, version <chr>,
#> #   fingerprint <chr>, cache time <S3: hms>, processed <chr>, process
#> #   time <S3: hms>, output <chr>, attribution required <chr>, attribution
#> #   name <chr>, share-alike <chr>, code version <chr>
```

## Search for datasets


```r
oa_search(country = "us", state = "ca")
#> # A tibble: 53 x 5
#>    country state                  city    id
#> *    <chr> <chr>                 <chr> <chr>
#> 1       us    ca               alameda      
#> 2       us    ca                amador      
#> 3       us    ca              berkeley      
#> 4       us    ca                 butte      
#> 5       us    ca       city_of_anaheim      
#> 6       us    ca   city_of_bakersfield      
#> 7       us    ca        city_of_carson      
#> 8       us    ca     city_of_cupertino      
#> 9       us    ca       city_of_hayward      
#> 10      us    ca city_of_mountain_view      
#> # ... with 43 more rows, and 1 more variables: url <chr>
```

## Get data

Passing in a URL


```r
(out1 <- oa_get(dat$processed[5]))
#> <Openaddresses data> city_of_vienna
#> paths: /Users/sacmac/Library/Caches/openadds-ca ...
#> data set sizes (NROW): 282313
#> first data_frame ...  
#> # A tibble: 282,313 x 11
#>         LON      LAT NUMBER       STREET  UNIT  CITY DISTRICT REGION
#>       <dbl>    <dbl>  <chr>        <chr> <chr> <chr>    <chr>  <chr>
#> 1  16.36766 48.21032      1    Irisgasse  <NA>  <NA>     <NA>   <NA>
#> 2  16.36743 48.21029     13  Naglergasse  <NA>  <NA>     <NA>   <NA>
#> 3  16.36674 48.21101      1  Heidenschuß  <NA>  <NA>     <NA>   <NA>
#> 4  16.36657 48.21100     31  Naglergasse  <NA>  <NA>     <NA>   <NA>
#> 5  16.36954 48.21006      7   Tuchlauben  <NA>  <NA>     <NA>   <NA>
#> 6  16.37587 48.20312      4 Schubertring  <NA>  <NA>     <NA>   <NA>
#> 7  16.37547 48.20297      8  Fichtegasse  <NA>  <NA>     <NA>   <NA>
#> 8  16.37593 48.20226      7 Schubertring  <NA>  <NA>     <NA>   <NA>
#> 9  16.37403 48.20418     15 Seilerstätte  <NA>  <NA>     <NA>   <NA>
#> 10 16.37279 48.20407     18    Annagasse  <NA>  <NA>     <NA>   <NA>
#> # ... with 2.823e+05 more rows, and 3 more variables: POSTCODE <int>,
#> #   ID <chr>, HASH <chr>
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
#> <Openaddresses data> las_vegas
#> paths: /Users/sacmac/Library/Caches/openadds-ca ...
#> data set sizes (NROW): 159
#> first data_frame ...  
#> # A tibble: 159 x 11
#>          LON      LAT NUMBER                      STREET  UNIT  CITY
#>        <dbl>    <dbl>  <int>                       <chr> <chr> <chr>
#> 1  -115.0529 36.15966     NA RODRIGUEZ-DE-LOPEZ GRACIELA  <NA>  <NA>
#> 2  -115.0518 36.16089   5581             ORCHARD LN #150  <NA>  <NA>
#> 3  -115.0514 36.16099   5587                  ORCHARD LN  <NA>  <NA>
#> 4  -115.0525 36.16001   5516                  ORCHARD LN  <NA>  <NA>
#> 5  -115.0524 36.16059   6320           E CHARLESTON BLVD  <NA>  <NA>
#> 6  -115.0522 36.16039     NA              TAYLOR CYNTHIA  <NA>  <NA>
#> 7  -115.0524 36.16032   5539                  ORCHARD LN  <NA>  <NA>
#> 8  -115.0520 36.15991    863                   HURON AVE  <NA>  <NA>
#> 9  -115.0501 36.15981   5650                 VINEYARD LN  <NA>  <NA>
#> 10 -115.0528 36.15998   5528                  ORCHARD LN  <NA>  <NA>
#> # ... with 149 more rows, and 5 more variables: DISTRICT <chr>,
#> #   REGION <chr>, POSTCODE <chr>, ID <chr>, HASH <chr>
```

## Combine multiple datasets


```r
out2 <- oa_get(dat$processed[35])
(alldat <- oa_combine(out1, out2))
#> # A tibble: 383,344 x 4
#>         lon      lat         address        dataset
#> *     <dbl>    <dbl>           <chr>          <chr>
#> 1  16.36766 48.21032     1 Irisgasse city_of_vienna
#> 2  16.36743 48.21029  13 Naglergasse city_of_vienna
#> 3  16.36674 48.21101   1 Heidenschuß city_of_vienna
#> 4  16.36657 48.21100  31 Naglergasse city_of_vienna
#> 5  16.36954 48.21006    7 Tuchlauben city_of_vienna
#> 6  16.37587 48.20312  4 Schubertring city_of_vienna
#> 7  16.37547 48.20297   8 Fichtegasse city_of_vienna
#> 8  16.37593 48.20226  7 Schubertring city_of_vienna
#> 9  16.37403 48.20418 15 Seilerstätte city_of_vienna
#> 10 16.37279 48.20407    18 Annagasse city_of_vienna
#> # ... with 383,334 more rows
```

## Map data

Get some data


```r
x <- oa_get(oa_search(city = "oregon_city")[1,]$url)
```

Make an interactive map


```r
library("leaflet")
leaflet(x) %>%
  addTiles() %>%
  addCircles(lat = ~LAT, lng = ~LON, popup = ~STREET)
```

![map1](inst/img/map.png)

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
* Please [report any issues or bugs](https://github.com/sckott/openadds/issues)
* License: MIT
