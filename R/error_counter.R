increase_error_counter_by <- function(x, envir = knitr::knit_global())
{
  # get value from environment (return NULL if not exists)
  num_errors_total = get0(x = "repror_error_counter",
                         envir = envir)

  if (is.null(num_errors_total)) num_errors_total <- 0

  # increase value
  num_errors_total = num_errors_total + x

  # assign value to environment
  assign(x = "repror_error_counter",
       value = num_errors_total,
       envir = envir)
}
