#' Identify mentioned and not mentioned types
#'
#' Identification for questions where the answers are coded as
#' \code{'not_mentioned'}, and one other valid label, with, or without
#' missing labels.
#'
#' @importFrom dplyr mutate if_else
#' @importFrom retroharmonize val_label_normalize
#' @family identify functions
#' @return An augmented metadata table with the identified mentioned-type
#' variables
#' @examples{
#' example_survey <- read_surveys(system.file(
#'         "examples", "ZA7576.rds", package = "eurobarometer"),
#'          .f='read_rds')
#' identified <- identify_mentioned (metadata_create ( example_survey [[1]] ))
#' identified <- identified[(!is.na(identified$group_mentioned)),]
#' identified[, c("var_name_orig", "labels", "group_mentioned")]
#' }
#' @export

identify_mentioned <- function(metadata) {

  new_metadata <- metadata %>%
    mutate ( group_mentioned = NA_character_)

  new_metadata <- new_metadata  %>%
    mutate ( normalized_valid_labels = sapply ( 1:nrow(metadata), function(x) {
      retroharmonize::val_label_normalize(
        names(metadata$valid_labels[x][[1]])
      )
    }) )


  new_metadata <- new_metadata  %>%
    mutate ( group_mentioned = sapply ( 1:nrow(new_metadata), function(x) {
      t <- unlist(new_metadata$normalized_valid_labels[x])
      if_else (
        condition = setequal(c("mentioned", "not_mentioned"), t),
        true = "not_mentioned_mentioned",
        false = if_else (
          condition = "not_mentioned" %in% t & length(t) == 2,
          true  = "not_mentioned_other",
          false = NA_character_)
      )
    }))

  new_metadata$group_mentioned <- if_else (
    condition =  new_metadata$n_na_labels > 0 & !is.na(new_metadata$group_mentioned),
    true  = paste0(new_metadata$group_mentioned, "_na"),
    false = new_metadata$group_mentioned
  )

  new_metadata %>%
    dplyr::select ( -tidyselect::all_of("normalized_valid_labels") )

}
