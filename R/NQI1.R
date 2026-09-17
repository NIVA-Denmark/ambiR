#' Calculates NQI1, the Norwegian Quality Index
#'
#' @description
#' [NQI1()] calculates the Norwegian Quality Index, NQI1 [(Rygg, 2006)](#references)
#'
#' The NQI1 is based on AMBI and can only be calculated after first calculating
#' *AMBI*, the AZTI Marine Biotic Index, using output from the function [AMBI()].
#'
#' NQI1 is the only Norwegian benthic fauna index which is inter-calibrated with
#' all countries belonging to the North East Atlantic Geographical
#' Intercalibration Group (NEAGIG)[(Borgersen et al, 2019)](#references) .
#'
#'
#' @references
#' Rygg, B. (2006) Developing indices for quality-status classification of marine soft-bottom fauna in Norway. (Report No. 5208) Norwegian Institute for Water Research (NIVA). 33 pp.
#' <https://hdl.handle.net/11250/213219>
#' Borgersen, G., Trannum, H.C., Gundersen, H., Vedal, J. (2019). Oppdatering av bløtbunnsartenes sensitivitetsverdier (Report No. 7366). Norsk institutt for vannforskning (NIVA).
#' <https://hdl.handle.net/11250/2600903>
#'
#' @details
#' While [AMBI()] takes a dataframe of observations as an argument,
#' [NQI1()] does *not*. Instead, similarly to the DKI functions, it
#' takes values of the input parameters, either single values or as vectors.
#'
#' To calculate NQI1 for a dataframe of `AMBI` values, it could be called from
#' e.g. within a [dplyr::mutate()] function call. See the examples below.
#'
#' @seealso
#' For more details, see`vignette("other-indices").
#'
#'
#' @param AMBI        AMBI, the AZTI Marine Biotic Index, calculated using [AMBI()]
#' @param N           number of individuals - returned by both [AMBI()] and [Hdash()]
#' @param S           number of species - returned by both [AMBI()] and [Hdash()]
#'
#' @return
#' `NQI1` index value
#'
#' @examples
#'
#' # Simple example
#'
#' NQI1(AMBI = 1.61, N = 25, S = 6)
#'
#'
#' # ------ Example workflow for calculating NQI1 from species counts ----
#'
#' # calculate AMBI index using Norwegian example data
#'
#' df <- AMBI(test_data_NO,
#'                by = "station",
#'                var_rep = "sample",
#'                var_species = "species",
#'                var_count = "count",
#'                quiet = TRUE)[["AMBI"]]
#'
#' # show AMBI results
#' df
#'
#' # calculate NQI1 from AMBI results
#' df <- dplyr::mutate(df, NQI1 = NQI1(AMBI, N, S))
#' dplyr::select(df, AMBI, N, S, NQI1)
#'
#' @export

NQI1 <- function(AMBI, N, S){
  term_AMBI <- (1 - (AMBI  / 7))
  term_SN <- ( log(S) / log(log(N))) / 2.7
  term_N <- (N / (N+5))
  NQI1 <- 0.5*term_AMBI + 0.5*term_SN*term_N
  return(NQI1)
}

