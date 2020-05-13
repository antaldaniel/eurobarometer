
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eurobarometer

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/antaldaniel/eurobarometer/branch/master/graph/badge.svg)](https://codecov.io/gh/antaldaniel/eurobarometer?branch=master)
[![Project Status: Minimal or no implementation has been done yet, or
the repository is only intended to be a limited example, demo, or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
“[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)”
“[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/regions)](https://cran.r-project.org/package=eurobarometer)”
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3825700.svg)](https://doi.org/10.5281/zenodo.3825700)
<!-- badges: end -->

The goal of eurobarometer is converting Eurobarometer microdata files,
as stored by GESIS, into tidy R data frames and help common
pre-processing problems.

Please report all issues to
[github.com/antaldaniel/eurobarometer/issues](https://github.com/antaldaniel/eurobarometer/issues).

Pull requests are welcome on
[github.com/antaldaniel/eurobarometer](\(https://github.com/antaldaniel/eurobarometer/issues\))
from all potential contributors who abide by the terms of the
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).

If you use `eurobarometer` in your work, please [cite the
package](https://doi.org/10.5281/zenodo.3825700).

## Installation

At this moment you cannot install yest the packgae from
[CRAN](https://CRAN.R-project.org), but there is a development version
on [GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("antaldaniel/eurobarometer")
```

## Reading in an SPSS file from GESIS

First of all, we create a representation of the GESIS archive SPSS file
that can be programatically used in R. One problem is that SPSS variable
names may contain reserved characters. For further programmatic use in
R, the best is to rename the variables.

``` r
library(eurobarometer)
library(eurobarometer)
gesis_spss_read ( path = file.path('data-raw', 'example.sav'), 
                  rename = TRUE, 
                  unique_id = TRUE)
```

This setting the function calls `canonical_file_rename()` which removes
spaces and special characters, and converts all variable names to
lowercase. Similarly, by default the serial identifiers of observations
(rows) in the SPSS file are brought to the harmonized name `unique_id`.
This ID is unique in the single survey data file, but not if you create
panel trend files.

If you are planning to work in R with certain files, it makes sense to
save the result of this function as an R data object with `save()` or
`saveRDS()` somewhere. Conversion from SPSS is a rather
resource-intensive operation.

## Code of Conduct

Please note that the eurobarometer project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to its terms.
