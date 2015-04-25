#' Get data
#'
#' @export
#' @import dplyr httr readr
#'
#' @param x State name
#' @param path Path to store files in, a directory, not the file name
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#'
#' @references \url{http://openaddresses.io/}
#' @examples \dontrun{
#' res <- oa_get(x = "20150316/us-nc-burke.csv")
#' }

oa_get <- function(x, path = "~/.openadds", ...) {
  resp <- oa_GET(url = sprintf("http://data.openaddresses.io.s3.amazonaws.com/%s", x), x, path, ...)
  # loc <- if (store$store == "disk") resp else "memory"
  structure(list(data = resp), class = c("oa", "data.frame"), id = x, path = make_path(x, path))
}

# "http://data.openaddresses.io.s3.amazonaws.com/20150316/us-nc-burke.csv"
# "http://data.openaddresses.io.s3.amazonaws.com/20150422/us-or-oregon_city.csv"
# url <- "http://s3.amazonaws.com/openaddresses/20140822/us-nc-washington.zip"
# GET(url, write_disk("wash.zip"))

oa_GET <- function(url, x, path, ...){
  file <- make_path(x, path)
  res <- GET(url, write_disk(file, TRUE))
  stop_for_status(res)
  readr::read_csv(res$request$writer[[1]])
}

make_path <- function(x, path) {
  file.path(path, strsplit(x, "/")[[1]][[2]])
}

#' @export
print.oa <- function(x, ..., n = 10){
  cat(sprintf("<Openaddresses data> %s", attr(x, "path")), sep = "\n")
  print(x$data, n = n)
}
