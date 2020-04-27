
eurobarometer_vocabulary <- read.csv ( file.path ( 'data-raw',
                                                   'vocabulary.csv'),
           stringsAsFactors = FALSE)


usethis::use_data(eurobarometer_vocabulary, internal=TRUE, overwrite=TRUE)
