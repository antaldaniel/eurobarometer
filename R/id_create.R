#' @title Create A Unique ID
#'
#' @param dat A data frames containing one survey.
#' @param id_vars A vector of ID variables to form a panel ID var,
#' defaults to \code{c("uniqid", "doi")}.
#' @importFrom dplyr select mutate
#' @importFrom tidyr unite
#' @importFrom magrittr %>%
#' @importFrom tidyselect all_of
#' @return A tibble with the number of original ID vars and their
#' \code{panel_id} as their concatenation.
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

id_create <- function (dat,
                       id_vars ) {

  if ( ! all(id_vars %in% names(dat)) ) {
    stop ( "Not (all) of ",
           paste ( id_vars, collapse = ", "),
           " present in <dat>.")
  }

  tmp <- dat %>%
    select ( all_of ( id_vars ))

  if ( nrow(tmp) == 0 ) {
    stop ( "The id_vars are not present in the rows." )
  }

  tmp %>%
    tidyr::unite ( col = 'panel_id',
                   all_of(id_vars), remove=FALSE ) %>%
    mutate ( panel_id = label_normalize(panel_id))

}

dat <- survey_list[[1]]

