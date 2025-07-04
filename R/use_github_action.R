#' @title Add GitHub Action to test reproducibility
#' @description Creates a GitHub Actions workflow that runs
#' [isReproducible()] on all R Markdown files in the repository.
#' If all files reproduce successfully, a badge file `reproduced.svg`
#' is generated.
#'
#' @param path Path to the workflow file to create.
#'   Defaults to `.github/workflows/reproducibleR.yml`.
#' @return Invisibly returns the path to the created workflow file.
#' @export
use_github_action <- function(path = ".github/workflows/reproducibleR.yml") {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)

  workflow <- c(
    "name: Reproducibility",
    "on: [push, pull_request]",
    "",
    "jobs:",
    "  check:",
    "    runs-on: ubuntu-latest",
    "    steps:",
    "      - uses: actions/checkout@v3",
    "      - uses: r-lib/actions/setup-r@v2",
    "      - name: Install reproducibleRchunks",
    "        run: R -e \"install.packages('reproducibleRchunks')\"",
    "      - name: Run reproducibility checks",
    "        run: |",
    "          Rscript - <<'EOF'",
    "          library(reproducibleRchunks)",
    "          files <- list.files(pattern = '\\.[Rr]md$', recursive = TRUE)",
    "          success <- all(sapply(files, isReproducible))",
    "          if (success) {",
    "            download.file('https://img.shields.io/badge/reproduced-brightgreen.svg', 'reproduced.svg', mode = 'wb')",
    "          } else {",
    "            download.file('https://img.shields.io/badge/reproduced-failing-red.svg', 'reproduced.svg', mode = 'wb')",
    "            quit(status = 1)",
    "          }",
    "          EOF",
    "      - uses: actions/upload-artifact@v4",
    "        with:",
    "          name: reproduced-badge",
    "          path: reproduced.svg"
  )

  writeLines(workflow, path)
  invisible(path)
}
