#' Create Canonical Names for GESIS Columns
#'
#' Create canonical names that do not vary across several SPSS files
#' from different years.
#' @param metadata A metadata data frame created by
#' \code{\link{gesis_metadata_create}}
#' @importFrom stringr str_sub
#' @family naming functions
#' @examples
#' canonical_names ( c("digital_object_identifier",
#'                     "tns_unique_case_id") )
#' @export

canonical_names <- function(metadata) {

  x <- trimws(tolower(as.character(metadata$normalized_name)))
  x <- normalize_names (x)
  x <- ifelse (metadata$r_name == "caseid", "caseid", x)
  x <- ifelse (metadata$r_name == "uniqid", "uniqid", x)
  x <- ifelse (metadata$r_name == "doi", "doi", x)

  head ( x, 30)

  x <- ifelse ( test = grepl("unique_case_id", x),
                yes = "	uniqid", no = x)
  x <- ifelse ( grepl("digital_object_identifier", x),
                "doi",
                x)

  x <- ifelse ( grepl("wex_weight_extra", x),
                "wex",
                x)

  x <- gsub( '\\s', '_', x)
  x <- gsub( '___', '_', x)
  x <- gsub( '__', '_', x)

  x <- ifelse ( test = stringr::str_sub ( x, 1,  1 ) == '_',
                yes  = stringr::str_sub ( x, 2, -1 ),
                no   = x  )
  x
}
