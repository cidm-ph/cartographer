Small update to improve confusing error message reporting, and improve some
documentation.

## R CMD check results

The package was tested on the following platforms:

* Mac (R: release)
* Windows (R: devel, release, 4.1)
* Ubuntu (R: devel, release, oldrel-1)

There is a note when checking with remote checks about the non-CRAN package rnaturalearthhires.
cartographer needs to check whether this package is installed to avoid triggering an interactive
menu in rnaturalearth (which is on CRAN) with installation instructions.
