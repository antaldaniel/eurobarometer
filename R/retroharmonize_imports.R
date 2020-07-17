
#' @importFrom retroharmonize read_rds
#' @export
read_rds <- retroharmonize::read_rds


library(usethis)
use_build_ignore("inst/")
path <-
read_rds(path)
