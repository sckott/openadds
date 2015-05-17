#' Combine data helper
#'
#' @export
#' @importFrom dplyr rbind_all
#' @param ... Data sets, all of class \code{oa}
#' @details Gives back a single \code{tbl_df}, with a subset of columns, currently
#' \code{lon}, \code{lat}, and \code{address}
#' @examples \dontrun{
#' dat <- list_data()
#' out1 <- oa_get(dat[5])
#' out2 <- oa_get(dat[32])
#' (alldat <- combine(out1, out2))
#' }
combine <- function(...) {
  cb <- list(...)
  classes <- vapply(cb, is, logical(1), class2 = "oa")
  if (!all(classes)) stop("all inputs must be of class 'oa'", call. = FALSE)
  locnames <- lapply(sapply(cb, function(z) names(z$data)), guess_latlon)
  addname <- lapply(sapply(cb, function(z) names(z$data)), guess_address)
  out <- list()
  for (i in seq_along(cb)) {
    tmp <- cb[[i]]$data[, unlist(c(locnames[[i]], addname[[i]])) ]
    out[[i]] <- setNames(tmp, c('lon', 'lat', 'address'))
  }
  rbind_all(out)
}

###### code adapted from the leaflet package - source at github.com/rstudio/leaflet
guess_latlon <- function(x, lat = NULL, lon = NULL) {
  if (is.null(lat) && is.null(lon)) {
    lats <- x[grep("^(lat|latitude|OA:y)$", x, ignore.case = TRUE)]
    lngs <- x[grep("^(lon|lng|long|longitude|OA:x)$", x, ignore.case = TRUE)]

    if (length(lats) == 1 && length(lngs) == 1) {
      if (length(x) > 2) {
        message("Assuming '", lngs, "' and '", lats,
                "' are longitude and latitude, respectively")
      }
      return(list(lon = lngs, lat = lats))
    } else {
      stop("Couldn't infer longitude/latitude columns, please specify with 'lat'/'lon' parameters", call. = FALSE)
    }
  } else {
    return(list(lon = lon, lat = lat))
  }
}

guess_address <- function(x, add = NULL) {
  if (is.null(add)) {
    tf <- x[grep("^(full_addr|fulladdr)$", x, ignore.case = TRUE)]
    if (length(tf) == 0) tf <- x[grep("^(add|addr|address|stname)$", x, ignore.case = TRUE)]
    if (length(tf) == 1) {
      message("Assuming '", tf, "' is the address")
      return(tf)
    } else {
      stop("Couldn't infer the address column, please specify with the 'add' parameter", call. = FALSE)
    }
  } else {
    return(add)
  }
}
