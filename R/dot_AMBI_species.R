#' Species list for AMBI calculations
#'
#' Returns a dataframe with list of species and AMBI group. Called by the
#' function [AMBI()] to match species in observed data and find species groups.
#'
#' *Group I*. Species very sensitive to organic enrichment
#' and present under unpolluted conditions (initial state). They include the
#' specialist carnivores and some deposit- feeding _tubicolous polychaetes_.
#'
#' *Group II*. Species indiferent to enrichment, always present in low densities with
#' non-significant variations with time (from initial state, to slight unbalance).
#' These include suspension feeders, less selective carnivores and scavengers.
#'
#' *Group III*. Species tolerant to excess organic matter enrichment. These species
#' may occur under normal conditions, but their populations are stimulated by
#' organic richment (slight unbalance situations). They are surface
#' deposit-feeding species, as _tubicolous spionids_.
#'
#' *Group IV*. Second-order opportunistic species (slight to pronounced unbalanced
#' situations). Mainly small sized _polychaetes_: subsurface deposit-feeders,
#' such as _cirratulids_.
#'
#' *Group V*. First-order opportunistic species (pronounced unbalanced
#' situations). These are deposit- feeders, which proliferate in reduced
#' sediments.
#'
#'
#' @return a data frame
#' A data frame with 11,952 rows* and 3 columns:
#'
#' \describe{
#'   \item{species}{Species name or genus (spp.)}
#'   \item{group}{Species group for AMBI index calculation}
#'   \item{RA}{reallocatable}
#'   ...
#' }
#'
#' @source <https://ambi.azti.es/download/>
#'
#' *08 October 2024
#'
#' @param version string, version of the species list,
#'     default is "" - returns the latest version
#'
#'
#' @examples .AMBI_species()
#'
#' @import cli
#'
#' @noRd

.AMBI_species <- function(version = ""){
  version <- as.character(version)
  versions_alternative <- c("2022")
  if(version!="" & !version %in% versions_alternative){
    versions_alternative <-  paste0(versions_alternative, collapse="', '")
    cli::cli_inform(paste0(
      "The specified version of species list was not found: '{.emph {version}}'.\f",
      "Available older versions of species list are: '{.emph {versions_alternative}}.\f",
      "Returning the latest version from October 2024."
    ))
  }

  if(version=="2022"){
    return(AZTI_species_list_20220531)
  }else{
    return(AZTI_species_list)
  }
}
