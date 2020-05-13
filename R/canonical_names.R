#' Create Normalized Variable Names for GESIS Columns
#'
#' @param x A vector of the GESIS variable names
#' @importFrom stringr str_sub
#' @examples
#' normalize_names ( c("UPPER CASE VAR", "VAR NAME WITH % SYMBOL") )
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
