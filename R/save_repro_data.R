default_filetype <- function()getOption("reproducibleRchunks.filetype", "json")
default_digits <- function()getOption("reproducibleRchunks.digits", 8)
default_hashing <- function()getOption("reproducibleRchunks.hashing", FALSE)
default_hashing_algorithm <- function()getOption("reproducibleRchunks.hashing_algorithm", "sha256")

#' @param {name} {description}
#' @param filename Name (possible including full path) of the save file
save_repro_data <- function(x,
                            filename,
                            filetype=default_filetype(),
                            envir = NULL) {
  if (filetype=="json") {

    exist_all <- all(sapply(x, function(x) { exists(x)} ))
    if (!exist_all) stop("Some objects to be saved do not exist!")

    if (is.null(envir))
     named_list <- lapply(x, function(x){ get(x)})
    else
      named_list <- lapply(x, function(x){ get(x,envir=envir)})

    names(named_list) <- x
    if (isTRUE(default_hashing())) {
      named_list <- lapply(named_list, hash)
    }

    payload <- list(metadata = list(
      hashing = default_hashing(),
      hashing_algorithm = default_hashing_algorithm(),
      hashing_package = "digest",
      hashing_package_version = packageVersion("digest")
    ),
         data = named_list)

    json_data <- jsonlite::serializeJSON(payload, pretty=TRUE, digits = default_digits())
    con <- file(filename)
    writeLines(json_data, con)
    close(con)
  } else if (filetype=="rda") {
    save(list=x, file = filename)
  } else {
    stop("Unknown filetype. Cannot save reproducibility data.")
  }
}

