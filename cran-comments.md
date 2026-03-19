Avoid using internal C APIs. Now accessed via rlang, which itself uses those same internal
APIs but is working with upstream to expose suitable alternatives.

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

The package was tested on the following platforms:

* Mac (R: release)
* Windows (R: devel, release, 4.1)
* Ubuntu (R: devel, release, oldrel-1)
