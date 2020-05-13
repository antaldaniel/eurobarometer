#' Create Normalized Variable Names for GESIS Columns
#'
#' @param x A vector of the GESIS variable names
#' @importFrom stringr str_sub
#' @examples
#' normalize_names ( c("UPPER CASE VAR", "VAR NAME WITH % SYMBOL") )
#' @export

normalize_names <- function(x) {

  y <- trimws(tolower(as.character(x)))

  ##do the abbreviations first that may have a . sign
  y <- gsub( '\\ss\\.a\\.', '_sa', y)

  ##remove special regex characters
  y <- gsub( '\\&', '_and_', y)
  y <- gsub( '\\+', '_plus_', y)
  y <- gsub( '\\%', '_pct_', y)
  y <- gsub( '<', '_lt_', y)
  y <- gsub( '>', '_gt_', y)
  y <- gsub('\\.|-|\\:|\\;|\\/|\\(|\\)|\\!', '_', y)

  ##remove space(s)
  y <- gsub('\\s\\s', '\\s', y)

  y <- ifelse ( test = stringr::str_sub ( y, -1, -1 ) == '_',
                yes  = stringr::str_sub ( y,  1, -2 ),
                no   = y  )

  y <- gsub( '^q[abcde]\\d{1,2}', '', y )  # remove QA1, QB25 etc
  y <- gsub( '^d\\d{1,2}', '', y )       # removed d26_ etc
  y <- gsub( '^c\\d{1,2}', '', y )       # removed c26_ etc
  y <- gsub ( "^p\\d+{1,}_", "", y)  #remove p6_ like starts
  y <- gsub ( "^p\\d+{1,}\\s", "", y)  #remove p6  like starts
  y <- gsub ( "^q\\d+{1,}_", "", y)  #remove q1_ like starts
  y <- gsub ( "^q\\d+{1,}\\s", "", y)  #remove q1  like starts

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

  #x <- gsub( 'á', 'a', x)
  #x <- gsub( 'ü', 'u', x)
  #x <- gsub( 'é', 'e', x)

  y  <- gsub("15_plus", "gt_15", y)
  y  <- gsub("wex_weight_extra_population_gt_15", "wex", y)
  y  <- ifelse ( substr(y,1,3) =="w1_",
                 'w1', y)

  y <- ifelse ( test = stringr::str_sub ( y, 1,  1 ) == '_',
                yes  = stringr::str_sub ( y, 2, -1 ),
                no   = y  )
  y
}
