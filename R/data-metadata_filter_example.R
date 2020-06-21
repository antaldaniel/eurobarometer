#' Example file for the Creating Variable and Values Tables vignette
#'
#' @format A data frame with 4743 observations and 14 variables:
#' \describe{
#'   \item{class_orig}{The original variable class after importing with\code{\link[haven]{read_spss}}}
#'   \item{var_name_orig}{The original variable name in SPSS}
#'   \item{var_label_norm}{A normalized version of the variable labels}
#'   \item{var_name_suggested}{A partly canonized variable name.}
#'   \item{factor_levels}{A list of factor levels, i.e. value labels in SPSS}
#'   \item{class_suggested}{A suggested class conversion.}
#'   \item{filename}{The original file name}
#'   \item{n_categories}{The original number of categories}
#'   \item{val_label_norm}{A normalized version of the value labels}
#'   \item{val_label_orig}{The original value label}
#'   \item{var_numeric_orig}{The original numeric value}
#'   \item{var_order_alpha}{Sorted order of the value label}
#'   \item{var_order_length}{Total number of value labels of the variable}
#'   \item{var_label_orig}{The original variable label in SPSS}
#'   }
"metadata_filter_example"
