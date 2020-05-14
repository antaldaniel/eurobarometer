#' The sf File Of NUTS0 (country) Boundaries in Europe
#'
#' @format A data frame with 106 observations and four variables:
#' \describe{
#'   \item{id}{ISO 3166 country codes, except for Greece (EL) and the
#'   United Kingdom (UK)}
#'   \item{CNTR_CODE}{CNTR_CODE}
#'   \item{NUTS_NAME}{The official names of the statistical territories,
#'   in this case, countries.}
#'   \item{FID}{FID}
#'   \item{NUTS_ID}{The NUTS0 codes}
#'   \item{geometry}{an sfc_MULTIPOLYGON of the European country boundaries}
#'   \item{geo}{NUTS2013 regional codes}
#'   }
#'   @source \url{https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts}
"geodata_nuts0"
