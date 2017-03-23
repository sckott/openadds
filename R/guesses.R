###### code adapted from the leaflet package - source at
### github.com/rstudio/leaflet
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
      # stop("Couldn't infer longitude/latitude columns,
      # please specify with 'lat'/'lon' parameters", call. = FALSE)
    }
  } else {
    return(list(lon = lon, lat = lat))
  }
}

guess_address <- function(x, add = NULL) {
  if (is.null(add)) {
    tf <- x[grep("^(full_addr|fulladdr)$", x, ignore.case = TRUE)]
    if (length(tf) == 0) tf <- x[grep("^(add|addr|address|stname|owneraddre)$",
                                      x, ignore.case = TRUE)]
    if (length(tf) == 0) {
      tf <- x[grep("^(street|number)$", x, ignore.case = TRUE)]
    }
    if (length(tf) >= 1) {
      message("Assuming '", paste(tf, collapse = ", "), "' is the address")
      return(tf)
    } else {
      message("No address columns detected, no address data used")
      return(NULL)
      # stop("Couldn't infer the address column, please specify with
      # the 'add' parameter", call. = FALSE)
    }
  } else {
    return(add)
  }
}
