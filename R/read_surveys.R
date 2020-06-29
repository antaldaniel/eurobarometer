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
#' @param file_path A file path where the \code{import_file_names}
#' can be found.
#' Defaults to the working directory: \code{file_path = NULL}.
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
                           file_path = NULL ) {


  if ( !is.null(file_path) ) {
    if ( dir.exists(file_path) ) {
      read_file_names <- file.path(file_path, import_file_names)
    } else {
      stop(file_path, " cannot be found.")
    }
  } else {
    read_file_names <- import_file_names
  }

  read_spss_survey <- function( filename ) {

    tried_survey <- purrr::safely(.f = haven::read_spss)(filename, user_na = TRUE)

    if ( is.null(tried_survey$error)) {
      tried_survey$result
    } else {
      warning("Survey ", filename, " could not be read: ", tried_survey$error)
    }
  }

  tmp <- lapply ( X = read_file_names, FUN = eval(.f)   )

  for (i in 1:length(import_file_names)) {
    tmp[[i]]$filename <- import_file_names[i]
    attr(tmp[[i]]$filename, "label") <- "filename"
  }

  tmp
}

