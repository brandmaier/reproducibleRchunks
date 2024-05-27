
load_repro_data <- function(filename, envir=globalenv(),filetype=c("json","rda")) {
  if (filetype=="json") {
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
  } else {
    load(file=filename, envir=envir)
  }
}
