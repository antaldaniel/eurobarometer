#' @title Convert To Basic R Classes
#'
#' @param dat A data frame like object with the raw statistical data.
#' @param metadata A metadata data frame created by
#' \code{\link{gesis_metadata_create}}.
#' @param var_name Defaults to \code{"normalized_name"}.
#' @param conversion Defaults to \code{"conversion_suggested"}.
#' @return The \code{df} converted to numeric, character, factor classes.
#' Dummies are converted to binary numeric variables and their name is
#' prefixed with \code{'is_'}.
#' @importFrom tibble tibble
#' @importFrom dplyr mutate filter select bind_cols
#' @importFrom tidyselect all_of
#' @importFrom purrr set_names
#' @importFrom labelled to_factor to_character
#' @examples
#' \dontrun{
#' require(dplyr)
#' small_sample_convert  <- ZA5913_sample %>%
#'   mutate ( filename = "ZA5913_sample") %>%
#'   select (all_of(
#'      c("uniqid", "filename", "doi", "p3", "qa10_3", 'w1'))
#'      ) %>%
#'   sample_n(20)
#'
#' small_sample_metadata <- gesis_metadata_create(
#'                                 small_sample_convert )
#'
#' convert_class  ( dat = small_sample_convert,
#'                  metadata = small_sample_metadata,
#'                  var_name = "var_name_orig")
#' }
#' @importFrom purrr set_names
#' @importFrom dplyr filter select mutate_all bind_cols
#' @importFrom tidyselect all_of
#' @importFrom labelled to_factor
#' @family harmonization functions
#' @export

convert_class <- function(dat, metadata,
                          var_name = "var_name_suggested",
                          conversion = "conversion_suggested" ) {

  . <- var <- valid_range <- length_total_range <- NULL
  length_cat_range <- NULL

  original_name_order  <- names ( dat )
  class_conversion <- metadata %>%
    dplyr::select ( all_of(c(var_name, conversion,
                             "length_cat_range", "length_total_range") )) %>%
    purrr::set_names(c("var", "conversion", "length_cat_range", "length_total_range"))

  if (! all( class_conversion$var %in% names(dat)) ) {
    stop( "Not all '", var_name, "' can be found in the names of dat.")
  }

  numeric_vars <- class_conversion %>%
    filter ( conversion == 'numeric' ) %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  numeric_df <- dat %>%
    select ( tidyselect::all_of(numeric_vars) ) %>%
    mutate_all ( as.numeric )

  if ( length(numeric_vars) ==0  )  {
    numeric_vars_present <- FALSE } else {
      numeric_vars_present <- TRUE
    }

  character_vars <- class_conversion %>%
    filter ( conversion == 'character') %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  character_df <- dat %>%
    select ( tidyselect::all_of(character_vars) ) %>%
    mutate_all ( as.character )

  if ( length(character_vars) == 0  )  {
    character_vars_present <- FALSE } else {
      character_vars_present <- TRUE
    }

  labelled_harmonized_vars <- class_conversion %>%
    filter ( grepl("labelled", conversion) ,
             length_cat_range == 2,
             length_total_range < 5) %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  harmonize_value_labels_2 <- function(x) harmonize_value_labels(x, 2)

  labelled_harmonized_df <- dat %>%
    select ( tidyselect::all_of(labelled_harmonized_vars) ) %>%
    mutate_all ( harmonize_value_labels_2 )

  if ( length(labelled_harmonized_vars) ==0  )  {
    labelled_harmonized_vars_present <- FALSE } else {
      labelled_harmonized_vars_present <- TRUE
    }

  labelled_unharmonized_vars <- class_conversion %>%
    filter ( ! var %in% labelled_harmonized_vars ) %>%
    filter ( grepl("labelled", conversion) ) %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()


  if ( length(labelled_unharmonized_vars)>0) {
    labelled_unharmonized_df <- dat %>%
      select ( tidyselect::all_of(labelled_unharmonized_vars) ) %>%
      mutate_all ( labelled::to_character )
  }

  if ( length(labelled_unharmonized_vars) == 0 ) {
    labelled_unharmonized_vars_present <- FALSE
  } else {
    labelled_unharmonized_vars_present <- TRUE
  }

  dummy_vars <- class_conversion %>%
    filter ( conversion == 'dummy') %>%
    select ( all_of("var")) %>%
    unlist() %>% as.character()

  if ( length(dummy_vars) == 0 ) {
    dummy_vars_present <- FALSE
  } else {
    dummy_vars_present <- TRUE
  }

  recode_dummy <- function(x) {
    ifelse(x=="mentioned",
           1, ifelse(x=="not mentioned",
                     0,
                     NA_real_))
    dummy_df <- dat %>%
      select ( all_of(dummy_vars) ) %>%
      mutate_all ( labelled::to_factor ) %>%
      mutate_all ( as.character ) %>%
      mutate_all ( tolower ) %>%
      mutate_all ( recode_dummy )
  }

  if ( length(dummy_vars) > 0 ) {
    dummy_df <- dat %>%
      select ( all_of(dummy_vars) ) %>%
      mutate_all ( harmonize_value_labels )
  }

  factor_vars <- class_conversion %>%
    filter ( conversion == 'factor') %>%
    select ( all_of("var")) %>%
    unlist() %>%
    as.character()

  if ( length(factor_vars) > 0 ) {

    factor_vars_present <- TRUE
    relabel_factors <- function(x) {
      x <- labelled::to_factor(x, drop_unused_labels = TRUE)
    }

    factor_df <- dat %>%
      select ( all_of(factor_vars) ) %>%
      mutate_all ( relabel_factors  )
  } else {
    factor_vars_present <- FALSE
  }

  ## Binding together by class -------------------------------------
  remerged_dat <- tibble::tibble (
    remove_this_in_the_end_concert_class = vector(
      mode='logical', length=nrow(dat))
  )

  if ( character_vars_present ) {
    remerged_dat <- bind_cols(remerged_dat,character_df)
  }

  if ( numeric_vars_present ) {
    remerged_dat <- bind_cols(remerged_dat,numeric_df)
  }

  if ( labelled_harmonized_vars_present ) {
    remerged_dat <- bind_cols (
      remerged_dat, labelled_harmonized_df )
  }

  if ( labelled_unharmonized_vars_present) {
    remerged_dat <- bind_cols (
      remerged_dat, labelled_unharmonized_df )
  }

  if ( dummy_vars_present ) {
    remerged_dat <- bind_cols (
      remerged_dat, dummy_df )
  }

  if ( factor_vars_present ) {
    remerged_dat <- bind_cols (
      remerged_dat, factor_df )
  }

  missing_from_return <- names(dat) [! names(dat) %in% names (remerged_dat)]
  if ( length(missing_from_return) >0 ){
    stop ( "The following columns were lost:\n",
           paste(missing_from_return, collapse = ","),
           "\nThis is an error.")
  }

  remerged_dat <- remerged_dat %>%
    select ( all_of(original_name_order))

  rename_dummies <- names(remerged_dat)

  remerged_dat %>%
    purrr::set_names (., nm= ifelse ( rename_dummies  %in% dummy_vars,
                                      paste0('is_', rename_dummies ),
                                      names(remerged_dat))
                      )


}
