# reproducibleRchunks 1.0.3

* new function `isReproducible()` allows checking whether a given R Markdown file reproduces or not
* package metadata now contains comprehensive information about R version
* reproducibility information is now stored in an internal environment called `.cache`

# reproducibleRchunks 1.0.2

* Removed global environment references according to CRAN policy
* Improved documentation with more descriptions and return values
* Removed usage of installed.packages() according to CRAN policy
* Object comparisons are now made via `all.equal()` instead of `identical()`

# reproducibleRchunks 1.0.1

* Added a `NEWS.md` file to track changes to the package.
