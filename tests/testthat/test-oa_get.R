context("oa_get")

test_that("oa_get works", {
  skip_on_cran()

  urls <- c('http://data.openaddresses.io.s3.amazonaws.com/20150727/au-tas-launceston.csv',
            'http://data.openaddresses.io.s3.amazonaws.com/20150523/br-pe-recife.zip',
            'http://data.openaddresses.io.s3.amazonaws.com/20150803/ca-bc-north_vancouver.zip',
            'http://data.openaddresses.io.s3.amazonaws.com/20150713/ca-bc-okanagan_similkameen.zip',
            'http://data.openaddresses.io.s3.amazonaws.com/20150805/ca-on-kingston.csv',
            'http://data.openaddresses.io.s3.amazonaws.com/20150626/ca-on-ottawa.zip',
            'http://data.openaddresses.io.s3.amazonaws.com/20150511/ca-on-york_region.zip',
            'http://s3.amazonaws.com/openaddresses-cfa/20141030/de-berlin.zip',
            'http://data.openaddresses.io.s3.amazonaws.com/20150523/fr-bano.zip')

  # works for zip files
  aa <- oa_get(urls[3])

  expect_is(aa, "data.frame")
  expect_is(aa, "oa")
  expect_equal(attr(aa, "id"), urls[3])

  # works for csv files
  bb <- suppressWarnings(oa_get(urls[5]))

  expect_is(bb, "data.frame")
  expect_is(bb, "oa")
  expect_equal(attr(bb, "id"), urls[5])

  # works for geojson files
  cc <- oa_get(urls[2])

  expect_is(cc, "data.frame")
  expect_is(cc, "oa")
  expect_equal(attr(cc, "id"), urls[2])
  # geojson data exists
  expect_true("geometry.type" %in% names(cc))
  expect_true("geometry.coordinates" %in% names(cc))
  expect_is(cc$geometry.coordinates[[1]], "array")
  expect_type(cc$geometry.coordinates[[1]][,,1], "double")
})

test_that("oa_get fails well", {
  skip_on_cran()

  expect_error(oa_get(), "argument \"x\" is missing")
  expect_error(oa_get("adfdfasdfassdf"), "input doesn't appear to be an Openaddresses URL")

  expect_error(oa_get(NA_character_), "input was NULL or NA")

  expect_error(oa_get(5), "no 'oa_get' method")
  expect_error(oa_get(NA), "no 'oa_get' method")
})

# test_that("oa_get works when multiple data files to read", {
#   url_mont <- 'http://data.openaddresses.io/runs/104134/us/ia/montgomery.zip'
#   dd <- oa_get(url_mont)
#   expect_is(dd, "oa")
# })
