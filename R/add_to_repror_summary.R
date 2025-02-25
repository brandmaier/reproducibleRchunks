add_to_repror_summary <- function(x, envir = knitr::knit_global()) {
  temp_data = get0(x = "repror_summary",
                   envir = envir)
  temp_data <- rbind(temp_data,
                     data.frame(
                       Chunk = x[1],
                       Variable = x[2],
                       Success = as.logical(x[3])
                     ))
  assign(x = "repror_summary",
         value = temp_data,
         envir = envir)
}
