

get_num_reproducibility_errors <- function() {
  get(x = "repror_error_counter", envir=knitr::knit_global())
}

get_reproducibility_summary <- function() {
  num_errors_total = get_num_reproducibility_errors()

  if (num_errors_total==0) {
    return("Reproduction succeeded. All results were reproduced exactly.")
  } else {
    return(paste0("Reproduction failed. There were ",num_errors_total," non-reproducible results!"))
  }
}


