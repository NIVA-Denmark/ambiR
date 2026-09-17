#' Returns species list used by Norwegian index calculations
#'
#' @description
#'
#' [NO_species()] returns a dataframe with list of species and sensitivities for
#' use in functions calculating Norwegian indices [ISI()] and [NSI()].
#'
#' *latest version 13th November 2024*
#'
#' @references
#' "Sensitivitetsverdier for NSI2018 og ISI 2018_13.11.2024.xlsx"
#' retrieved 01-09-2026
#'  https://www.vannportalen.no/sharepoint/downloaditem?id=01FM3LD2WM4F42XCAEDNBZLJRZMUOM66OP
#' Borgersen, G., Trannum, H.C., Gundersen, H., Vedal, J. (2019). Oppdatering av bløtbunnsartenes sensitivitetsverdier (Report No. 7366). Norsk institutt for vannforskning (NIVA).
#' <https://hdl.handle.net/11250/2600903>
#' Rygg, B., Norling, K. (2013). Norwegian Sensitivity Index (NSI) for marine macroinvertebrates, and an update of Indicator Species Index (ISI). (Report No. 6475). Norsk institutt for vannforskning (NIVA). 46 pp.
#'
#' @details
#'
#' This table contains the species-specific sensitivities used to calculate the
#' Norwegian indices [ISI()] and [NSI()].
#'
#' Similarly to the `AMBI` index, the principle of the Norwegian quality indices
#' is that high species diversity indicates good environmental status and species
#' primarily found at sites with high diversity and considered sensitive, while
#' sites with low species diversity are considered as stressed environments and
#' species more frequently found at such sites are considered more tolerant.
#' Species diversity thus serves as a proxy for the degree of disturbance at a site.
#'
#' The calculation of species sensitivity values for ISI and NSI is based on
#' analysis of `ES100` values calculated for a large number of grab samples from
#' the Norwegian monitoring data. The sensitivity values for a species are
#' the weighted averages of `ES100` values across samples where the species
#' was present.
#'
#'    \itemize{
#'    \item *ES100avg_2018* \cr The weighted average of `ES100` values across
#'    samples where the species was present. Theses are the updated 2018 values.\cr
#'    \item *ES100min5_2018* \cr The weighted average of `ES100` values across
#'    samples where the species was present but based on the 5 samples having the
#'    lowest `ES100` value. This value was determined only for species found in
#'    at least six samples. Theses are the updated 2018 values.\cr
#'    \item *ES100avg_2012* \cr The weighted average of `ES100` values across
#'    samples where the species was present.  These are the values determined
#'    by [Rygg & Norling (2013)](#references) \cr
#'    \item *ES100min5_2012* \cr The weighted average of `ES100` values across
#'    samples where the species was present but based on the 5 samples having the
#'    lowest `ES100` value. This value was determined only for species found in
#'    at least six samples. These are the values determined
#'    by [Rygg & Norling (2013)](#references) \cr
#'    }
#'     ,
#' For more details, please see [Borgersen et al. (2019)](#references):
#'
#'
#' @return
#' A data frame with 760 rows* and 10 columns:
#'
#' \describe{
#'   \item{species}{Species name or genus (spp.)}
#'   \item{ES100avg_2018}{Species sensitivity value for ES100 used to calculate [NSI()] version 2018}
#'   \item{ES100min5_2018}{Species sensitivity value used to calculate [ISI()] version 2018}
#'   \item{ES100avg_2012}{Species sensitivity value for ES100 used to calculate [NSI()] version 2012}
#'   \item{ES100min5_2012}{Species sensitivity value used to calculate [ISI()] version 2012}
#'   \item{group_AMBI}{AMBI species group. This information is included by
#'                      [Borgersen et al. (2019)](#references). For the
#'                      authoritative list see [AMBI_species()]}
#'   \item{group_NSI}{NSI species group. See [Borgersen et al. (2019)](#references)}
#'   \item{group_ISI}{ISI species group}
#'   \item{Revidert}{Indicates that information has been revised.}
#'   \item{Kommentar}{Comment in Norwegian describing revision.}
#' }
#'
#' @seealso [NSI()] and [ISI()] use this species list to calculate these indices.
#'
#' @examples
#'
#' NO_species() %>% head()
#'
#' NO_species() %>% tail()
#'
#' @export

NO_species <- function(){
  return(get("NO_species_list"))
}
