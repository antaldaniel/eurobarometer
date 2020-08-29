# case study of harmonizing questions about ownership of durables: television, dvd player, cd player, smartphone
# * 15 Eurobarometer waves
# * 34 countries after CY-TCC was removed and DE and GB were combined with appropriate transformation of weights
# see eb_filenames.xlsx for details about weights recodes
# * 5-15 surveys per country

durables_2012_2019 <- readRDS("data-raw/durables_2012_2019.rds")




# the process of getting there:

library(tidyverse)
library(retroharmonize)
library(eurobarometer)

# gesis_dir <- file.path("C:/Users/mkolc/Google Drive/Work in progress/data-for-harm/EB")
#
# # get a vector of file names in the selected directory, with .sav extensions
# eb <- dir ( gesis_dir, pattern = ".sav$" )
# # create path for the file names
# eb_rounds <- file.path(gesis_dir, eb)
# # read data files to memory
# eb_waves <- read_surveys(eb_rounds, .f='read_spss')
#
# ## add a meaningful id for data
# for (i in 1:length(eb_waves)) {
#   attr(eb_waves[[i]], "id") <- eb[i]
# }
#
# document_waves(eb_waves)
#
# eb_metadata <- lapply ( X = eb_waves, FUN = metadata_create )
# eb_metadata <- do.call(rbind, eb_metadata)
#
# saveRDS(eb_metadata, "data-raw/eb_metadata_44files.rds")

eb_metadata <- readRDS("data-raw/eb_metadata_44files.rds")


####

harmonization_candidates <- eb_metadata %>%
  identify_mentioned () %>%
  filter ( !is.na(group_mentioned)) %>%
  mutate ( var_label = var_label_normalize(label_orig)) %>%
  mutate ( var_label = case_when (
    grepl("^unique identifier", var_label) ~ "unique_id",
    TRUE ~ var_label)) %>%
  mutate ( var_name = val_label_normalize(var_label)) %>%
  # harmonized variable names are not unique in surveys. need filtering out
  group_by(filename, var_name) %>%
  mutate(ndist = n()) %>%
  filter(ndist == 1) %>%
  select(-ndist)

harmonization_candidates1 <- harmonization_candidates %>%
  filter ( grepl ( "ownership", var_label ),
           grepl ( "television|dvd|cd|smartphone", var_label ) )

# get waves which have any of the variables
waves <- harmonization_candidates1 %>% ungroup() %>% count(filename) %>% pull(filename)


###

gesis_dir <- file.path("C:/Users/mkolc/Google Drive/Work in progress/data-for-harm/EB")

# create path for the file names
eb_rounds <- file.path(gesis_dir, waves)
# read data files to memory
eb_waves <- read_surveys(eb_rounds, .f='read_spss')

## add a meaningful id for data
for (i in 1:length(eb_waves)) {
  attr(eb_waves[[i]], "id") <- waves[i]
}

# assign names to list elements; will be used in loops
names(eb_waves) <- waves

document_waves(eb_waves)

####

merged_eb_durables <- retroharmonize::merge_waves (
  waves = eb_waves,
  var_harmonization =  harmonization_candidates1  )

document_waves(merged_eb_durables)

# assign names to list elements; will be used in loops
names(merged_eb_durables) <- waves

saveRDS(merged_eb_durables, "data-raw/merged_eb_durables.rds")


###

harmonize_mentioned <- function(x) {

  label_comparison <- data.frame (
    from_labels = retroharmonize::collect_val_labels (harmonization_candidates),
    norm_labels = val_label_normalize(retroharmonize::collect_val_labels (harmonization_candidates))
  )

  all_labels <- label_comparison$norm_labels

  missing_labels <- all_labels[grepl("^inap|^dk", all_labels)]
  positive_labels <- setdiff(all_labels , c("not_mentioned", missing_labels))
  ## check non_sponantenous, I think it is meant to be not_mentioned, but maybe missing

  potentially_missing_labels <- c( "^do_not_know", "^dk", "^missing", "^inap", "dk")
  negative_labels <- setdiff(all_labels, c(positive_labels, potentially_missing_labels))

  label_harmonization <- label_comparison %>%
    mutate ( numeric_value = case_when (
      norm_labels %in% positive_labels ~ 1,
      grepl("^do_not_know|^don_t_know|^dk", norm_labels) ~ 99997,
      grepl("^decline", norm_labels) ~ 99998,
      grepl("^inap|^missing", norm_labels) ~ 99999,
      TRUE ~ 0)) %>%
    dplyr::distinct_all()

  label_list <- list(
    from = label_harmonization$from_labels,
    to = label_harmonization$norm_labels,
    numeric_values = label_harmonization$numeric_value
  )

  retroharmonize::harmonize_values(
    x,
    harmonize_labels = label_list
  )
}


eb_filenames <- rio::import("data-raw/eb_filenames.xlsx")


# harmonize waves in a loop

# only these waves (13-27 as in the loop below) have no problems. Earlier ones have country
# variables with different names.
# Serbia in ZA5612_v2-0-0.sav has a problem with ownership of tv, dvd, and cd -- the mean is 9


harm_own <- list()

for (i in names(merged_eb_test)[13:27]) {

  country_var <- eb_filenames %>% filter(file_name_full == i) %>% pull(cntry_var)
  year_survey <- eb_filenames %>% filter(file_name_full == i) %>% pull(year)
  weight_recode <- eb_filenames %>% filter(file_name_full == i) %>%
    pull(weight_recode)

  # select technical variables, recode weights to apply to untied DE and GB
  eb_technical <- eb_waves[[i]] %>%
    mutate(wave = i,
           weight = eval(parse(text = weight_recode)),
           # cntry = eval(parse(text = country_var)),
           year = year_survey) %>%
    select(isocntry, wave, weight, year)

  harm_own[[i]] <- merged_eb_test[[i]] %>%
    mutate_all ( harmonize_mentioned ) %>%
    bind_cols(eb_technical) %>%
    select(isocntry, weight, wave, year, everything())

}

# something doesn't match with labels, so I'm getting rid of them
# Error: `labels` must be unique.
harm_own1 <- lapply(harm_own, sjlabelled::remove_all_labels)

harm_own_df <- bind_rows(harm_own1) %>%
  filter(isocntry != "CY-TCC") %>% # get rid of CY-TCC for now
  # get single isocntry for DE and GB, since weights are taken care of
  mutate(isocntry = substr(isocntry, 1, 2),
         country = countrycode::countrycode(isocntry, "iso2c", "country.name"))

# 34 countries, 5-15 waves per country
harm_own_df %>% count(isocntry, wave) %>% count(isocntry)

# save
saveRDS(durables_2012_2019, "data-raw/durables_2012_2019.rds")


# read
durables_2012_2019 <- readRDS("data-raw/durables_2012_2019.rds")

# graph
durables_2012_2019 %>%
  group_by(country, year) %>%
  summarise_at(vars(ownership_durables_television, ownership_durables_dvd_player,
                    ownership_durables_music_cd_player, ownership_durables_smartphone),
               function(x) mean(x, na.rm = T)) %>%
  gather(var, value, 3:6) %>%
  mutate(var = gsub("ownership_durables_", "", var)) %>%
  ggplot(., aes(x = year, y = value, col = var)) +
  geom_line(size = 1) +
  ylab("Proportion of owners") +
  xlab("") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  facet_wrap("country")
