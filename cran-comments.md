Dear CRAN maintainers,

this is an update with new features (compatibility with renv, support for github actions, more vignettes) and full backward compatibility. The package was checked both locally and using winbuilder.

Regarding the potential NOTE on the 403 ("forbidden") error when checking a link to the journal Collabra in the README.md: I double-checked that it works in a browser. I assume that Collabra blocks automated access from command line tools like curl.

PS: I now fixed the extra parentheses - thanks Uwe Ligges for your feedback!

## R CMD check results

── R CMD check results ──── reproducibleRchunks 1.2.0 ────
Duration: 42.9s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

R CMD check succeeded

