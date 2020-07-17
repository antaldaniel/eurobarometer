#' Create Normalized Variable Labels
#'
#' Remove relative reference to question blocks, special characters
#' used in regular expressions, whitespace.
#'
#' @param x A vector of the (GESIS) variable labels
#' @importFrom retroharmonize var_label_normalize
#' @family naming functions
#' @return A character vector with the normalized variable labels.
#' @examples
#' label_normalize (
#'  c('QF4C INTERESTS INFO SOURCES: INTERNET',
#'    'QB15A CHILDREN NEEDS: SOME NEW CLOTHES',
#'    'QB9B RESEARCH INFO SOURCE - PREFERENCE 2ND',
#'    'EU MEANING: CULTURAL DIVERSITY',
#'    'P6 SIZE OF COMMUNITY - AUSTRIA',
#'    'D49D_CY WEBSITES: OTHER',
#'    'LOVE RELATIONSHIP OF CHILD - CHRISTIAN PERSON' )
#' )
#' @export

var_label_normalize <- function(x) {

  y <- retroharmonize::var_label_normalize(x)

  ##do the abbreviations first that may have a . sign
  y <- gsub( '\\ss\\.a\\.', '_sa', y)

  ## remove prefix of question block numbers
  y <- gsub( '^q[abcdef]\\d{1,2}[abcdef]', '', y )  # remove QB9B, QB25 etc
  y <- gsub( '^q[abcdef]\\d{1,2}_\\d{1,2}', '', y )  # remove QA117_1
  y <- gsub( '^q[abcdef]\\d{1,2}', '', y )  # remove QA1, QB25 etc
  y <- gsub( '^q\\d{1,2}[abc]', '', y )  # remove QA1, QB25 etc
  y <- gsub( '^d\\d{1,2}[abcdef]', '', y )       # removed d26a_ etc
  y <- gsub( '^d\\d{1,2}', '', y )       # removed d26_ etc
  y <- gsub( '^c\\d{1,2}', '', y )       # removed c26_ etc
  y <- gsub ( "^p\\d+{1,}_", "", y)  #remove p6_ like starts
  y <- gsub ( "^p\\d+{1,}\\s", "", y)  #remove p6  like starts
  y <- gsub ( "^q\\d+{1,}_", "", y)  #remove q1_ like starts
  y <- gsub ( "^q\\d+{1,}\\s", "", y)  #remove q1  like starts
  y <- gsub( '^\\d{1,2}_', '', y ) #remove leading number 1_
  y <- gsub( '^_', '', y ) #remove leading _
  y
  y <- snakecase::to_snake_case(y)

  ## groups and recategorizations -----------------------
  y  <- gsub("recoded_three_groups", "rec_3", y)
  y  <- gsub("recoded_four_groups", "rec_4", y)
  y  <- gsub("recoded_five_groups", "rec_5", y)
  y  <- gsub("recoded_six_groups", "rec_6", y)
  y  <- gsub("3_groups_recoded", "rec_3", y)
  y  <- gsub("4_groups_recoded", "rec_4", y)
  y  <- gsub("5_groups_recoded", "rec_5", y)
  y  <- gsub("6_groups_recoded", "rec_6", y)
  y  <- gsub("7_groups_recoded", "rec_7", y)
  y  <- gsub("8_groups_recoded", "rec_8", y)
  y  <- gsub("11_groups_recoded", "rec_11", y)
  y  <- gsub("3_cat_recoded", "rec_3", y)
  y  <- gsub("4_cat_recoded", "rec_4", y)
  y  <- gsub("5_cat_recoded", "rec_5", y)
  y  <- gsub("6_cat_recoded", "rec_6", y)
  y  <- gsub("7_cat_recoded", "rec_7", y)
  y  <- gsub("8_cat_recoded", "rec_8", y)
  y  <- gsub("11_cat_recoded", "rec_11", y)

  y <- gsub(
    "^cap_", "common-agricultural-policy_", y)
  y <- gsub(
    "_cap_", "_common-agricultural-policy_", y)

  y <- retroharmonize::var_label_normalize(y)

  # leftover question numbers at the beginning of value labels
  y <- gsub(
    "^w[0-9]{12}", "", y)
  y <- gsub(
    "^[0-9]{1-3}_", "", y)
  y <- gsub(
    "^[a-z]{12}_", "", y)
  y <- gsub(
    "^[a-z][0-9]{2}[a-z]_", "", y)
  y <- gsub(
    "^[a-z]{12}[0-9]{12}[a-z]_", "", y)
  y <- gsub(
    "^[0-9]{12}_", "", y)
  y <- gsub(
    "^[a-z][0-9]_[0-9]{12}_", "", y)

  # country names
  y <- gsub(
    "united_kingdom", "united-kingdom", y)
  y <- gsub(
    # should not we use the new official name czechia (shorter?)
    "czech_republic", "czechia", y)
  y <- gsub(
    "great_britain", "great-britain", y)
  y <- gsub(
    "united_germany", "united-germany", y)
  y <- gsub(
    "united_nations", "united-nations", y)
  y <- gsub(
    "ivory_coast", "ivory-coast", y)

  # commonly abbreviated words
  y <- gsub(
    "2_nd|2nd", "second_", y)
  y <- gsub(
    "enlargem_", "enlargement_", y)
  y <- gsub(
    "particip_", "participation_", y)
  y <- gsub(
    "environmt_|environm_", "environment_", y)
  y <- gsub(
    "citizenshp_", "citizenship_", y)
  y <- gsub(
    "_rght", "_right", y)
  y <- gsub(
    "_fulfld", "_fullfilled", y)
  y <- gsub(
    "_pessim", "_pessimistic", y)
  y <- gsub(
    "_immigr", "_immigration", y)
  y <- gsub(
    "_convcd", "_convinced", y)
  y <- gsub(
    "_dom_viol|domestic_violence", "_domestic-violence", y)
  y <- gsub(
    "not_invo", "not_involved", y)
  y <- gsub(
    "intelligenc$", "intelligence", y)
  y <- gsub(
    "gvrnm", "government", y)
  y <- gsub(
    "ctry|cntry|\\[country\\]", "country", y)
  y <- gsub(
    "_accom$|_accomod$", "_accomodation", y)
  y <- gsub(
    "_activit", "_activity", y)
  y <- gsub(
    "_cig|_cigs", "_cigarettes", y)
  y <- gsub(
    "cildren", "children", y)
  y <- gsub(
    "citizenshp", "citizenship", y)
  y <- gsub(
    "collgs|collegues", "colleagues", y)
  y <- gsub(
    "competitivn", "competition", y)
  y <- gsub(
    "comptrs", "computers", y)
  y <- gsub(
    "confidfence", "confidence", y)
  y <- gsub(
    "conflicte$", "conflicts", y)
  y <- gsub(
    "conn$|connec$", "connection", y)
  y <- gsub(
    "contrls", "controls", y)
  y <- gsub(
    "communit$", "community", y)
  y <- gsub(
    "situatn_", "situation", y)
  y <- gsub(
    "freq_", "frequency_", y)
  y <- gsub(
    "hh", "household", y)
  y <- gsub(
    "_pers_", "_personal_", y)
  y <- gsub(
    "prov_", "provider_", y)
  y <- gsub(
    "info_", "information_", y)
  y <- gsub(
    "newspv|newspapers", "newspaper", y)
  y <- gsub(
    "_newsp_|_newspap_", "_newspaper_", y)
  y <- gsub(
    "_newsp$|_newspap$", "_newspaper_", y)
  y <- gsub(
    "serv_", "services_", y)
  y <- gsub(
    "financ_", "financial_", y)
  y <- gsub(
    "_op_", "_operator_", y)

  # two- or three-word phrases to be kept as keywords
  y <- gsub(
    "tv_channels", "tv-channels", y)
  y <- gsub(
    "radio_stations", "radio-stations", y)
  y <- gsub(
    "regional_local", "regional-local", y)
  y <- gsub(
    "air_conditioning", "air-conditioning", y)
  y <- gsub(
    "pol_party|political_party", "political-party"
    , y)
  y <- gsub(
    "electoral_particip_", "electoral-participation_"
    , y)
  y <- gsub(
    "electoral_particip$", "electoral-participation$"
    , y)
  y <- gsub(
    "trust_in_institutions", "trust"
    , y)
  y <- gsub(
    "justice_legal_system|justice_nat_legal_system",
    "justice-system", y)
  y <- gsub(
    "non_govmnt_org|non_govnmt_org", "ngo", y)
  y <- gsub(
    "polit_parties|political_parties", "political-parties", y)

  y <- gsub(
    "reg_loc_public_authorities|reg_local_authorities|reg_loc_authorities|reg_local_public_authorities|rg_lc_authorities", "regional-local-authorities", y)
  y <- gsub(
    "written_press", "press", y)
  y <- gsub(
    "pers_influence", "personal-influence", y)
  y <- gsub(
    "job_situation", "job-situation", y)
  y <- gsub(
    "religious_inst$", "religious-institutions",
    y)
  y <- gsub(
    "polit_matters|political_matters", "political-matters", y)
  y <- gsub(
    "pol_discussion|polit_discussion|political_discussion", "political-discussion", y)
  y <- gsub(
    "nat_resources", "natural-resources", y)
  y <- gsub(
    "climate_change", "climate-change", y)
  y <- gsub(
    "non_euro_zone", "non-euro-zone", y)
  y <- gsub(
    "party_attachment", "party-attachment", y)
  y <- gsub(
    "which_issue", "which-issue", y)
  y <- gsub(
    "economic_situation|economic_sit", "economic-situation", y)
  y <- gsub(
    "public_debt", "public-debt", y)
  y <- gsub(
    "left_right", "left-right", y)
  y <- gsub(
    "important_issues_cntry", "important-issues-cntry",
    y)
  y <- gsub(
    "important_issues|import_issues", "important-issues",
    y)
  y <- gsub(
    "important_values_eu", "important-values-eu", y)
  y <- gsub(
    "important_values_pers", "important-values-personal",
    y)
  y <- gsub(
    "important_life_domains", "important-life-domains",
    y)
  y <- gsub(
    "quality_of_life|life_quality", "life-in-general",
    y)
  y <- gsub(
    "household_composition", "household-composition",
    y)
  y <- gsub(
    "size_of_community", "size-of-community", y)
  y <- gsub(
    "head_of_hh", "head-of-hh", y)
  y <- gsub(
    "last_job", "last-job", y)
  y <- gsub(
    "level_in_society", "level-in-society", y)
  y <- gsub(
    "self_placement", "self-placement", y)
  y <- gsub(
    "social_class|soc_class", "social-class", y)
  y <- gsub(
    "education_level", "education-level", y)
  y <- gsub(
    "living_conditions", "living-conditions", y)
  y <- gsub(
    "_nat_", "_national_", y)
  y <- gsub(
    "^nat_", "national_", y)
  y <- gsub(
    "_nat$", "_national", y)
  y <- gsub(
    "europ_", "european_", y)
  y <- gsub(
    "12_months_|12_mo_", "12-months_", y)
  y <- gsub(
    "national_parliament", "national-parliament", y)
  y <- gsub(
    "national_government", "national-government", y)
  y <- gsub(
    "national_economy", "national-economy", y)
  y <- gsub(
    "good_bad", "good-bad", y)
  y <- gsub(
    "court_of_auditors", "court-of-auditors", y)
  y <- gsub(
    "council_of_ministers", "council-of-ministers",
    y)

  # EU-related abbreviations and phrases
  y <- gsub(
    "euro_12", "euro-12", y)
  y <- gsub(
    "european_parliament|eu_parl", "european-parliament",
    y)
  y <- gsub(
    "european_union", "european-union", y)
  y <- gsub(
    "european_unification|europ_unification|europ_unif",
    "european-unification", y)
  y <- gsub(
    "european_economy|europ_economy", "european-economy",
    y)
  y <- gsub(
    "european_ombudsman", "european-ombudsman", y)
  y <- gsub(
    "european_elections|ep_election", "european-elections",
    y)
  y <- gsub("european_elec|european_elect|europ_elec", "european-elections", y)
  y <- gsub(
    "european_economy", "european-economy", y)
  y <- gsub(
    "european_currency|europ_currency", "european-currency",
    y)
  y <- gsub(
    "europ_court_of_auditors|eur_court_of_auditors", "eu-court-of-auditors",
    y)
  y <- gsub(
    "europ_court_of_justice|european_court_of_justice", "eu-court-of-justice",
    y)
  y <- gsub("econ_and_social_committee|economic_and_soc_committee|econ_and_soc_committee", "econ-and-soc-committee", y)
  y <- gsub("europ_polit_matter|europ_political_matters", "european-political-matters",
            y)
  y <- gsub(
    "euro_zone", "euro-zone", y)
  y <- gsub(
    "eu_issues", "eu-issues", y)
  y <- gsub(
    "eu_budget", "eu-budget", y)
  y <- gsub(
    "eu_statements", "eu-statements", y)
  y <- gsub(
    "eu_citizenship", "eu-citizenship", y)
  y <- gsub(
    "eu_membership|eu_membersh", "eu-membership", y)
  y <- gsub(
    "eu_image", "eu-image", y)
  y <- gsub(
    "eu_level", "eu-level", y)
  y <- gsub(
    "ecb|european_central_bank", "european-central-bank", y)
  y <- gsub(
    "european_commission", "european-commission", y)
  y <- gsub(
    "nms", "new-member-states", y)
  y <- gsub(
    "council_of_the_eu", "council-of-the-eu", y)

  ## some policy areas

  y <- gsub(
    "^cap_", "common-agricultural-policy_", y)
  y <- gsub(
    "_cap_", "_common-agricultural-policy_", y)

  gsub("_", " ", trimws(y,which = 'both'))

}

