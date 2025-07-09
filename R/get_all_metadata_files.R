#' find all metadata files
#'
get_all_metadata_files <- function()
{
prefix <- default_prefix()
filetype <- default_filetype()
pattern <- paste0("^", prefix, ".*\\.", filetype, "$")
files <- list.files(pattern = pattern, all.files = TRUE)
return(files)

}
