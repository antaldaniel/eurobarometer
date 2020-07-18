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


  tmp  <- retroharmonize::read_rds(file, id=id, doi=doi)

  amend_survey(survey = tmp)

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
                      user_na = TRUE,
                      id = NULL,
                      filename = NULL,
                      doi = NULL,
                      .name_repair = "unique") {

  tmp  <- retroharmonize::read_spss(
    file,
    .name_repair = "unique",
    id = id,
    doi = doi )

  amend_survey(survey = tmp)
}

#' @importFrom retroharmonize read_spss survey
#' @importFrom dplyr filter
#' @importFrom stringr str_sub
#' @keywords internal
amend_survey <- function (survey) {
  data("eb_waves", package = "eurobarometer", envir = environment())

  zacat <- substr(attr(survey, "filename"),1,6)

  version <- stringr::str_sub(
    fs::path_ext_remove ( attr(survey, "filename") ), 8,-1)
  if (nchar(version)==0) version <- NA_character_

  wave_info <- eb_waves %>%
    dplyr::filter ( zacat_code == zacat )

  if(nrow(wave_info) == 1 ) {
    attr(tmp, "gesis_file_version")  <- version
    attr(tmp, "wave") <- wave_info$wave
    attr(tmp, "timeframe") <- wave_info$timeframe
    attr(tmp, "EB_description") <- wave_info$description
  }

  tmp
}
