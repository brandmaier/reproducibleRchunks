#' @export
#' @title Loading reproducibility data
#'
#' @description
#' This function loads reproducibility meta data from a file
#' and stores the meta information about the variable contents
#' in the specified environment. Reproducibility
#' meta data can be loaded from either a json (preferred) or
#' a binary saved R object. The function returns a named list
#' with meta information restored from file. The named elements include
#' "hashing" indicating whether a hashing algorithm was used,
#' "hashing_algorithm" indicating the name of the hashing algorithm,
#' "hashing_package" indicating the name of the R package, from which
#' the hashing algorithm was used, "hashing_package_version" indicating
#' the package version, "digits" the numeric precision used before hashing
#' numeric values, and "code_fingerprint" the actual hashed string of the chunk code.
#'
#' @param filename Character. File name to load objects from.
#' @param envir Environment to load the objects into. By default, this is the global environment.
#' @param filetype Character. Currently supported is json and rda.
#'
#' @seealso [save_repro_data()]
#'
#' @returns Returns a named list with meta information restored from file. See description for more details.
#'
load_repro_data <-
  function(filename,
           envir,
           filetype = c("json", "rda")) {

    filetype = match.arg(filetype)

    if (tolower(filetype) == "json") {
      con <- file(filename)
      json_data <- paste0(readLines(con))
      close(con)
      json_payload <- jsonlite::unserializeJSON(json_data)
      json_lst <- json_payload$data
      json_meta <- json_payload$metadata

      if (json_meta$hashing_algorithm != default_hashing_algorithm())
      {
        stop("Hashing algorithm mismatch between Markdown and JSON file!")
      }
      if (json_meta$hashing_package != "digest") {
        stop("Unsupported R package for hashing in JSON file!")
      }
      if (json_meta$hashing != default_hashing()) {
        stop("Hashing vs. raw data mismatch between Markdown and JSON file!")
      }

      # TODO    if (json$hashing_package_version != ...) {}

      for (i in 1:length(json_lst)) {
        var_name <- names(json_lst)[i]
        assign(x = var_name,
               value = json_lst[[i]],
               envir = envir)
      }
    } else if (tolower(filetype) == "rda") {
      load(file = filename, envir = envir)
    } else {
      stop("Filetype is not supported!")
    }

    return(json_meta)
  }
