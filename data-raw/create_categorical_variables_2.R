### This file is used to create the final version of the metadata file
### to the data/ folder.
### If we will have more building blocks, they will be bind together
### Only the maintainer of the data files should run this and refresh
### it in the repo.

categorical_variables_2 <- readRDS(file.path("data-raw", "trust_variables.rds"))

category_labels_2 <- readRDS(file.path("data-raw",
                                          "trust_value_labels.rds"))


# Saving 'categorical_variables_2' to 'data/categorical_variables_2.rda'
# Saving 'category_labels_2' to 'data/category_labels_2.rda'
# See document your data: 'https://r-pkgs.org/data.html'

usethis::use_data(categorical_variables_2, internal = FALSE, overwrite=TRUE)
usethis::use_data(category_labels_2, internal = FALSE, overwrite=TRUE)
