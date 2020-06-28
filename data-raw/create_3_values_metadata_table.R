library(eurobarometer)
library(dplyr)
metadata_database <- readRDS(
  file.path("data-raw", "eb_metadata_database_20200628.rds")
  )

message("Running the creation of three-value tables")
three_value_vars1 <- metadata_database %>%
  filter ( length_cat_range == 3 ) %>%
  filter ( length_total_range <= 6)

three_value_vars <- three_value_vars1  %>%
  select (
    -all_of(
    c("conversion_suggested", "class_orig", "var_label_norm",
      "length_cat_range"))
    )

fn_return_names <- function(x, n) {
  tmp <- names(x)[n]
  if ( is.null(tmp)) { NA_character_} else { tmp }
}

three_value_vars2 <- three_value_vars %>%
  mutate (
    num_val_1 = sapply( three_value_vars$valid_range,  function(x) as.numeric(x[1])),
    num_val_2 = sapply( three_value_vars$valid_range,  function(x) as.numeric(x[2])),
    num_val_3 = sapply( three_value_vars$valid_range,  function(x) as.numeric(x[3])),
    label_val_1 = sapply( three_value_vars$valid_range,  function(x) fn_return_names(x, 1)),
    label_val_2 = sapply( three_value_vars$valid_range,  function(x) fn_return_names(x, 2)),
    label_val_3 = sapply( three_value_vars$valid_range,  function(x) fn_return_names(x, 3))
    )


fn_na_names <- function(var_table, x, var_name_orig, n) {
  var_table$var_name_orig[x]
  tmp <- unlist(var_table$factor_levels[x])[
    ! unlist(var_table$factor_levels[x]) %in% c(var_table$num_val_1[x],
                                                    var_table$num_val_2[x])
  ]
  if (!is.null(names(tmp))) {
    names( tmp ) <- gsub(
      paste0(var_table$var_name_orig[x], "."), "", names(tmp)
    )
  }
  if (length(tmp)== 0 ) {
    tmp[1] <- NA_real_
    tmp[2] <- NA_real_
    tmp[3] <- NA_real_
  } else  if ( length(tmp)== 1) {
    tmp[2] <- NA_real_
    tmp[3] <- NA_real_
  } else if ( length(tmp)== 2 ) {
    tmp[3] <- NA_real_
  }

  tmp
}


for ( i in 1:nrow(three_value_vars2)) {
  if ( i == 1 ) {
    na_values_df <- names(fn_na_names(var_table = three_value_vars2,
                                      x = i ))
  } else {
    na_values_df <- rbind(na_values_df,
                          names(fn_na_names(var_table = three_value_vars2,
                                            x = i ))
                          )
  }
}

na_values_df <- as.data.frame(na_values_df)
names( na_values_df ) <- c("na_lab_1", "na_lab_2", "na_lab_3")

for ( i in 1:nrow(three_value_vars2)) {
  if ( i == 1 ) {
    na_num_values_df <- fn_na_names(three_value_vars2, x = i )
  } else {
    na_num_values_df <- rbind(na_num_values_df,
                          fn_na_names(three_value_vars2, x = i )
    )
  }
}

na_num_values_df <- as.data.frame(na_num_values_df)
names( na_num_values_df ) <- c("na_val_1", "na_val_2", "na_val_3")

three_values_metadata <- dplyr::bind_cols(
  three_value_vars2, na_num_values_df ) %>%
  dplyr::bind_cols(na_values_df)

three_values_metadata$filename <- gsub(
  paste0(gesis_dir, "."), "", three_values_metadata$filename )


saveRDS( three_values_metadata,
         file.path('data-raw', 'three_value_tables.rds')
         )


unique_val_1 <- unique( label_normalize(three_values_metadata$label_val_1))
unique_val_2 <- unique( label_normalize(three_values_metadata$label_val_2))
unique_val_3 <- unique( label_normalize(three_values_metadata$label_val_3))
unique_na_1 <- unique( label_normalize(three_values_metadata$na_lab_1))
unique_na_2 <- unique( label_normalize(three_values_metadata$na_lab_2))
unique_na_3 <- unique( label_normalize(three_values_metadata$na_lab_3))

c( unique_na_1 , unique_na_2, unique_na_3 )
c ( unique_val_1, unique_val_2, unique_val_3 )

three_value_triads <- three_values_metadata %>%
  select ( all_of (c("label_val_1", "label_val_2", "label_val_3")) ) %>%
  distinct_all() %>%
  mutate_all ( label_normalize )

write.csv(three_value_triads,
          file.path("data-raw", "three_value_triads.csv"))
write.csv(three_values_metadata,
          file.path("data-raw", "three_values_table.csv"))

na_harmonization <- tibble (
  normalized_labels = c( unique_na_1 , unique_na_2, unique_na_3 )
  ) %>%
  filter ( nchar (normalized_labels)>0 ) %>%
  mutate ( na_harmonized = dplyr::case_when (
   grepl("inap_", normalized_labels) ~ "inap",
   grepl("decline|dk|refuse", normalized_labels) ~ "decline",
   normalized_labels %in% c("dont_know") ~ "do not know",
   normalized_labels %in% c("na") ~ "inap",
   TRUE ~ normalized_labels )
  ) %>%
  mutate ( na_numeric_value =  case_when (
    na_harmonized == "inap"  ~  9999,
    na_harmonized == "decline" ~ 9998,
    na_harmonized == "do_not_know" ~ 9997,
    TRUE ~ 8999
  ))
