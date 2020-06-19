#' Suggest Conversion
#'
#' @param metadata A metadata file created by metadata_create within
#' \code{\link{gesis_metadata_create}}
#' @return The metadata tibble augmented with the \code{class_suggested}
#' variable.
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate case_when

class_suggest <- function(metadata) {

  factor_levels <- sapply ( metadata$factor_levels,
                        function(x) sort(tolower(unlist(x))) )

  first_level  <- unlist(lapply(factor_levels, function(x) x[1]))
  second_level <- unlist(lapply(factor_levels, function(x) x[2]))

  suggestions <- metadata %>%
    dplyr::select ( class_orig,
                    factor_levels, n_categories ) %>%
    mutate ( first_level  = first_level,
             second_level = second_level )

  suggestions <-suggestions %>%
    mutate ( suggestion = dplyr::case_when (
      class_orig %in% c("numeric","character") ~ class_orig,
      class_orig == 'haven_labelled' & n_categories  == 1 ~ 'character',
      first_level == "mentioned" & second_level == "not mentioned" ~  'dummy',
      TRUE ~ "factor" ))

  metadata$class_suggested <- suggestions$suggestion
  metadata
}

#' Identify A Question Block
#'
#' @param metadata A metadata file created by metadata_create within
#' \code{\link{gesis_metadata_create}}
#' @return A question block identifier.
#' @importFrom magrittr %>%
#' @importFrom dplyr case_when
#'

question_block_identify <- function (metadata) {

  suggested <- as.character(metadata$var_name_suggested)
  var_label_orig <- as.character(metadata$var_label_orig)
  n_categories <- metadata$n_categories

  qb <- vector ( mode = 'character', length = length(suggested))
  orig_1 <- tolower(substr(var_label_orig, 1, 1))
  orig_2 <- tolower(substr(var_label_orig, 1, 2))

 qb <- dplyr::case_when (

    suggested %in% c("filename", "doi", "uniqid" ) ~  "id",
    grepl( "gesis_archive", suggested)             ~  "id",
    orig_1 == "p"                                  ~  "metadata",
    var_label_orig %in%
      c("d7", "d8", "d25", "d60")                  ~  "demography",
    orig_1 == "w"                                  ~  "weights",
    grepl ( "trust_in|_trust", suggested) &
      n_categories  == 4                           ~  "trust",


    TRUE ~ 'not_identified'
    )

 qb
}
