metadata_rel_path_from_root <- find_root_file(
  "data-raw", "eb_metadata_database_large.rds",
  criterion = has_file("DESCRIPTION"))

metadata_database <- readRDS( metadata_rel_path_from_root )

metadata_filter_example <- metadata_database  %>%
  filter (
    grepl( "trust|concert|democracy", var_label_norm )
  )

usethis::use_data ( metadata_filter_example, overwrite=TRUE)
