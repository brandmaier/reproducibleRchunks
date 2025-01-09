default_filetype <-
  function()
    getOption("reproducibleRchunks.filetype", "json")
default_digits <-
  function()
    getOption("reproducibleRchunks.digits", 8)
default_hashing <-
  function()
    getOption("reproducibleRchunks.hashing", TRUE)
default_hashing_algorithm <-
  function()
    getOption("reproducibleRchunks.hashing_algorithm", "sha256")
default_prefix <-
  function()
    getOption("reproducibleRchunks.prefix", ".repro")
default_templates <-
  function()
    getOption(
      "reproducibleRchunks.templates",
      list(html = "<div style='border: 3px solid black; padding: 10px 10px 10px 10px; background-color: #EEEEEE;'><h5>${title}</h5>${content}</div>",
           latex = "\\hrulefill \n \\section{${title}} \\medskip \\small  ${content}\n \\hrulefill \n")
    )

#' @title Storing reproducibility data
#' @param x Object to be stored.
#' @param filename Name (possible including full path) of the save file
#' @param envir Environment to load the objects into. By default, this is the global environment.
#' @param filetype Character. Currently supported is json and rda.
#' @param extra List. Extra payload to store in the meta data
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
        digits = default_digits()
      ),
      data = named_list
    )

    # add extra information to payload (if given)
    if (!is.null(extra)) {
      for (key in names(extra)) {
        payload$metadata[[key]] <- extra[[key]]
      }
    }

    json_data <- jsonlite::serializeJSON(payload,
                                         pretty = TRUE,
                                         digits = default_digits())
    con <- file(filename)
    writeLines(json_data, con)
    close(con)
  } else if (tolower(filetype) == "rda") {
    save(list = x, file = filename)
  } else {
    stop("Unknown filetype. Cannot save reproducibility data.")
  }
}
