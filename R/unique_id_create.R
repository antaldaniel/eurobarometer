#' @title Unique ID create
#'
#' GESIS usually, but not always, calls the unique observation identifier
#' within a data table \code{'uniqid'}. These ID's are unique within one
#' survey data frame, but not in the whole GESIS archive.
#'
#' This helper function makes sure that whatever it is called in the GESIS
#' SPSS file, it will be renamed to uniqid.
#'
#' @param df A data frame like object with the raw statistical data.
#' @return The \code{df} with a unique identifier.
#' @export
#'

unique_id_create <- function ( df ) {

  . <- uniqid <- NULL

  names_df <- names ( df )

  possible_id_identifiers <- "serial_case_id|serial_case_number|national_serial_id|id_serial_number"

  if ( any ( grepl( possible_id_identifiers, names_df)) ) {

   possible_id_var <-  names_df [grepl( possible_id_identifiers, names_df)]

   if ( length( possible_id_var) != 1 ) {
     stop ( "Could not identify ID variables. Candidates are ", possible_id_var )
   } else {
     names(df)[which (  names(df)  == possible_id_var)] <- 'unique_id'
   }

  }

  df
}
