#' @title Read Survey Files
#'
#' Import surveys into a list. Add filename as a constant to each
#' element of the list.
#'
#' @param import_file_names A vector of file names to import.
#' @param .f A function to import the surveys with.
#' Defaults to \code{read_example_file}.
#' @return A list of the surveys.  Each element of the list is a data
#' frame. The respective file names are added to each data frame as a
#' constant column \code{filename}.
#' @examples
#' import_file_names <- c(
#' 'ZA7576_sample','ZA6863_sample','ZA5913_sample'
#' )
#' read_surveys (import_file_names, .f = 'read_example_file' )
#' @export

read_surveys <- function ( import_file_names, .f = 'read_example_file' ) {

  tmp <- lapply ( X = import_file_names, FUN = eval(.f)   )

  for (i in 1:length(import_file_names)) {
    tmp[[i]]$filename <- import_file_names[i]
    attr(tmp[[i]]$filename, "label") <- "filename"
  }

  tmp
}

