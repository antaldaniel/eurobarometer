require(readxl)
require(stringr)
library(dplyr)
library(tidyr)
eb_filenames <- readxl::read_excel(
  file.path("data-raw", "eb_waves_filenames.xlsx"))

eb_waves <- eb_filenames %>%
  mutate ( zacat_code = str_sub(x, 1,6),
           wave = str_sub(x, 9, 26),
           x = str_sub(x, 28,-1)) %>%
  mutate ( timeframe = gsub(".*\\((.*)\\).*", "\\1", x)) %>%
  mutate ( description = str_extract(x, "[^*:]*$")) %>%
  mutate_all ( str_trim ) %>%
  select ( -all_of("x"))

usethis::use_data(eb_waves, overwrite = TRUE)

