openadds 0.2.0
==============

## NEW FEATURES

* Now using `crul` package for HTTP requests instead of 
`httr` (#8)

## MINOR IMPROVEMENTS

* Fix `oa_cache_delete_all()` and `oa_cache_delete()` to delete parent 
folder as well (#7)

## BUG FIXES

* Fix `readr` dependency version (#5)
* Now handling geojson files appropriately without failing (#6)

openadds 0.1.2
==============

## BUG FIXES

* require `readr >= 1.0.0` as older `readr` versions cause some errors/warnings

openadds 0.1.0
==============

## NEW FEATURES

* released to CRAN
