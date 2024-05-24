
save_repro_data <- function(x, filename, filetype=c("json","rda")) {
  if (filetype=="json") {
    named_list <- lapply(x, function(x){ get(x)})
    names(named_list) <- x
    json_data <- jsonlite::serializeJSON(named_list, pretty=TRUE, digits = 8)
    con <- file(filename)
    writeLines(json_data, con)
    close(con)
  } else if (filetype=="rda") {
    save(list=x, file = filename)
  }
}

