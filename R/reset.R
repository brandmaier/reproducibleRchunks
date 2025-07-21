#' @title Delete reproducibility files
#' @description
#' Deletes all meta data in the current directory, that is,
#' deletes all files in the current working directory that start with
#' \code{default_prefix()} and end with \code{default_filetype()}.
#'
#' @param interactive Logical. If \code{TRUE} (the default), the user is asked
#'   for confirmation before files are removed.
#'
#' @return Invisibly returns the vector of deleted files.
#' @export
reset <- function(interactive = NULL) {
  files <- get_all_metadata_files()

  if (is.null(interactive)) {
    interactive = base::interactive()
  } else {
    interactive = match(interactive, c(TRUE,FALSE))
  }

  if (length(files) == 0) {
    message("No files found.")
    return(invisible(character()))
  }

  if (isTRUE(interactive)) {
    cat("Files to be deleted:\n")
    cat(paste0(" - ", files), sep = "\n")
    choice <- utils::menu(c("Yes", "No"), title = "Delete all files above?")
    if (choice != 1) {
      message("Aborted.")
      return(invisible(character()))
    }
  }

  unlink(files)
  invisible(files)
}
