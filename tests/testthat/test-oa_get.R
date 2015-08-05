context("oa_get")

test_that("oa_get works", {
  skip_on_cran()

  urls <- c('http://data.openaddresses.io.s3.amazonaws.com/20150727/au-tas-launceston.csv', 'http://data.openaddresses.io.s3.amazonaws.com/20150523/br-pe-recife.zip', 'http://data.openaddresses.io.s3.amazonaws.com/20150803/ca-bc-north_vancouver.zip', 'http://data.openaddresses.io.s3.amazonaws.com/20150713/ca-bc-okanagan_similkameen.zip', 'http://data.openaddresses.io.s3.amazonaws.com/20150805/ca-on-kingston.csv', 'http://data.openaddresses.io.s3.amazonaws.com/20150626/ca-on-ottawa.zip', 'http://data.openaddresses.io.s3.amazonaws.com/20150511/ca-on-york_region.zip', 'http://s3.amazonaws.com/openaddresses-cfa/20141030/de-berlin.zip', 'http://data.openaddresses.io.s3.amazonaws.com/20150523/fr-bano.zip')

  # works for zip files
  aa <- oa_get(urls[3])

  expect_is(aa, "data.frame")
  expect_is(aa, "oa")
  expect_named(aa, "data")
  expect_equal(attr(aa, "id"), urls[3])

  # works for csv files
  bb <- suppressWarnings(oa_get(urls[5]))

  expect_is(bb, "data.frame")
  expect_is(bb, "oa")
  expect_named(bb, "data")
  expect_equal(attr(bb, "id"), urls[5])
})

test_that("oa_get fails well", {
  skip_on_cran()

  expect_error(oa_get(), "no applicable method")
  expect_error(oa_get("adfdf"))
})
