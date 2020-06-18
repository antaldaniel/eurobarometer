#' @title Create A Panel Skeleton With Unique ID
#'
#' @param survey_list A list of data frames containing surveys.
#' @param id_vars A vector of ID variables to form a panel ID var,
#' defaults to \code{c("uniqid", "doi")}.
#' @importFrom dplyr select mutate
#' @importFrom tidyr unite
#' @importFrom tidyselect all_of
#' @return A tibble with the number of original ID vars and their
#' \code[panel_id] as their concatenation.
#' @examples
#' data (ZA7576_sample)
#' data (ZA7562_sample)
#' data (ZA7489_sample)
#'
#' survey_list <- list ( 'ZA7576_sample' = ZA7576_sample,
#'                       'ZA7562_sample' = ZA7562_sample,
#'                       'ZA7489_sample' = ZA7489_sample)
#' create_panel_id (survey_list, id_vars =c("uniqid", "doi") )
#' @export


create_panel_id <- function (survey_list, id_vars = c("uniqid", "doi") ) {

  # in case of unexpected results, after fixing add a unique test
  # to tests/testthat/test-create_panel_id.R

  create_id <- function (dat, id_vars = c("uniqid", "doi") ) {

    if ( ! all(id_vars %in% names(dat)) ) {
      stop ( "Not (all) of ",
             paste ( id_vars, collapse = ", "),
             " present in <dat>.")
    }

    dat %>%
      select ( all_of ( id_vars )) %>%
      unite ( col = 'panel_id', all_of(id_vars), remove=FALSE) %>%
      mutate ( panel_id = label_normalize(panel_id))

  }

  results_id <- lapply ( survey_list, create_id)
  do.call(rbind,results_id )

}
