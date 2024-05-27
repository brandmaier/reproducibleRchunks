hash <- function(x) {
  digest::digest(x, algo=default_hashing_algorithm(), serialize=TRUE)
}
