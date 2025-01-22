#' Calculates AMBI, the AZTI Marine Biotic Index
#'
#' @description
#' Matches a list of species counts with the AMBI species list
#' and calculates the AMBI index.
#'
#' @details
#'
#' Species can be matched to one of five groups, the distribution of individuals between the groups
#' reflecting different levels of stress on the ecosystem.
#'
#'  * _Group I_. Species very sensitive to organic enrichment
#' and present under unpolluted conditions (initial state). They include the
#' specialist carnivores and some deposit- feeding _tubicolous polychaetes_.
#'
#'  * _Group II_. Species indifferent to enrichment, always present in low densities with
#' non-significant variations with time (from initial state, to slight unbalance).
#' These include suspension feeders, less selective carnivores and scavengers.
#'
#'  * _Group III_. Species tolerant to excess organic matter enrichment. These species
#' may occur under normal conditions, but their populations are stimulated by
#' organic enrichment (slight unbalance situations). They are surface
#' deposit-feeding species, as _tubicolous spionids_.
#'
#'  * _Group IV_. Second-order opportunistic species (slight to pronounced unbalanced
#' situations). Mainly small sized _polychaetes_: subsurface deposit-feeders,
#' such as _cirratulids_.
#'
#'  * _Group V_. First-order opportunistic species (pronounced unbalanced
#' situations). These are deposit- feeders, which proliferate in reduced
#' sediments.
#'
#' The distribution of these ecological groups, according to their sensitivity to
#' pollution stress, provides a BI with eight levels, from 0 to 7
#'
#' _Biotic Coefficient = (0.0 * GI + l.5 * GII + 3.0 * GIII + 4.5 * GIV + 6.0 * GV)_
#'
#' where:
#'
#' _Gn := fraction of individuals in Group n \[I, II, III, IV, V\]_
#'
#' Under certain circumstances, the AMBI index should not be used:
#'
#' * The percentage of individuals not assigned to a group is higher than 20%
#' * The (not null) number of species is less than 3
#' * The (not null) number of individuals is less than 6
#'
#' In these cases the function will still perform the calculations but will
#' also return a warning:
#'
#' @source
#' Borja, A., Franco, J., Pérez, V. (2000) A marine biotic index to establish the
#' ecological quality of soft bottom benthos within European estuarine and
#' coastal environments. Marine Pollution Bulletin 40(12): 1100-1114.
#' <https://doi.org/10.1016/S0025-326X(00)00061-8>
#'
#'
#' @param df          a dataframe of species observations
#'
#' @param by          a vector of column names found in `df` by which calculations
#'                    should be grouped _e.g. c("station","date")_
#' @param var_rep     _optional_ column name in `df` which contains the name of
#'                    the column identifying replicates. If replicates are used,
#'                    the AMBI index will be calculated for each replicate before
#'                    an average is calculated for each combination of `by`
#'                    variables. If the Shannon diversity index `H` is calculated
#'                    this will be done for species counts collected within `by`
#'                    groups without any consideration of replicates.
#'
#' @param var_species name of the column in `df` containing species names
#'
#' @param var_count   name of the column in `df` containing count/density/abundance
#'
#' @param df_species  _optional_ dataframe of user-specified species groups. By default,
#'                    the function matches species in `df` with the official species
#'                    list from AZTI. If a dataframe with a user-defined list of
#'                    species is provided here, then this will be used instead.
#'
#' @param var_group_AMBI   _optional_ name of the column in `df_species`
#'                    containing the groups for the AMBI index calculations. These
#'                    should be specified as integer values from 1 to 7. Any other
#'                    values will be ignored. If `df_species` is not specified
#'                    then `var_group_AMBI` will be ignored.
#'
#' @return a list of three dataframes:
#'
#'  * `AMBI` : results of the AMBI index calculations. For each unique
#'  combination of `by` variables, the following values are calculated:
#'    - `AMBI` : the AMBI index value
#'    - `N` : the number of individuals
#'    - `S` : the number of species
#'    - `H` : the Shannon diversity index
#'    - `fNA` : the fraction of individuals _not assigned_, that is, matched to
#'       a species in the AZTI species with *Group 0*. Note that this is
#'      different from the number of rows where no match was found. These
#'      are excluded from the totals.
#'
#'  * `match` : the original dataframe with columns added from the species list.
#'  For a user-specified list provided `df_species`, all columns will be included.
#'  For the default AZTI species list the following additional columns will be
#'  included:
#'    - `group` : showing the species group
#'    -  `RA` : indicating that the species is
#'  _reallocatable_ according to the AZTI list. That is, it could be re-assigned to
#'  a different species group.
#'
#'  any species/taxa in `df` which do not have a match in `df_species` will have
#'  have _NA_ in these columns.
#'
#'  * `warnings` : a dataframe showing warnings for any combination of `by`
#'  variables a warning where
#'    - The percentage of individuals not assigned to a group is higher than 20%
#'    - The (not null) number of species is less than 3
#'    - The (not null) number of individuals is less than 6
#'
#' @import tidyr
#' @import dplyr
#' @import cli
#' @import utils
#'
#' @examples
#'
#' AMBI(test_data, by=c("station"), var_rep="replicate")
#'
#' df <- data.frame(station = c("1","1","2","2","2"),
#' species = c("Acidostoma neglectum",
#'             "Acrocirrus validus",
#'             "Acteocina bullata",
#'             "Austrohelice crassa",
#'             "Capitella nonatoi"),
#'             count = c(2, 4, 5, 3, 7))
#'
#'  AMBI(df, by = c("station"))
#'
#'
#' @export

AMBI <- function(df, by=NULL,
                 var_rep=NA_character_,
                 var_species="species",
                 var_count="count",
                 df_species = NULL,
                 var_group_AMBI = "group"
){

  H <- N <- NNA <- fGroup <- fNA <- NULL
  sum_count <- wt <- f <- n_species <- count_0 <- NULL
  species <- S <- ambi_group <- species_1 <- NULL

  missing <- c()
  # var_check <- ifelse(ifelse(is.na(var_rep), c(), var_rep))
  # var_check <- c(var_check, by, var_species, var_count)

  if(is.na(var_rep)){
    var_check <- c(by, var_species, var_count)
    vars_group <- c(var_group_AMBI, by)
    vars_group_f <- vars_group
  }else{
    var_check <- c(var_rep, by, var_species, var_count)
    vars_group <- c(var_rep, var_group_AMBI, by)
    vars_group_f <- c(var_group_AMBI, by)
  }

  for(var in var_check){
    if(!var %in% names(df)){
      missing <- c(missing, var)
    }
  }
  if(length(missing)>0){
    msg <- paste0(missing, collapse="','")
    msg <- paste0(length(missing)," column(s) not found in observation data: '", msg, "'")
    stop(msg)
  }

  if(is.null(df_species)){
    df_species <- AMBI_species()
    var_group_AMBI <- "group"

    df <- df %>%
      dplyr::left_join(df_species, by=dplyr::join_by(!!var_species==species))

  }else{
    missing <- c()
    for(var in c(var_species, var_group_AMBI)){
      if(!var %in% names(df_species)){
        missing <- c(missing, var)
      }
    }
    if(length(missing)>0){
      msg <- paste0(missing, collapse="','")
      msg <- paste0(length(missing),
                    " column(s) not found in user-specified species list: '",
                    msg, "'")
      stop(msg)
    }

    df <- df %>%
      dplyr::left_join(df_species, by=dplyr::join_by(!!var_species==!!var_species))

  }

  df_matched <- df
  df <- df %>%
    filter(!is.na(!!as.name(var_group_AMBI)))

  # vars_group <- c(var_group_AMBI, by)

  # calculate H'
  dfH <- Hdash(df, by=by,
               var_species=var_species,
               var_count=var_count,
               check_species = F)$H

  df <- df%>%
    mutate(species_1 = ifelse(!!as.name(var_count) > 0, 1, 0))

  df <- df %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(vars_group))) %>%
    dplyr::summarise(sum_count = sum(!!as.name(var_count)),
                     n_species = sum(species_1, na.rm=T),
              .groups="drop") %>%
    dplyr::arrange(dplyr::across(dplyr::all_of(by)))


  # apply the weighting for Groups I - V

  df_multipliers <- data.frame(
    ambi_group = c(0,1,2,3,4,5),
    wt = c(0, 0, 1.5, 3, 4.5, 6)
  )

  df <- df %>%
    left_join(df_multipliers, by=dplyr::join_by(!!var_group_AMBI==ambi_group))

  if(!is.na(var_rep)){
    by_rep <- c(var_rep, by)
  }else{
    by_rep <- by
  }


  # if a species is not recognized, it is not counted AT ALL
  # if a species is recognized (matched to the list of species)
  # but does not have a category, then it counts towards the fNA
  df <- df %>%
    dplyr::mutate(
      count_0 = ifelse(is.na(!!as.name(var_group_AMBI)), 0,
                       ifelse(!!as.name(var_group_AMBI)==0,
                              sum_count, 0))) %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(by_rep))) %>%
    dplyr::mutate(f = wt * sum_count / (sum(sum_count, na.rm = T) -
                                          sum(count_0, na.rm = T)))

  dfF <- df %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(vars_group_f))) %>%
    dplyr::summarise(
      N = sum(sum_count, na.rm = T),
      NNA = sum(count_0, na.rm = T),
      .groups="drop")


  dfF <- dfF %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(by))) %>%
    mutate(fGroup = N / (sum(N, na.rm=T)-sum(NNA, na.rm=T))) %>%
    ungroup()

  dfall <- data.frame(x = c(1,2,3,4,5))
  names(dfall) <- var_group_AMBI

  dfall <- dfF %>%
    distinct(dplyr::across(dplyr::all_of(by))) %>%
    merge(dfall, all=T)

  dfF <- dfall %>%
    left_join(dfF, by=dplyr::all_of(vars_group_f))

  dfF <- dfF %>%
    mutate(NNA=ifelse(is.na(NNA),0,NNA)) %>%
    filter(NNA==0) %>%
    mutate(fGroup=ifelse(is.na(fGroup),0,fGroup)) %>%
    rowwise() %>%
    mutate(!! var_group_AMBI := roman(!! as.name(var_group_AMBI))) %>%
    #mutate(!!var_group_AMBI := roman(!! rlang::sym(var_group_AMBI))) %>%
    ungroup()


  dfF <- dfF %>%
    select(-c(N,NNA)) %>%
    pivot_wider(names_from = var_group_AMBI, values_from = fGroup, values_fill=0)

  # explanation needed in documentation
  # that f I-V is excluding NA group values
  # fNA is based on all counts

  df <- df %>%
    dplyr::summarise(
      AMBI = sum(f, na.rm=T),
      N = sum(sum_count, na.rm = T),
      S = sum(n_species, na.rm=T),
      fNA = sum(count_0, na.rm = T) / sum(sum_count, na.rm = T),
      .groups="drop") %>%
    dplyr::mutate(AMBI=ifelse(S==0, 7, AMBI))

  if(!is.na(var_rep)){
    df <- df %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(by))) %>%
      dplyr::summarise(
        AMBI = mean(AMBI, na.rm=T),
        fNA = sum(fNA * N, na.rm = T) / sum(N, na.rm = T),
        .groups="drop")
  }else{
    df <- df %>%
      select(dplyr::all_of(c(by, "AMBI", "fNA")))
  }

  if(is.null(by)){
    df <- df %>%
      bind_cols(dfH)
    df <- df %>%
      bind_cols(dfF)
  }else{
    df <- df %>%
      left_join(dfH, by=all_of(by))
    df <- df %>%
      left_join(dfF, by=all_of(by))
  }
  df <- df %>%
    relocate(H, S, .after = AMBI)

  dfwarn <- ambi_warnings(df, by)

  return(list(AMBI=df, matched=df_matched, warnings=dfwarn))
}

# auxiliary function to convert numeric group to roman numerals
roman <- function(n, roman_numbers=c("I","II","III","IV","V")){
  return(roman_numbers[n])
  }

# auxiliary function to give warnings for numbers of individuals and species
ambi_warnings <- function(df, by){

  fNA <- S <- N <- warnpctNA <- warnS <- warnN <- warningtype <- NULL

  warningNA = "The percentage of individuals not assigned to a group is higher than 20%"
  warningS = "The (not null) number of species is less than 3"
  warningN = "The (not null) number of individuals is less than 6"

  df <- df %>%
    mutate(warnpctNA = ifelse(fNA>0.2,
                              paste0(warningNA, " [", round(100*fNA, 1),"%]."),
                              NA_character_)) %>%
    mutate(warnS = ifelse(S<3,paste0(warningS," [",S,"]."),
                          NA_character_)) %>%
    mutate(N = N * (1-fNA)) %>%
    mutate(warnN = ifelse(N<6, paste0(warningN," [",N,"]."),
                          NA_character_))

  by <- c(by, "warnpctNA", "warnS", "warnN")
  df <- df %>%
    select(all_of(c(by))) %>%
    pivot_longer(cols=c(warnpctNA, warnS, warnN), names_to = "warningtype",
                 values_to = "warning", names_prefix = "warn")
  df <- df %>%
    select(-warningtype) %>%
    filter(!is.na(warning))


#   df <- df %>%
#     dplyr::group_by(dplyr::across(dplyr::all_of(by))) %>%
#     dplyr::summarise(warning = paste0(warning, collapse = "\n"))

  nc <- ncol(df)
  if(nrow(df)>0){
    for(i in 1:nrow(df)){
      info <- rep(NA_character_, nc-1)
      for(j in 1:(nc-1)){
        info[j] <- paste0(names(df)[j], " ", df[i, j])
      }
      info <- paste0(info, collapse = ", ")
      cli::cli_warn(paste0(info,": ",df[i, "warning"]))
    }

    return(df)
  }else{
    return(NULL)
  }

}

utils::globalVariables(c(":="))
