#' @inheritParams retroharmonize::as_factor
#' @export
as_factor <- retroharmonize::as_factor

#' @inheritParams retroharmonize::as_numeric
#' @export
as_numeric <- retroharmonize::as_numeric

#' @inheritParams retroharmonize::as_character
#' @export
as_character <- retroharmonize::as_character

#' Create a metadata table
#'
#' Create a metadata table from the survey data files. This is a generic
#' solution imported from retroharmonize.
#'
#' @details The structure of the returned tibble:
#' \describe{
#'   \item{filename}{The original file name; if present; \code{missing}, if a non-\code{\link{survey}} data frame is used as input \code{survey}.}
#'   \item{id}{The ID of the survey, if present; \code{missing}, if a non-\code{\link{survey}} data frame is used as input \code{survey}.}
#'   \item{var_name_orig}{The original variable name in SPSS.}
#'   \item{class_orig}{The original variable class after importing with\code{\link[haven]{read_spss}}.}
#'   \item{label_orig}{The original variable label in SPSS.}
#'   \item{labels}{A list of the value labels.}
#'   \item{valid_labels}{A list of the value labels that are not marked as missing values.}
#'   \item{na_labels}{A list of the value labels that refer to user-defined missing values.}
#'   \item{na_range}{An optional range of a continuous missing range, if present in the vector.}
#'   \item{n_labels}{Number of categories or unique levels, which may be different from the sum of missing and category labels.}
#'   \item{n_valid_labels}{Number of categories in the non-missing range.}
#'   \item{n_na_labels}{Number of categories of the variable, should be the sum of the former two.}
#'   \item{na_levels}{A list of the user-defined missing values.}
#' }
#'
#' @inheritParams retroharmonize::metadata_create
#' @family metadata functions
#' @export
metadata_create <- retroharmonize::metadata_create


#' Document survey lists
#'
#' Document survey lists, imported from retroharmonize.
#'
#' @inheritParams retroharmonize::document_waves
#' @family metadata functions
#' @export
document_waves <- retroharmonize::document_waves
