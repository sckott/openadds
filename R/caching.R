#' Manage cached files
#'
#' @export
#' @name oa_cache
#' @param files File name or names
#' @param force (logical) Should files be force deleted? Default:
#' \code{FALSE}
#' @details \code{cache_delete} only accepts 1 file name, while
#' \code{cache_delete_all} doesn't accept any names, but deletes all files.
#' For deleting many specific files, use \code{cache_delete} in a
#' \code{\link{lapply}} type call
#'
#' @details We cache using \code{\link[rappdirs]{user_cache_dir}}, find your
#' cache folder by executing \code{rappdirs::user_cache_dir("openadds-cache")}
#'
#' @examples \dontrun{
#' # list files in cache
#' oa_cache_list()
#'
#' # List info for single files
#' oa_cache_details(files = oa_cache_list()[1])
#' oa_cache_details(files = oa_cache_list()[2])
#'
#' # List info for all files
#' oa_cache_details()
#'
#' # delete files by name in cache
#' # oa_cache_delete(files = oa_cache_list()[1])
#'
#' # delete all files in cache - BE CAREFUL, MAKE SURE YOU WANT TO DO THIS
#' # oa_cache_delete_all()
#' }

#' @export
#' @rdname oa_cache
oa_cache_list <- function() {
  list.files(oa_cache_path(), pattern = ".csv|.zip|.shp|.geojson",
             ignore.case = TRUE, recursive = TRUE, full.names = TRUE)
}

#' @export
#' @rdname oa_cache
oa_cache_delete <- function(files, force = TRUE) {
  if (!all(file.exists(files))) {
    stop("These files don't exist or can't be found: \n",
         strwrap(files[!file.exists(files)], indent = 5), call. = FALSE)
  }
  # find parent folder
  dirs <- list.files(oa_cache_path(), full.names = TRUE)
  files_dir <- unlist(lapply(files, function(z) {
    dirs[vapply(dirs, function(x) grepl(x, z), logical(1))]
  }))
  # delete it
  unlink(files_dir, force = force, recursive = TRUE)
}

#' @export
#' @rdname oa_cache
oa_cache_delete_all <- function(force = TRUE) {
  dirs <- list.files(oa_cache_path(), full.names = TRUE)
  unlink(dirs, force = force, recursive = TRUE)
}

#' @export
#' @rdname oa_cache
oa_cache_details <- function(files = NULL) {
  if (is.null(files)) {
    files <- list.files(oa_cache_path(), pattern = ".csv|.zip|.shp|.geojson",
                        ignore.case = TRUE,
                        full.names = TRUE, recursive = TRUE)
    structure(lapply(files, file_info_), class = "oa_cache_info")
  } else {
    structure(lapply(files, file_info_), class = "oa_cache_info")
  }
}

file_info_ <- function(x) {
  fs <- file.size(x)
  list(file = x,
       type = strextract(basename(x), "\\.zip|\\.csv"),
       size = if (!is.na(fs)) getsize(fs) else NA
  )
}

getsize <- function(x) round(x/10 ^ 6, 3)

#' @export
print.oa_cache <- function(x, ...) {
  cat("<openadds cached files>", sep = "\n")
  cat(" ZIP files: ", strwrap(x$zip, indent = 5), sep = "\n")
  cat(" CSV files: ", strwrap(x$csv, indent = 5), sep = "\n")
}

#' @export
print.oa_cache_info <- function(x, ...) {
  cat("<openadds cached files>", sep = "\n")
  for (i in seq_along(x)) {
    cat(paste0("  File: ", x[[i]]$file), sep = "\n")
    cat(paste0("  Size: ", x[[i]]$size, " mb"), sep = "\n")
    cat("\n")
  }
}

oa_cache_path <- function() rappdirs::user_cache_dir("openadds-cache")
