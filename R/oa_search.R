#' Search Openaddresses datasets
#'
#' @export
#' @param country (characater) Country name
#' @param state (characater) State (or province) name
#' @param city (characater) City name
#' @param ext (characater) One of \code{.zip} or \code{.csv}
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # return all data in a data.frame
#' oa_search()
#'
#' # search by various combinations
#' oa_search(country = "us")
#' oa_search(country = "us", state = "ca")
#' oa_search(state = "tx")
#' oa_search(city = "houston")
#' oa_search(ext = ".zip")
#' }
oa_search <- function(country = NULL, state = NULL, city = NULL, ext = NULL, ...) {
  dd <- oa_list()[-1]
  all <- lapply(dd, function(x) {
    tmp <- basename(x)
    ext <- strextract(tmp, "\\.[a-z]+")
    locs <- strsplit(gsub("\\.[a-z]+", "", tmp), "-")[[1]]
    locs <- if (length(locs) == 4) {
      c(locs[1:2], paste0(locs[3:4], collapse = "_"))
    } else if (length(locs) == 2) {
      c(locs[1:2], "")
    } else if (length(locs) == 1) {
      c(locs[1], "", "")
    } else {
      locs
    }
    setNames(data.frame(t(c(locs, ext, x)), stringsAsFactors = FALSE),
             c("country", "state", "city", "ext", "url"))
  })
  df <- rbind_all(all)
  if (length(comp(list(country, state, city, ext))) == 0) {
    return(df)
  } else {
    sub_set(df, list(country = country, state = state, city = city, ext = ext))
  }
}

sub_set <- function(df, x) {
  vars <- comp(x)
  if ("country" %in% names(vars)) {
    df <- df[ df$country == vars$country, ]
  }
  if ("state" %in% names(vars)) {
    df <- df[ df$state == vars$state, ]
  }
  if ("city" %in% names(vars)) {
    df <- df[ df$city == vars$city, ]
  }
  if ("ext" %in% names(vars)) {
    df <- df[ df$ext == vars$ext, ]
  }
  df
}
