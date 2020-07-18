#' Suggest Conversion
#'
#' @param metadata A metadata file created by metadata_create within
#' \code{\link{gesis_metadata_create}}
#' @return The metadata tibble augmented with the \code{class_suggested}
#' variable.
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate case_when
#' @importFrom tidyselect all_of
#' @keywords internal
#'
class_suggest <- function(metadata) {

  . <- n_categories <- class_orig <- valid_range <- NULL

  is_dummy <- function(x) {

    if ( is.null(x) ) return(FALSE)
    these_labels <- label_normalize(names(x))
    if ( length(these_labels) != 2 ) return(FALSE)

    ifelse ( all(sort (label_normalize(names(x))) == c(
      "mentioned", "not_mentioned")),
      TRUE, FALSE)
  }

  metadata_lab  <- metadata %>%
    filter ( "haven_labelled" == class_orig  )

  metadata_spss <- metadata %>%
    filter ( "haven_labelled_spss" == class_orig )

  suggestions <- metadata %>%
    mutate ( dummy = vapply(valid_range, is_dummy, logical(1))) %>%
    mutate ( conversion_suggested = dplyr::case_when (
      qb         == "id" ~ 'character',
      class_orig %in% c("numeric","character") ~ class_orig,
      class_orig == 'haven_labelled' & length_cat_range == 2  ~ 'harmonized_labelled',
      class_orig == 'haven_labelled_spss' & length_cat_range == 2  ~ 'harmonized_labelled',
      dummy == TRUE ~  'dummy',
      TRUE ~ class_orig )) %>%
    select ( -all_of("dummy"))

  suggestions
}
