#' @title Read A eurobarometer Package Example File
#'
#' This function is created to make panel data creation examples
#' without relying on importing large SPSS files.
#'
#' @param sample_file_name Any of \code{ZA7576_sample},
#' \code{ZA6863_sample} or \code{ZA5913_sample}.
#' @importFrom utils data
#' @examples
#' read_example_file ( sample_file_name = 'ZA7576_sample' )
#' @export

read_example_file <- function( sample_file_name = 'ZA7576_sample' ) {

  . <- ZA7576_sample <- ZA6863_sample <- ZA5913_sample <- NULL
  class_orig <- n_categories <- panel_id <- val_label_orig <- NULL
  val_numeric_orig <- var_name_orig <- NULL

  sample_file_name <- substr( sample_file_name,1,6)
  if ( ! sample_file_name %in% c('ZA7576',
                                 'ZA6863',
                                 'ZA5913') ) {
    stop ( sample_file_name ,
           "_sample is not among the package sample data files.")
  }

  if (sample_file_name == 'ZA7576' ) {
    data ('ZA7576_sample', envir = environment())
    return(ZA7576_sample)
  } else if (sample_file_name == 'ZA6863') {
    data ('ZA6863_sample', envir = environment())
    return(ZA6863_sample)
  } else if (sample_file_name == 'ZA5913') {
    data ('ZA5913_sample', envir = environment())
    return(ZA5913_sample)
  }
}
