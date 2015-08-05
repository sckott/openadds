context("oa_list")

test_that("oa_list works", {
  skip_on_cran()

  res <- oa_list()

  expect_is(res, "character")
  expect_is(res[1], "character")
  expect_match(res[1], "complete\\.zip")
})

test_that("oa_list fails well", {
  skip_on_cran()

  library("httr")
  expect_error(oa_list("asdfad"), "no applicable method")
  expect_error(oa_list(config = timeout(0.001)), "Timeout was reached")
})
