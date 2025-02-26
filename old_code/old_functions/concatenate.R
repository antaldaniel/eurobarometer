#' @title Concatenate haven_labelled_spss vectors
#'
#' @param x A haven_labelled_spss vector.
#' @param y A haven_labelled_spss vector.
#' @return A concatenated haven_labelled_spss vector. Returns an error
#' if the attributes do not match. Gives a warning when only the variable
#' label do not match.
#' @examples
#' s1 <-labelled_spss(
#'   x = unclass(v1),         # remove labels from earlier defined
#'   labels = val_labels(v1), # use the labels from earlier defined
#'   na_values = NULL,
#'   na_range = 8:9,
#'   label = "Variable Example"
#' )
#'
#' s2 <-labelled_spss(
#'   x = unclass(v2),         # remove labels from earlier defined
#'   labels = val_labels(v2), # use the labels from earlier defined
#'   na_values = NULL,
#'   na_range = 8:9,
#'   label = "Variable Example"
#' )
#' concatenate (x,y)
#' @importFrom haven is.labelled_spss labelled_spss
#' @family joining functions
#' @export

concatenate <- function(x, y) {
  if ( ! all(c(is.labelled_spss(x), is.labelled_spss(y))) ) {
    stop ("Both arguments must be haven_labelled_spss")
  }

  if ( is.null(attr(x, "na_range")) ) {
    if ( ! is.null(attr(y, "na_range")) ) {
      stop("The first (x) na_range is NULL, the second (y) is not.")
    }
  } else if ( is.null(attr(y, "na_range")) ) {
    stop("The second (y) na_range is NULL, the first (x) is not.")
  } else {
    if ( any( attr(x, "na_range" ) != attr(y, "na_range" )) ) {
      stop ("The na_range attribute must be equal.")
    }
  }

  if ( is.null(attr(x, "na_values")) ) {
    if ( ! is.null(attr(y, "na_values")) ) {
      stop("The first (x) na_values is NULL, the second (y) is not.")
    }
  } else if ( is.null(attr(y, "na_values")) ) {
    stop("The second (y) na_values is NULL, the first (x) is not.")
  } else {
    if ( any( attr(x, "na_values" ) != attr(y, "na_values" )) ) {
      stop ("The na_values attribute must be equal.")
    }
  }

  if ( ! is.labelled (x) && is.labelled(y) ) {
    stop ("Both x and y must be labelled.")
  }

  if ( ! all(class(x)==class(y))) {
    stop ("class(x)=",
          paste(class(x), collapse=","),
          "\nbut class(y)=", paste(class(y), collapse =","))
  }

  label_x <- attr(x, "label")
  label_y <- attr(y, "label")

  if ( sum(is.null(label_x), is.null(label_y))==1 ) {
    if (is.null(label_x)) {
      attr(x, "label") <- attr(y, "label")
      warning ("The variable label of y <", label_y, "> will be used as variable label.")
    } else {
      warning("The variable label of x <", label_x, "> will be used as variable label.")
    }


  } else {
    if (label_x != label_y) {
      warning ("The variable labels are not the same, <", label_x, "> of x will be used.")
    }
  }

  z <- c(unclass(x), unclass(y))
  new_vctr(z,
           label = attr(x, "label"),
           labels = attr(x, "labels"),
           na_range = attr(x, "na_range"),
           na_values = attr(x, "na_values"),
           class = class(x),
           inherit_base_type = TRUE)
}

