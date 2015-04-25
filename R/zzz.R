# print.oa <- function(x, ..., n = 10){
#   cat(sprintf("<NOAA ERDDAP griddap> %s", attr(x, "datasetid")), sep = "\n")
#   cat(sprintf("   Path: [%s]", attr(x, "path")), sep = "\n")
#   if(attr(x, "path") != "memory"){
#     finfo <- file_info(attr(x, "path"))
#     cat(sprintf("   Last updated: [%s]", finfo$mtime), sep = "\n")
#     cat(sprintf("   File size:    [%s]", finfo$size), sep = "\n")
#   }
#   cat(sprintf("   Dimensions:   [%s X %s]\n", NROW(x), NCOL(x)), sep = "\n")
#   trunc_mat_(x, n = n)
# }
