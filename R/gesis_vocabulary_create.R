#' Get The Vocabulary Of A Survey
#'
#' Retrieve a metadata file with from your data directory or the temporary directory
#' of your current R session.
#' @param dat For example,
#' @importFrom sjlabelled get_label get_labels
#' @importFrom dplyr bind_rows
#' @importFrom labelled val_labels
#' @seealso canonical_name_create
#' @return The vocabulary of the survey in a data frame.
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

    tibble(
      r_name  = r_name,
      numeric_value = numeric_value,
      character_value = character_value,
      label = names ( items )

    )
  }

  ##Creating the basic metadata ----
  metadata <- data.frame (
    r_name = names ( dat ),
    r_class = r_class,
    spss_name = spss_name,
    normalized_names = normalized_names
  )

  vocabulary <- NULL

  for (i in which(metadata$r_class == "haven_labelled") ) {

    if ( ! is.null(vocabulary) ) {
      vocabulary <- dplyr::bind_rows(vocabulary,
                                     get_items(metadata$r_name[i]))
    } else {
      vocabulary <- get_items(metadata$r_name[i])
    }

  }

  vocabulary$label_normalized <- normalize_names(vocabulary$label)

  vocabulary

}

