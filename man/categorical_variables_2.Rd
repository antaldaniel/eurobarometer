% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data-categorical_variables_2.R
\docType{data}
\name{categorical_variables_2}
\alias{categorical_variables_2}
\title{Vocabulary To Rename Categorical Variables With Two Valid Categories}
\format{
A data frame with 6 rows in 9 variables:
\describe{
  \item{filename}{The name of the GESIS SPSS file where the variable can be found}
  \item{r_name}{The raw variable name in the GESIS SPSS file.}
  \item{normalized_names}{The variable label after normalization}
  \item{canonical_names}{The preferred variable label}
  \item{keyword_1}{If necessary, later new keyword columns can be added.}
  \item{geo_qualifier}{To explicitly refer to separate questionnaire items like the Turkish Cypriot Community}
  }
}
\usage{
categorical_variables_2
}
\description{
Later the filename may be omitted.
The \code{canonical_name} is suggested for programmatic use in R files.
The keywords should be consistent with the ELSST thesaurus.
}
\seealso{
category_labels_2
}
\keyword{datasets}
