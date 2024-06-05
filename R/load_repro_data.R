#' @export
#' @title Loading reproducibility data
#'
#' @param filename Character. Filename to load objects from.
#' @param envir Environment to load the objects into. By default, this is the global environment.
#' @param filetype Character. Currenlty supported is json and rda.
load_repro_data <- function(filename, envir=globalenv(),filetype=c("json","rda")) {
  if (tolower(filetype)=="json") {
    con <- file(filename)
    json_data <- paste0(readLines(con))
    close(con)
    json_payload <- jsonlite::unserializeJSON(json_data)
    json_lst <- json_payload$data
    json_meta <- json_payload$metadata

    if (json_meta$hashing_algorithm != default_hashing_algorithm())
    {
      stop("Hashing algorith mismatch between Markdown and JSON file!")
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
      assign(x=var_name, value=json_lst[[i]], envir=envir)
    }
  } else if (tolower(filetype)=="rda") {
    load(file=filename, envir=envir)
  } else {
    stop("Filetype is not supported!")
  }

  return(json_meta)
}
