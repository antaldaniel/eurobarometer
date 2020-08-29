file1 <- system.file(
    "examples", "ZA7576.rds", package = "eurobarometer")
file2 <- system.file(
    "examples", "ZA5913.rds", package = "eurobarometer")

test_waves <- c(file1, file2)
library(eurobarometer)

eb_waves <- read_surveys(test_waves, .f='read_rds')
document_waves ( eb_waves )

eb_test_metadata <- lapply ( X = eb_waves, FUN = metadata_create   )
eb_test_metadata <- do.call(rbind, eb_test_metadata)
harmonization_candidates <- eb_test_metadata %>%
  identify_mentioned () %>%
  filter ( !is.na(group_mentioned)) %>%
  mutate ( var_label = var_label_normalize(label_orig)) %>%
  mutate ( var_label = case_when (
    grepl("^unique identifier", var_label) ~ "unique_id",
    TRUE ~ var_label)) %>%
  mutate ( var_name = val_label_normalize(var_label))
names ( var_harmonization )

merged_eb_test <- retroharmonize::merge_waves (
  waves = eb_waves,
  var_harmonization =  harmonization_candidates  )

##There is an annoying warning that should be elsewhere

document_waves(merged_eb_test)

harmonize_mentioned <- function(x) {

  label_comparison <- data.frame (
    from_labels = retroharmonize::collect_val_labels (harmonization_candidates),
    norm_labels = val_label_normalize(retroharmonize::collect_val_labels (harmonization_candidates))
  )

  all_labels <- label_comparison$norm_labels

  missing_labels <- all_labels[grepl("^inap|^dk", all_labels)]
  positive_labels <- setdiff(all_labels , c("not_mentioned", missing_labels))
  ## check non_sponantenous, I think it is meant to be not_mentioned, but maybe missing

  potentially_missing_labels <- c( "^do_not_know", "^dk", "^missing", "^inap", "dk")
  negative_labels <- setdiff(all_labels, c(positive_labels, potentially_missing_labels))

  label_harmonization <- label_comparison %>%
    mutate ( numeric_value = case_when (
      norm_labels %in% positive_labels ~ 1,
      grepl("^do_not_know|^don_t_know|^dk", norm_labels) ~ 99997,
      grepl("^decline", norm_labels) ~ 99998,
      grepl("^inap|^missing", norm_labels) ~ 99999,
      TRUE ~ 0)) %>%
    dplyr::distinct_all()

  label_list <- list(
    from = label_harmonization$from_labels,
    to = label_harmonization$norm_labels,
    numeric_values = label_harmonization$numeric_value
  )

  retroharmonize::harmonize_values(
    x,
    harmonize_labels = label_list,
    na_values = c("do_not_know"=99997,
                  "declined"=99998,
                  "inap"=99999)
  )
}

merged_eb_test[[1]] %>%
  mutate_all ( harmonize_mentioned )

merged_eb_test[[2]] %>%
  mutate_all ( harmonize_mentioned )

### And there is an issue here that I cannot resolve today.
### They work separately, but there is an error in the loop

harmonized_test_waves <- retroharmonize::harmonize_waves (
  waves = merged_eb_test,
  .f = harmonize_mentioned )
