#' Returns species list for AMBI calculations
#'
#' @description
#'
#' Returns a dataframe with list of species and AMBI group. Called by the
#' function [AMBI()] to match species in observed data and find species groups.
#'
#' @details
#'
#' The species groups, as described by Borja et al (2000):
#'
#'    \itemize{
#'    \item *Group&nbsp;I* \cr Species very sensitive to organic enrichment
#'    and present under unpolluted conditions (initial state). They include the
#'    specialist carnivores and some deposit- feeding _tubicolous polychaetes_. \cr
#'
#'    \item *Group&nbsp;II* \cr Species indifferent to enrichment, always present in low densities with
#'    non-significant variations with time (from initial state, to slight unbalance).
#'    These include suspension feeders, less selective carnivores and scavengers.\cr
#'
#'    \item *Group&nbsp;III* \cr Species tolerant to excess organic matter enrichment. These species
#'    may occur under normal conditions, but their populations are stimulated by
#'    organic richment (slight unbalance situations). They are surface
#'    deposit-feeding species, as _tubicolous spionids_. \cr
#'
#'    \item *Group&nbsp;IV* \cr Second-order opportunistic species (slight to pronounced unbalanced
#'    situations). Mainly small sized _polychaetes_: subsurface deposit-feeders,
#'    such as _cirratulids_. \cr
#'
#'    \item *Group&nbsp;V* \cr First-order opportunistic species (pronounced unbalanced
#'    situations). These are deposit- feeders, which proliferate in reduced
#'    sediments. \cr
#'    }
#'
#' @return
#' A data frame with 11,952 rows* and 3 columns:
#'
#' \describe{
#'   \item{species}{Species name or genus (spp.)}
#'   \item{group}{Species group for AMBI index calculation}
#'   \item{RA}{reallocatable}
#' }
#'
#' **latest version 8th October 2024*
#'
#' @source
#' <https://ambi.azti.es/download/>
#'
#' Borja, A., Franco, J., Pérez, V. (2000) A marine biotic index to establish the
#' ecological quality of soft bottom benthos within European estuarine and
#' coastal environments. Marine Pollution Bulletin 40(12): 1100-1114.
#' <https://doi.org/10.1016/S0025-326X(00)00061-8>
#'
#' @param version _string_, version of the species list to return.
#'                The default value is the empty string (`""`)
#'                which returns the latest version
#'                (8th October 2024)
#'                Presently, the only other valid option for version is `"2022"`
#'                (31st May 2022)
#'
#'
#' @examples AMBI_species()
#'
#' @export

AMBI_species <- function(version=""){
  return(.AMBI_species(version))
}
