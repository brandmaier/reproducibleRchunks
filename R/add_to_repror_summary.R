add_to_repror_summary <- function(x, envir = knitr::knit_global()) {
  temp_data = get0(x = "repror_summary",
                   envir = envir)
  temp_data <- rbind(temp_data,
                     x)
  assign(x = "repror_summary",
         value = temp_data,
         envir = envir)
}
