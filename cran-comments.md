Dear CRAN maintainers,
dear Beni Altmann,

thank you for your helpful feedback on our previous package submission. I fixed all issues as per your request:
- there is no references to the global environment (instead the knitr environment is now used)
- there is more documentation, particularly now including @returns tags
- I use `requireNamespace` instead of `installed.packages()`
- The DOI is properly referenced in the DESCRIPTION

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
