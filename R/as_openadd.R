#' Coerce to openadd object
#'
#' @export
#' @param country (characater) Country name
#' @param state (characater) State (or province) name
#' @param city (characater) City name
#' @param ... ignored
#' @details This is a helper function to let the user specify what they want
#' with any combination of country, state, and city - the output of which
#' can be passed to \code{\link{oa_get}} to get data.
#'
#' If your search results in more than 1 result, we stop with message to
#' refine your search.
#' @return an object of class \code{openadd}
#' @examples \dontrun{
#' as_openadd(country="us", state="nv", city="las_vegas")
#'
#' # too coarse, will ask you to refine your search
#' # as_openadd(country="us", state="mi", city="detroit")
#' }
as_openadd <- function(country = NULL, state = NULL, city = NULL, ...) {
  tmp <- oa_search(country, state, city)
  if (NROW(tmp) == 1) {
    make_openadd(tmp)
  } else {
    stop("Refine your search, more than 1 result", call. = FALSE)
  }
}

make_openadd <- function(x) {
  structure(x$url, class = "openadd", country = x$country, state = x$state,
            city = x$city)
}

#' @export
print.openadd <- function(x, ...) {
  cat("<<OpenAddreses>> ", sep = "\n")
  cat(paste0("  <<country>> ", attr(x, "country")), sep = "\n")
  cat(paste0("  <<state>> ", attr(x, "state")), sep = "\n")
  cat(paste0("  <<city>> ", attr(x, "city")), sep = "\n")
}
