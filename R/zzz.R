strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

strtrim <- function(str) gsub("^\\s+|\\s+$", "", str)

oa_base <- function() "http://data.openaddresses.io"

comp <- function (l) Filter(Negate(is.null), l)
