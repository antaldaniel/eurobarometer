
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eurobarometer

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/antaldaniel/eurobarometer.svg?branch=master)](https://travis-ci.com/antaldaniel/eurobarometer)
[![Codecov test
coverage](https://codecov.io/gh/antaldaniel/eurobarometer/branch/master/graph/badge.svg)](https://codecov.io/gh/antaldaniel/eurobarometer?branch=master)
[![Project Status: Minimal or no implementation has been done yet, or
the repository is only intended to be a limited example, demo, or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
“[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)”
“[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/eurobarometer)](https://cran.r-project.org/package=eurobarometer)”
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3901724.svg)](https://doi.org/10.5281/zenodo.3901724)
[![Follow
author](https://img.shields.io/twitter/follow/antaldaniel.svg?style=social)](https://twitter.com/intent/follow?screen_name=antaldaniel)
[![Follow
contributor](https://img.shields.io/twitter/follow/martakolcz.svg?style=social)](https://twitter.com/martakolcz?lang=en)
<!-- badges: end -->

The goal of `eurobarometer` is converting Eurobarometer microdata files,
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

At this moment you cannot install yet the package from
[CRAN](https://CRAN.R-project.org), but there is a development version
on [GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("antaldaniel/eurobarometer")
```

## Workflow

Not all elements of the
[Workflow](http://eurobarometer.danielantal.eu/articles/workflow.html)
are implemented yet.

## Data Preparation For Programmatic Use

The SPSS files in GESIS are not ready for programmatic use in R, because
the variable names often contain reserved special characters. You should
use `gesis_metadata_create()` to understand what are the possible
problems in the SPSS file and how to resolve them. (See: [Working With
Metadata](http://eurobarometer.danielantal.eu/articles/metadata.html))

  - The naming functions `normalize_names()` removes regex symbols,
    whitespace, and basic inconsistencies in abbreviations. The function
    `canonical_names()`harmonizes the names across various GESIS files,
    so that they can be joined into panels across time.

  - You can read in the SPSS file to R in
    [haven](https://haven.tidyverse.org/), which will result in many
    `labelled` variables. The metadata file contains a suggestion of the
    most practical class conversion for data analysis. You can review
    and change this suggestion and then make the conversions at once
    with `convert_class()`

See `vignette("metadata")`

## Joining With Eurostat & Other Data Tables

  - The regional boundaries are consistently used, coded and named -
    this will be harmonized with the package
    [regions](http://regions.danielantal.eu/), which helps resolving
    common issues, and to properly join various Eurobarometer files with
    Eurostat data tables and Google data tables.

  - This will also allow you to create regional statistics from
    Eurobarometer microdata files.

  - Currently `code_nuts1()` and `code_nuts2()` is implemented but this
    will be replaced with a more comprehensive `NUTS0`-`NUTS3` level
    helper function to make the regional coding consistent.

## Code of Conduct

Please note that the `eurobarometer` project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to its terms.
