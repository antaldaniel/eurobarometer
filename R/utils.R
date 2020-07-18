#' Identify A Question Block
#'
#' Add a question block identifier in column \code{qb}.
#' @param metadata A metadata file created by metadata_create within
#' \code{\link{gesis_metadata_create}}
#' @return The metadata data frame with a new column \code{qb}.
#' @importFrom magrittr %>%
#' @importFrom dplyr case_when mutate select
#' @importFrom tidyselect all_of
#' @keywords internal

question_block_identify <- function (metadata) {

  var_name_orig <- panel_id <- NULL

  var_name_suggested <- as.character(metadata$var_name_suggested)
  var_label_orig <- as.character(metadata$var_label_orig)
  n_categories <- metadata$n_categories

  qb <- vector ( mode = 'character', length = length(var_name_suggested))


  metadata_tmp <- metadata %>%
    mutate (
      orig_1 = tolower(substr(var_name_orig, 1, 1)),
      orig_2 = tolower(substr(var_name_orig, 1, 2))
      ) %>%
    mutate (qb  = case_when (
    var_name_suggested %in%
      c("filename", "doi", "uniqid" )              ~  "id",
    grepl( "gesis_archive", var_name_suggested)    ~  "id",
    orig_1 == "p"                                  ~  "metadata",
    var_name_orig == "isocntry"                    ~  "metadata",
    var_name_orig %in%
      c("d7", "d8", "d25", "d60")                  ~  "socio-demography",
    orig_1 == "w"                                  ~  "weights",
    grepl ( "trust_in|_trust", var_name_suggested) &
      n_categories  == 4                           ~  "trust",
    ## add further cases here
    TRUE ~ 'not_identified')
    )

 metadata_tmp %>%
   select ( -all_of(c("orig_1", "orig_2")) )
}

#' To Survey List
#'
#' @param x A list of survey data frames or a single survey data frame.
#' @return A list of surveys.
#' @keywords internal

to_survey_list <- function (x) {
  if ( ! "list" %in% class(x) ) {
    if ( "data.frame" %in% class(x) ) {

      if ( ! "filename" %in% names(x) )
        x$filename = "not_given"
      attr(x$filename, "label") <- "not_given"

      x <- list ( survey = x )
    } else {
      stop ( "Parameter 'survey_list' must be a list of data frames or a single data frame.")
    }
  }
  x
}

#' Harmonize Missing Values
#'
#' @param x A vector of labelled or the character vector of
#' value labels.
#' @importFrom labelled to_character labelled
#' @importFrom dplyr case_when mutate
#' @importFrom tibble tibble
#' @family harmonize functions
#' @return A helper table to harmonize missing values.
#' @keywords internal

harmonize_missing_values <- function (x) {

  if ( all( c("haven_labelled", "double") %in% class(x)) ) {
    x <- labelled::to_character(x)
  } else {
    x <- as.character(x)
  }

  tmp <- tibble::tibble (
    label_norm = label_normalize(x)
  )

  tmp %>%
    mutate (
      na_harmonized = dplyr::case_when (
      grepl("inap_", label_norm) ~ "inap",
      grepl("decline|dk|refuse", label_norm) ~ "decline",
      label_norm %in% c("dont_know") ~ "do not know",
      label_norm %in% c("na") ~ "inap",
      TRUE ~ label_norm )
    ) %>%
    mutate ( na_numeric_value =  case_when (
      na_harmonized == "inap"  ~  99999,
      na_harmonized == "decline" ~ 99998,
      na_harmonized == "do_not_know" ~ 99997,
      TRUE ~ 99900
    ))
}
