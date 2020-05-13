#' Create Normalized Variable Names for GESIS Columns
#'
#' @param x A vector of the GESIS variable names
#' @importFrom stringr str_sub
#' @examples
#' normalize_names ( c("UPPER CASE VAR", "VAR NAME WITH % SYMBOL") )
#' @export

normalize_names <- function(x) {

  x <- trimws(tolower(as.character(x)))

  ##do the abbreviations first that may have a . sign
  x <- gsub( '\\ss\\.a\\.', '_sa', x)

  ##remove special regex characters
  x <- gsub( '\\&', '_and_', x)
  x <- gsub( '\\+', '_plus_', x)
  x <- gsub( '\\%', '_pct_', x)
  x <- gsub('\\.|-|\\:|\\;|\\/|\\(|\\)|\\!', '_', x)

  ##remove space(s)
  x <- gsub('\\s\\s', '\\s', x)

  x <- ifelse ( test = stringr::str_sub ( x, -1, -1 ) == '_',
                yes  = stringr::str_sub ( x,  1, -2 ),
                no   = x  )

  x <- gsub( '^q[abc]\\d{1,2}', '', x )  # remove QA1, QB25 etc
  x <- gsub( '^d\\d{1,2}', '', x )       # remove QA1, QB25 etc

  x <- gsub( '\\s', '_', x)
  x <- gsub( '___', '_', x)
  x <- gsub( '__', '_', x)

  #x <- gsub( 'á', 'a', x)
  #x <- gsub( 'ü', 'u', x)
  #x <- gsub( 'é', 'e', x)

  x <- ifelse ( test = stringr::str_sub ( x, 1,  1 ) == '_',
                yes  = stringr::str_sub ( x, 2, -1 ),
                no   = x  )
  x
}
