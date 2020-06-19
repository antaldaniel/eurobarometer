#' Add standard NUTS1 codes
#'
#' Currently works only with NUTS2010 (for years 2012-2014) and NUTS2013
#' (for years 2015-2017). In the case of earlier and later data sets
#' boundary changes may effect some regions. See
#' [Eurostat History of NUTS](http://ec.europa.eu/eurostat/web/nuts/history).
#' Small countries where Eurobarometer has NUT3 level data are aggregated
#' to NUTS2 (Croatia, Ireland, Latvia, Lithuania, Slovenia). Malta, Cyprus
#' and Luxembourg receive an auxilliary code MT00, CY00, LU00.
#' In the United Kingdom, NUTS2 level data is available only for Northern
#' Ireland. The country code of the United Kingdom in the GESIS files is
#' GB, but in the NUTS2 vocubulary it is UK.
#' In Germany, France, Italy and the United Kingdom only NUTS1 level data
#' is available.
#' The region codes of Greece (GR) start with EL.
#' @param region_nuts_names A region_nuts_names column from a GESIS file.
#' @param country_code To avoid ambigouity with NUTS name coding,
#' provide country codoes if possible. There are a few ambigous names in
#' Europe. Defaults to \code{NULL}.
#' @param nuts_code Currently only \code{code10} and \code{code13}
#' is supported.
#' @importFrom dplyr left_join mutate_all mutate filter add_count
#' @importFrom magrittr %>%
#' @importFrom utils data
#' @examples
#'code_nuts1 (
#'  region_nuts_names = c("Brandenburg", "London", "Centro", NA),
#'  country_code = c("DE", "GB", "IT", NA)
#'  )
#' code_nuts1 (
#'    region_nuts_names = c("Brandenburg", "London", "Centro", NA)
#'   )
#' @export

code_nuts1 <- function ( country_code = NULL,
                         region_nuts_names,
                         nuts_code = "code10" )  {

   . <- vocabulary_nuts1 <- NULL

  if (! nuts_code %in% c("code10", "code13")) {
    stop("Currently only NUTS2010 (for years 2012-2014)
         and NUTS2013 (for years 2015-2017) can be coded.")
  }

 nuts1 <- vector ( mode = "character", length = length(region_nuts_names))
 country_code <- as.character(country_code)
 region_nuts_names <- as.character(region_nuts_names)

 utils::data("vocabulary_nuts1", package = "eurobarometer", envir = environment())


 if ( is.null(country_code) ) {
   vocabulary <- vocabulary_nuts1 %>%
     mutate (region_nuts_names = tolower(as.character(region_nuts_names)))

   df <- data.frame ( region_nuts_names = tolower(as.character(region_nuts_names)),
                      stringsAsFactors = FALSE)
   df$row <- 1:nrow(df)
   nuts1_df <- dplyr::left_join ( df, vocabulary,
                                  by = "region_nuts_names") %>%
     add_count( row ) #check there are not duplicates
 } else {
   country_code <- ifelse ( "UK" == country_code, "GB", country_code )

   vocabulary <- eurobarometer::vocabulary_nuts1 %>%
     mutate ( country_code = tolower(as.character(country_code)),
              region_nuts_names = tolower(as.character(region_nuts_names)))

   df <- data.frame ( country_code = tolower(as.character(country_code)),
                      region_nuts_names = tolower(as.character(region_nuts_names)),
                      stringsAsFactors = FALSE)

   df$row <- 1:nrow(df)
   nuts1_df <- dplyr::left_join ( df, vocabulary,
                                  by = c("country_code",
                                         "region_nuts_names")
                                  ) %>%
     add_count( row ) #check there are not duplicates

 }
 if ( any(nuts1_df$n > 1) ) {
   warning("Duplicate region names found!")
 }

 if (nuts_code == "code10") return(nuts1_df$code10)
 if (nuts_code == "code13") return(nuts1_df$code13)

}
