#' List available data
#'
#' @export
#' @param ... Pass on curl options to \code{\link[httr]{GET}}
#' @return A tibble (a data.frame)
#' @examples \dontrun{
#' (res <- oa_list())
#' # mean address count
#' mean(res$`address count`, na.rm = TRUE)
#' }
oa_list <- function(...) {
  res <- httr::GET("http://results.openaddresses.io/state.txt", ...)
  tt <- httr::content(res, "text", encoding = "UTF-8")
  readr::read_tsv(tt)
}
