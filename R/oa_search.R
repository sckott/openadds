#' Search Openaddresses datasets
#'
#' @export
#' @param country (characater) Country name
#' @param state (characater) State (or province) name
#' @param city (characater) City name
#' @param ... Pass on curl options to [oa_list()] and then
#' to [crul::HttpClient()] within that function
#' @return a tibble (a data.frame)
#' @examples \dontrun{
#' # return all data in a data.frame
#' oa_search()
#'
#' # search by various combinations
#' oa_search(country = "us")
#' oa_search(country = "us", state = "ca")
#' oa_search(state = "tx")
#' oa_search(city = "houston")
#' oa_search("us", "nv", "las_vegas")
#' }
oa_search <- function(country = NULL, state = NULL, city = NULL, ...) {
  dd <- oa_list(...)

  all <- Map(function(x, y) {
    tmp <- basename(x)
    ext <- strextract(tmp, "\\.[a-z]+")
    locs <- strsplit(gsub("\\.[a-z]+", "", x), "/")[[1]]
    locs <- if (length(locs) == 4) {
      c(c(locs[1:2], paste0(locs[3:4], collapse = "_")), "")
    } else if (length(locs) == 2) {
      try2 <- tryCatch(as.numeric(locs[2]), warning = function(w) w)
      if (!inherits(try2, "warning")) {
        c(locs[1], "", "", locs[2])
      } else {
        c(locs[1], "", locs[2], "")
      }
    } else if (length(locs) == 1) {
      c(locs[1], "", "", "")
    } else {
      c(locs, "")
    }
    stats::setNames(data.frame(t(c(locs, y)), stringsAsFactors = FALSE),
             c("country", "state", "city", "id", "url"))
  }, dd$source, dd$processed)

  df <- dplyr::bind_rows(all)
  if (length(comp(list(country, state, city))) != 0) {
    df <- sub_set(df, list(country = country, state = state, city = city))
  }
  tibble::as_tibble(df)
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
  df
}
