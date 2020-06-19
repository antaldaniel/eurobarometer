#' @title Convert To Basic R Classes
#'
#' @param dat A data frame like object with the raw statistical data.
#' @param metadata A metadata data frame created by
#' \code{\link{gesis_metadata_create}}.
#' @param var_name Defaults to \code{"normalized_name"}.
#' @param conversion Defaults to \code{"conversion_suggestion"}.
#' @return The \code{df} converted to numeric, character, factor classes.
#' Dummies are converted to binary numeric variables and their name is
#' prefixed with \code{'is_'}.
#' @examples
#' \dontrun{
#' sample <- eurobarometer:::eb_sample
#' sample_metadata <- gesis_metadata_create(dat = sample)
#' convert_class ( dat = sample, metadata = sample_metadata)
#' }
#' @importFrom purrr set_names
#' @importFrom dplyr filter select mutate_all bind_cols
#' @importFrom tidyselect all_of
#' @importFrom labelled to_factor
#' @export

convert_class <- function(dat, metadata,
                          var_name = "normalized_name",
                          conversion = "conversion_suggestion" ) {

  class_conversion <- metadata %>%
    dplyr::select ( all_of(c(var_name, conversion) )) %>%
    purrr::set_names(c("var", "conversion"))

  if (! all( class_conversion$var %in% names(dat))) {
    stop( "Not all '", var_name, "' can be found in the names of dat.")
  }

  numeric_vars <- class_conversion %>%
    filter ( conversion == 'numeric') %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  numeric_df <- dat %>%
    select ( tidyselect::all_of(numeric_vars) ) %>%
    mutate_all ( as.numeric )


  character_vars <- class_conversion %>%
    filter ( conversion == 'character') %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  character_df <- dat %>%
    select ( tidyselect::all_of(character_vars) ) %>%
    mutate_all ( as.character )

  dummy_vars <- class_conversion %>%
    filter ( conversion == 'dummy') %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  recode_dummy <- function(x) {
    ifelse(x=="mentioned",
           1, ifelse(x=="not mentioned",
                     0,
                     NA_real_))
  }

  dummy_df <- dat %>%
    select ( all_of(dummy_vars) ) %>%
    mutate_all ( labelled::to_factor ) %>%
    mutate_all ( as.character ) %>%
    mutate_all ( tolower ) %>%
    mutate_all ( recode_dummy )

  factor_vars <- class_conversion %>%
    filter ( conversion == 'factor') %>%
    select ( all_of("var")) %>%
    unlist() %>%
    as.character()

  relabel_factors <- function(x) {
    x <- labelled::to_factor(x, drop_unused_labels = TRUE)
  }

  factor_df <- dat %>%
    select ( all_of(factor_vars) ) %>%
    mutate_all ( relabel_factors  )

  remerged_dat <- dplyr::bind_cols (
    factor_df, character_df, numeric_df, dummy_df
  )

  missing_from_return <- names(dat) [! names(dat) %in% names (remerged_dat)]
  if ( length(missing_from_return) >0 ){
    stop ( "The following columns were lost:\n",
           paste(missing_from_return, collapse = ","),
           "This is an error.")
  }

  rename_dummies <- names(remerged_dat)

  remerged_dat %>%
    purrr::set_names (ifelse ( rename_dummies  %in% dummy_vars,
                               paste0('is_', rename_dummies ),
                               names(remerged_dat))
    )

}
