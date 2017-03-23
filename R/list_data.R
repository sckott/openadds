#' List available data
#'
#' @export
#' @param ... Pass on curl options to \code{\link[crul]{HttpClient}}
#' @return A tibble (a data.frame)
#' @examples \dontrun{
#' (res <- oa_list())
#'
#' # mean address count per state/country/etc
#' mean(res$`address count`, na.rm = TRUE)
#' }
oa_list <- function(...) {
  cli <- crul::HttpClient$new(
    url = "http://results.openaddresses.io/state.txt",
    opts = list(...)
  )
  temp <- cli$get()
  temp$raise_for_status()
  readr::read_tsv(temp$parse("UTF-8"))
}
