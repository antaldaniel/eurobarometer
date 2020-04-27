#' @title Recode A Binary Variable in Multiple Choice
#'
#' @param var A binary variale with multiple choice options
#' @family recode functions
#' @examples
#' #not case sensitive
#' recode_binary  ( var = c("Mentioned", "Not mentioned", "mentioned", "Refusal", "DK") )
#' @export

recode_mentioned <- function ( var ) {

  if ( class(var) == "haven_labelled" )  {
    var <- haven::as_factor (var)
  }

  dplyr::case_when (
    tolower(as.character(var)) == "mentioned" ~ 1,
    tolower(as.character(var)) == "not mentioned" ~ 0,
    TRUE ~ NA_real_)

}



