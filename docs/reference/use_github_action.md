# Add GitHub Action to test reproducibility

Creates a GitHub Actions workflow that runs
[`isReproducible()`](isReproducible.md) on all R Markdown files in the
repository. The workflow installs pandoc so that the documents can be
rendered. Depending on the result, a badge file
`reproducibleRchunks-badge.svg` is generated indicating successful,
failing or unknown reproduction status.

## Usage

``` r
use_github_action(
  files = NULL,
  path = ".github/workflows/reproducibleR.yml",
  packages = NULL
)
```

## Arguments

- files:

  Character. File(s) that should be tested for reproducibility. If NULL,
  all Rmd files in the directory.

- path:

  Path to the workflow file to create. Defaults to
  `.github/workflows/reproducibleR.yml`.

- packages:

  Character. If NULL, necessary R packages are inferred automatically.

## Value

Invisibly returns the path to the created workflow file.
