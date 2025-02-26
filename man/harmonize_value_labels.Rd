% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/harmonize_value_labels.R
\name{harmonize_value_labels}
\alias{harmonize_value_labels}
\title{Harmonize Value Labels}
\usage{
harmonize_value_labels(labelled_var, categories = 2)
}
\arguments{
\item{labelled_var}{A vector (survey variable) coded in with
labelled class.}

\item{categories}{The number of valid categories in the value range.}
}
\value{
A labelled vector containing harmonized numeric values and
labels, and in \code{attr(v, num_orig)} the original numeric values,
\code{attr(v, labels_orig)} the original labelling.
}
\description{
Harmonize the numeric values and the value labels of variables.
Currently works only with binary values.
}
\examples{
v <- labelled::labelled(
       c(3,4,4,3,8, 9),
       c(YES = 3, NO = 4, wrong_label = 8, refused = 9)
      )
harmonize_value_labels(v, 2)

v3 <- labelled::labelled(c(3,4,5,3,8, 9),
c(`BETTER`= 3, `WORSE`= 4,
  `SAME` = 5,
  wrong_label = 8, refused = 9))

harmonize_value_labels(
  labelled_var = v3,categories = 3)
}
\seealso{
Other harmonization functions: 
\code{\link{eurobarometer_special_values}()}
}
\concept{harmonization functions}
