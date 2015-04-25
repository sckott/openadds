#' Get data
#'
#' @export
#' @import dplyr httr
#'
#' @param x Anything coercable to an object of class erddap_info. So the output of a call to
#' \code{erddap_info}, or a datasetid, which will internally be passed through \code{erddap_info}.
#' @param ... Dimension arguments.
#' @param fields Fields to return, a character vector.
#' @param stride (integer) How many values to get. 1 = get every value, 2 = get every other value,
#' etc. Default: 1 (i.e., get every value)
#' @param fmt (character) One of csv (default) or ncdf
#' @param store One of \code{disk} (default) or \code{memory}. You can pass options to \code{disk}
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#'
#' @references \url{http://upwell.pfeg.noaa.gov/erddap/index.html}
#' @examples \dontrun{
#' oa_get()
#' }

oa_get <- function(x, ...) {
  if(all(var == "none")){
    args <- paste0(sapply(dims, function(y) parse_args(x, y, stride, dimargs, wname = TRUE)), collapse = ",")
  } else {
    pargs <- sapply(dims, function(y) parse_args(x, y, stride, dimargs))
    args <- paste0(lapply(var, function(y) paste0(y, paste0(pargs, collapse = ""))), collapse = ",")
  }
  resp <- erd_up_GET(url = sprintf("%sgriddap/%s.%s", eurl(), d, fmt), dset = d, args, store, fmt, callopts)
  loc <- if(store$store == "disk") resp else "memory"
  structure(read_upwell(resp, fmt), class=c("erddap_grid","data.frame"), datasetid=d, path=loc)
}

#' @export
print.erddap_grid <- function(x, ..., n = 10){
  cat(sprintf("<NOAA ERDDAP griddap> %s", attr(x, "datasetid")), sep = "\n")
  cat(sprintf("   Path: [%s]", attr(x, "path")), sep = "\n")
  if(attr(x, "path") != "memory"){
    finfo <- file_info(attr(x, "path"))
    cat(sprintf("   Last updated: [%s]", finfo$mtime), sep = "\n")
    cat(sprintf("   File size:    [%s]", finfo$size), sep = "\n")
  }
  cat(sprintf("   Dimensions:   [%s X %s]\n", NROW(x), NCOL(x)), sep = "\n")
  trunc_mat_(x, n = n)
}

oa_GET <- function(url, dset, args, store, fmt, ...){
  if(store$store == "disk"){
    out <- suppressWarnings(cache_get(cache = TRUE, url = url, args = args, path = store$path))

    # fpath <- path.expand(file.path(store$path, paste0(dset, ".csv")))
    if( !is.null( out ) && !store$overwrite ){
      out
    } else {
      dir.create(store$path, showWarnings = FALSE, recursive = TRUE)
      res <- GET(url, query=args, write_disk(write_path(store$path, url, args, fmt), store$overwrite), ...)
      out <- check_response_erddap(res, fmt)
      if(res$status_code != 200) unlink(res$request$writer[[1]])
      if(grepl("Error", out, ignore.case = TRUE)) NA else res$request$writer[[1]]
    }
  } else {
    res <- GET(url, query=args, ...)
    out <- check_response_erddap(res, fmt)
    if(grepl("Error", out, ignore.case = TRUE)) NA else res
  }
}
