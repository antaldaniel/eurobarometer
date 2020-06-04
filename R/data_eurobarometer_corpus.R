#' GESIS Eurobarometer Variable Labels
#'
#' Variable labels used for the harmonization of questionnaire items,
#' created by \code{\link{gesis_corpus_create}}, which is in turn a
#' wrapper around  \code{\link{gesis_vocabulary_create}}.
#'
#' @format A data_frame:
#' \describe{
#'   \item{r_name}{The name of the variable in the data file.}
#'   \item{numeric_value}{The original SPSS numeric values, if applicable}
#'   \item{character_value}{The original SPSS character value, if applicable}
#'   \item{label}{The label of the questionnaire item}
#'   \item{label_normalized}{Normalized version of the questionnaire item}
#'   \item{filename}{The name of the original GESIS file.}
#' }
#' @seealso gesis_corpus_create gesis_vocabulary_create
"eurobarometer_vocabulary"


