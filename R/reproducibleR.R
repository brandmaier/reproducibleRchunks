#' @title Knitr Hook
#'
#' @author Andreas M. Brandmaier
#' @name reproducibleR
#'
#' @description This is the main RMarkdown chunk hook for processing
#' the automated reproducibility tests of code chunks
#' @details
#' This function first executes the R code from a given chunk.
#'
#'
#'
#' @param options A list of chunk options passed from the knitr engine.
#'
#' @export
#'
reproducibleR <- function(options) {

  # abort if chunk option eval==FALSE
  if (isFALSE(options$eval)) {
    return(knitr::engine_output(options, options$code, ""))
  }

  path <- dirname(knitr::current_input(dir = TRUE))
  this_filename <- knitr::current_input()
  # determine requested output format
  output_format <- knitr::pandoc_to()
  if (is.null(output_format))
    output_format <- "undef"
  # initialize empty output vector
  output = c()
  # error counter set to zero
  err_counter = 0
  # get label of chunk, must be non-empty
  label <- options$label
  stopifnot(!is.null(label))
  stopifnot(label != "")
  # get code as a single string
  code <- paste(options$code, collapse = "\n")
  # build code fingerprint
  code_fingerprint <- digest::digest(code, algo = "sha256")
  # create an environment for the current reproduction attempt
  current_env <- knitr::knit_global()#globalenv()
  existing_var_names <- ls(current_env)
  # evaluate code
  code_result <- eval(parse(text = code), envir = current_env)
  # get all defined variables
  current_vars <- ls(current_env)
  # remove those that existed already (from previous chunks)
  current_vars <-
    current_vars[sapply(current_vars, function(x) {
      !x %in% existing_var_names
    })]
  # set filetype
  # get file with repro values
  filename <-
    paste0(path,
           .Platform$file.sep,
           default_prefix(),
           "_",
           this_filename,
           "_",
           label,
           ".",
           default_filetype(),
           collapse = "")

  # does the file exist?
  if (!file.exists(filename)) {
    output <-
      c(
        output,
        "**Creating reproduction file**\n This seems to be the first run of the R Markdown file including reproducible chunks.\nStoring reproducibility information for variables:\n ",
        paste0("- ", current_vars, collapse = "\n")
      )
    # are there any variables defined at all?
    if (length(current_vars) == 0) {
      warning(
        "No variables were created. No reproduction report possible for current chunk ",
        label,
        "."
      )
    } else {
      # save all defined files
      save_repro_data(
        current_vars,
        filename,
        filetype = "json",
        envir = current_env,
        extra = list(code_fingerprint = code_fingerprint)
      )
    }

  } else {
    # restore original results
    repro_env <- new.env()
    meta_data <- load_repro_data(filename,
                                 envir = repro_env,
                                 filetype = "json")

    # compare code fingerprint (if exists)
    if (hasName(meta_data, "code_fingerprint")) {
      if (!identical(meta_data$code_fingerprint, code_fingerprint)) {
        output <-
          c(
            warning_symbol(output_format),
            " Warning: Current code chunk fingerprint and stored code chunk fingerprint mismatch. Likely, the code chunk was modified after reproduction data was stored the first time.\n",
            output
          )
      }

    }

    # check whether variables are the same in current
    # and reproduction data?
    # TODO not implemented yet

    # compare all results
    for (var in ls(repro_env)) {

      cur_attempt_successful <- FALSE

      original_value <- get(var, envir = repro_env)

      if (!exists(var, envir = current_env)) {
        output <-
          c(
            output,
            fail_symbol(),
            "Reproduction error! Variable ",
            var,
            " was not defined in this chunk!"
          )
        next
      }
      current_value <- get(var, envir = current_env)

      if (isTRUE(default_hashing())) {
        current_value <- hash(current_value)
      }

      if (is.numeric(current_value))
        current_value <- round(current_value, default_digits())
      if (is.numeric(original_value))
        original_value <- round(original_value, default_digits())

      if (base::identical(original_value, current_value)) {
        result <-
          paste0("- ",
                 ok_symbol(output_format),
                 var,
                 ": REPRODUCTION SUCCESSFUL")
        cur_attempt_successful <- TRUE
      } else {
        err_counter = err_counter + 1
        if (isTRUE(default_hashing())) {
          errmsg <- "Fingerprints are not identical."
        } else {
          errmsg <- "Objects are not identical."

          if (is.character(original_value) &&
              is.character(current_value)) {
            errmsg <-
              paste0("Character vectors differ: ",
                     original_value,
                     " vs ",
                     current_value)
          }

          # generate more informative error message for numeric values
          if (is.numeric(original_value) &&
              is.numeric(current_value))         {
            if (length(original_value) == 1 && length(current_value == 1)) {
              errmsg <-
                paste0(
                  "Numbers are not identical: ",
                  original_value,
                  " vs ",
                  current_value,
                  collapse = ""
                )
            } else {
              num_diff = sum(original_value != current_value)
              errmsg <-
                paste0(
                  num_diff ,
                  " numbers out of ",
                  length(original_value),
                  " differ!\nOriginal values:",
                  paste0(original_value, collapse = ", "),
                  "\n",
                  "Current values: ",
                  paste0(current_value, collapse = ", ")
                )
            }

          }
        }


        result <-
          paste0("- ",
                 fail_symbol(output_format),
                 var,
                 ": **REPRODUCTION FAILED** ",
                 errmsg)
      }
      output <- c(output, result, "\n")

      # store information
      temp_data = get(x = "repror_summary",
                      envir = knitr::knit_global())
      temp_data <- rbind(temp_data,
                         c(label,var,cur_attempt_successful))
      assign(x = "repror_summary",
             value = temp_data,
             envir = knitr::knit_global())


    } # end for var in ...



  }

  # update error counter
  num_errors_total = get(x = "repror_error_counter", envir = knitr::knit_global())
  num_errors_total = num_errors_total + err_counter
  assign(x = "repror_error_counter",
         value = num_errors_total,
         envir = knitr::knit_global())

  out <- paste0(output, sep = "", collapse = "\n")
  title <- "Code Chunk Reproduction Report"
  code <- options$code

  options$results <- "asis"

  # write a separate report file (DELETE ME...)
 # if (!is.null(options$reportfile))
    # if (isTRUE(options$reportfile)) {
    #   if (is.null(this_filename))
    #     this_filename <- ""
    #   filename <-
    #     paste0("reproducibility_report_",
    #            this_filename,
    #            "-",
    #            label,
    #            ".txt")
    #   con <- file(filename)
    #   writeLines(text = out, con = con)
    #   close(con)
    # }

      template <- default_templates()
      if (hasName(template, output_format)) {
        out <-
          gsub(pattern = "(\\$\\{content\\})",
               replacement = out,
               x = template[[output_format]])
        out <- gsub(pattern = "(\\$\\{title\\})",
                    replacement = title,
                    x = out)

      } else {
        out <-
          paste0(paste0("###", title, collapse = ""), out, "\n\n", collapse = "\n")
      }

  # merge code result and package output
  if (isFALSE(options$report)) out <- ""
  out <- c(code_result,"\n", out)

  knitr::engine_output(options, code, out)

}
