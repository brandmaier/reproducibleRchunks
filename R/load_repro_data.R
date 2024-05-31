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
    for (i in 1:length(json_lst)) {
      var_name <- names(json_lst)[i]
      assign(x=var_name, value=json_lst[[i]], envir=envir)
    }
  } else if (tolower(filetype)=="rda") {
    load(file=filename, envir=envir)
  } else {
    stop("Filetype is not supported!")
  }
}
