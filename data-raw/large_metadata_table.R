metadata_table <- readRDS(file.path("data-raw",
                            "eb_metadata_database_large.rds"))

small_table <- metadata_table %>%
  filter ( grepl( "trust|age_exact|uniqid|occupation", var_name_suggested ) )


id_table <- metadata_table %>%
  filter ( grepl( "uniq", tolower(var_label_orig) ) )
