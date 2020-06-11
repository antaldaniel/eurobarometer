#' Get The Vocabulary Of A Survey
#'
#' Get every single unique questionnaire item from a survey file.
#'
#' @param dat For example,
#' @importFrom sjlabelled get_label get_labels
#' @importFrom dplyr bind_rows mutate arrange
#' @importFrom labelled val_labels
#' @importFrom tibble tibble
#' @seealso canonical_name_create
#' @return The vocabulary of the survey in a data frame. The return
#' data frame has 7 columns: \code(r_name), \code(numeric_value),
#' \code(character_value), \code(label), \code(item_no), \code(item_of),
#' \code(label_normalized).
#' @examples
#' \dontrun{
#' ##use your own file:
#' tmp <- haven::read_spss( file.path(gesis_dir, gesis_file) )
#' metadata <- gesis_vocabulary_create (tmp)
#' }
#' @export

gesis_vocabulary_create <- function ( dat ) {

  r_class   <- vapply ( dat,
                        function(x) class(x)[1],
                        character(1) )
  spss_name <- vapply ( dat, sjlabelled::get_label, character(1) )
  normalized_names <- normalize_names(x = spss_name )
  normalized_names

  get_items <- function ( r_name  = 'nuts') {

    itemize <- dat[, r_name ]
    names(itemize) <- "item"
    items <- labelled::val_labels(itemize$item)


    if ( class(items)=="character" ) {
      character_value <- as.character(items)
    } else {
      character_value <- rep(NA_character_, length(items))
    }

    if ( class(items)!="character" ) {
      numeric_value <- as.numeric(items)
    } else {
      numeric_value <- rep(NA_real_, length(items))
    }

    tmp_metadata <- tibble(
      r_name  = r_name,
      numeric_value = numeric_value,
      character_value = character_value,
      label = names ( items )
      ) %>%
      dplyr::arrange ( label ) %>%
      dplyr::mutate ( item_no = 1:nrow(.),
                      item_of = length(items))

    tmp_metadata

  }

  ##Creating the basic metadata ----
  metadata <- data.frame (
    r_name = names ( dat ),
    r_class = r_class,
    spss_name = spss_name,
    normalized_names = normalized_names
  )

  vocabulary <- NULL

  haven_labelled_vars <- which(metadata$r_class == "haven_labelled")
  for (v in  haven_labelled_vars ) {

    if ( ! is.null(vocabulary) ) {
      vocabulary <- dplyr::bind_rows(vocabulary,
                                     get_items(metadata$r_name[v]))
    } else {
      vocabulary <- get_items(r_name = metadata$r_name[v])
    }

  }

  vocabulary$label_normalized <- normalize_names(vocabulary$label)

  vocabulary

}

