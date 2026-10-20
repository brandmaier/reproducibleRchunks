# Using renv with reproducibleRchunks

## Introduction

This vignette demonstrates how to create a small project using `renv`
for dependency management. We will initialize a project, install the
`psych` package, and run a simple factor analysis on one of the datasets
that ships with that package, all while using `reproducibleRchunks`.

## Creating a project

First, inside your R project, initialize `renv` to track and manage
package dependencies:

``` r
# Initialize renv
renv::init()
```

`renv` creates a project-specific library and writes a lock file to
record package versions. Your R session will be restarted (if running
inside RStudio). Next we install the `psych` package as well as the
`reproducibleRchunks` in the managed environment:

``` r
renv::install("psych")
renv::install("reproducibleRchunks")
```

After installation, snapshot the project state so the lock file is
updated:

``` r
renv::snapshot(prompt = FALSE)
```

## Running a factor analysis

With the packages installed and recorded, we can load `psych` and run a
quick factor analysis on the `bfi` dataset that comes with that package.
The following code chunk could now be a part of an R Markdown document
inside your project:

``` r
library(psych)

# Use the first 200 cases of the bfi dataset for speed
bfi_subset <- head(bfi, 200)

fa_result <- fa(bfi_subset[, 1:10], nfactors = 3)
#> Loading required namespace: GPArotation
fa_result
#> Factor Analysis using method =  minres
#> Call: fa(r = bfi_subset[, 1:10], nfactors = 3)
#> Standardized loadings (pattern matrix) based upon correlation matrix
#>      MR2   MR1   MR3   h2   u2 com
#> A1  0.01 -0.19  0.47 0.32 0.68 1.3
#> A2  0.10  0.51 -0.33 0.53 0.47 1.8
#> A3  0.00  0.83  0.00 0.69 0.31 1.0
#> A4  0.14  0.47  0.21 0.23 0.77 1.6
#> A5 -0.06  0.73  0.00 0.52 0.48 1.0
#> C1  0.65 -0.01 -0.05 0.43 0.57 1.0
#> C2  0.72  0.04  0.14 0.52 0.48 1.1
#> C3  0.66 -0.02  0.01 0.43 0.57 1.0
#> C4 -0.53  0.03  0.25 0.37 0.63 1.4
#> C5 -0.41 -0.02  0.12 0.20 0.80 1.2
#> 
#>                        MR2  MR1  MR3
#> SS loadings           1.88 1.81 0.54
#> Proportion Var        0.19 0.18 0.05
#> Cumulative Var        0.19 0.37 0.42
#> Proportion Explained  0.44 0.43 0.13
#> Cumulative Proportion 0.44 0.87 1.00
#> 
#>  With factor correlations of 
#>       MR2   MR1   MR3
#> MR2  1.00  0.22 -0.13
#> MR1  0.22  1.00 -0.36
#> MR3 -0.13 -0.36  1.00
#> 
#> Mean item complexity =  1.2
#> Test of the hypothesis that 3 factors are sufficient.
#> 
#> df null model =  45  with the objective function =  2.35 with Chi Square =  457.46
#> df of  the model are 18  and the objective function was  0.13 
#> 
#> The root mean square of the residuals (RMSR) is  0.03 
#> The df corrected root mean square of the residuals is  0.05 
#> 
#> The harmonic n.obs is  199 with the empirical chi square  19.98  with prob <  0.33 
#> The total n.obs was  200  with Likelihood Chi Square =  24.42  with prob <  0.14 
#> 
#> Tucker Lewis Index of factoring reliability =  0.961
#> RMSEA index =  0.042  and the 90 % confidence intervals are  0 0.081
#> BIC =  -70.95
#> Fit based upon off diagonal values = 0.98
#> Measures of factor score adequacy             
#>                                                    MR2  MR1   MR3
#> Correlation of (regression) scores with factors   0.88 0.90  0.69
#> Multiple R square of scores with factors          0.77 0.81  0.48
#> Minimum correlation of possible factor scores     0.54 0.63 -0.04
```

###### Code Chunk Reproduction Report

- ✅bfi_subset: REPRODUCTION SUCCESSFUL

- ❌fa_result: **REPRODUCTION FAILED** Fingerprints are not identical.

This chunk is executed with `reproducibleR`, so fingerprints of
`bfi_subset` and `fa_result` are stored for later reproducibility
checks.

Note that if you operate inside RStudio, RStudio will ask your
permission to install all packages necessary to render Markdown files
inside your managed environment.

## Restoring the environment

If you share your project, others can reproduce the same setup by
calling
[`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html)
in the project directory. This will install the recorded package
versions and allow them to re-run the analyses above with verified
reproducibility.

``` r
renv::restore()
```

## GitHub actions

If you host your project on GitHub, you can add a github action that
automatically verifies reproduction in the GitHub cloud:

``` r
reproducibleRchunks::use_github_action()
```

Depending on whether reproduction succeeded of failed, a badge is
generated and added and committed to your repository. This is how the
badges look like depending on the status:

![](https://img.shields.io/badge/reproduced-brightgreen.svg) or
![](https://img.shields.io/badge/reproduction-failed-red.svg)
