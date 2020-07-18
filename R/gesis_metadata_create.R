#' Create A Metadata Table
#'
#' Create a metadata file from your surveys.
#'
#' @details The structure of the returned tibble:
#' \describe{
#'   \item{filename}{The original file name}
#'   \item{qb}{Identifier of a question block for further tasks.}
#'   \item{var_name_orig}{The original variable name in SPSS.}
#'   \item{class_orig}{The original variable class after importing with\code{\link[haven]{read_spss}}.}
#'   \item{var_label_orig}{The original variable label in SPSS.}
#'   \item{var_label_norm}{A normalized version of the variable labels.}
#'   \item{var_name_suggested}{A partly canonized variable name.}
#'   \item{factor_levels}{A list of factor levels, i.e. value labels in SPSS}
#'   \item{na_levels}{Values marked as missing by GESIS.}
#'   \item{valid_range}{Not missing factor(category) levels.}
#'   \item{class_suggested}{A suggested class conversion.}
#'   \item{length_cat_range}{Number of categories in the non-missing range.}
#'   \item{length_na_range}{Number of categories marked as missing by GESIS.}
#'   \item{length_total_range}{Number of categories or unique levels, which may be different from the sum of missing and category labels.}
#'   \item{n_categories}{Number of categories of the variable, should be the sum of the former two.}
#' }
#' @param survey_list A list of data frames containing surveys, or a
#' single survey in a single data frame. The filename should be added
#' in the column \code{filename}.
#' @importFrom labelled val_labels var_label
#' @importFrom dplyr full_join mutate
#' @importFrom tibble tibble
#' @importFrom tidyselect all_of
#' @importFrom retroharmonize metadata_create
#' @return A data frame with the original variable attributes and
#' suggested conversions and changes.
#' @examples
#' import_file_names <- c(
#'   'ZA7576_sample','ZA5913_sample'
#' )
#'
#' my_surveys <- read_surveys (
#'     import_file_names,
#'     .f = 'read_example_file' )
#'
#' metadata <- gesis_metadata_create(my_surveys)
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
      mutate (
        filename = this_filename,
        var_label_norm = var_label_normalize(label_orig)
        ) %>%
      mutate (
        # do we need this?
        var_name_suggested = label_suggest( var_label_norm,
                                            var_name_orig )
      )

    names(metadata)
    ## Creating the basic metadata ----
    metadata  <- mtd %>%
      select ( filename, var_name_orig, class_orig,
               var_label_norm,
               var_name_suggested,
               label_orig,
               n_na_values,
               n_cat_labels,
               labels,
               na_values,
               valid_range, na_values, na_range) %>%
      dplyr::rename ( n_cat_values  = n_cat_labels) %>%
      mutate ( n_categories = n_cat_values - n_na_values  ) %>%
      dplyr::rename ( var_label_orig = label_orig,
                      na_levels = na_values,
                      length_na_range = n_na_values,
                      length_total_range = n_cat_values ) %>%
      mutate ( length_cat_range =length_total_range-length_na_range )

    metadata <- question_block_identify(metadata)

    metadata %>%
      select ( all_of(c("filename", "qb", "var_name_orig",
                        "var_label_orig",
                        "var_label_norm", "var_name_suggested",
                        "length_cat_range", "length_na_range",
                        "length_total_range",
                        "n_categories",
                        "labels","na_levels", "na_range",
                        "class_orig")
              )
      )

    ## class_suggest is not needed any more  in utils.R
  }

  dat <- survey_list[[2]]
  metadata_create ( dat )

  metadata_list <- lapply ( survey_list, metadata_create )
  do.call(rbind,metadata_list)
}
