#' Convert Harmonized And Labelled To Numeric
#'
#' Convert a harmonized, labelled variable created by
#' \code{\link{harmonize_value_labels}} to the numeric class.
#'
#' @param harmonized_labelled_var A harmonized labelled var created
#' by \code{\link{harmonize_value_labels}}
#' @examples
#' \dontrun{
#' v <- labelled::labelled(c(3,4,4,3,8, 9),
#'              c(YES = 3, NO = 4, wrong_label = 8, refused = 9)
#'              )
#' input_labelled_var = harmonize_value_labels(v,2)
#'
#' harmonize_to_numeric(input_labelled_var)
#' }
#' @export

harmonize_to_numeric <- function( harmonized_labelled_var ) {

  ifelse ( as.numeric(harmonized_labelled_var) < 8900,
           as.numeric(harmonized_labelled_var),
           NA_real_)
}
