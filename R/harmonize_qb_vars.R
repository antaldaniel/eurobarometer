#' @title Harmonize A Question Block in Surveys
#'
#' Harmonize the variable names and the class of a question block.
#' @param survey_list A list of data frames containing surveys.
#' @param metadata A metadata table that contains \code{var_name_orig} and
#' \code{qb} for the questions blocks, and \code{var_name_suggested} or
#' its user defined alternative, \code{class_suggested} or its user defined
#' alternative.
#' @param question_block A user defined question block, or pre-defined
#' question blocks: \code{"id"}, \code{"metadata"}, \code{"weights"},
#' \code{"socio-demography"}.
#' @param id_vars A vector of ID variables to form a panel ID var,
#' defaults to \code{c("uniqid", "doi")}.
#' @param var_name Defaults to \code{var_name_suggested}. Must be
#' a column in \code{metadata}.
#' @param conversion Defaults to \code{class_suggested}. Must be
#' a column in \code{metadata}.
#' @importFrom dplyr select filter bind_cols distinct_at distinct
#' @importFrom purrr set_names
#' @importFrom magrittr %>%
#' @importFrom tidyselect all_of
#' @return A tibble containing all variables with harmonized names and
#' classes, and a unique key column named \code{panel_id}.
#' @family harmonization functions
#' @examples
#' \dontrun{
#' harmonize_qb_vars (
#'    survey_list,
#'    metadata,
#'    question_block = "socio-demography",
#'    var_name = "var_name_suggested",
#'    conversion = "class_suggested"
#'    )
#' }
#' @export

harmonize_qb_vars <- function ( survey_list,
                                metadata,
                                id_vars = c("uniqid", "doi"),
                                question_block = "socio-demography",
                                var_name = "var_name_suggested",
                                conversion = "class_suggested" ) {

  id_vars_input <- id_vars
  id_vars <- qb <- survey_subset <- var_name_orig <- NULL
  . <- panel_id <- NULL

  if ( ! "list" %in% class(survey_list) ) {
    survey_list <- to_survey_list(survey_list)
  }

  if ( ! var_name %in% names(metadata) ) {
    stop( var_name , " is not in <metadata>." )
  }

  qb_metadata <- metadata %>%
    filter ( qb == question_block )

  if ( nrow(qb_metadata) == 0 ) {
    warning("No ", question_block,  " variables found.")
    ## Shall it return an empty tibble?
  }

  qb_vars_orig <- qb_metadata[["var_name_orig"]]
  qb_vars <- qb_metadata[[var_name]]

  ## Subsetting the individual survey --------------------------------------
  survey_subset <- function( dat ) {

    select_qb <- names(dat)[ names(dat) %in% qb_vars_orig ]

    subset_metadata <- qb_metadata %>%
      filter ( var_name_orig %in% select_qb ) %>%
      filter ( filename == unique(dat$filename)[1] )

    #remove not found in this particular file
    select_qb <-  subset_metadata$var_name_orig

    new_names <- unique(as.character(subset_metadata[[var_name]]))

    if ( length(new_names) != length(select_qb) ) {
      stop ( "Old names: ", paste(select_qb, collapse = ","),
             "\nlength: ",  length(select_qb),
             "\nNew names:", paste(new_names, collapse=(",")),
             "\nlength: ",  length(new_names) )
    }

    select_conversion <- subset_metadata %>%
      distinct_at ( all_of(c(var_name, conversion)),.keep_all = FALSE )

    skeleton <- dat %>%
      id_create ( ., id_vars = id_vars_input ) %>%
      select( -all_of(id_vars_input))

    question_block <- dat %>%
      select(all_of( select_qb ))

    if ( ncol(question_block) > 0 ) {
      question_block <- question_block %>%
        purrr::set_names ( new_names )

      question_block <- convert_class (
         dat = question_block,
         metadata = subset_metadata,
         conversion = conversion )

      dplyr::bind_cols(skeleton, question_block)
    } else {
      skeleton
    }
  }

  #dat_1 <- survey_subset ( dat = survey_list [[1]] )
  #dat_2 <- survey_subset ( dat = survey_list [[2]] )
  #dat_3 <- survey_subset ( dat = survey_list [[3]] )

  subsetted_surveys <- lapply (survey_list, survey_subset)

  number_vars <- unlist (lapply ( subsetted_surveys, ncol))
  only_id <- which( number_vars == 1 )

  if (length(only_id)>0) {
    warning("The survey in position ", only_id, " of the input list contains no '",
            question_block, "' variables.")
  }

  if ( length(unique(number_vars)) == 1 ) {
    do.call(rbind, lapply (survey_list, survey_subset) )
  } else {
    return_df <- subsetted_surveys[[1]]
    number_surveys <- length(subsetted_surveys)

    if ( number_surveys  > 1 ) {

      for ( i in 2:number_surveys  ) {
        this_survey <- subsetted_surveys[[i]]

        if (
          ## Only join surveys with existing variables in the QB
          ncol(this_survey) > 1
          ) {
          names_in_this_survey <- names (this_survey)
          join_by_vars <- names(return_df)[names(return_df) %in% names_in_this_survey ]

          return_df <- full_join (
              return_df, this_survey,
              by = join_by_vars
            )
        }
      } # loop in surveys
    }
   return_df
  }
}
