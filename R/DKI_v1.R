#' Calculates DKI (_v1_), the Danish Quality Index
#'
#' @description
#' [DKI()] calculates the original version of the Danish quality index DKI
#' [(Carstensen et al., 2014)](#references)
#'
#' The DKI is based on AMBI and can only be calculated after first calculating
#' *AMBI*, the AZTI Marine Biotic Index, and *H'*, the Shannon diversity index.
#' Both indices are included in output from the function [AMBI()].
#'
#' The function uses an estimated maximum possible value of H' in Danish
#'  waters (`H_max`) as a reference value to normalise DKI. If this value is not
#'   specified as an argument, the default value is used (`5.0`) [(Borja et al., 2007)](#references)
#'
#' @references
#' Borja, A., Josefson, A., Miles, A., Muxika, I., Olsgard, F., Phillips, G.,
#' Rodriguez, J., Rygg, B. (2007). An Approach to the Intercalibration of Benthic
#' Ecological Status Assessment in the North Atlantic Ecoregion, According to the
#' European Water Framework Directive. _Marine Pollution Bulletin_, 55(1-6),
#' 42-52. \doi{doi:10.1016/j.marpolbul.2006.08.018}.
#'
#' Carstensen, J., Krause-Jensen, D., Josefson, A. (2014). "Development and
#' testing of tools for intercalibration of phytoplankton, macrovegetation and
#' benthic fauna in Danish coastal areas." Aarhus University, DCE – Danish Centre
#'  for Environment and Energy, 85 pp. _Scientific Report from DCE – Danish
#'  Centre for Environment and Energy_ No. 93.
#' <https://dce2.au.dk/pub/SR93.pdf>
#'
#' @details
#' The [AMBI()] and [Hdash()] functions take a dataframe of observations as an
#' argument. The DKI functions, [DKI2()] and [DKI()], do *not* take a dataframe
#' as an argument. Instead they take values of the input parameters, either
#' single values or as vectors.
#'
#' To calculate DKI for a dataframe of `AMBI` values, it could be called from
#' e.g. within a [dplyr::mutate()] function call. See the examples below.
#'
#' @seealso
#' DKI v1 has been superseded by [DKI2()] a salinity-normalised version of DKI.
#' For more details, see`vignette("other-indices").
#'
#'
#' @param AMBI        AMBI, the AZTI Marine Biotic Index, calculated using [AMBI()]
#' @param H           H', the Shannon diversity index, calculated using [Hdash()]
#' @param N           number of individuals - returned by both [AMBI()] and [Hdash()]
#' @param S           number of species - returned by both [AMBI()] and [Hdash()]
#' @param H_max       maximum H' used to normalise AMBI, _default 5_
#'
#' @return
#' `DKI` index value
#'
#' @examples
#'
#' # Simple example
#'
#' DKI(AMBI = 1.61, H = 2.36, N = 25, S = 6)
#'
#'
#' # ------ Example workflow for calculating DKI from species counts ----
#'
#' # calculate AMBI index
#' df <- AMBI(test_data_DK, by = c("station"), var_rep="sample")[["AMBI"]]
#'
#' # modify names which were not recognized by AMBI() and recalculate
#' df_obs <- dplyr::mutate(test_data_DK, species = gsub(" indet\\.", "", species))
#' df <- ambiR::AMBI(df_obs, by = c("station"), var_rep="sample")[["AMBI"]]
#'
#' # show AMBI results
#' df
#'
#' # calculate DKI from AMBI results
#' df <- dplyr::mutate(df, DKI = DKI(AMBI, H, N, S))
#'
#' dplyr::select(df, station, AMBI, H, N, S, DKI)
#'
#' @export

DKI <- function(AMBI, H, N, S, H_max = 5){
  # DKI v1
  term_AMBI <- (1 - (AMBI  / 7))
  term_NS <- ((1 - (1/N)) + (1 - (1/S))) * 0.5
  DKI <- 0.5*(term_AMBI + (H/H_max)) * term_NS
  return(DKI)
}
