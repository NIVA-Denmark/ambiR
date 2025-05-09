% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test_data.R
\docType{data}
\name{test_data}
\alias{test_data}
\title{AMBI test dataset}
\format{
The test dataset \code{test_data} has 53 rows and 4 variables:
\describe{
\item{station}{3 sampling sites 1, 2, 3}
\item{replicate}{unique samples taken at each site,
identified \emph{a}, \emph{b}, \emph{c}}
\item{species}{Name of observed species/taxon}
\item{count}{Number of individuals}
}
}
\source{
\url{https://ambi.azti.es/download/}
}
\usage{
test_data
}
\description{
Example data included with the AMBI tool from AZTI (\emph{example_BDheader.xls}).
}
\examples{
summary(test_data)

}
\keyword{datasets}
