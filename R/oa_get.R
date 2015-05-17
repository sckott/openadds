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
#' dat <- list_data()
#' (out1 <- oa_get(dat[5]))
#' (out2 <- oa_get(dat[21]))
#' (out3 <- oa_get(dat[32]))
#' (out4 <- oa_get(dat[876]))
#' (out5 <- oa_get(dat[376]))
#' (out6 <- oa_get(dat[474]))
#' (out7 <- oa_get(dat[121]))
#' (out8 <- oa_get(dat[41]))
#' (out9 <- oa_get(dat[400]))
#' (out10 <- oa_get(dat[23])) # error
#'
#' # combine data sets
#' (alldat <- combine(out1, out3))
#'
#' # Map data
#' library("leaflet")
#' small <- out9$data[1:10000L, ]
#' leaflet(small) %>%
#'   addTiles() %>%
#'   addCircles(lat = ~LAT, lng = ~LON,
#'              popup = unname(apply(small[, c('NUMBER', 'STREET')], 1, paste, collapse = " ")))
#' }
oa_get <- function(x, path = "~/.openadds", ...) {
  resp <- oa_GET(url = x, fname = basename(x), path, ...)
  structure(list(data = resp), class = c("oa", "data.frame"),
            id = x, path = make_path(basename(x), path))
}

oa_GET <- function(url, fname, path, ...){
  file <- make_path(fname, path)
  if ( file.exists(path.expand(file)) ) {
    ff <- file
  } else {
    res <- GET(url, write_disk(file, TRUE))
    stop_for_status(res)
    ff <- res$request$output$path
  }
  switch(strextract(basename(ff), "\\zip|csv"),
         csv = read_csv_(ff),
         zip = read_zip_(ff, path)
  )
}

read_csv_ <- function(x) {
  readr::read_csv(x)
}

read_zip_ <- function(fname, path) {
  exdir <- file.path(path, strsplit(basename(fname), "\\.")[[1]][[1]])
  unzip(fname, exdir = exdir)
  switch(file_type(exdir),
         csv = {
           files <- list.files(exdir, pattern = ".csv", full.names = TRUE, recursive = TRUE)
           if (length(files) > 1) stop('More than 1 csv file found', call. = FALSE)
           readr::read_csv(files)
         },
         shp = read_shp(exdir))
}

read_shp <- function(dir) {
  shpfile <- list.files(dir, pattern = ".shp", full.names = TRUE, recursive = TRUE)
  if (length(shpfile) != 1) {
    shpfile2 <- grep("\\.shp$", shpfile, value = TRUE)
    shpfile <- shpfile2[1]
    message("Many shp files, using \n", shpfile2[1], "\n others available:\n", shpfile2[-1])
  }
  tmp <- maptools::readShapeSpatial(shpfile)
  tmp@data
}

file_type <- function(b) {
  ff <- basename(list.files(b, full.names = TRUE, recursive = TRUE))
  if (any(grepl("\\.csv", ff))) {
    "csv"
  } else if (any(grepl("\\.shp", ff))) {
    "shp"
  } else {
    stop("not file type csv or shp", call. = FALSE)
  }
}

make_path <- function(x, path) {
  file.path(path, x)
  # file.path(path, strsplit(x, "/")[[1]][[2]])
}

#' @export
print.oa <- function(x, ..., n = 10) {
  cat(sprintf("<Openaddresses data> %s", attr(x, "path")), sep = "\n")
  cat(sprintf("Dimensions [%s, %s]\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat(x$data, n = n)
}
