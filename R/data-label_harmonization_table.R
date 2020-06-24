#' Vocabulary To Rename Categorical Variables With Two Valid Categories
#'
#' The harmonization table of categorical value labels. Currently contains
#' only valid binary values.  Missing labels are harmonized with the
#' internal function \code{\link{harmonize_missing_values}}.
#'
#' @format A data frame with 84 rows in 3 variables:
#' \describe{
#'   \item{label_norm}{Value labels created by \code{\link{label_normalize}}}
#'   \item{value_numeric}{Harmonized numeric values}
#'   \item{label_harmonized}{Harmonized labels}
#'   }
#'   @seealso harmonize_value_labels label_normalize
"label_harmonization_table"
