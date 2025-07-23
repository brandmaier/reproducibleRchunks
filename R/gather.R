#'
#' @title Gather Package Names
#' @description
#' Searches all meta data in the current directory for
#' information on what R packages are necessary to
#' reproduce the Markdown files.
#'
#' @returns A character vector of R package names.
#'
#'
#' @export
gather_package_names <- function()
{
  prefix <- default_prefix()
  filetype <- default_filetype()
  pattern <- paste0("^", prefix, ".*\\.", filetype, "$")
  files <- list.files(pattern = pattern, all.files = TRUE)

  if (length(files)==0) {
    invisible(character())
  }

  pkg_names <- c()

  tmp_envir <- new.env()

  for (file in files) {
    meta <- load_repro_data(filename = file, envir = tmp_envir)

    if (utils::hasName(x=meta, "session_info")) {
      pkgs <- meta$session_info$otherPkgs
      pkg_names <- c(pkg_names, sapply(pkgs, function(x){x$Package}))
    }

    if (utils::hasName(x=meta, "packages")) {
      pkg_names <- c(pkg_names, meta$packages)
    }
  }

  return(unique(pkg_names))
}
