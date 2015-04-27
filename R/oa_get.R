#' Get data from Openaddresses
#'
#' @export
#' @importFrom httr GET stop_for_status write_disk config content
#' @importFrom readr read_csv
#' @importFrom maptools readShapeSpatial
#'
#' @param x State name
#' @param path Path to store files in, a directory, not the file name
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#'
#' @references \url{http://openaddresses.io/}
#' @examples \dontrun{
#' res <- oa_get(x = "20150316/us-nc-burke.csv")
#' res <- list_data()
#' (dat <- oa_get(res[5]))
#' (dat2 <- oa_get(res[17]))
#' }

oa_get <- function(x, path = "~/.openadds", ...) {
  # resp <- oa_GET(url = sprintf("http://data.openaddresses.io.s3.amazonaws.com/%s", x), x, path, ...)
  resp <- oa_GET(x, basename(x), path, ...)
  # loc <- if (store$store == "disk") resp else "memory"
  structure(list(data = resp), class = c("oa", "data.frame"), id = x, path = make_path(x, path))
}

oa_GET <- function(url, x, path, ...){
  file <- make_path(x, path)
  res <- GET(url, write_disk(file, TRUE))
  stop_for_status(res)
  switch(strextract(basename(res$request$writer[[1]]), "\\zip|csv"),
         csv = read_csv_(res),
         zip = read_zip_(res, path)
  )
}

read_csv_ <- function(x) {
  readr::read_csv(x$request$writer[[1]])
}

read_zip_ <- function(x, path) {
  exdir <- file.path(path, strsplit(basename(x$request$writer[[1]]), "\\.")[[1]][[1]])
  unzip(x$request$writer[[1]], exdir = exdir)
  shpfile <- list.files(exdir, pattern = ".shp", full.names = TRUE, recursive = TRUE)
  if (length(shpfile) != 1) {
    shpfile2 <- grep("\\.shp$", shpfile, value = TRUE)
    shpfile <- shpfile2[1]
    message("Many shp files, using \n", shpfile2[1], "\n others available:\n", shpfile2[-1])
  }
  tmp <- maptools::readShapeSpatial(shpfile)
  tmp@data
}

make_path <- function(x, path) {
  file.path(path, x)
  # file.path(path, strsplit(x, "/")[[1]][[2]])
}

#' @export
print.oa <- function(x, ..., n = 10){
  cat(sprintf("<Openaddresses data> %s", attr(x, "path")), sep = "\n")
  trunc_mat(x$data, n = n)
}
