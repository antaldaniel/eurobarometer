#' @title Recode Age Education
#'
#' If age exact is labelled to a number less than 10, coded to 15.
#' Refused answers are coded to missing.
#' Still studying answers are recoded to the exact age, when given,
#' otherwise to missing.
#' @param var Age Education variable
#' @param age_exact The exact age variable, defaults to \code{NULL}.
#' @importFrom dplyr case_when
#' @importFrom haven as_factor
#' @family recode functions
#' @examples
#' #Exact age is given
#' recode_age_education  (
#'  var =  c( "2 years", "75 years", NA_real_,
#'            "Still studying", "Refusal",
#'            "No full-time education"),
#'  age_exact = c(87, 75, 34,23, 19, 45)
#'  )
#'
#' #Exact age is not given, school living is recoded to missing
#' recode_age_education  (
#'  var =  c( "2 years", "75 years", NA_real_,
#'            "Still studying", "Refusal",
#'            "No full-time education")
#'            )
#' @export

recode_age_education <- function ( var, age_exact = NULL ) {

  if ( class(var) == "haven_labelled" )  {
    var <- haven::as_factor (var)
  }

  if ( is.null(age_exact)) age_exact = as.character(var)
  age_exact <- as.character(age_exact)

  age_education_special <- tolower(as.character(var))
  var [ is.na(age_education_special)]

  tested <- case_when (
    age_education_special == "no full-time education" ~ "15",
    grepl ( " years", age_education_special) ~ gsub(" years", "", as.character(age_education_special)) ,
    age_education_special == "still studying" ~ as.character(age_exact),
    age_education_special %in% c("dK", "declined", "refusal", "na")  ~ NA_character_,
    is.na(age_education_special) ~ NA_character_,
    TRUE ~ as.character(age_education_special)
  )

  case_when (
    as.numeric ( tested ) < 15 ~ 15,
    TRUE ~ as.numeric(tested)
    )

}


