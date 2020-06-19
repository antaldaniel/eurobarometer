#' Get The Vocabulary Of A Survey
#'
#' Get every single unique questionnaire item from a survey file.
#'
#' @details The variables in the returned data frame
#' \describe{
#'   \item{var_label_orig}{The name of the variable in the data file.}
#'   \item{val_numeric_orig}{The original SPSS numeric values, if applicable}
#'   \item{val_label_orig}{The original SPSS character value, if applicable}
#'   \item{val_order_alpha}{The rank number of the alphabetically sorted answer option.}
#'   \item{val_order_length}{The number of answer options in the questionnaire item.}
#'   \item{val_label_normalized}{Normalized version of the questionnaire item}
#' }
#' @param dat A data frame read by \code{\link[haven]{read_spss}}.
#' @importFrom dplyr bind_rows mutate arrange
#' @importFrom labelled var_label
#' @importFrom tibble tibble
#' @seealso label_suggest
#' @return The vocabulary of the survey in a data frame. The return
#' data frame has 6 columns.
#' @examples
#' \dontrun{
#' ##use your own file:
#' tmp <- haven::read_spss( file.path(gesis_dir, gesis_file) )
#' metadata <- gesis_vocabulary_create (tmp)
#' }
#' @export

gesis_vocabulary_create <- function ( dat ) {

  class_orig   <- vapply (
    dat, function(x) class(x)[1], character(1)
  )

  get_items <- function ( this_var_name_orig  = 'nuts') {

    . <- val_label_orig <- val_numeric_orig <- NULL

    itemize <- dat[, this_var_name_orig ]
    names(itemize) <- "item"
    items <- unique(itemize$item)

    numeric_value <- rep(NA_real_, length(items))
    character_value <- rep(NA_character_, length(items))

    if ( "haven_labelled" %in% class ( items )) {
      character_value <- names(attr(items, "labels"))
      numeric_value <- as.numeric(attr(items, "labels"))
    } else if (any(c("character") %in% class(items))) {
      character_value <- as.character(items)
      numeric_value <- rep(NA_real_, length(items))
    } else if  (
      any(c("integer", "numeric", "double") %in% class(items))
      ) {
      numeric_value <- NA_real_
      character_value <- NA_character_
    }

    tmp_metadata <- tibble(
      var_name_orig = this_var_name_orig,
      val_numeric_orig = numeric_value,
      val_label_orig = character_value
      ) %>%
      dplyr::arrange( val_numeric_orig, val_label_orig )%>%
      dplyr::mutate ( val_order_alpha = 1:nrow(.),
                      val_order_length = length(items))

    if ( nrow(tmp_metadata) == 1 ) {
      if ( is.na(tmp_metadata$val_numeric_orig) &
           is.na(tmp_metadata$val_label_orig) ){
        tmp_metadata$val_order_length <- NA_real_
        tmp_metadata$val_order_alpha <- NA_real_
      }
    }

    tmp_metadata
  }

  vocabulary <- NULL

  haven_labelled_vars <- which(class_orig == "haven_labelled" )
  character_vars <- which(class_orig == "character" )
  numeric_vars <- which(class_orig == "numeric" )

  for (v in haven_labelled_vars ) {
    if ( ! is.null(vocabulary) ) {
      vocabulary <- dplyr::bind_rows(
        vocabulary,
        get_items(names(dat)[v])
        )
    } else {
      vocabulary <- get_items(
        this_var_name_orig = names(dat)[v]
        )
    }
  }

  char_vocabulary <- NULL

  for (c in character_vars ) {
    if ( ! is.null(char_vocabulary) ) {
      char_vocabulary <- dplyr::bind_rows(
        char_vocabulary,
        get_items(names(dat)[c])
      )
    } else {
      char_vocabulary <- get_items(
        this_var_name_orig = names(dat)[c]
      )
    }
  }

  nrow(vocabulary)

  if (!is.null(char_vocabulary)) {
    vocabulary <- dplyr::bind_rows(
      vocabulary, char_vocabulary)
  }

  nrow(vocabulary)

  num_vocabulary <- NULL

  for (n in numeric_vars ) {
    if ( ! is.null(num_vocabulary) ) {
      num_vocabulary <- dplyr::bind_rows(
        num_vocabulary,
        get_items(names(dat)[n])
      )
    } else {
      num_vocabulary <- get_items(
        this_var_name_orig = names(dat)[n]
      )
    }
  }

  if (!is.null(num_vocabulary)) {
    vocabulary <- dplyr::bind_rows(
      vocabulary, num_vocabulary)
  }

  nrow(vocabulary)

  vocabulary$val_label_norm <- label_normalize(
             vocabulary$val_label_orig )

  vocabulary$val_label_norm <- ifelse (
    ## mark potentially missing labels
    vocabulary$val_label_norm %in% c("_", " ", "", "-"),
    yes = "<missing_label>",
    no = vocabulary$val_label_norm
    )

  vocabulary
}

