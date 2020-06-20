#' @title Create A Unique ID
#'
#' @param dat A data frames containing one survey.
#' @param id_vars A vector of ID variables to form a panel ID var,
#' defaults to \code{c("uniqid", "doi")}.
#' @importFrom dplyr select mutate summarize_all mutate_all
#' @importFrom tidyr unite
#' @importFrom magrittr %>%
#' @importFrom tidyselect all_of everything
#' @return A tibble with the number of original ID vars and their
#' \code{panel_id} as their concatenation for a single survey.
#' @family harmonization functions
#' @examples
#' data (ZA7576_sample)
#' id_create (dat=ZA7576_sample, id_vars =c("uniqid", "doi") )
#' @export

id_create <- function (dat,
                       id_vars ) {

  . <- panel_id <- NULL

  if ( ! all(id_vars %in% names(dat)) ) {
    stop ( "Not (all) of ",
           paste ( id_vars, collapse = ", "),
           " present in <dat>.")
  }

  first_id_var <- id_vars[1]
  last_id_var <- id_vars[length(id_vars)]

  n_unique <- function(x) length(unique(x))

  tmp <- dat %>%
    select ( all_of ( id_vars )) %>%
    mutate_all ( as.character )

  if ( nrow(tmp) == 0 ) {
    stop ( "The id_vars are not present in the rows." )
  }

  tmp <- tmp %>%
    tidyr::unite ( col = 'panel_id',
                   !!first_id_var:!!last_id_var, remove=FALSE ) %>%
    mutate ( panel_id = gsub("[^[:alnum:] ]", "_", panel_id)) %>%
    select ( panel_id, everything())

  unicity_test <- tmp %>% summarize_all ( n_unique )

  if ( unicity_test$panel_id < nrow(tmp) ) {
    #warning("The id_vars=c('", paste(id_vars, collapse = "', '"),
    #        "') do not form unique IDs, row number is added as a prefix.")

    tmp$panel_id <- paste0(1:nrow(tmp), "_", tmp$panel_id)
  }

  tmp
}

