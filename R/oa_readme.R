#' Print readme from one or more datasets
#'
#' @export
#' @param x input, either an object of class `oa` or a list of such
#' objects
#' @return character string
#' @examples \dontrun{
#' # single
#' url1 <- "http://data.openaddresses.io/runs/33311/us/mi/ottawa.zip"
#' xx <- oa_get(url1)
#' oa_readme(xx)
#' cat(oa_readme(xx))
#'
#' # many at once
#' url2 <- "http://data.openaddresses.io/runs/101436/us/ca/yolo.zip"
#' zz <- oa_get(url2)
#' oa_readme(list(xx, zz))
#' cat(oa_readme(list(xx, zz)), sep = "\n\n")
#' }
oa_readme <- function(x) {
  UseMethod("oa_readme")
}

#' @export
oa_readme.default <- function(x) {
  stop("no 'oa_readme' method for class ", class(x), call. = FALSE)
}

#' @export
oa_readme.oa <- function(x) {
  xx <- attr(x, "readme")
  if (is.null(xx)) return("") else return(xx)
}

#' @export
oa_readme.list <- function(x) {
  classes <- vapply(x, inherits, logical(1), what = "oa")
  if (!all(classes)) stop("all inputs must be of class 'oa'", call. = FALSE)
  unlist(lapply(x, oa_readme))
}
