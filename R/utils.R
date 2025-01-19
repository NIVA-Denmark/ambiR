#' Minimum AMBI as a linear function of salinity
#'
#' _AMBI_sal_ and _H_sal_ are called _AMBI_min_ and
#' _H_max_ in the DKI documentation
#' They are renamed to reflect the fact that they are
#' functions of salinity and not min/max  values from
#'  the data being used in the function
#'
#' @return a numeric value AMBI_min
#'
#' @source <https://dce2.au.dk/pub/SR93.pdf>
#'
#' @param psal numeric salinity
#' @param intercept numeric, default 3.083
#' @param slope numeric default -0.111
#'
#' @examples AMBI_sal(20.1)
#'
#' @export

AMBI_sal <- function(psal, intercept=3.083, slope=-0.111){
  # AMBI_min as function of salinity
  AMBI_min <- intercept + slope * psal
  AMBI_min <- ifelse(AMBI_min < 0, 0, AMBI_min)
  return(AMBI_min)
}

#' Maximum H' as a linear function of salinity
#'
#' _AMBI_sal_ and _H_sal_ are called _AMBI_min_ and
#' _H_max_ in the DKI documentation
#' They are renamed to reflect the fact that they are
#' functions of salinity and not min/max  values from
#'  the data being used in the function
#'
#' @return a numeric value H_max
#'
#' @source <https://dce2.au.dk/pub/SR93.pdf>
#'
#' @param psal numeric salinity
#' @param intercept numeric, default 2.117
#' @param slope numeric default 0.086
#'
#' @examples H_sal(20.1)
#'
#' @export

H_sal <- function(psal, intercept=2.117, slope=0.086){
  # H_max as function of salinity
  return(2.117 + 0.086 * psal)
}
