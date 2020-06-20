#' @title Create A Skeleton Survey
#'
#' @param survey_list A list of data frames containing surveys.
#' @param id_vars A vector of ID variables to form a panel ID var,
#' defaults to \code{c("uniqid", "doi")}.
#' @return A tibble with the number of original ID vars and their
#' \code{panel_id} as their concatenation for several surveys.
#' @family harmonization functions
#' @examples
#' data (ZA7576_sample)
#' data (ZA7562_sample)
#' data (ZA7489_sample)
#'
#' survey_list <- list ( 'ZA7576_sample' = ZA7576_sample,
#'                       'ZA7562_sample' = ZA7562_sample,
#'                       'ZA7489_sample' = ZA7489_sample)
#' panel_create (survey_list, id_vars =c("uniqid", "doi") )
#' @export


panel_create <- function (survey_list,
                          id_vars = c("uniqid", "doi") ) {

  input_id_vars <- id_vars
  panel_id <- NULL
  id_vars <- NULL

  # in case of unexpected results, after fixing add a unique test
  # to tests/testthat/test-panel_create.R

  results_id <- lapply (
    survey_list,
    function(x) id_create (dat = x, id_vars = input_id_vars)
    )

  do.call(rbind,results_id )

}
