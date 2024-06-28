
ok_symbol <- function(fmt="undef") {
  if (is.null(fmt)) fmt<-"undef"
  if (fmt=="html")
    return("✅  ")
  else
    return("OK ")
}

fail_symbol <- function(fmt="undef") {
  if (is.null(fmt)) fmt<-"undef"
  if (fmt=="html")
    return("❌")
  else
    return("[x] ")
}

warning_symbol <- function(fmt="undef") {
  if (is.null(fmt)) fmt<-"undef"
  if (fmt=="html")
    return("&#9888;")
  else
    return("/!\\")
}
