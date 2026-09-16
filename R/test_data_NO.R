#' Norwegian test dataset
#'
#' Example data from Norwegian monitoring data. Used for testing Norwegian index calculations.
#'
#' @format The test dataset `test_data_NO` has 396 rows and 4 variables:
#' \describe{
#'   \item{station}{2 sampling sites "Ærøy (U10)", "Ærøydypet (U12)" _(Vannlokalitetsnavn)_}
#'   \item{sample}{unique samples taken at each site,
#'             identified _G1_, _G2_ _(Provenr)_}
#'   \item{species}{Name of observed species/taxon _(VitenskapligNavn)_}
#'   \item{count}{Number of individuals _(Verdi)_}
#'   }
#'
#'
#' @source [Vann-Nett](https://vann-nett.no/)
#' @examples
#' head(test_data_NO)
#'
"test_data_NO"
