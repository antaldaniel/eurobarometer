#' Construct A eurobarometer_labelled Variable
#'
#' @param x A vector of numeric values of class integer, numeric,
#' haven_labelled or haven_labelled_spss.
#' @param value_labels The \code{labels} attribute, defaults to \code{NULL}.
#' @param na_values The \code{na_values} attribute, defaults to \code{NULL}.
#' @param na_range The \code{na_range} attribute, defaults to \code{NULL}.
#' @param labels_orig The \code{labels_orig} attribute which contains the original
#' value_labels before harmonization or normalization, defaults to \code{NULL}.
#' @param var_name_orig The \code{var_name_orig} attribute, which
#' contains the original variable name,  defaults to \code{NULL}.
#' @param qb The \code{qb} attribute, which contains the identifier of the
#' question block, defaults to \code{NULL}.
#' @param conversion The \code{conversion} attribute which contains the
#' name of the function that created the variable, defaults to \code{NULL}.
#' @return A vector with metadata attributes of class \code{eurobarometer_labelled}.
#' @examples
#' eurobarometer_labelled(x = c(6,7,8,9,6,7,8),
#'    labels =c("HI" = 6, "HELLO" = 7,
#'              "HOWDY" = 8, "BYE" = 9),
#'    na_values = 9,
#'    qb = "Example Block",
#'    conversion = "eurobarometer_labelled"
#' )
#' @export

eurobarometer_labelled <- function ( x = NULL,
                                     value_labels = NULL,
                                     na_values = NULL,
                                     na_range = NULL,
                                     labels_orig = NULL,
                                     var_name_orig = NULL,
                                     qb = NULL,
                                     conversion = NULL) {

  if ( is.null(x) ) {
    stop ( "Parameter x must be given.")
  }

  if (class(x)[1] =='logical' ) {
    warning ("class <logical> is converted to <integer>.")
    x <- as.integer(x)
  }
  if ( any( class(x) %in% c("integer", "numeric")) ) {
    ebl <- haven::labelled_spss( x = x,
                          labels = value_labels,
                          na_values = na_values,
                          na_range = na_range )
  } else if ( any(class(x) %in% "haven_labelled_spss") ) {
    ebl <- x
  } else if ( class(x)[1] == "haven_labelled") {
    ebl <- haven::labelled_spss (
      x = unclass(x),
      labels = labelled::val_labels(x),
      na_values = na_values,
      na_range = na_range)
  } else {
     stop ( "Parameter x must be of class integer, numeric,
            haven_labelled (labelled), haven_labelled_spss (labelled_spss),
            or logical [which will be converted to integer].")
   }

  if ( !is.null(labels_orig) ) {
    add_labels <- TRUE
    if ( class(labels_orig) != "numeric") {
      warning( "Parameter 'labels_orig' must be a named numeric." )
      add_labels <- FALSE
    }
    if ( class(labelling) != "character" & length(labelling) > 0) {
      warning( "Parameter 'labels_orig' must be a named numeric,
               with at least one value label.")
      add_labels <- FALSE
    }
   if ( add_labels ) {
     attr(ebl, "labels_orig") <- labels_orig

   }
  }

  ebl_class  <- class ( ebl )

  ## eurobarometer_labelled should be the first class for
  ## method dispatch, but keeping original classes for
  ## fall back, particularly labelled classes.

  class (ebl) <-  c("eurobarometer_labelled", ebl_class)

  attr(ebl, "var_name_orig") <- var_name_orig
  attr(ebl, "qb") <- qb
  attr(ebl, "conversion") <- conversion
  ebl
}


