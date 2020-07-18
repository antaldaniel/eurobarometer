#' @title Read Survey Files
#'
#' Import surveys into a list. Adds filename as a constant to each
#' element of the list.
#'
#' @param import_file_names A vector of file names to import.
#' @param .f A function to import the surveys with.
#' Defaults to \code{'read_example_file'}. For SPSS files,
#' \code{'read_spss_survey'} is recommended, which is a
#' well-parametrised version of \code{\link[haven]{read_spss}}.
#' @param save_to_rds Should it save the imported survey to .rds?
#' Defaults to \code{TRUE}.
#' @return A list of the surveys.  Each element of the list is a data
#' frame. The respective file names are added to each data frame as a
#' constant column \code{filename}.
#' @importFrom purrr safely
#' @importFrom haven read_spss
#' @examples
#' import_file_names <- c(
#' 'ZA7576_sample','ZA6863_sample','ZA5913_sample'
#' )
#' read_surveys (import_file_names, .f = 'read_example_file' )
#' @export

read_surveys <- function ( import_file_names,
                           .f = 'read_example_file',
                           save_to_rds = TRUE ) {

  read_spss_survey <- function( filename ) {

    tried_survey <- purrr::safely(.f = read_spss)(file = filename, user_na = TRUE)

    if ( is.null(tried_survey$error)) {
      if (save_to_rds) {
        rds_filename <- gsub(".sav|.por", ".rds", filename)
        "Saving the survey to rds in the same location."
      }
      saveRDS(tried_survey$result, rds_filename, version=2)
      tried_survey$result
    } else {
      warning("Survey ", filename, " could not be read: ", tried_survey$error)
    }
  }

  tmp <- lapply ( X = as.list(import_file_names), FUN = eval(.f)   )

  tmp
}

