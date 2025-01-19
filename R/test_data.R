#' AMBI test dataset
#'
#' Example data included with the AMBI tool from AZTI (*example_BDheader.xls*).
#'
#' @format The test dataset `test_data` has 53 rows and 4 variables:
#' \describe{
#'   \item{station}{3 sampling sites 1, 2, 3}
#'   \item{replicate}{unique samples taken at each site,
#'             identified _a_, _b_, _c_}
#'   \item{species}{Name of observed species/taxon}
#'   \item{count}{Number of individuals}
#'   }
#'
#'
#' @source <https://ambi.azti.es/download/>
#' @examples
#' summary(test_data)
#'
"test_data"
