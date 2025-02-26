% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eurobarometer.R
\docType{package}
\name{eurobarometer}
\alias{eurobarometer}
\title{eurobarometer: A package to create tidy Eurobarometer microdata files.}
\description{
The package eurobarometer has a number of related functions to
analyse metadata; labelling variables with the help of metadata;
harmonizing variable names, classes and labels.
}
\section{labelling functions}{

The naming functions make the GESIS SPSS files usable in a programmatic
context.
\code{\link{var_label_normalize}} and \code{\link{val_label_normalize}}
removes regex symbols, whitespace, and
basic inconsistencies in abbreviations.
\code{\link{label_suggest}} harmonizes the names across various GESIS
files, so that they can be joined into panels across time.
}

\section{metadata functions}{

The metadata functions map the SPSS file and suggest variable names,
re-labelling and class conversions.
\code{\link{metadata_create}}
\code{\link{gesis_metadata_create}}
}

\section{identify functions}{

Identify functions try to find harmonization candidates by logical rules.
}

\section{sample data files}{

\code{\link{ZA5913_sample}} A small subset of the ZA5913:
Eurobarometer 81.2 (March 2014): Europeans in 2014,
Financial and Economic Crisis, European Citizenship, and
European Values survey.

\code{\link{ZA6863_sample}} A small subset of the ZA6863:
Standard Eurobarometer 87.3, May 2017 survey.

\code{\link{ZA7576_sample}} A small subset of the ZA7576:
Eurobarometer 91.5 (June-July 2019):
Standard Eurobarometer, European Parliament
Post-election survey 2019, and EU citizens and
development cooperation survey.
}

