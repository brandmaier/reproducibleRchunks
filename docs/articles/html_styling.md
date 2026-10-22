# Conditional Backgrounds

This document contains the following metaparameters in the YAML header
of the Markdown file

``` yaml
reproducibleR:
  conditional_backgroundcolor: true
```

This turns on dynamic coloring of code blocks that do not reproduce. In
the following code blocks with failures to reproduce get a light red
background color.

``` r
library(reproducibleRchunks)
```

The following code is set up to reproduce fine:

``` r
a <- 1
b <- 2
```

##### Code Chunk Reproduction Report

- ✅a: REPRODUCTION SUCCESSFUL

- ✅b: REPRODUCTION SUCCESSFUL

The next code block is set up to fail:

``` r
today <- date()
rnd <- rnorm(1)
```

##### Code Chunk Reproduction Report

- ❌.Random.seed: **REPRODUCTION FAILED** Fingerprints are not
  identical.

- ❌rnd: **REPRODUCTION FAILED** Fingerprints are not identical.

- ❌today: **REPRODUCTION FAILED** Fingerprints are not identical.
