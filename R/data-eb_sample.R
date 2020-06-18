#' Vocabulary To Rename Categorical Variables With Two Valid Categories
#'
#' Later the filename may be omitted.
#' The \code{canonical_name} is suggested for programmatic use in R files.
#' The \code{topic_1}, \code{topic_2} keywords should be later replaced with
#' consistent keywords from various thesauri, if necessary. Or they may be
#' omitted.
#'
#' The treatment of declined answers in \code{level} should probably be
#' excluded later, but in a harmonized way.
#'
#' @format A data frame with 6 rows in 9 variables:
#' \describe{
#'   \item{topic_1}{A temporary first level keyword.}
#'   \item{topic_2}{A temporary second level keyword.}
#'   \item{label_normalized}{The variable label after normalization, as imported from the GESIS SPSS file.}
#'   \item{level}{The number of levels excluding decline.}
#'   \item{character_value}{The preferred variable label as.character}
#'   \item{numeric_value}{A suggested numerical coding, when applicable.}
#'   \item{missing}{A logical variable to indicate if the label in the row represents some level of missingess.}
#'   }
"data-eb_sample"
