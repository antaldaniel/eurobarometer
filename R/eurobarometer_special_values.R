#' Eurobarometer Special Values
#'
#' Special values used in the Eurobarometer surveys with harmonized
#' labels and harmonized numeric values.
#' @importFrom tibble tribble
#' @return A tibble (data frame) of the special numeric values with
#' labels.
#' @examples
#' eurobarometer_special_values()
#' @family harmonization functions
#' @export

eurobarometer_special_values <- function() {

  ## use range 99990-99999 for NA values
  ## use range 99890-99800 for education related special values
  ## start new range after 99800 for special values in other topics
  ## use 99000 for unidentified special value (likely labelling error)
  ## not stated here

  tibble::tribble(
    ~labels, ~num_value,  ~description,
    "inap"          , 99999, "inappropriate (f.e. question filtered out for respondant)",
    "declined"      , 99998, "respondant declined to answer, refused to answer",
    "do_not_know"   , 99997, "do not know defined as missing answer",
    "still_studying", 99890, "respondent did not finish education yet"
  )

}
