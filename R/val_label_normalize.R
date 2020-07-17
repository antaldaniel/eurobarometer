#' Create Normalized Value Labels
#'
#' Remove relative reference to question blocks, special characters
#' used in regular expressions, whitespace.
#'
#' @param x A vector of the (GESIS) value labels
#' @importFrom retroharmonize val_label_normalize
#' @family naming functions
#' @return A character vector with the normalized value labels.
#' @examples
#' label_normalize (
#'     c('QF4C INTERESTS INFO SOURCES: INTERNET',
#'     'QB15A CHILDREN NEEDS: SOME NEW CLOTHES',
#'     'QB9B RESEARCH INFO SOURCE - PREFERENCE 2ND',
#'     'EU MEANING: CULTURAL DIVERSITY',
#'     'P6 SIZE OF COMMUNITY - AUSTRIA',
#'     'D49D_CY WEBSITES: OTHER',
#'     'LOVE RELATIONSHIP OF CHILD - CHRISTIAN PERSON' )
#' )
#' @export

val_label_normalize <- function(x) {

  y <- tolower(as.character(x))
  retroharmonize::var_label_normalize(y)
}
