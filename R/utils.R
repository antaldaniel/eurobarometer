#' Suggest Conversion
#'
#' @param metadata A metadata file created by gesis_metadata_create
#' @return The metadata tibble augmented with the \code{class_suggested}
#' variable.
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate case_when

class_suggest <- function(metadata) {

  factor_levels <- sapply ( metadata$factor_levels,
                        function(x) sort(tolower(unlist(x))) )

  first_level  <- unlist(lapply(factor_levels, function(x) x[1]))
  second_level <- unlist(lapply(factor_levels, function(x) x[2]))

  suggestions <- metadata %>%
    dplyr::select ( class_orig,
                    factor_levels, n_categories ) %>%
    mutate ( first_level  = first_level,
             second_level = second_level )

  suggestions <-suggestions %>%
    mutate ( suggestion = dplyr::case_when (
      class_orig %in% c("numeric","character") ~ class_orig,
      class_orig == 'haven_labelled' & n_categories  == 1 ~ 'character',
      first_level == "mentioned" & second_level == "not mentioned" ~  'dummy',
      TRUE ~ "factor" ))

  metadata$class_suggested <- suggestions$suggestion
  metadata
}
