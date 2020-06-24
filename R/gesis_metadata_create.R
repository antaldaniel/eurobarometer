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
#'   \item{n_categories}{Number of categories of the variable, should be the sum of the former two.}
#' }
#' @param survey_list A list of data frames containing surveys, or a
#' single survey in a single data frame. The filename should be added
#' in the column \code{filename}.
#' @importFrom labelled val_labels var_label
#' @importFrom dplyr full_join mutate
#' @importFrom tibble tibble
#' @importFrom tidyselect all_of
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

    class_orig   <- vapply (
      dat, function(x) class(x)[1], character(1)
    )

    attr (dat$filename, "label" ) <- "filename"

    get_labels <- function( dat ) {
      vapply ( dat, function(x) attr(x, "label"), character(1))
    }

    var_label_orig <- vapply ( dat, labelled::var_label, character(1) )
    var_label_norm <- label_normalize(x = var_label_orig )
    var_label_suggested <- label_suggest( var_label_norm,
                                          names(dat) )

    ## Creating the basic metadata ----
    metadata <- tibble::tibble (
      filename = unique(dat$filename)[1],
      var_name_orig = names ( dat ),
      class_orig  = class_orig,
      var_label_orig = var_label_orig,
      var_label_norm = var_label_norm,
      var_name_suggested = var_label_suggested
    )

    ## Creating a catalog of possible categories / factor levels ----
    all_val_labels <- sapply ( dat, labelled::val_labels )
    value_labels_df <- data.frame (
      var_name_orig = names ( all_val_labels  )
    )
    value_labels_df$factor_levels <- all_val_labels
    value_labels_df$na_levels <- sapply ( dat, labelled::na_values)

    fn_valid_range <- function ( x ) {
      f <- value_labels_df$factor_levels[x]
      n <- value_labels_df$na_levels[x]
      f[ ! f %in% n]
    }

    value_labels_df$valid_range <- sapply (
      1:nrow(value_labels_df), fn_valid_range )

    value_labels_df$length_cat_range <- sapply (
      value_labels_df$valid_range, length )

    value_labels_df$length_na_range <- sapply (
      value_labels_df$na_levels, length )

    ##Merging the basic metadata with the categories
    metadata <- dplyr::full_join(
      metadata,
      value_labels_df, by = 'var_name_orig' )

    metadata$n_categories <- vapply (
      sapply ( metadata$factor_levels, unlist ),
      length, numeric(1) )  #number of categories in categorical variables

    metadata <- question_block_identify(metadata)

    metadata <- metadata %>%
      select ( all_of(c("filename", "qb", "var_name_orig",
                        "var_label_orig",
                        "var_label_norm", "var_name_suggested",
                        "length_cat_range", "length_na_range",
                        "n_categories",
                        "factor_levels", "valid_range", "na_levels",
                        "class_orig")
                      )
               )

    ## class_suggest is not exported, it is in utils.R
    ## Can be directly called as eurobarometer:::class_suggest(metadata)
    class_suggest(metadata)
  }

  tmp <- metadata_create( dat = survey_list[[1]])

  metadata_list <- lapply ( survey_list, metadata_create )
  do.call(rbind,metadata_list)
}
