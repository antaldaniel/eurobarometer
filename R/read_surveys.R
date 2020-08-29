#' @title Read Survey Files
#'
#' Import surveys into a list. Adds filename as a constant to each
#' element of the list.
#'
#' @inheritParams retroharmonize::read_surveys
#' @return A list of the surveys.  Each element of the list is a data
#' frame. The respective file names are added to each data frame as a
#' constant column \code{filename}.
#' @importFrom retroharmonize read_surveys
#' @examples
#' file1 <- system.file(
#'     "examples", "ZA7576.rds", package = "eurobarometer")
#' file2 <- system.file(
#'     "examples", "ZA5913.rds", package = "eurobarometer")
#'
#' read_surveys (c(file1,file2), .f = 'read_rds' )
#' @export

read_surveys <- retroharmonize::read_surveys
