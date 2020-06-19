#' @title Read A eurobarometer Package Example File
#'
#' This function is created to make panel data creation examples
#' without relying on importing large SPSS files.
#'
#' @param sample_file_name Any of \code{ZA7576_sample},
#' \code{ZA7562_sample} or \code{ZA7489_sample}.
#' @importFrom utils data
#' @examples
#' read_example_file ( sample_file_name = 'ZA7576_sample' )
#' @export

read_example_file <- function( sample_file_name = 'ZA7576_sample' ) {

  . <- ZA7576_sample <- ZA7562_sample <- ZA7489_sample <- NULL
  class_orig <- n_categories <- panel_id <- val_label_orig <- NULL
  val_numeric_orig <- var_name_orig <- NULL

  sample_file_name <- substr( sample_file_name,1,6)
  if ( ! sample_file_name %in% c('ZA7576',
                                 'ZA7562',
                                 'ZA7489') ) {
    stop ( sample_file_name , "_sample is not among the package sample data files.")
  }

  if (sample_file_name == 'ZA7576' ) {
    data ('ZA7576_sample', envir = environment())
    return(ZA7576_sample)
  } else if (sample_file_name == 'ZA7562') {
    data ('ZA7562_sample', envir = environment())
    return(ZA7562_sample)
  } else if (sample_file_name == 'ZA7489') {
    data ('ZA7489_sample', envir = environment())
    return(ZA7489_sample)
  }
}
