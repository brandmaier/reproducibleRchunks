#' @export
#' @title Test reproducibility of an R Markdown file
#'
#' @param filename An R Markdown file to check for reproducibility
#' @param \ldots Optional arguments passed down to rmarkdown::render()
#'
isReproducible <- function(filename, env = knitr::knit_global(),
                           ...)
{
  if (!file.exists(filename)) stop("File does not exist")
  if (!endsWith(tolower(filename),"rmd")) warning("Possibly not an Rmd file")

  # this is R's global environment by default
  #temp_envir <- knitr::knit_global()

  .reset(env)

  rmarkdown::render(input = filename,
                    envir = env,
                    quiet = TRUE,
                    ...)

  if (nrow(get_reproducibility_summary()) == 0) {
    warning("No reproducibility information found! Could not evaluate reproducibility status.")
    return(NA)
  }

  all(get_reproducibility_summary()$Success)

}
