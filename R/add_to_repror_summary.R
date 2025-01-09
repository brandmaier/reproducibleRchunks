add_to_repror_summary <- function(x, envir = knitr::knit_global()) {
  temp_data = get0(x = "repror_summary",
                   envir = envir)
  temp_data <- rbind(temp_data,
                     x)
  names(temp_data) <- c("Chunk","Variable","Success") # no need to do this everytime
  assign(x = "repror_summary",
         value = temp_data,
         envir = envir)
}
