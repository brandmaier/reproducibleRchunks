Dear CRAN maintainers,
dear Beni Altmann,

this is an update with new features (better support of code chunk options provided by the knitr package) and full backward compatibility. The package was checked locally and using winbuilder.

Regarding the potential NOTE on the 403 ("forbidden") error when checking a link to the journal Collabra in the README.md: I double-checked that it works in a browser. I assume that Collabra blocks automated access from command line tools like curl.

## R CMD check results

❯ checking for future file timestamps ... NOTE
  unable to verify current time

0 errors ✔ | 0 warnings ✔ | 1 note ✖

