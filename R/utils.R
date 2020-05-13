#' Suggest Conversion
#'
#' @param metadata A metadata file created by gesis_metadata_create
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate case_when

suggest_conversion <- function(metadata) {

  factor_levels <- sapply ( metadata$factor_levels,
                        function(x) sort(tolower(unlist(x))) )

  first_level  <- unlist(lapply(factor_levels, function(x) x[1]))
  second_level <- unlist(lapply(factor_levels, function(x) x[2]))

  suggestions <- metadata %>%
    dplyr::select ( r_class,factor_levels, level_length ) %>%
    mutate ( first_level  = first_level,
             second_level = second_level ) %>%
    mutate ( suggestion = case_when (
      r_class %in% c("numeric","character") ~ r_class,
      r_class == 'haven_labelled' & level_length == 1 ~ 'character',
      first_level == "mentioned" & second_level == "not mentioned" ~  'dummy',
      TRUE ~ "factor" ))

  metadata$conversion_suggestion <- suggestions$suggestion
  metadata
}
