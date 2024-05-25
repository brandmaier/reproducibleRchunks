default_filetype <- function()getOption("reproducibleRchunks.filetype", "json")
default_digits <- function()getOption("reproducibleRchunks.digits", 8)
save_repro_data <- function(x, filename, filetype=default_filetype()) {
  if (filetype=="json") {
    named_list <- lapply(x, function(x){ get(x)})
    names(named_list) <- x
    json_data <- jsonlite::serializeJSON(named_list, pretty=TRUE, digits = default_digits())
    con <- file(filename)
    writeLines(json_data, con)
    close(con)
  } else if (filetype=="rda") {
    save(list=x, file = filename)
  }
}

