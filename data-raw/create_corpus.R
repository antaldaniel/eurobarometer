gesis_dir <- file.path("C:/Users/Daniel Antal/OneDrive - Visegrad Investments/",
                       "_data", "gesis")

gesis_files <- file.path(gesis_dir,
          dir(gesis_dir)[grepl(".sav", dir(gesis_dir))])

dat = gesis_files[2]

this_corpus <- gesis_corpus_create( file_path=gesis_dir)
eurobarometer_corpus <- this_corpus

usethis::use_data(eurobarometer_corpus, overwrite =TRUE, internal = FALSE)
