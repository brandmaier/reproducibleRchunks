#' @title Add GitHub Action to test reproducibility
#' @description Creates a GitHub Actions workflow that runs
#' [isReproducible()] on all R Markdown files in the repository.
#' The workflow installs Pandoc so that the documents can be rendered.
#' If all files reproduce successfully, a badge file `reproduced.svg`
#' is generated.
#'
#' @param path Path to the workflow file to create.
#'   Defaults to `.github/workflows/reproducibleR.yml`.
#' @return Invisibly returns the path to the created workflow file.
#' @export
use_github_action <- function(path = ".github/workflows/reproducibleR.yml",
                              packages = NULL) {

  yml_existed <- file.exists(path)

  if (yml_existed && interactive()) {
    choice <- utils::menu(c("Yes", "No"), title = "Github action already exists. Overwrite?")
    if (choice != 1) {
      message("Aborted.")
      return(invisible(character()))
    }
  }

  # create github action file
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)

  # determine packages
  if (is.null(packages)) {
    pkglist <- unique(c('reproducibleRchunks', gather_package_names()))
  } else {
    if (!is.vector(packages)) stop("Invalid packages given.")
    if (!is.character(packages)) stop("Invalid packages given.")
    pkglist <- paste0(c('reproducibleRchunks', packages),collapse=",")
  }

  # add quotes (and escape them)
  pkglist <- escapedQuote(pkglist)

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
    "    steps:",
    "      - uses: actions/checkout@v3",
    "      - name: Check if last commit was from github-actions bot",
    "        run: |",
    "          AUTHOR=$(git log -1 --pretty=format:'%an')",
    "          echo \"Last commit author: $AUTHOR\"",
    "          if [ \"$AUTHOR\" = \"github-actions[bot]\" ]; then",
    "           echo \"Commit made by github-actions bot. Exiting.\"",
    "           exit 0",
    "          fi",
    "      - uses: r-lib/actions/setup-r@v2",
    "      - uses: r-lib/actions/setup-pandoc@v2",
    "      - name: Install reproducibleRchunks",
    paste0("        run: R -e \"install.packages(",paste0(pkglist,sep="",collapse=", "),")\""),
    "      - name: Run reproducibility checks",
    "        run: |",
    "          Rscript - <<'EOF'",
    "          library(reproducibleRchunks)",
    "          files <- list.files(pattern = '\\\\.[Rr]md$', recursive = TRUE)",
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
    "          path: reproduced.svg",
    "      - name: Commit and push",
    "        env:",
    "         GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}",
    "        run: |",
    "          git config --global user.name \"github-actions[bot]\"",
    "          git config --global user.email \"github-actions[bot]@users.noreply.github.com\"",
    "          git add reproduced.svg",
    "          git commit -m \"chore: add generated file\" || echo \"No changes to commit\"",
    "          git push https://x-access-token:${GITHUB_TOKEN}@github.com/${{ github.repository }}.git HEAD:${{ github.ref_name }}"

  )

  if (!yml_existed)
    message("Note: Make sure that your GitHub repository has write permissions set. On the repository website, go to Settings -> Action -> General -> Workflow permissions and allow 'Read and write permissions'")

  writeLines(workflow, path)
  invisible(path)
}
