# reproducibleRchunks


## Demo

Install the package and render `test.Rmd` to assess reproducibility of its R code chunks. Each code chunk will render a reproducibility report. One chunk is set up to fail to demonstrate the package.

## Mechanics

The package executes reproducibleR code chunks as regular R code and gathers information about all variables that are newly defined in the chunk. The contents of those variables are stored in a separate JSON data file (which is labelled according to the original Markdown file and the chunk label). Once the document is re-generated and JSON data files exist, their content is checked against the newly computed chunk variables for identity.

## Notes

Do not store critical and/or large data in reproducibleR chunks. In particular, do not store raw data (too large and possible breach of data protection laws), passwords (security risk as they are stored in clear text), etc.
