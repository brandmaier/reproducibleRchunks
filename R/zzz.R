
.onLoad <- function(libname, pkgname){
  assign(x="repror_error_counter",value = 0, envir=knitr::knit_global())
  knitr::knit_engines$set(reproducibleR = reproducibleR)
  op <- options()
  op_add <- list(reproducibleRchunks.filetype = "json",
                 reproducibleRchunks.digits = 8)
  toset <- !(names(op_add) %in% names(op))
  if(any(toset)) options(op_add[toset])
  invisible()
}
