#' @title Rescale a 4-element ordinary scale variable
#'
#' @param x A variable from the data set with four-level, ordinary
#' scale variable.
#' @param factor_4_highest Defaults to \code{3}, if an natural language
#' expression is given, it will create a character vector. (See example.)
#' @param factor_4_high = Defaults to \code{2}.
#' @param factor_4_low = Defaults to \code{1},
#' @param factor_4_lowest = Defaults to \code{0}.
#' @importFrom dplyr case_when
#' @family rescale functions
#' @return Depending on the rescaling inputs, a numeric or character vector.
#' @examples
#' x = c("fairly easy", "very easy", "very easy", "not at all easy", "not very easy")
#' rescale_factor_4(x,
#'                  factor_4_highest = 'highest',
#'                  factor_4_high = 'high',
#'                  factor_4_low = 'low',
#'                  factor_4_lowest = 'lowest' )
#' @export

rescale_factor_4 <- function (x,
                              factor_4_highest = 3,
                              factor_4_high = 2,
                              factor_4_low = 1,
                              factor_4_lowest = 0 ) {

  ## Determine input classes ----------------------
  input_classes <- c(class( factor_4_highest),
    class(factor_4_high),
    class(factor_4_low),
    class(factor_4_lowest)
  )

  if ( all ( input_classes == 'numeric')  ) {
    return_type <- 'numeric'
  } else return_type <- 'character'

  x <- tolower(as.character(x))

  if ( return_type  == 'numeric' ) {

    dplyr::case_when ( grepl("very", str_sub(x,1,10)) ~ 3,
                grepl("fairly", str_sub(x,1,10)) ~ 2,
                grepl("not very", str_sub(x,1,10)) ~ 1,
                grepl("not at all", str_sub(x,1,10)) ~ 0,
                grepl("dk|decline", str_sub(x,1,10)) ~ NA_real_,
                TRUE ~ NA_real_)
  }

  if ( return_type  == 'character' ) {

    dplyr::case_when ( grepl("very", str_sub(x,1,10)) ~ factor_4_highest,
                grepl("fairly", str_sub(x,1,10)) ~ factor_4_high,
                grepl("not very", str_sub(x,1,10)) ~ factor_4_low,
                grepl("not at all", str_sub(x,1,10)) ~ factor_4_lowest,
                grepl("dk|decline", str_sub(x,1,10)) ~ NA_character_,
                TRUE ~ NA_character_)
  }

}

