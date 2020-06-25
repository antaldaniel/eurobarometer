#' GESIS Eurobarometer Variable Labels
#'
#' Variable labels used for the harmonization of questionnaire items,
#' created by \code{\link{gesis_vocabulary_create}}.
#'
#' @format A data_frame:
#' \describe{
#'   \item{var_label_orig}{The name of the variable in the data file.}
#'   \item{val_numeric_orig}{The original SPSS numeric values, if applicable}
#'   \item{val_label_orig}{The original SPSS character value, if applicable}
#'   \item{val_oder_orig}{The rank number of the alphabetically sorted answer option.}
#'   \item{val_order_length}{The number of answer options in the questionnaire item.}
#'   \item{label_normalized}{Normalized version of the questionnaire item}
#'   \item{filename}{The name of the original GESIS file.}
#' }
#' @seealso gesis_vocabulary_create
"eurobarometer_corpus"


