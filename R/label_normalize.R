#' Create Normalized Variable & Value Labels
#'
#' Remove relative reference to question blocks, special characters
#' used in regular expressions, whitespace and bring the variable and
#' value labels to snake_case_format.
#'
#' @param x A vector of the (GESIS) variable or value labels
#' @importFrom stringr str_sub str_trim
#' @family naming functions
#' @return A character vector with the normalized labels
#' @examples
#' label_normalize ( c(
#' "QA17_1 EUROPEAN PARLIAMENT - TRUST",
#' "QA13_1 TRUST IN INSTITUTIONS: NAT GOVERNMENT" )
#'  )
#' @export

label_normalize <- function(x) {

  ## unit tests for this function are in
  ## tests/testthat/test-label_normalize.R
  ## please add test after correcting for unexpected results

  y <- trimws(tolower(as.character(x)))

  ##do the abbreviations first that may have a . sign
  y <- gsub( '\\ss\\.a\\.', '_sa', y)

  ## remove prefix of question block numbers
  y <- gsub( '^q[abcde]\\d{1,2}_\\d{1,2}', '', y )  # remove QA117_1
  y <- gsub( '^q[abcde]\\d{1,2}', '', y )  # remove QA1, QB25 etc
  y <- gsub( '^d\\d{1,2}', '', y )       # removed d26_ etc
  y <- gsub( '^c\\d{1,2}', '', y )       # removed c26_ etc
  y <- gsub ( "^p\\d+{1,}_", "", y)  #remove p6_ like starts
  y <- gsub ( "^p\\d+{1,}\\s", "", y)  #remove p6  like starts
  y <- gsub ( "^q\\d+{1,}_", "", y)  #remove q1_ like starts
  y <- gsub ( "^q\\d+{1,}\\s", "", y)  #remove q1  like starts
  y <- gsub( '^\\d{1,2}_', '', y ) #remove leading number 1_
  y <- stringr::str_trim(y, side = "both")

  ##remove special regex characters
  y <- gsub( '\\&', '_and_', y)
  y <- gsub( '\\+', '_plus_', y)
  y <- gsub( '\\%', '_pct_', y)
  y <- gsub( '<', '_lt_', y)
  y <- gsub( '>', '_gt_', y)
  y <- gsub('\\.|-|\\:|\\;|\\/|\\(|\\)|\\!', '_', y)
  y  <- gsub("15_plus", "gt_15", y)

  ##remove space(s) and some other characters -------------
  y <- gsub('\\s\\s', '\\s', y)
  y <- gsub("\\'", "",  y)

  y <- ifelse ( test = stringr::str_sub ( y, -1, -1 ) == '_',
                yes  = stringr::str_sub ( y,  1, -2 ),
                no   = y  )
  y <- stringr::str_trim(y, side = "both")

  ## groups and recategorizations -----------------------
  y  <- gsub("recoded_three_groups", "rec_3", y)
  y  <- gsub("recoded_four_groups", "rec_4", y)
  y  <- gsub("recoded_five_groups", "rec_5", y)
  y  <- gsub("recoded_six_groups", "rec_6", y)
  y  <- gsub("3_groups_recoded", "rec_3", y)
  y  <- gsub("4_groups_recoded", "rec_4", y)
  y  <- gsub("5_groups_recoded", "rec_5", y)
  y  <- gsub("6_groups_recoded", "rec_6", y)
  y  <- gsub("7_groups_recoded", "rec_7", y)
  y  <- gsub("8_groups_recoded", "rec_8", y)
  y  <- gsub("11_groups_recoded", "rec_11", y)
  y  <- gsub("3_cat_recoded", "rec_3", y)
  y  <- gsub("4_cat_recoded", "rec_4", y)
  y  <- gsub("5_cat_recoded", "rec_5", y)
  y  <- gsub("6_cat_recoded", "rec_6", y)
  y  <- gsub("7_cat_recoded", "rec_7", y)
  y  <- gsub("8_cat_recoded", "rec_8", y)
  y  <- gsub("11_cat_recoded", "rec_11", y)
  y <- gsub( '\\s', '_', y)
  y <- gsub( '___', '_', y)
  y <- gsub( '__', '_', y)

  # Shall we remove Central & Eastern European characters, Greek characters?
  #x <- gsub( 'á', 'a', x)
  #x <- gsub( 'ü', 'u', x)
  #x <- gsub( 'é', 'e', x)

  y <- ifelse ( test = stringr::str_sub ( y, 1,  1 ) == '_',
                yes  = stringr::str_sub ( y, 2, -1 ),
                no   = y  )

  y <- ifelse ( test = stringr::str_sub ( y, 1,  1 ) == '_',
                yes  = stringr::str_sub ( y, 2, -1 ),
                no   = y  )

  stringr::str_trim(y, side = "both")
}
