#' Coerce to openadd object
#'
#' @export
#' @param country (characater) Country name
#' @param state (characater) State (or province) name
#' @param city (characater) City name
#' @param ext (characater) One of \code{.zip} or \code{.csv}
#' @param ... Ignored
#' @examples \dontrun{
#' as_openadd("us", "nm", "hidalgo")
#' }
as_openadd <- function(country = NULL, state = NULL, city = NULL, ext = NULL, ...) {
  tmp <- oa_search(country, state, city, ext)
  if (NROW(tmp) == 1) {
    make_openadd(tmp)
  } else {
    stop("Refine your search, more than 1 result", call. = FALSE)
  }
}

make_openadd <- function(x) {
  structure(x$url, class = "openadd", country = x$country, state = x$state,
            city = x$city, ext = x$ext)
}

#' @export
print.openadd <- function(x, ...) {
  cat("<<OpenAddreses>> ", sep = "\n")
  cat(paste0("  <<country>> ", attr(x, "country")), sep = "\n")
  cat(paste0("  <<state>> ", attr(x, "state")), sep = "\n")
  cat(paste0("  <<city>> ", attr(x, "city")), sep = "\n")
  cat(paste0("  <<extension>> ", attr(x, "ext")), sep = "\n")
}
