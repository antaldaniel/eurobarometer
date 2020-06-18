ZA5479_raw <- haven::read_spss(file.path("not_included", "ZA5479_v6-0-0.sav"))
set.seed(2000)
ZA5479_sample <- ZA5479_raw[ ZA5479_raw$v7 %in% c("DE-W", "DE-E", "GB-GBN", "GB-NIR"), ]
ZA5479_sample <- dplyr::sample_n( ZA5479_sample, 2000 )
ZA5479_sample <- ZA5479_sample[, c(1:8, 53, 104:114, 520:524, 551:622)]
eb_sample <- ZA5479_sample

usethis::use_data(eb_sample, internal = FALSE, overwrite = TRUE)


sample <- eurobarometer:::eb_sample
