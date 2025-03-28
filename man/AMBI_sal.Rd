% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{AMBI_sal}
\alias{AMBI_sal}
\title{Minimum AMBI as a linear function of salinity}
\source{
\url{https://dce2.au.dk/pub/SR93.pdf}
}
\usage{
AMBI_sal(psal, intercept = 3.083, slope = -0.111)
}
\arguments{
\item{psal}{numeric salinity}

\item{intercept}{numeric, default 3.083}

\item{slope}{numeric default -0.111}
}
\value{
a numeric value AMBI_min
}
\description{
\emph{AMBI_sal} and \emph{H_sal} are called \emph{AMBI_min} and
\emph{H_max} in the DKI documentation
They are renamed to reflect the fact that they are
functions of salinity and not min/max  values from
the data being used in the function
}
\examples{
AMBI_sal(20.1)

}
