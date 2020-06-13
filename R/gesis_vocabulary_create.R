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
#' @seealso canonical_name_create
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

  var_label_orig <- vapply ( dat, labelled::var_label, character(1) )
  var_label_norm <- label_normalize(x = var_label_orig )

  get_items <- function ( this_var_name_orig  = 'nuts') {

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
      numeric_value <- as.numeric(items)
      character_value <- rep(NA_character_, length(items))
    }

    tmp_metadata <- tibble(
      var_label_orig  = rep(this_var_name_orig,
                            length(numeric_value)),
      val_numeric_orig = numeric_value,
      val_label_orig = character_value
      ) %>%
      dplyr::arrange( val_numeric_orig, val_label_orig )%>%
      dplyr::mutate ( val_order_alpha = 1:nrow(.),
                      val_order_length = length(items))

    tmp_metadata
  }

  ## Creating the basic metadata ----
  metadata <- tibble::tibble (
    var_name_orig = names ( dat ),
    class_orig  = class_orig,
    var_label_orig = var_label_orig,
    var_label_norm = var_label_norm
  )

  vocabulary <- NULL

  haven_labelled_vars <- which(
    metadata$class_orig == "haven_labelled" )

  for (v in  haven_labelled_vars ) {
    if ( ! is.null(vocabulary) ) {
      vocabulary <- dplyr::bind_rows(
        vocabulary,
        get_items(metadata$var_name_orig[v])
        )
    } else {
      vocabulary <- get_items(
        this_var_name_orig = metadata$var_name_orig[v]
        )
    }
  }

  vocabulary$label_normalized <- label_normalize(
             vocabulary$val_label_orig )

  vocabulary$label_normalized <- ifelse (
    ## mark potentially missing labels
    vocabulary$label_normalized %in% c("_", " ", "", "-"),
    yes = "<missing_label>",
    no = vocabulary$label_normalized
    )

  vocabulary

}

