#'
#' This is the main RMarkdown chunk hook for processing
#' the reproducibility tests
#'
#' @export
#'
reproducibleR <- function(options) {
  path <- dirname(knitr::current_input(dir=TRUE))
  this_filename <- knitr::current_input()
  # initialize empty output vector
  output = c()
  # error counter set to zero
  err_counter = 0
  # get label of chunk, must be non-empty
  label <- options$label
  stopifnot(!is.null(label))
  stopifnot(label!="")
  # get code as a single string
  code <- paste(options$code, collapse = "\n")
  # create an environment for the current reproduction attempt
  current_env <- globalenv()
  existing_var_names <- ls(current_env)
  # evaluate code
  result <- eval(parse(text=code), envir = current_env)
  # get all defined variables
  current_vars <- ls(current_env)
  # remove those that existed already (from previous chunks)
  current_vars <- current_vars[sapply(current_vars,function(x){!x %in% existing_var_names})]
  # set filetype
  # get file with repro values
  filename <- paste0(path,"/",".repro_",this_filename,"_",label,".",default_filetype(),collapse="")
  cat("Filename: ", filename,"\n")
  # does the file exist?
  if (!file.exists(filename)) {
    output <- c(output, "**Creating reproduction file**\n This seems to be the first run of the R Markdown file including reproducible chunks.\nCreating variables: ",paste0("-",current_vars,collapse="\n"))
    # are there any variables defined at all?
    if (length(current_vars)==0) {
      warning("No variables were created. No reproduction report possible for current chunk ",label,".")
    } else {
      # save all defined files
      save_repro_data(current_vars, filename, filetype = "json")
    }

  } else {
    # restore original results
    repro_env <- new.env()
    load_repro_data(filename, envir=repro_env, filetype="json")
    # compare all results
    for (var in ls(repro_env)) {
      original_value <- get(var, envir = repro_env)
      current_value <- get(var, envir = current_env)

      if (is.numeric(current_value)) current_value <- round(current_value,default_digits())
      if (is.numeric(original_value)) original_value <- round(original_value,default_digits())

      if (base::identical(original_value, current_value)) {
        result <- paste0("- ✅  ",var, ": REPRODUCTION SUCCESSFUL")
      } else {
        err_counter = err_counter + 1
        errmsg <- "Objects are not identical."
        if (is.numeric(original_value) && is.numeric(current_value))         {
          if (length(original_value)==1 && length(current_value==1)) {
            errmsg <- paste0("Numbers are not identical: ",original_value," vs ", current_value, collapse="")
          } else {
            num_diff = sum(original_value!=current_value)
            errmsg <- paste0(num_diff , " numbers out of ",length(original_value)," differ!\nOriginal values:",paste0(original_value,collapse=", "),"\n",
                             "Current values: ",
                             paste0(current_value,collapse=", "))
          }

        }
        result <- paste0("- ❌",var, ": **REPRODUCTION FAILED** ",errmsg)
      }
      output <- c(output, result,"\n")
    }
  }

  # update error counter
  num_errors_total = get(x = "repror_error_counter", envir=knitr::knit_global())
  num_errors_total = num_errors_total + err_counter
  assign(x="repror_error_counter",value = num_errors_total, envir=knitr::knit_global())

  #cat(output)
  out <- paste0(output,sep="",collapse="\n")
  out <- paste0("## Reproduction Report\n",out,"\n\n",collapse="\n")
  code <- options$code

  options$results <- "asis"


  if (!is.null(options$report))
    if (isTRUE(options$report)) {

      if (is.null(this_filename)) this_filename <- ""
      filename <- paste0("reproducibility_report_",this_filename,"-",label,".txt")
      con <- file(filename)
      writeLines(text = out, con=con)
      close(con)
    }

  knitr::engine_output(options, code, out)

}
