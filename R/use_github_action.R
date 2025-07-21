#' @title Add GitHub Action to test reproducibility
#' @description Creates a GitHub Actions workflow that runs
#' [isReproducible()] on all R Markdown files in the repository.
#' The workflow installs Pandoc so that the documents can be rendered.
#' Depending on the result, a badge file `reproduced.svg` is generated
#' indicating successful, failing or unknown reproduction status.
#'
#' @param files Character. File(s) that should be tested for reproducibility. If NULL, all Rmd files in the directory.
#' @param path Path to the workflow file to create.
#'   Defaults to `.github/workflows/reproducibleR.yml`.
#' @param packages Character. If NULL, necessary R packages are inferred automatically.
#' @return Invisibly returns the path to the created workflow file.
#' @export
use_github_action <- function(files= NULL,
                              path = ".github/workflows/reproducibleR.yml",
                              packages = NULL) {

  yml_existed <- file.exists(path)
  is_renv <- file.exists("renv.lock")

  if (yml_existed && interactive()) {
    choice <- utils::menu(c("Yes", "No"), title = "Github action already exists. Overwrite?")
    if (choice != 1) {
      message("Aborted.")
      return(invisible(character()))
    }
  }

  # create github action file
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)

  # basic packages (for rmarkdown::render() to work)
  # TODO: is there a way to remove these because
  # they may actually not be needed depending on how
  # isReproducible() performs the checks
  pkgs_basic <- c('reproducibleRchunks')#,'knitr','shiny','ggplot2','thematic')

  # determine packages
  if (is.null(packages)) {
    if (is_renv) {
      pkglist <- c(pkgs_basic, 'renv')
    } else {
      pkglist <- unique(c(pkgs_basic, gather_package_names()))
    }

  } else {
    if (!is.vector(packages)) stop("Invalid packages given.")
    if (!is.character(packages)) stop("Invalid packages given.")
    pkglist <- c(pkgs_basic, packages)
  }

  # determine if renv was used, if so
  # ignore inferred packages and use renv later
  # to restore packages
  # renv should be activated anyway if .Rprofile is checked in
  if (is_renv) {
    renv_cmd <- "          renv::restore()"
  } else {
    renv_cmd <- ""
  }

  # make package list unique
  pkglist <- unique(pkglist)

  # add quotes (and escape them)
  pkglist <- escapedQuote(pkglist, double=TRUE)

  # assemble string
  if (length(pkglist)==1) {
    pkglist_str = pkglist
  } else {
    pkglist_str = paste0("c(",paste0(pkglist,sep="",collapse=", "),")")
  }

  # assemble Rmd files to reproduce
  if (is.null(files)) {
    files <- list.files(pattern = '\\.[Rr]md$', recursive = FALSE)
  } else {
    if (!is.character(files)) stop("Given files are invalid.")
  }
  files <- escapedQuote(files, double=FALSE)
  file_lst <- paste0("c(",paste(files,sep="",collapse=","),")")

  # create workflow yml
  workflow <- c(
    "name: Reproducibility",
    "on:",
    "  push:",
    "    paths-ignore:",
    "      - reproduced.svg",
    "",
    "permissions:",
    "  contents: write",
    "",
    "jobs:",
    "  check:",
    "    runs-on: ubuntu-latest",
    "    container:",
    "      image: rocker/verse:latest  # Contains R + RStudio + tidyverse + rmarkdown",
    "    steps:",
    "      - name: Install packages",
    paste0("        run: R -e \"install.packages(",pkglist_str,")\""),
"      - uses: actions/checkout@v4",
"      - name: Check if last commit was from github-actions bot",
"        run: |",
"          git config --global --add safe.directory /__w/${{github.event.repository.name}}/${{github.event.repository.name}}",
"          AUTHOR=$(git log -1 --pretty=format:'%an')",
"          echo \"Last commit author: $AUTHOR\"",
"          if [ \"$AUTHOR\" = \"github-actions[bot]\" ]; then",
"           echo \"Commit made by github-actions bot. Exiting.\"",
"           exit 0",
"          fi",
    "      - name: Run reproducibility checks",
    "        run: |",
    "          Rscript - <<'EOF'",
    "          library(reproducibleRchunks)",
    renv_cmd,
    paste0("          files <- ",file_lst),
    "          success <- all(sapply(files, isReproducible))",
    "          if (is.na(success)) {",
    "            download.file('https://img.shields.io/badge/reproducibility_status-unknown-black.svg', 'reproduced.svg', mode = 'wb')",
    "          } else if (success) {",
    "            download.file('https://img.shields.io/badge/reproduced-brightgreen.svg', 'reproduced.svg', mode = 'wb')",
    "          } else {",
    "            download.file('https://img.shields.io/badge/reproduction-failed-red.svg', 'reproduced.svg', mode = 'wb')",
    "          }",
    "          EOF",
    "      - uses: actions/upload-artifact@v4",
    "        with:",
    "          name: reproduced-badge",
    "          path: reproduced.svg",
    "      - name: Commit and push",
    "        env:",
    "         GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}",
    "        run: |",
    "          git config --global user.name \"github-actions[bot]\"",
    "          git config --global user.email \"github-actions[bot]@users.noreply.github.com\"",
    "          git add reproduced.svg",
    "          git commit -m \"reproducibleRchunks: updated reproducibility status\" || echo \"No changes to commit\"",
    "          git push https://x-access-token:${GITHUB_TOKEN}@github.com/${{ github.repository }}.git HEAD:${{ github.ref_name }}"

  )

  if (!yml_existed)
    message("Note: Make sure that your GitHub repository has write permissions set. On the repository website, go to Settings -> Action -> General -> Workflow permissions and allow 'Read and write permissions'")

  writeLines(workflow, path)
  invisible(path)
}
