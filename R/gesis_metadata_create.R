#' Get A Metadata File
#'
#' @description
#' Retrieve a metadata file with from your data directory or the
#' temporary directory of your current R session.
#'
#' @details The structure of the returned tibble (data frame)
#' \emph{var_name_orig}: The original variable name in SPSS;
#' \emph{class_orig}: The original variable class after importing
#' \emph{class_orig}: The original variable class after importing
#' with \code{\link{haven::read_spss}};
#' \emph{var_label_orig}: The original variable label in SPSS;
#' \emph{var_label_norm}: A normalized version of the variable labels;
#' \emph{factor_levels}: A list of factor levels, i.e. value labels in SPSS;
#' \emph{class_suggested}: A suggested class conversion.
#'
#' @param zacat_id For example, \code{"ZA5688_v6-0-0"}, as analyzed and saved by
#' \code{\link{analyze_gesis_file}}.
#' Defaults to \code{"last_data_frame"}, which is
#' the last file in the temporary directory of the current session.
#' @param data_dir Defaults to \code{"NULL"}. In this case the \code{"tempdir()"}
#' of your current R session will be used.
#' @importFrom labelled val_labels var_label
#' @importFrom dplyr full_join
#' @importFrom tibble tibble
#' @return A data frame with the original variable attributes and
#' suggested conversions and changes.
#' @examples
#' \dontrun{
#' ##use your own file:
#' tmp <- haven::read_spss( file.path(gesis_dir, gesis_file) )
#' metadata <- gesis_metadata_create(tmp)
#' }
#' @export

gesis_metadata_create <- function ( dat ) {

  class_orig   <- vapply (
    dat, function(x) class(x)[1], character(1)
    )

  var_label_orig <- vapply ( dat, labelled::var_label, character(1) )
  var_label_norm <- label_normalize(x = var_label_orig )
  var_label_norm

  ## Creating the basic metadata ----
  metadata <- tibble::tibble (
    var_name_orig = names ( dat ),
    class_orig  = class_orig,
    var_label_orig = var_label_orig,
    var_label_norm = var_label_norm
  )

  ## Creating a catalog of possible categories / factor levels ----
  all_val_labels <- sapply ( dat, labelled::val_labels )
  value_labels_df <- data.frame (
    var_name_orig = names ( all_val_labels  )
    )

  value_labels_df$factor_levels <- all_val_labels

  ##Merging the basic metadata with the categories
  metadata <- dplyr::full_join(
    metadata,
    value_labels_df, by = 'var_name_orig' )

  metadata$n_categories <- vapply (
    sapply ( metadata$factor_levels, unlist ),
    length, numeric(1) )  #number of categories in categorical variables

  ## class_suggest is not exported, it is in utils.R
  ## Can be directly called as eurobarometer:::class_suggest(metadata)
  class_suggest(metadata)
}
