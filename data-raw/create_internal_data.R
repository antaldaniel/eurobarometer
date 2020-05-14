
eurobarometer_vocabulary <- read.csv ( file.path ( 'data-raw',
                                                   'vocabulary.csv'),
           stringsAsFactors = FALSE)

source(file.path("data-raw", "create_eurobarometer_sample.R"))


usethis::use_data(eurobarometer_vocabulary,
                  eb_sample, internal=TRUE, overwrite=TRUE)
