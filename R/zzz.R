.cache <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  default_envir <- knitr::knit_global()

  .reset(.cache)

  knitr::knit_engines$set(reproducibleR = reproducibleR)
  #op <- options()
  #op_add <- list(
  #  reproducibleRchunks.filetype = "json",
  #  reproducibleRchunks.digits = 8
  #)
  #toset <- !(names(op_add) %in% names(op))
  #if (any(toset))
  #  options(op_add[toset])
  invisible()
}


.reset <- function(envir = .cache) {

  assign(x = "repror_error_counter",
         value = 0,
         envir = envir)
  assign(
    x = "repror_summary",
    value = data.frame(
      Chunk = character(),
      Variable = character(),
      Success = logical()
    ),
    envir = envir
  )
}

default_filetype <-
  function()
    getOption("reproducibleRchunks.filetype", "json")
default_digits <-
  function()
    getOption("reproducibleRchunks.digits", 10)
default_hashing <-
  function()
    getOption("reproducibleRchunks.hashing", TRUE)
default_hashing_algorithm <-
  function()
    getOption("reproducibleRchunks.hashing_algorithm", "sha256")
default_prefix <-
  function()
    getOption("reproducibleRchunks.prefix", ".repro")
default_templates <-
  function()
    getOption(
      "reproducibleRchunks.templates",
      list(html = "<div style='border: 3px solid black; padding: 10px 10px 10px 10px; background-color: #EEEEEE;'><h5>${title}</h5>${content}</div>",
           latex = "\\hrulefill \n \\section{${title}} \\medskip \\small  ${content}\n \\hrulefill \n")
    )
default_msg_success <-
  function()
    getOption("reproducibleRchunks.msg_success",": REPRODUCTION SUCCESSFUL")
default_msg_failure <-
  function()
    getOption("reproducibleRchunks.msg_failure",": **REPRODUCTION FAILED** ")
