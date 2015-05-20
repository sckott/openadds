#' Combine data helper
#'
#' @export
#' @importFrom dplyr rbind_all
#' @param ... Data sets, all of class \code{oa}
#' @details Gives back a single \code{tbl_df}, with a subset of columns, currently
#' \code{lon}, \code{lat}, and \code{address}
#' @examples \dontrun{
#' dat <- oa_list()
#'
#' out1 <- oa_get(dat[5])
#' out2 <- oa_get(dat[32])
#' (alldat <- oa_combine(out1, out2))
#'
#' out3 <- oa_get(dat[368])
#' out4 <- oa_get(dat[788])
#' (alldat <- oa_combine(out1, out2))
#'
#' x <- oa_get(dat[535])
#' y <- oa_get(dat[349])
#' (alldat <- oa_combine(x, y))
#' library("leaflet")
#' leaflet(alldat) %>%
#'   addTiles() %>%
#'   addCircles(lat = ~lat, lng = ~lon, popup = ~address)
#' }
oa_combine <- function(...) {
  cb <- list(...)
  classes <- vapply(cb, is, logical(1), class2 = "oa")
  if (!all(classes)) stop("all inputs must be of class 'oa'", call. = FALSE)
  locnames <- lapply(lapply(cb, function(z) names(z$data)), guess_latlon)
  addname <- lapply(lapply(cb, function(z) names(z$data)), guess_address)
  out <- list()
  for (i in seq_along(cb)) {
    if (!is.null(locnames[[i]])) {
      tmp <- cb[[i]]$data[, unname(unlist(c(locnames[[i]], addname[[i]]))) ]
      nms <- c('lon', 'lat', 'address')
      nms <- if (length(addname[[i]]) == 1) {
        out[[i]] <- setNames(tmp, nms)
      } else {
        tmp$address <- strtrim(apply(tmp[, addname[[i]]], 1, paste, collapse = " "))
        for (j in seq_along(addname[[i]])) {
          tmp[[ addname[[i]][[j]] ]] <- NULL
        }
        out[[i]] <- setNames(tmp, nms)
      }
      out[[i]]$dataset <- basename(attr(cb[[i]], "path"))
    }
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
      message("No long/lat columns detected, dataset dropped")
      return(NULL)
      # stop("Couldn't infer longitude/latitude columns, please specify with 'lat'/'lon' parameters", call. = FALSE)
    }
  } else {
    return(list(lon = lon, lat = lat))
  }
}

guess_address <- function(x, add = NULL) {
  if (is.null(add)) {
    tf <- x[grep("^(full_addr|fulladdr)$", x, ignore.case = TRUE)]
    if (length(tf) == 0) tf <- x[grep("^(add|addr|address|stname|owneraddre)$", x, ignore.case = TRUE)]
    if (length(tf) == 0) {
      tf <- x[grep("^(street|number)$", x, ignore.case = TRUE)]
    }
    if (length(tf) >= 1) {
      message("Assuming '", paste(tf, collapse = ", "), "' is the address")
      return(tf)
    } else {
      message("No address columns detected, no address data used")
      return(NULL)
      # stop("Couldn't infer the address column, please specify with the 'add' parameter", call. = FALSE)
    }
  } else {
    return(add)
  }
}
