#' @title Read in a GESIS SPSS file
#'
#' Read in an SPSS file archived in GESIS and change the variables to
#' R classes for further use.
#'
#' @param path An object to be converted to character
#' @param zacat_id Default to \code{NULL}. Not used in this instance
#' of the method.
#' @param rename Default to \code{TRUE} which creates machine-readable
#' variable names from the original SPSS variable names with calling the
#' function \code{\link{canonical_names}}. If you set it to
#' \code{FALSE} it will create serial variable names, given that the SPSS
#' file names cannot be directly used because of the their special characters.
#' @param unique_id It makes sense to call harmonize the variable name which
#' contains the unique, serial identifier within the SPSS file. Defaults to
#' \code{TRUE} which calls \code{\link{unique_id_create}}.
#' @param conversion Defaults to \code{'labelled'}.
#' \code{'factor'} converts all SPSS labelled variables to factors.
#' Alternative is \code{'character'} which behaves better with visualization.
#' @importFrom purrr possibly map_chr
#' @importFrom rlang set_names
#' @importFrom haven read_spss is.labelled
#' @importFrom dplyr mutate_if
#' @return A tibble (data.frame) with R classes defined by the user in the
#' case of non-numeric data (i.e.\code{'labelled'}, \code{'factor'},
#' or \code{'character'})
#' @examples
#' \dontrun{
#' ##use your own file:
#' gesis_spss_read(    path = file.path ( 'not_included', 'example.sav'),
#'                     zacat_id = NULL )
#' }
#' @export

gesis_spss_read <- function ( path = NULL,
                              zacat_id = NULL,
                              rename  = TRUE,
                              unique_id = TRUE,
                              conversion = 'labelled') {
  . <- NULL

  if ( ! is.null(path) ) {

    possibly_read_spss <-  purrr::possibly( haven::read_spss,
                                            otherwise = NULL)
    read_df <- possibly_read_spss (path)

    if ( is.null(read_df) ) {
      stop ( "File could not be found or read.")
    }

  } else if ( ! is.null(zacat_id) ) {

    message ( "this is not yeat written")

  } else {
    stop ('No path or zacat_id given.')
  }

  ## Unless otherwise stated, the variable names will be brought to
  ## a more canonical form -----------------------------------------------
  if ( rename == TRUE ) {

    read_df <-  read_df %>%
      rlang::set_names (., nm = read_df %>%
                          purrr::map_chr(~attributes(.)$label) %>%
                          canonical_name_create (.)   )
  }

  ## Unless otherwise stated, the unique serial ID will have a harmonized
  ## name, i.e. unique_id ------------------------------------------------
  if ( unique_id == TRUE ) {
    read_df <-  unique_id_create( read_df )
  }

  ## Unless otherwise stated, the haven labelled classes will be used ----

  if ( is.null ( conversion ) ) {
    return(read_df)
  } else if ( conversion == 'labelled') return ( read_df )

  ## If the users wants to use less specific, base R variable classes
  ## factor or character can be used  -----------------------------------

  if ( ! conversion %in% c('labelled', 'factor', 'character')) {
    warning ( "Parameter conversion = '", conversion, "' is not implemented.\nIt can be 'labelled', 'factor' or 'character'.")
    message ( "Parameter conversion reset to 'factor'")
    conversion <- 'factor'
  }

  message ( "Read ", path, '\n', "Continue to change labelled variables to ", conversion )

  read_df_relevelled <- dplyr::mutate_if ( read_df,
                                           haven::is.labelled,
                                           haven::as_factor )

  if ( conversion == 'factor' ) {
    read_df_relevelled

  } else if ( conversion == 'character' )  {
    dplyr::mutate_if ( read_df_relevelled,
                       is.factor,
                       as.character )
  }
}
