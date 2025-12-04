#' Species list for AMBI calculations
#'
#' Called from the function [AMBI()]. Returns a dataframe with list of species
#' and the AMBI group they are assigned to. Used within to match species in
#' observed data and find species groups.
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
#' *02 December 2025
#'
#' @param version string, version of the species list,
#'     default is "" - returns the latest version
#'
#'
#' @examples .AMBI_species()
#'
#' @seealso [AMBI()] which calculates the AMBI index.#'
#'
#' @import cli
#'
#' @noRd

.AMBI_species <- function(version = ""){
  version <- as.character(version)

  # list of available species list versions
  versions <- .species_versions()

  cli_div(theme = list(
    span.classavailable = list(color = "#96CBFE"),
    span.classunavailable = list(color = "orange" )))


  if(version!="" & !version %in% names(versions)){

    msg <- paste0("The specified version of species list was not found: {.classunavailable '{version}'}.\f",
      "Available versions of species list are:")
    for(i in 1:length(versions)){
      date <- as.Date(versions[i], format="%Y%m%d")
      msg <- msg %>%
        paste0("\f   {.classavailable '", names(versions)[i],
               "'} {.emph (",
               date, ")}")
    }
    msg <- msg %>%
      paste0("\fReturning the default version: {.classavailable '", names(versions)[1], "'} ")

    cli::cli_warn(msg)

    version <- versions[1]
  }
  if(version == ""){
    version <- names(versions)[1]
  }
  version <- versions[version]
  dataname <- paste0("AMBI_species_list",
                     ifelse(version=="", "", "_"),
                     version)

  return(get(dataname))

}

# return a list of available versions for the species lists
.species_versions <- function(){

  version_names <- c("2025","2024","2022")
  versions <- c("20251205", "20241008", "20220531")

  names(versions) <- version_names

  return(versions)

}

# return the date of the latest version of the species lists
.latest_version <- function(){

  versions <- .species_versions()

  latest <- as.Date(versions, format="%Y%m%d") %>% sort(decreasing = T)
  latest <- latest[1]

  return(format(latest, "%d %B %Y"))

}


