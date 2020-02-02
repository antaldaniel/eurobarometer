#' @title Harmonize gender variable
#'
#' @param df A data frame like object with the raw statistical data.
#' @param harmonized_name The harmonized name of the variable.
#' @return The \code{df} with the gender binary variable in the data frame
#' names as \code{gender}
#' @examples
#' \dontrun{
#' gesis_spss_read ( path = file.path('data-raw', 'example.sav'),
#'                   rename = TRUE,
#'                   unique_id = TRUE ) %>%
#'    recode_var (., harmonized_name = "gender")
#' }
#' @export

rename_var <- function ( df,
                         harmonized_name = "gender" ) {

  . <- canonical_name <- harmonized_var <- NULL


  ## Check if the harmonized name can be found in the vocabulary --------

  if ( ! harmonized_name %in% eurobarometer_vocabulary$harmonized_name ) {
    stop ( "Variable '", harmonized_name, "' cannot be found in the internal package vocabulary." )
  }

  names_df <- names ( df )

  harmonize_vars <- eurobarometer_vocabulary %>%
    dplyr::filter ( harmonized_name == harmonized_name ) %>%
    dplyr::select ( harmonized_name, canonical_name )

  if ( any (harmonize_vars$canonical_name %in% names (df)) ) {

    possible_harmonized_var <-  names_df [ names_df %in% harmonize_vars$canonical_name]

    if ( length( possible_harmonized_var ) != 1 ) {
      stop ( "Could not identify '", harmonized_name , "' variables.\nCandidates are ", possible_harmonized_var )
    } else {
      names(df)[which (  names(df)  == possible_harmonized_var)] <- harmonized_var
    }

  }
  df
}
