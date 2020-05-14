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

  ## Hard replacmenet ------------------------
  x <- ifelse ( grepl("unique_case_id", x),
                yes = "uniqid",
                no  = x )
  x <- ifelse ( grepl("digital_object_identifier", x),
                yes = "doi",
                no  = x )
  x <- ifelse ( grepl("wex_weight_extra", x),
                yes = "wex",
                no  = x )
  x <- ifelse ( grepl("trend_type_of_community", x),
                yes = "type_of_community",
                no  = x )
  x <- ifelse ( grepl("gesis_archive_version", x),
                yes = "gesis_archive_version_and_date",
                no  = x )



  appears_replace <- function(x, appears, replace) {
    ifelse ( grepl(appears,x ),
             yes = gsub( appears, replace , x),
             no  = x )
  }

  x <- appears_replace ( x, appears = "cultural_act_go_to|cultural_act_visit",
                         replace ="cultural_activities_freq" )
  x <- appears_replace ( x, appears = "trend_type_of_community",
                         replace ="type_of_community" )
  x <- appears_replace ( x, appears = "durables_appartment|durables_appartm",
                         replace ="durables_apartment" )
  x <- appears_replace ( x, appears = "durables_ap_house",
                         replace ="durables_apartment_house" )

  x  <- gsub("recoded_3_categories", "rec_3", x)
  x  <- gsub("recoded_4_categories", "rec_4", x)
  x  <- gsub("recoded_5_categories", "rec_5", x)
  x  <- gsub("recoded_6_categories", "rec_6", x)
  x  <- gsub("recoded_7_categories", "rec_7", x)
  x  <- gsub("recoded_8_categories", "rec_8", x)
  x  <- gsub("recoded_11_categories", "rec_11", x)
  x  <- gsub("recoded_3_cat", "rec_3", x)
  x  <- gsub("recoded_4_cat", "rec_4", x)
  x  <- gsub("recoded_5_cat", "rec_5", x)
  x  <- gsub("recoded_6_cat", "rec_6", x)
  x  <- gsub("recoded_7_cat", "rec_7", x)
  x  <- gsub("recoded_8_cat", "rec_8", x)
  x  <- gsub("recoded_11_cat", "rec_11", x)
  x  <- gsub("3_cat_recoded", "rec_3", x)
  x  <- gsub("4_cat_recoded", "rec_4", x)
  x  <- gsub("5_cat_recoded", "rec_5", x)
  x  <- gsub("6_cat_recoded", "rec_6", x)
  x  <- gsub("7_cat_recoded", "rec_7", x)
  x  <- gsub("8_cat_recoded", "rec_8", x)
  x  <- gsub("11_cat_recoded", "rec_11", x)

  x <- gsub( '\\s', '_', x)
  x <- gsub( '___', '_', x)
  x <- gsub( '__', '_', x)

  x <- ifelse ( test = stringr::str_sub ( x, 1,  1 ) == '_',
                yes  = stringr::str_sub ( x, 2, -1 ),
                no   = x  )
  x
}
