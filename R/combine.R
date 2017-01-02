#' Combine data helper
#'
#' @export
#' @param ... Data sets, all need to be of class \code{oa}
#' @details Gives back a single \code{tbl_df}, with a subset of columns, currently
#' \code{lon}, \code{lat}, and \code{address}.
#'
#' This function attempts to combine, but may fail sometimes.
#' @return a tibble (a data.frame) of all the inputs combined, with attributes for
#' original urls and paths on disk
#' @examples \dontrun{
#' dat <- oa_list()
#'
#' out1 <- oa_get(dat$processed[5])
#' out2 <- oa_get(dat$processed[35])
#' (alldat <- oa_combine(out1, out2))
#'
#' out4 <- oa_get(dat$processed[788])
#' (alldat <- oa_combine(out2, out4))
#'
#' if (!requireNamespace("leaflet")) {
#'   install.packages("leaflet")
#' }
#' library("leaflet")
#' leaflet(alldat) %>%
#'   addTiles() %>%
#'   addCircles(lat = ~lat, lng = ~lon, popup = ~address)
#' }
oa_combine <- function(...) {
  cb <- list(...)
  classes <- vapply(cb, inherits, logical(1), what = "oa")
  if (!all(classes)) stop("all inputs must be of class 'oa'", call. = FALSE)

  ids <- vapply(cb, attr, "", which = "id")
  paths <- vapply(cb, attr, "", which = "path")
  readmes <- vapply(cb, attr, "", which = "readme")

  dnames <- unlist(lapply(cb, function(z) {
    rep(attr(z, "name"), length(z))
  }))

  # unnest list of data.frames
  cbdat <- unlist(cb, recursive = FALSE)

  locnames <- lapply(lapply(cbdat, function(z) names(z)), guess_latlon)
  addname <- lapply(lapply(cbdat, function(z) names(z)), guess_address)

  out <- list()
  for (i in seq_along(cbdat)) {
    if (!is.null(locnames[[i]])) {
      tmp <- cbdat[[i]][, unname(unlist(c(locnames[[i]], addname[[i]]))) ]
      nms <- c('lon', 'lat', 'address')
      nms <- if (length(addname[[i]]) == 1) {
        out[[i]] <- stats::setNames(tmp, nms)
      } else {
        tmp$address <- strtrim(apply(tmp[, addname[[i]]], 1, paste, collapse = " "))
        for (j in seq_along(addname[[i]])) {
          tmp[[ addname[[i]][[j]] ]] <- NULL
        }
        out[[i]] <- stats::setNames(tmp, nms)
      }
      out[[i]]$dataset <- dnames[i]
    }
  }
  structure(dplyr::bind_rows(out),
            class = c("tbl_df", "data.frame", "oa"),
            id = ids, path = paths, readme = readmes)
}
