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

  # pass on to regular R if we have no information about
  # the entire Rmarkdown file and its location
  unknown_knitr_filename <-
    is.null(knitr::current_input(dir = TRUE))
  if (unknown_knitr_filename) {
    # evaluate code
    code_output <- utils::capture.output({
      code_result <-
        eval(parse(text = options$code), envir = globalenv())
    })

    options$engine <- "r"
    return(c(
      code_output,
      knitr::engine_output(
        options = options,
        code = options$code,
        out = code_output
      )
    ))
  }

  # determine path where to store the meta data
  fullpath_of_inputfile <- knitr::current_input(dir = TRUE)
  if (is.null(fullpath_of_inputfile)) {
    # we end up here eg. if people run individual chunks in Rstudio
    if ("rstudioapi" %in% utils::installed.packages()) {
      act_doc <- rstudioapi::getActiveDocumentContext()$path
      path <- dirname(act_doc)
      this_filename <- basename(act_doc)
    } else {
      return("Note: Unable to determine file and chunk name for reproducibility check.")
    }
  } else {
    # we end up here if people render an entire Rmd file
    # through knitr or Rstudio's knitr button
    path <- dirname(fullpath_of_inputfile)
    this_filename <- knitr::current_input()
  }


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
  code_output <- utils::capture.output({
    code_result <-
      eval(parse(text = code), envir = current_env)
  })
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
    paste0(
      path,
      .Platform$file.sep,
      default_prefix(),
      "_",
      this_filename,
      "_",
      label,
      ".",
      default_filetype(),
      collapse = ""
    )

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
    if (utils::hasName(meta_data, "code_fingerprint")) {
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
      add_to_repror_summary(c(label, var, cur_attempt_successful))


    } # end for var in ...



  }

  # update error counter
  increase_error_counter_by(err_counter)

  out <- paste0(output, sep = "", collapse = "\n")
  title <- "Code Chunk Reproduction Report"
  code <- options$code


  template <- default_templates()
  if (utils::hasName(template, output_format)) {
    out <-
      gsub(pattern = "(\\$\\{content\\})",
           replacement = out,
           x = template[[output_format]])
    out <- gsub(pattern = "(\\$\\{title\\})",
                replacement = title,
                x = out)

  } else {
    out <-
      paste0(paste0("### ", title, "\n", collapse = ""),
             out,
             "\n\n",
             collapse = "\n")
    # use knitr superpowers again TODO: improve
    opts_int <- options
    opts_int$engine <- output_format
    opts_int$results <- "asis"
    opts_int$echo <- FALSE # suppress code generation
    out <- knitr::engine_output(options = opts_int,
                                code = "",
                                out = out)

  }

  # merge code result and package output
  if (isFALSE(options$report))
    out <- ""


  # use knitr to prettyprint R output
  opts_int <- options
  opts_int$engine <- "r"
  opts_int$echo <- FALSE # suppress code generation
  code_output_pretty <- knitr::engine_output(options = opts_int,
                                             code = "",
                                             out = code_output)
  #---


  #  out <- c(code_output,"\n", out)

  # use knitr to prettyprint R code
  opts_int <- options
  opts_int$engine <- "r"
  opts_int$code <- ""
  code_pretty <- knitr::engine_output(options = opts_int,
                                      code = code,
                                      out = "")
  # ---



  #options$results <- "asis" # set results to 'asis' for proper display of report summary
  #knitr::engine_output(options, code_pretty, out)
  paste0(code_pretty, code_output_pretty, out)
  # paste0(code_output_pretty)
}
