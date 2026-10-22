Dear CRAN maintainers,

this is an update with some bugfixes. In addition, fingerprints are not computed
based on a canonical object representation, which ignores orders of attributes and
is tolerant to small numerical differences.

Regarding the potential NOTE on the 503 ("forbidden") error when checking a link to the journal Collabra in the README.md: I double-checked that it works in a browser. I assume that Collabra blocks automated access from command line tools like curl.


## R CMD check results

── R CMD check results ───── reproducibleRchunks 1.2.1 ────
Duration: 1m 52.6s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

R CMD check succeeded

