#' @title Recode gender variable
#'
#' The harmonize demography function create a harmonized labelling or value
#' setting for standard demography variables.
#'
#' @param var The gender variable, such as \code{gender}, \code{D10 GENDER},
#' or the Turkish Cypriot Community equivalents.
#' @family recode functions
#' @examples
#' #not case sensitive
#' recode_gender  ( var = c("Man", "Female", "man", "Woman" ))
#' @export



recode_gender <- function ( var ) {

  var <- tolower(as.character(var))
  ifelse ( var %in% c("man", "male"), "m", "f")

}
