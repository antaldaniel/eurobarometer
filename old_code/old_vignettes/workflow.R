## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  eval = FALSE,
  collapse = TRUE,
  comment = "#>"
)
example_panel_id <- data.frame(
  panel_id = rep(NA_character_, 8),
  id_uniqid = c(101,102,103,104, 108,199,104,188), 
  id_survey = c( rep("eb_23.4", 4), 
                 rep("eb_28.9", 4)),
  filename = c( rep("GESIS_A.sav", 4), 
                rep("GESIS_B.sav", 4)), 
  w1 =  round(runif(8, 0, 1.5),2),
  wex = round(runif(8, 0, 1.5)*runif(8, 1000,9000),2)
  )
example_panel_id$panel_id <- paste0(
  example_panel_id$id_survey, "_", 
  example_panel_id$id_uniqid, "_",
  example_panel_id$filename
)

my_panel <- example_panel_id

## ----setup, eval=TRUE, echo=TRUE----------------------------------------------
## This vignette is hypothetical at this stage, and the chunks, 
## unless stated otherwise, are NOT evaluated.
library(eurobarometer)
library(knitr)

## -----------------------------------------------------------------------------
#  ## read in all GESIS SPSS files and validated the
#  ## reading process, save only those that are valid GESIS files.
#  ## must canonize some id vars, such as uniqid, and filename
#  ##or anything that is present in all files.
#  
#  gesis_spss_to_rds ( import_dir, working_dir )

## -----------------------------------------------------------------------------
#  ## filter out the most basic and omnipresent id variables, and the
#  ## most basic weights, w1 and its projected version wex
#  
#  my_panel <- panel_create ( working_dir,
#                 # do not start with id_ to make filtering other IDs
#                 # easier later
#                            panel_id = "panel_id",
#                 ## must be at least two, and one must be the uniqid
#                 ## of the file or row_id
#                            id_components = c("uniqid", "filename")
#                 )

## ---- eval=TRUE---------------------------------------------------------------
kable(my_panel)

## -----------------------------------------------------------------------------
#  ## read in all GESIS SPSS files and validated the reading process,
#  ## save only those that are valid GESIS files.
#  working_metadata <- gesis_metadata_create ( working_dir )
#  
#  # the researcher at this point can tweak the metadata, for example, adjust variable names.
#  
#  ## read in .rds files and save them to renamed rds files with corrected metadata
#  survey_rename (working_metadata, working_dir)
#  

## -----------------------------------------------------------------------------
#  ## this is how I would envision a pipeline to join various survey
#  ## files with limited number of variables, ending in a
#  ## a panel of data stretching across several surveys (time)
#  
#  my_panel %>%
#    left_join (
#                 harmonize_demography (
#                   #harmonizes variables identified by survey rename
#                   #with the help of demography_table
#                            working_metadata,
#                            working_dir),
#                 by = c("id_uniq", "filename")
#                 ) %>%
#     left_join (
#                 harmonize_metadata  (
#                   # harmonizes variables identified by survey rename
#                   # with the help of survey_metadata_table
#                   # such as date, people present, etc.
#                            working_metadata,
#                            working_dir),
#                 by = c("id_uniq", "filename")
#                 ) %>%
#     left_join (
#                 harmonize_qb (
#                   # harmonizes variables identified by survey rename
#                   # from a particular question block
#                   # table part of the package
#                            working_metadata,
#                            working_dir,
#                            harmonize_table = trust_table),
#                 by = c("id_uniq", "filename")
#                 ) %>%
#     left_join (
#                 harmonize_qb (
#                   # harmonizes variables identified by survey rename
#                   # from a particular question block
#                   # designed by the user
#                            working_metadata,
#                            working_dir,
#                            harmonize_table = user_table_1 ),
#                 by = c("id_uniq", "filename")
#                 ) %>%
#    filter (
#      # if only a few survey files had trust variables, then many
#      # trust_vars are missing, chose one for filtering
#      !is.na(my_trust_var)
#      )
#  

## -----------------------------------------------------------------------------
#  ## This is how I envision the basic documentation workflow
#  
#  my_workflow %>%
#    left_join (
#      document_demography (
#        #documents variables identified by survey rename
#        #with the help of demography_table
#        working_metadata,
#        working_dir),
#      by = c("id_uniq", "filename")
#    ) %>%
#    left_join (
#      document_metadata  (
#        # documents variables identified by survey rename
#        # with the help of survey_metadata_table
#        # such as date, people present, etc.
#        working_metadata,
#        working_dir),
#      by = c("id_uniq", "filename")
#    ) %>%
#    left_join (
#      document_qb (
#        # documents variables identified by survey rename
#        # from a particular question block
#        # table part of the package
#        working_metadata,
#        working_dir,
#        document_table = trust_table),
#      by = c("id_uniq", "filename")
#    ) %>%
#    left_join (
#      document_qb (
#        # documents variables identified by survey rename
#        # from a particular question block
#        # designed by the user
#        working_metadata,
#        working_dir,
#        document_table = user_table_1 ),
#      by = c("id_uniq", "filename")
#    ) %>%
#    filter (
#      # if only a few survey files had trust variables, then many
#      # trust_vars are missing, chose one for filtering
#      !is.na(my_trust_var)
#    )

## -----------------------------------------------------------------------------
#  ## this produces as latex or html output with knitr::kable and
#  ## kableExtra
#  ## that the user can follow up on
#  
#  workflow_table ( my_workflow ) %>%
#    kableExtra::add_footnote( <users own additions> )
#  

## -----------------------------------------------------------------------------
#  ## this produces a readable summary with a package such as
#  ## stargazer or sjMisc or whatever we chose as a dependency
#  ## about number of observations, mean, median values, missingness,
#  ## etc.
#  
#  panel_summarize ( my_panel )
#  

