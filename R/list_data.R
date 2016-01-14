#' List available data
#'
#' @export
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#' @return A data.frame
#' @examples \dontrun{
#' (res <- oa_list())
#' # mean address count
#' mean(res$`address count`, na.rm = TRUE)
#' }
oa_list <- function(...) {
  res <- httr::GET("http://results.openaddresses.io/state.txt", ...)
  tt <- httr::content(res, "text")
  readr::read_tsv(tt)
}
# ht <- xml2::read_html(tt)
# links <- xml2::xml_find_all(ht, "//a")
# hrefs <- xml2::xml_attr(links, "href")
# unique(grep("\\.csv|\\.zip", hrefs, value = TRUE))

# get_link <- function() {
#   res <- GET(oa_base(), config(followlocation = TRUE))
#   tt <- content(res, "text")
#   # file.path(oa_base(), paste0(strextract(tt, "runs/[0-9\\.]+"), "/index.html"))
#   paste0(xml2::xml_text(xml2::xml_find_all(xml2::read_html(tt), "//body")),
#          "/index.html")
# }
