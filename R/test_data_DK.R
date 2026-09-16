#' Danish test dataset
#'
#' Example data from Danish monitoring data. Used for testing DKI calculations.
#'
#' @format The test dataset `test_data_DK` has 112 rows and 4 variables:
#' \describe{
#'   \item{station}{2 sampling sites "42", "49" _(ObservationsStedNavn)_}
#'   \item{sample}{unique samples taken at each site,
#'             identified _1_, _2_, _3_, _4_, _5_ _(Prøvetagningsnummer)_}
#'   \item{species}{Name of observed species/taxon _(Artsnavn)_}
#'   \item{count}{Number of individuals _(Antal)_}
#'   }
#'
#'
#' @source [Danish National Aquatic Monitoring and Assessment Programme.](https://odaforalle.au.dk)
#' @examples
#' head(test_data_DK)
#'
"test_data_DK"
