.cache <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  default_envir <- knitr::knit_global()

  .reset(.cache)

  knitr::knit_engines$set(reproducibleR = reproducibleR)
  #op <- options()
  #op_add <- list(
  #  reproducibleRchunks.filetype = "json",
  #  reproducibleRchunks.digits = 8
  #)
  #toset <- !(names(op_add) %in% names(op))
  #if (any(toset))
  #  options(op_add[toset])
  invisible()
}


.reset <- function(envir = .cache) {

  assign(x = "repror_error_counter",
         value = 0,
         envir = envir)
  assign(
    x = "repror_summary",
    value = data.frame(
      Chunk = character(),
      Variable = character(),
      Success = logical()
    ),
    envir = envir
  )
}
