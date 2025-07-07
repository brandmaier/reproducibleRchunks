escapedQuote <- function(x)
{
  return(gsub('"', '\\\\"', shQuote(x, type = "cmd")))
}
