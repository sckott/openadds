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
#' out3 <- oa_get(dat$processed[368])
#' out4 <- oa_get(dat$processed[788])
#' (alldat <- oa_combine(out1, out2))
#'
#' x <- oa_get(dat$processed[534])
#' y <- oa_get(dat$processed[349])
#' (alldat <- oa_combine(x, y))
#'
#'
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
  locnames <- lapply(lapply(cb, function(z) names(z)), guess_latlon)
  addname <- lapply(lapply(cb, function(z) names(z)), guess_address)
  out <- list()
  for (i in seq_along(cb)) {
    if (!is.null(locnames[[i]])) {
      tmp <- cb[[i]][, unname(unlist(c(locnames[[i]], addname[[i]]))) ]
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
      out[[i]]$dataset <- basename(attr(cb[[i]], "path"))
    }
  }
  structure(dplyr::bind_rows(out),
            class = c("tbl_df", "data.frame", "oa"),
            id = ids, path = paths)
}
