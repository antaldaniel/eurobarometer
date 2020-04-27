#' Get a metadata file
#'
#' Retrieve a metadata file with from your data directory or the temporary directory
#' of your current R session.
#' @param zacat_id For example, \code{"ZA5688_v6-0-0"}, as analyzed and saved by
#' \code{\link{analyze_gesis_file}}.
#' Defaults to \code{"last_data_frame"}, which is
#' the last file in the temporary directory of the current session.
#' @param data_dir Defaults to \code{"NULL"}. In this case the \code{"tempdir()"}
#' of your current R session will be used.
#' @importFrom sjlabelled get_label get_labels
#' @importFrom dplyr full_join
#' @seealso canonical_name_create
#' @return A data frame with the original file names, the suggested canonical
#' names, factor lists, suggested class conversions.
#' @examples
#' \dontrun{
#' ##use your own file:
#' gesis_metadata_get( zacat_id = "ZA5688",
#'                     data_dir = "data-raw/")
#' }
#' @export

gesis_metadata_create <- function ( dat ) {

  r_class   <- vapply ( dat, class, character(1) )
  spss_name <- vapply ( dat, sjlabelled::get_label, character(1) )
  canonical_name <- canonical_name_create(spss_name)

  ##Creating the basic metadata ----
  metadata <- data.frame (
    r_name = names ( dat ),
    r_class = r_class,
    spss_name = spss_name,
    canonical_name = canonical_name
  )


  ##Creating a catalog of possible categories / factor levels ----
  value_labels <- sapply ( dat, sjlabelled::get_labels )
  value_labels_df <- data.frame (
    r_name = names ( value_labels )
    )

  value_labels_df$factor_levels <- value_labels

  ##Merging the basic metadata with the categories
  metadata <- dplyr::full_join( metadata,
                                value_labels_df, by = 'r_name' )

  metadata$level_length <- vapply (
    sapply ( metadata$factor_levels, unlist ),
    length, numeric(1) )  #number of categories in categorical variables

  ##Adding constants -----

  if ( "doi" %in% names(dat)) {
    metadata$doi = dat$doi[1]
  } else { metadata$doi <- NA_character_ }

  if ( "version" %in% names(dat)) {
    metadata$version = dat$version[1]
  } else { metadata$version <- NA_character_ }

  study_number <- which ( metadata$canonical_name == "study_number_distributor")
  gesis_archive_version <-  which ( metadata$canonical_name == "gesis_archive_version")
  id_serial_number <- which ( metadata$canonical_name == "id_serial_number")

  if ( length(study_number) > 0 ) {
    metadata$study_number <- as.character(dat [1, study_number])
  } else {
    metadata$study_number<- NA
  }

  if ( length(gesis_archive_version) > 0 ) {
    metadata$gesis_archive_number <- as.character(dat [1, gesis_archive_version])
  } else {
    metadata$gesis_archive_number <- NA
  }

 metadata
}
