#' Read A Survey File
#'
#' Read a survey into a survey data.frame, and record its
#' important metadata: information about the Eurobarometer wave,
#' the filename, the digital object identifier, the timeframe of the
#' survey and a short description.
#'
#' The retorharmonize_survey class extends the metadata of the survey
#' data frame, but otherwise it inherits all methods of a modern
#' tibble data frame.
#'
#' @inheritParams retroharmonize::read_rds
#' @importFrom retroharmonize read_rds survey
#' @importFrom fs path_file
#' @seealso data_eb_waves
#' @return The survey data in a retorharmonize_survey class which
#' records important metadata about the survey contents.
#' @examples
#' path <- system.file("examples", "ZA7576.rds", package = "eurobarometer")
#' read_eb <- read_rds(path)
#' attributes(read_eb)
#' @export

read_rds <- function(file, id = NULL, doi = NULL) {

  data("eb_waves", package = "eurobarometer", envir = environment())

  filename <-  fs::path_file(file)

  if ( is.null(id)) {
    id <- gsub(".rds", "", filename  )
  }

  tmp  <- retroharmonize::read_rds(file, id=id, filename=filename)


  wave_info <- eb_waves %>%
    filter ( zacat_code == gsub(".rds", "", filename  ))

  if (is.null(doi) && ("doi" %in% names(tmp)) ) {
    doi <- tmp$doi[1]
    }

  amend_survey(tmp)

}

#' @rdname read_rds
#' @inheritParams retroharmonize::read_spss
#' @importFrom retroharmonize read_spss survey
#' @importFrom fs path_file
#' @return The survey data in a retorharmonize_survey class which
#' records important metadata about the survey contents.
#' @examples
#' path <- system.file("examples", "iris1.sav", package = "eurobarometer")
#' read_spss <- read_spss(path)
#' attributes(read_eb)
#' @export
read_spss <- function(file,
                      user_na = NULL,
                      col_select = NULL,
                      skip = NULL,
                      n_max = NULL,
                      .name_repair = "unique",
                      id = NULL,
                      filename = NULL,
                      doi = NULL) {


  filename <-  fs::path_file(file)

  if ( is.null(id)) {
    id <- gsub(".rds", "", filename  )
  }

  tmp  <- retroharmonize::read_spss(
    file,
    id=id, filename=filename,
    user_na = user_na,
    col_select = col_select,
    n_max = n_max,
    .name_repair = "unique",
    id = id,
    filename = filename,
    doi = doi )


  amend_survey(tmp, filename = filename)


}

#' @importFrom retroharmonize read_spss survey
#' @keywords internal
amend_survey <- function (survey, filename) {
  tmp <- retroharmonize::survey(
    df = survey, id = id, filename = filename, doi = doi
  )
  data("eb_waves", package = "eurobarometer", envir = environment())

  wave_info <- eb_waves %>%
    filter ( zacat_code == gsub(".rds", "", filename  ))

  if (is.null(doi) && ("doi" %in% names(tmp)) ) {
    doi <- tmp$doi[1]
  }

  if(nrow(wave_info) == 1 ) {

    attr(tmp, "wave") <- wave_info$wave
    attr(tmp, "timeframe") <- wave_info$timeframe
    attr(tmp, "EB_description") <- wave_info$description

  }

  tmp
}
