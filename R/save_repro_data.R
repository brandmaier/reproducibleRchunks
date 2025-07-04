#' @title Storing reproducibility data
#' @param x Object to be stored.
#' @param filename Name (possible including full path) of the save file
#' @param envir Environment to load the objects into. By default, this is the global environment.
#' @param filetype Character. Currently supported is json and rda.
#' @param extra List. Extra payload to store in the meta data
#'
#' @returns No return value
#'
#' @seealso [load_repro_data()]
#'
#' @export
save_repro_data <- function(x,
                            filename,
                            filetype = default_filetype(),
                            envir = NULL,
                            extra = NULL) {
  # search the calling frame for definitions, ignore
  # local definitions such as x, filename, filetype
  if (is.null(envir))
    envir = sys.parent()

  if (tolower(filetype) == "json") {
    exist_all <- all(sapply(x, function(x) {
      if (is.null(envir))
        exists(x)
      else
        exists(x, envir = envir)
    }))
    if (!exist_all) {
      missing_obj_names <- names(which(sapply(x, function(x) {
        if (is.null(envir))
          ! exists(x)
        else
          ! exists(x, envir = envir)

      })))
      stop("Some objects to be saved do not exist: ",
           paste0(missing_obj_names, collapse = ", "))
    }

    if (is.null(envir))
      named_list <- lapply(x, function(x) {
        get(x)
      })
    else
      named_list <- lapply(x, function(x) {
        get(x, envir = envir)
      })

    names(named_list) <- x
    if (isTRUE(default_hashing())) {
      named_list <- lapply(named_list, hash)
    }

    payload <- list(
      metadata = list(
        hashing = default_hashing(),
        hashing_algorithm = default_hashing_algorithm(),
        hashing_package = "digest",
        hashing_package_version = utils::packageVersion("digest"),
        digits = default_digits(),
        R_version = base::R.version
      ),
      data = named_list
    )

    # add extra information to payload (if given)
    if (!is.null(extra)) {
      for (key in names(extra)) {
        payload$metadata[[key]] <- extra[[key]]
      }
    }

    digits <- default_digits()
    # this is a heuristic to increase numeric precision
    # when raw data is stored, otherwise identity-test
    # may run into problems with numeric precision
    #if (isFALSE(default_hashing())) digits <- 16

    json_data <- jsonlite::serializeJSON(payload,
                                         pretty = TRUE,
                                         digits = digits)
    con <- file(filename)
    writeLines(json_data, con)
    close(con)
  } else if (tolower(filetype) == "rda") {
    save(list = x, file = filename)
  } else {
    stop("Unknown filetype. Cannot save reproducibility data.")
  }

  return()
}
