#' Vocabulary To Rename Categorical Variables With 2 Or 3 Valid Categories
#'
#' The harmonization table of categorical value labels. Currently contains
#' only labels with 2 or 3 categories.  Missing labels are harmonized with the
#' internal function \code{\link{harmonize_missing_values}}.
#'
#' @format A data frame with 150 rows in 3 variables:
#' \describe{
#'   \item{label_norm}{Value labels created by \code{\link{label_normalize}}}
#'   \item{value_numeric}{Harmonized numeric values}
#'   \item{label_harmonized}{Harmonized labels}
#'   \item{valid_range}{Number of valid categories for the variable where this label can be found.}
#'   }
#'   @seealso harmonize_value_labels label_normalize
"label_harmonization_table"
