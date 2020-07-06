library(stringi)

replacements_table <- data.frame(
  pattern = c("%", "europ|eu", "dk"),
  x = c("_pct", "european", "do_not_know")
)


replacement_vector <- c("^cap_", "^[a-z]{1,2}_", "czech_republic|czech_rep")
names (replacement_vector) <- c("common-agricultural-policy_", "", "chechia")

str_replace_all(s = c("europ-council", "dk",
                      "100%", "less than 25%", "eu parliament"),
                replacement_vector)


stri_replace_all_fixed("The quicker brown fox jumped over the lazy dog.",
                       c("quick", "brown", "fox"),
                       c("slow",  "black", "bear"), vectorize_all=FALSE)


stri_replace_all_regex("The quicker brown fox jumped over the lazy dog.",
                       "\\b"%s+%c("quick", "brown", "fox")%s+%"\\b", c("slow",  "black", "bear"),
                       vectorize_all=FALSE)



stri_replace_all_regex(tolower(c("D12_cap_in_czech_republic",
                                 "cap_in_czech_rep")),
                       pattern = replacement_table$pattern,
                       replacement = replacement_table$replacement,
                       vectorize_all=FALSE)
