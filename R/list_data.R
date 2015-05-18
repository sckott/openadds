#' List available data
#'
#' @importFrom xml2 read_html xml_find_all xml_attr
#' @export
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' res <- oa_list()
#' res[5]
#' }
oa_list <- function(...) {
  res <- GET(get_link(), ...)
  tt <- content(res, "text")
  ht <- xml2::read_html(tt)
  links <- xml2::xml_find_all(ht, "//a")
  hrefs <- xml2::xml_attr(links, "href")
  unique(grep("\\.csv|\\.zip", hrefs, value = TRUE))
}

get_link <- function() {
  res <- GET(oa_base(), config(followlocation = TRUE))
  tt <- content(res, "text")
  file.path(oa_base(), paste0(strextract(tt, "runs/[0-9\\.]+"), "/index.html"))
}
