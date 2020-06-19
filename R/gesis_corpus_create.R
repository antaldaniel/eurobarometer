#' Create A Corpus Of Survey Answer Items
#'
#' Reads in all SPSS files in a directory, runs
#' \code{\link{gesis_vocabulary_create}} as a wrapper function
#' and binds the results into a single data.frame.
#'
#' @param file_path A file path to work from (will be changed)
#' @seealso gesis_vocabulary_create
#' @importFrom purrr possibly
#' @importFrom haven read_spss
#' @importFrom dplyr bind_rows
#' @return A data frame with seven variables, results binded together
#' from \code{\link{gesis_vocabulary_create}}. The returned data frame has
#' 8 variables:
#' \describe{
#'   \item{var_name_orig}{The name of the variable in the data file.}
#'   \item{val_numeric_orig}{The original SPSS numeric values, if applicable}
#'   \item{var_label_orig}{The original SPSS character value, if applicable}
#'   \item{val_order_alpha}{The rank number of the alphabetically sorted answer option.}
#'   \item{val_order_length}{The number of answer options in the questionnaire item.}
#'   \item{val_label_normalized}{Normalized version of the questionnaire item}
#'   \item{filename}{The name of the original GESIS file.}
#' }
#' @seealso gesis_vocabulary_create
#' @examples
#' \dontrun{
#' ##use your own path:
#' corpus <- gesis_corpus_create ( <your_path> )
#' }
#' @export

gesis_corpus_create <- function ( file_path ) {

  spss_files <- dir(file_path)[grepl(".sav", dir(file_path))]
  gesis_files <- file.path( file_path, spss_files)
  n_files <- length(spss_files)

  for ( f in 1:n_files ) {
    message ( f, "/", n_files, " reading ", spss_files[f])
    tmp <- purrr::possibly(haven::read_spss, NULL)(gesis_files[f])

    if ( is.null(tmp) ) {
      ## possibly retuns NULL in case there was a file reading error.
      warning("Error reading file: ", spss_files[f], " (omitted)")
      next
    }
    if ( f == 1 ) {
      corpus <- gesis_vocabulary_create(dat = tmp)
      corpus$filename <- spss_files[f]
    } else {
      new_corpus <- purrr::possibly(gesis_vocabulary_create, NULL)(tmp)
      if (!is.null(new_corpus)) {
        ## If the vocabulary is successfully created, join with previous
        new_corpus$filename <- spss_files[f]
        corpus <- dplyr::bind_rows(corpus, new_corpus)

      } else {
        ## At this moment files that are read in with an error
        ## are just omitted with a warning.
        warning("Corpus creation error in file ", spss_files[f],
                "\nThis file is omitted from the results.")
        }
    }
  }

  corpus
}


