#' Create A Corpus Of Survey Answer Items
#'
#' Reads in all SPSS files in a directory, runs
#' \code{\link{gesis_vocabulary_create}} as a wrapper function
#' and binds the results into a single data.frame.
#'
#' @param dat For example,
#' @seealso gesis_vocabulary_create
#' @importFrom purrr possibly
#' @importFrom haven read_spss
#' @importFrom dplyr bind_rows
#' @return A data frame with six variables.
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
      warning("Not read")
      next
    }
    if ( f == 1 ) {
      corpus <- gesis_vocabulary_create(dat = tmp)
      corpus$filename <- spss_files[f]
    } else {
      new_corpus <- purrr::possibly(gesis_vocabulary_create, NULL)(tmp)
      if (!is.null(new_corpus)) {
        new_corpus$filename <- spss_files[f]
        corpus <- dplyr::bind_rows(corpus, new_corpus)
      } else warning("Corpus creation error.")
    }
  }
  corpus
}


