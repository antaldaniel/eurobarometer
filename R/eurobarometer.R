#' eurobarometer: A package to create tidy Eurobarometer microdata files.
#'
#' @section naming functions:
#' The naming functions make the GESIS SPSS files usable in a programmatic
#' context.
#' \code{\link{label_normalize}} removes regex symbols, whitespace, and
#' basic inconsistencies in abbreviations.
#' \code{\link{canonical_names}} harmonizes the names across various GESIS
#' files, so that they can be joined into panels across time.
#'
#' @section metadata functions:
#' The metadata functions map the SPSS file and suggest variable names,
#' re-labelling and class conversions.
#' \code{\link{gesis_metadata_create}}
#' \code{\link{gesis_vocabulary_create}}
#' \code{\link{gesis_corpus_create}} is a wrapper the two former functions.
#' @docType package
#' @name eurobarometer
NULL
