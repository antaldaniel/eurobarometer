#' Get A Metadata File
#'
#' Retrieve a metadata file with from your data directory or the
#' temporary directory of your current R session.
#'
#' @details The structure of the returned tibble:
#' \describe{
#'   \item{var_name_orig}{The original variable name in SPSS}
#'   \item{class_orig}{The original variable class after importing with\code{\link[haven]{read_spss}}}
#'   \item{var_label_orig}{The original variable label in SPSS}
#'   \item{var_label_norm}{A normalized version of the variable labels}
#'   \item{var_name_suggested}{A partly canonized variable name.}
#'   \item{factor_levels}{A list of factor levels, i.e. value labels in SPSS}
#'   \item{class_suggested}{A suggested class conversion.}
#' }
#' @param dat A data frame read by \code{\link[haven]{read_spss}}.
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
  var_label_suggested <- label_suggest( var_label_norm,
                                        names(dat) )

  ## Creating the basic metadata ----
  metadata <- tibble::tibble (
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
