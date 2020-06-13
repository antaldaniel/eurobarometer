#' eurobarometer: A package to create tidy Eurobarometer microdata files.
#'
#' The regions package provides four categories of important functions:
#' validate, recode, impute and aggregate.
#'
#' @section naming functions:
#' The naming functions make the GESIS SPSS files usable in a programmatic
#' context.
#' \code{\link{normalize_names}} removes regex symbols, whitespace, and
#' basic inconsistencies in abbreviations.
#' \code{\link{canonical_names}} harmonizes the names across various GESIS
#' files, so that they can be joined into panels across time.
#'
#' @docType package
#' @name eurobarometer
NULL
