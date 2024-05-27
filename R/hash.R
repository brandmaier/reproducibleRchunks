hash <- function(x) {
  digest::digest(x, algo="sha256", serialize=TRUE)
}
