% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/label_normalize.R
\name{label_normalize}
\alias{label_normalize}
\title{Create Normalized Variable & Value Labels}
\usage{
label_normalize(x)
}
\arguments{
\item{x}{A vector of the (GESIS) variable or value labels}
}
\value{
A character vector with the normalized labels
}
\description{
Remove relative reference to question blocks, special characters
used in regular expressions, whitespace and bring the variable and
value labels to snake_case_format.
}
\examples{
label_normalize (
    c("QA17_1 EUROPEAN PARLIAMENT - TRUST",
      "QA13_1 TRUST IN INSTITUTIONS: NAT GOVERNMENT" )
)
}
\seealso{
Other naming functions: 
\code{\link{val_label_normalize}()},
\code{\link{var_label_normalize}()}
}
\concept{naming functions}
