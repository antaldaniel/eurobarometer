library(tidyverse)
library(eurobarometer)
source('R/utils.R')
source(file.path("not_included", "daniel_env.R")) ##loads Daniel's local gesis directory

gesis_files <- file.path(gesis_dir,
                         dir(gesis_dir)[grepl(".sav", dir(gesis_dir))])
spss_files <- dir(gesis_dir)[grepl(".sav", dir(gesis_dir))]
gesis_file <- spss_files[5]

gesis_file_list <- split(spss_files, ceiling(seq_along(spss_files)/3))
n_batches <- length(gesis_file_list)

message ( length(spss_files), " SPSS files will be read in ", n_batches, " batches." )
for (i in 1:n_batches) {

  start_time <- Sys.time()
  message ( i, "/", n_batches ,  " Reading ",
            paste (gesis_file_list[[i]], collapse = "; "))

  tmp_surveys <- read_surveys( gesis_file_list[[i]],
                               .f = "read_spss_survey",
                               file_path = gesis_dir)

  message ( "Read batch ", i,  "/", n_batches )

  if ( i == 1 ) {
    metadata_database <- gesis_metadata_create(tmp_surveys)
  } else {
    tmp_metadata <- gesis_metadata_create(tmp_surveys)
    metadata_database <- dplyr::bind_rows(metadata_database,
                                          tmp_metadata)

    n_files <- length(unique ( metadata_database$filename))
    n_vars <- length(unique ( metadata_database$var_name_suggested))


    message ( "Current vars: ", nrow(metadata_database), " (new: ",
              nrow(tmp_metadata),
              "; unique: ",
              n_vars, ") from ", n_files, " SPSS files." )
  }

  saveRDS(metadata_database,
          file = file.path("data-raw", "eb_metadata_database_20200628.rds"))

  end_time <- Sys.time()

  message ( "Ellapsed time: " , round(end_time - start_time,0), " sec")
}

write.csv( metadata_database %>%
             mutate_all( as.character),
           file = file.path("data-raw",
                            "eb_metadata_database_20200628.csv"),
           row.names=FALSE )

saveRDS(metadata_database,
        file = file.path("data-raw",
                         "eb_metadata_database_20200628.rds"))

source(file.path('data-raw', 'create_binary_metadata_table.R'))
source(file.path('data-raw', 'create_binary_metadata_table.R'))
