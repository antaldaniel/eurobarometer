message("Running the creation of binary tables")
binary_vars <- metadata_database %>%
  filter ( length_cat_range == 2) %>%
  select (
    -all_of(
    c("class_suggested", "class_orig", "var_label_norm", "length_cat_range")))


binary_vars2 <- binary_vars %>%
  mutate (
    num_val_1 = sapply( binary_vars$valid_range,  function(x) as.numeric(x[1])),
    num_val_2 = sapply( binary_vars$valid_range,  function(x) as.numeric(x[2])),
    label_val_1 = sapply( binary_vars$valid_range,  function(x) fn_return_names(x, 1)),
    label_val_2 = sapply( binary_vars$valid_range,  function(x) fn_return_names(x, 2))
)

fn_return_names <- function(x, n) {
  tmp <- names(x)[n]
  if ( is.null(tmp)) { NA_character_} else { tmp }
}
x= 104
fn_na_names <- function(x, var_name_orig, n) {
  binary_vars2$var_name_orig[x]
  tmp <- unlist(binary_vars2$factor_levels[x])[
    ! unlist(binary_vars2$factor_levels[x]) %in% c(binary_vars2$num_val_1[x],
                                                    binary_vars2$num_val_2[x])
  ]
  if (!is.null(names(tmp))) {
    names( tmp ) <- gsub(
      paste0(binary_vars2$var_name_orig[x], "."), "", names(tmp)
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


for ( i in 1:nrow(binary_vars2)) {
  if ( i == 1 ) {
    na_values_df <- names(fn_na_names(x = i ))
  } else {
    na_values_df <- rbind(na_values_df,
                          names(fn_na_names(x = i ))
                          )
  }
}

na_values_df <- as.data.frame(na_values_df)
names( na_values_df ) <- c("na_lab_1", "na_lab_2", "na_lab_3")

for ( i in 1:nrow(binary_vars2)) {
  if ( i == 1 ) {
    na_num_values_df <- fn_na_names(x = i )
  } else {
    na_num_values_df <- rbind(na_num_values_df,
                          fn_na_names(x = i )
    )
  }
}

na_num_values_df <- as.data.frame(na_num_values_df)
names( na_num_values_df ) <- c("na_val_1", "na_val_2", "na_val_3")

binary_metadata <- dplyr::bind_cols( binary_vars2,  na_num_values_df) %>%
  dplyr::bind_cols(na_values_df)

binary_metadata$filename <- gsub(paste0(gesis_dir, "."), "", binary_metadata$filename)


saveRDS( binary_metadata, file.path('data-raw', 'binary_value_table.rds'))


unique_val_1 <- unique( label_normalize(binary_metadata$label_val_1))
unique_val_2 <- unique( label_normalize(binary_metadata$label_val_2))
unique_na_1 <- unique( label_normalize(binary_metadata$na_lab_1))
unique_na_2 <- unique( label_normalize(binary_metadata$na_lab_2))
unique_na_3 <- unique( label_normalize(binary_metadata$na_lab_3))

c( unique_na_1 , unique_na_2, unique_na_3 )
c ( unique_val_1, unique_val_2 )

binary_value_pairs <- binary_metadata %>%
  select ( all_of (c("label_val_1", "label_val_2")) ) %>%
  distinct_all() %>%
  mutate_all ( label_normalize )

write.csv(binary_value_pairs, file.path("data-raw", "binary_value_pairs.csv"))


na_harmonization <- tibble (
  normalized_labels = c( unique_na_1 , unique_na_2, unique_na_3 )
  ) %>%
  filter ( nchar (normalized_labels)>0 ) %>%
  mutate ( na_harmonized = dplyr::case_when (
   grepl("inap", normalized_labels) ~ "inap",
   grepl("decline|dk|refuse", normalized_labels) ~ "decline",
   grepl("dont_know", normalized_labels) ~ "do_not_know",
   TRUE ~ normalized_labels )
  ) %>%
  mutate ( na_numeric_value =  case_when (
    na_harmonized == "inap"  ~  9999,
    na_harmonized == "decline" ~ 9998,
    na_harmonized == "do_not_know" ~ 9997,
    TRUE ~ 8999
  ))
