#' Create A Metadata Table
#'
#' Create a metadata file from your surveys.
#'
#' @details The structure of the returned tibble:
#' \describe{
#'   \item{filename}{The original file name.}
#'   \item{id}{The ID of the survey, if present.}
#'   \item{qb}{Question Block}
#'   \item{var_name_orig}{The original variable name in SPSS.}
#'   \item{var_label_norm}{The normalized variable label.}
#'   \item{var_name_suggested}{Suggested variable name.}
#'   \item{class_orig}{The original variable class after importing with\code{\link[haven]{read_spss}}.}
#'   \item{label_orig}{The original variable label in SPSS.}
#'   \item{labels}{A list of the value labels.}
#'   \item{valid_labels}{A list of the value labels that are not marked as missing values.}
#'   \item{na_labels}{A list of the value labels that refer to user-defined missing values.}
#'   \item{na_range}{An optional range of a continous missing range, if present in the vector.}
#'   \item{n_labels}{Number of categories or unique levels, which may be different from the sum of missing and category labels.}
#'   \item{n_valid_labels}{Number of categories in the non-missing range.}
#'   \item{n_na_labels}{Number of categories of the variable, should be the sum of the former two.}
#'   \item{na_levels}{A list of the user-defined missing values.}
#' }
#' @param survey_list A list of data frames containing surveys, or a
#' single survey in a single data frame. The filename should be added
#' in the column \code{filename}.
#' @importFrom labelled val_labels var_label
#' @importFrom dplyr full_join mutate rename select
#' @importFrom tibble tibble
#' @importFrom tidyselect all_of
#' @importFrom retroharmonize metadata_create
#' @return A data frame with the original variable attributes and
#' suggested conversions and changes.
#' @examples
#' file1 <- system.file(
#'   "examples", "ZA7576.rds", package = "eurobarometer")
#' file2 <- system.file(
#'   "examples", "ZA5913.rds", package = "eurobarometer")
#'
#' import_file_names <- c(file1,file2)
#'
#' my_surveys <- read_surveys (
#'   import_file_names, .f = 'read_rds' )
#'
#' gesis_metadata_create(survey_list = my_surveys )
#' @export

gesis_metadata_create <- function ( survey_list ) {

  ## if input is a data.frame, place it in a list -----------
  if ( ! "list" %in% class(survey_list) ) {
    survey_list <- to_survey_list( x = survey_list )
  }

  ## start of internal function metadata_create -------------
  metadata_create <- function (dat) {

    this_filename <- attr(dat, "filename")
    if (is.null(this_filename)) this_filename <- "unknonw"

    mtd <- retroharmonize::metadata_create(dat)

    mtd <- mtd %>%
      dplyr::mutate (
        ##somewhere there is a problem with a mutate
        filename = this_filename) %>%
      dplyr::mutate (
        var_label_norm = var_label_normalize(label_orig)
        ) %>%
      dplyr::mutate (
        # do we need this?
        var_name_suggested = label_suggest( var_label_norm,
                                            var_name_orig )
      )

    ## Creating the basic metadata ----
    metadata  <- mtd %>%
      dplyr::select ( filename, var_name_orig, class_orig,
               var_label_norm,
               var_name_suggested,
               label_orig,
               n_valid_labels,
               n_na_labels,
               labels,
               valid_labels,
               na_labels, na_range)

    metadata <- question_block_identify(metadata)

    metadata %>%
      dplyr::select ( all_of(c("filename", "qb", "var_name_orig",
                        "label_orig",
                        "var_label_norm", "var_name_suggested",
                        "n_valid_labels", "n_na_labels",
                        "labels","na_labels", "na_range",
                        "class_orig")
              )
      )
  }

  metadata_list <- lapply ( survey_list, metadata_create )
  do.call(rbind,metadata_list)
}


#' @noRd
#' @param x A list of survey data frames or a single survey data frame.
#' @return A list of surveys.
#' @keywords internal

to_survey_list <- function (x) {
  if ( ! "list" %in% class(x) ) {
    if ( "data.frame" %in% class(x) ) {

      if ( ! "filename" %in% names(x) )
        x$filename = "not_given"
      attr(x$filename, "label") <- "not_given"

      x <- list ( survey = x )
    } else {
      stop ( "Parameter 'survey_list' must be a list of data frames or a single data frame.")
    }
  }
  x
}
