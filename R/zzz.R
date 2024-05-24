
.onLoad <- function(libname, pkgname){
  assign(x="repror_error_counter",value = 0, envir=knitr::knit_global())

  knitr::knit_engines$set(reproducibleR = reproducibleR)

}
