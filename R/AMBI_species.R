#' Returns species list for AMBI calculations
#'
#' @description
#'
#' [AMBI_species()] returns a dataframe with list of species and AMBI group.
#' Called by the function [AMBI()] and then used to match species in observed
#' data and find species groups.
#'
#' *latest version 8th October 2024*
#'
#' @details
#'
#' The species groups, as described by [Borja et al. (2000)](\doi{10.1016/S0025-326X(00)00061-8}):
#'
#'    \itemize{
#'    \item *Group&nbsp;I* \cr Species very sensitive to organic enrichment
#'    and present under unpolluted conditions (initial state). They include the
#'    specialist carnivores and some deposit-feeding _tubicolous polychaetes_. \cr
#'
#'    \item *Group&nbsp;II* \cr Species indifferent to enrichment, always present in low densities with
#'    non-significant variations with time (from initial state, to slight unbalance).
#'    These include suspension feeders, less selective carnivores and scavengers.\cr
#'
#'    \item *Group&nbsp;III* \cr Species tolerant to excess organic matter enrichment. These species
#'    may occur under normal conditions, but their populations are stimulated by
#'    organic enrichment (slight unbalance situations). They are surface
#'    deposit-feeding species, such as _tubicolous spionids_. \cr
#'
#'    \item *Group&nbsp;IV* \cr Second-order opportunistic species (slight to pronounced unbalanced
#'    situations). Mainly small sized _polychaetes_: subsurface deposit-feeders,
#'    such as _cirratulids_. \cr
#'
#'    \item *Group&nbsp;V* \cr First-order opportunistic species (pronounced unbalanced
#'    situations). These are deposit-feeders, which proliferate in reduced
#'    sediments. \cr
#'    }
#'
#' @return
#' A data frame with 11,952 rows* and 3 columns:
#'
#' \describe{
#'   \item{species}{Species name or genus (spp.)}
#'   \item{group}{Species group for AMBI index calculation: `1`, `2`,
#'                `3`, `4` or `5`. A value of `0` indicates that the
#'                species is not assigned to a species group.}
#'   \item{RA}{reallocatable (`0` or `1`), a `1` indicates that a
#'          species could be re-assigned to a different
#'          species group.}
#' }
#'
#' @seealso [AMBI()] which uses the species list to calculate the AMBI index.
#'
#' @param version _string_, version of the species list to return.
#'                The default value is the empty string (`""`)
#'                which returns the latest version of the list
#'                _(8. October 2024)_. Currently, the only other valid value for
#'                `version` is `"2022"` _(31. May 2022)_.
#'
#' @examples
#'
#' AMBI_species() %>% head()
#'
#' AMBI_species() %>% tail()
#'
#' @export

AMBI_species <- function(version = ""){
  return(.AMBI_species(version))
}
