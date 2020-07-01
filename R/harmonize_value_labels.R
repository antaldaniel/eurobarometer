#' Harmonize Value Labels
#'
#' Harmonize the numeric values and the value labels of variables.
#' Currently works only with binary values.
#'
#' @param labelled_var A vector (survey variable) coded in with
#' labelled class.
#' @param categories The number of valid categories in the value range.
#' @importFrom labelled to_character labelled
#' @importFrom dplyr case_when mutate left_join if_else distinct_all
#' @importFrom tibble tibble
#' @return A labelled vector containing harmonized numeric values and
#' labels, and in \code{attr(v, num_orig)} the original numeric values,
#' \code{attr(v, labels_orig)} the original labelling.
#' @family harmonization functions
#' @examples
#' v <- labelled::labelled(
#'        c(3,4,4,3,8, 9),
#'        c(YES = 3, NO = 4, wrong_label = 8, refused = 9)
#'       )
#' harmonize_value_labels(v, 2)
#'
#' v3 <- labelled::labelled(c(3,4,5,3,8, 9),
#' c(`BETTER`= 3, `WORSE`= 4,
#'   `SAME` = 5,
#'   wrong_label = 8, refused = 9))
#'
#' harmonize_value_labels(
#'   labelled_var = v3,categories = 3)
#' @export

harmonize_value_labels <- function (labelled_var,
                                    categories = 2) {

  ## non-standard evaluation initialization --------------------
  label_harmonization_table <- label_harmonized <- label_norm <- NULL
  label_orig <- na_harmonized <- na_numeric_value <- value_numeric <- NULL
  valid_range <- NULL

  data ("label_harmonization_table", envir = environment())

  if ("haven_labelled_spss" %in% class ( labelled_var )) {
    new_labelled_var <- labelled_var
    labelled_var <- labelled::labelled(
      unclass(new_labelled_var),
      labels = attr(new_labelled_var, "labels")
    )
  }

  harmonized_1 <- tibble (
    numeric = as.numeric(labelled_var),
    label_orig = labelled::to_character(labelled_var),
    label_norm = label_normalize(label_orig),
    valid_range = categories  ) %>%
    left_join ( label_harmonization_table %>%
                  distinct_all(),
                by = c('label_norm', 'valid_range') ) %>%
    mutate ( label_harmonized = if_else(
      is.na(label_harmonized),
      label_norm,
      label_harmonized
    )) %>%
    mutate ( value_numeric = if_else(
      is.na(value_numeric),
      as.numeric(numeric),
      as.numeric(value_numeric)
    ))

  valid_harmonized_values <- unique (
    label_harmonization_table %>%
      filter ( valid_range == categories ) %>%
      select (label_harmonized) %>% unlist()
  )

  harmonized <- harmonized_1 %>%
    left_join( harmonize_missing_values(x = labelled_var) %>%
                 distinct_all(),
               by = 'label_norm') %>%
    mutate (
      # set numeric values to special if needed
      value_numeric = if_else (
        ! label_harmonized %in% valid_harmonized_values,
        99000,
        value_numeric
    ))   %>%
    mutate (
     # harmonize the numeric values
      value_numeric = if_else (
        label_harmonized == na_harmonized,
        value_numeric,
        na_numeric_value
    ))   %>%
    mutate (
      # harmonize the labels
      label_harmonized = if_else (
         label_harmonized == na_harmonized,
         label_harmonized,
         na_harmonized
    ))

  if (  all(harmonized$numeric == harmonized$value_numeric, na.rm=TRUE) ) {
    harmonized_num_var = harmonized$numeric
  } else {
    harmonized_num_var = harmonized$value_numeric
  }
  harmonized_num_var


  ### create harmonized labels ---------
  harmonized_label_creation <-  harmonized %>%
    distinct ( value_numeric, label_harmonized )
  labels_harmonized <- harmonized_label_creation$value_numeric
  names ( labels_harmonized) <- harmonized_label_creation$label_harmonized
  harmonized_labelled_var <- labelled ( harmonized_num_var, labels_harmonized)
  harmonized_labelled_var

  ## Add original labels as attribute -----------------------
  orig_label_creation <-  harmonized %>%
    distinct ( value_numeric, label_orig )
  labels_orig <- orig_label_creation$value_numeric
  names ( labels_orig) <- orig_label_creation$label_orig
  attr(harmonized_labelled_var, "labels_orig") <- labels_orig
  harmonized_labelled_var

  ## Add original numeric values as attribute --------------------
  orig_num_creation <- harmonized %>%
    distinct ( value_numeric, numeric )
  num_orig <- orig_num_creation$value_numeric
  names (num_orig) <- orig_num_creation$numeric
  attr(harmonized_labelled_var, "num_orig") <- num_orig

  harmonized_labelled_var
}
