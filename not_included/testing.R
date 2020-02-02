library(eurobarometer)
source (file.path("not_included", "folders.R"))

path <-  file.path ( raw_data_folder, spss_files[1])
test <- gesis_spss_read ( file.path ( raw_data_folder, spss_files[1]))



df <- test
names ( test )

names ( test )

test$ge


tested <- rename_var ( df, harmonized_name = "gender" )
