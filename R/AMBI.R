#' Calculates AMBI, the AZTI Marine Biotic Index
#'
#' @description
#' Matches a list of species counts with the AMBI species list
#' and calculates the AMBI index.
#'
#' @details
#'
#' ## AMBI method
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
#' also return a warning.(see below)
#'
#' ## Results
#'
#' The output of the function consists of a list of three dataframes:
#'
#'  * `AMBI` containing the calculated `AMBI` index, as well as other information.
#'  * `matched` showing the species matches used
#'  * `warnings` containing any warnings generated regarding numbers of of species
#'  or numbers of individuals
#'
#' ## _quiet_ mode
#'
#' By default, any warnings generated be shown in the console as well as
#' being stored in the output. If the function is called with the
#' argument `quiet = TRUE` then warnings in the console will be suppressed.
#'
#' ## Species matching and _interactive_ mode
#'
#' By default, the function will first check for a species list supplied in the
#' function call using the argument `df_species`. If this is specified, the species
#' names in the input data will be matched with this list first. If no alternative
#' species list is provided (this is the default situation) then the function will
#' go directly  to matching with the AZTI species list.
#'
#' Any species names in the input for which a match was not found in a user-provided
#' species list are then matched with names in the AZTI list. After this, if no
#' match is found then the species will be recorded with a an `NA`value for species group.
#'
#' By checking the output from the first function call, the user can identify species
#' names not matched and if necessary provide a user-defined list to specify the
#' species group before running the function a second time
#'
#' _TO DO: example needed!_
#'
#' If the function is called with the argument `interactive = TRUE` then the user
#' will be asked to assign a species group (_I, II, III, IV, V_) for any species
#' names which were not identified. The user does this by typing _1, 2, 3, 4_ or
#' _5_ and pressing _Enter_. Alternatively, the user can type _0_ to mark the species
#' as recognized but not assigned to a group. By typing _Enter_ without
#' any number the species will be recorded as unidentified (`NA`). This is the
#' same result which would have been returned when calling the function in
#' non-interactive mode. There are two other options: _s_ will display a list of
#' 10 species names which occur close to the unrecognized name when names are sorted
#' in alphabetical order. Entering _s_ a second time will display the next 10 names,
#' and so on. Finally, entering _x_ will abort the interactive species assignment.
#' Any species groups assigned manually at this point wil be discarded and the
#' calculations will process as in the non-interactive mode.
#'
#' Any user-provided group information will be recorded in the `matched` results.
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
#'
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
#'                    species is provided here, then a check will first be made
#'                    against this list before searching the AZTI species list.
#'
#' @param var_group_AMBI   _optional_ name of the column in `df_species`
#'                    containing the groups for the AMBI index calculations. These
#'                    should be specified as integer values from 1 to 7. Any other
#'                    values will be ignored. If `df_species` is not specified
#'                    then `var_group_AMBI` will be ignored.
#'
#' @param quiet       warnings about low numbers of species and/or individuals
#'                    are contained in the `warnings` dataframe. By default
#'                    (`quiet = FALSE`) these warnings are also shown in the console.
#'                    If the function is called with the parameter `quiet = TRUE`
#'                    then warnings will not be displayed in the console.
#'
#' @param interactive (default `FALSE`) if a species name in the input data is not
#'                     found in the AZTI species list, then this will be seen in
#'                     the output dataframe `matched`. If _interactive_ mode is
#'                     selected, the user will be given the opportunity to assign
#'                     _manually_ a species group (_I, II, III, IV, V_) or to
#'                     mark the species as _not assigned_ to a species group (see
#'                     details).
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
#'  * `matched` : the original dataframe with columns added from the species list.
#'  Contains the following columns:
#'    - `group` : showing the species group. Any species/taxa in `df` which were not
#'    matched will have an `NA` value in this column.
#'    -  `RA` : indicating that the species is
#'  _reallocatable_ according to the AZTI list. That is, it could be re-assigned to
#'  a different species group.
#'    - `source` : this column is included only if a user-specified list was
#'    provided `df_species`, or if species groups were assigned interactively.
#'    An _'I'_ in this column indicates that the group was assigned interactively.
#'    A _'U'_ shows that the group information came from a user-provided species
#'    list. An _NA_ value indicates that no interactive or user-provided changes
#'    were applied.
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
                 var_group_AMBI = "group",
                 quiet=F,
                 interactive=F
){

  if(!interactive()){
    # if R is not running interactively, then we cannot interact with the user
    interactive <- FALSE
  }

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

  df_ambi <- AMBI_species()
  names(df_ambi)[names(df_ambi)=="species"] <- var_species
  names(df_ambi)[names(df_ambi)=="group"] <- var_group_AMBI

  if(is.null(df_species)){
    df_species <- df_ambi

  }else{
    missing <- c()
    for(var in c(var_species, var_group_AMBI)){
      if(!var %in% names(df_species)){
        missing <- c(missing, var)
      }
    }
    if(length(missing)>0){
      msg <- paste0(missing, collapse="','")
      msg <- paste0("A user-specified species list was supplied but ",
                    length(missing),
                    " column(s) were not found: '",
                    msg, "'")
      stop(msg)
    }

    df_species <- df_species %>%
      distinct(across(dplyr::all_of(c(var_species,var_group_AMBI))))

    df_dup <- df_species %>%
      species_check_duplicates(var_species=var_species,
                               var_group_AMBI=var_group_AMBI)

    if(nrow(df_dup)>0){

          duplicates <- df_dup %>%
            mutate(duplicates=paste0(!!as.name(var_species),
                                     " [Groups ", groups, "]")) %>%
            pull("duplicates")

      # allow user to correct this is if running interactively?

      msg <- paste0(duplicates, collapse=", ")
      msg <- paste0("More than one user-assigned species group was specified for ",
                    ifelse(length(duplicates)>1, length(duplicates), "a"),
                    " species: ", msg)
      stop(msg)
    }

    df_species <- df_species %>%
      mutate(source="U") %>%
      bind_rows(df_ambi) %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(var_species))) %>%
      dplyr::arrange(dplyr::across(dplyr::all_of("source"))) %>%
      slice(1) %>%
      ungroup()
  }

  unmatched <- df %>%
    distinct(!!as.name(var_species)) %>%
    dplyr::left_join(df_species, by=dplyr::join_by(!!var_species==!!var_species)) %>%
    filter(is.na(!!as.name(var_group_AMBI))) %>%
    dplyr::pull(var_species)

  # unmatched <- unmatched[,var_species]
  unmatched <- sort(unmatched)
  user_entry <- rep(NA, length(unmatched))

  if(length(unmatched)>0){
    if(interactive){
      list_ok <- c("I","II","III","IV","V")
      msg <- c("{length(unmatched)} species name{?s} {?was/were} not recognized.
               These will now be displayed, one at a time.",
               "For each species, you can assign it to one of the five
               AMBI categories ({.emph I, II, III, IV, V}).
               Do this by entering an integer value from {.emph 1} to {.emph {length(list_ok)}}.
               Alternatively, you can assign a value of {.emph 0}.
               This indicates that the species name is recognized but it is
               not possible to assign it to one of the five categories.",
               "If {.emph Enter} is pressed, without providing a value,
               no change will be made. The species name in question
               will be treated as unrecognized.",
               "Enter {.emph s} at the prompt to see a list of similar species
               names and their corresponding AMBI categories.",
               "Enter {.emph x} to abort the interactive species selection.
               Any entries made up to that point will be discarded. All
               {length(unmatched)} species will be treated as unrecognized.")

      cli::cli_par()
      cli::cli_h1("Assigning unrecognized species")
      cli::cli_end()
      for(msgi in msg){
        cli::cli_par()
        ecolor <- ifelse(length(grep("similar", msgi))>0, "green", "blue")
        ecolor <- ifelse(length(grep("abort", msgi))>0, "red", ecolor)
        cli_div(theme = list(span.emph = list(color = ecolor)))
        cli::cli_ul(msgi)
        cli::cli_end()
        cli::cli_end()
      }

      for(ispecies in 1:length(unmatched)){

        res <- get_user_entry(ispecies, unmatched[ispecies], list_ok,
                              df_species, var_species, var_group_AMBI)
        if(res >= 0){
          user_entry[ispecies] <- res
        }else if(res == -99){
          # user selected "x" to abort
          break
        }
      }

    }else{
      # we are not running interactively but if quiet == FALSE then we should
      # show unrecognized species names in the console
      if(quiet==F){
        cli::cli_alert_info("{length(unmatched)} species name{?s} {?was/were} not recognized:")
        unmatched <- paste0("{.emph ", unmatched,"}")
        cli::cli_ol(unmatched)
      }
    }
  }

  unmatched <- unmatched[!is.na(user_entry)]
  user_entry <- user_entry[!is.na(user_entry)]

  if(length(user_entry)>0){
    df_user <- data.frame(v1=unmatched,
                          v2=user_entry)
    names(df_user) <- c(var_species, var_group_AMBI)

    df_species <- df_user %>%
      mutate(source="I") %>%
      bind_rows(df_species) %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(var_species))) %>%
      dplyr::arrange(dplyr::across(dplyr::all_of("source"))) %>%
      slice(1) %>%
      ungroup()
  }

  df <- df %>%
    dplyr::left_join(df_species, by=dplyr::join_by(!!var_species==!!var_species))

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

  dfwarn <- ambi_warnings(df, by, quiet=quiet)

  return(list(AMBI=df, matched=df_matched, warnings=dfwarn))
}

# ----------------- auxiliary functions -----------------


species_check_duplicates <- function(df,
                                     var_species,
                                     var_group_AMBI){

  df <- df %>%
    dplyr::distinct(across(dplyr::all_of(c(var_species, var_group_AMBI))))

  duplicates <- df %>%
    dplyr::group_by(across(dplyr::all_of(var_species))) %>%
    dplyr::summarise(n=n(), .groups="drop") %>%
    filter(n>1) %>%
    select(-n) %>%
    pull(var_species)

  if(length(duplicates)>0){
    df <- df %>%
      filter(!!as.name(var_species) %in% duplicates) %>%
      arrange(across(dplyr::all_of(c(var_species, var_group_AMBI))))

    df <- df %>%
      group_by(across(dplyr::all_of(var_species))) %>%
      dplyr::summarise(groups = paste0(!!as.name(var_group_AMBI), collapse=", "),
                       n=n(), .groups="drop")


  }else{
    df <- data.frame()
  }

  return(df)

}


list_similar <- function(df, species, n0, n, var_species, var_group_AMBI){

  spc <- X <- NULL

  maxchar <- df %>% pull("species") %>% nchar() %>% max()

  species <- strsplit(species, " ") %>% unlist()
  species <- species[1]
  df_match <- data.frame(v1 = species, v2="X")
  names(df_match) <- c(var_species, "X")

  df <- df %>%
    bind_rows(df_match) %>%
    dplyr::arrange(dplyr::across(dplyr::all_of(var_species)))

  df$row <- 1:nrow(df)
  id <- df %>%
    filter(X=="X") %>%
    pull("row")


  n0 <- ifelse(n0<=1,0,1) + id + n0

  df <- df %>%
    filter(is.na(X)) %>%
    filter(row>=n0) %>%
    slice(1:n) %>%
    select(dplyr::all_of(c(var_species, var_group_AMBI)))

  if(nrow(df)>0){
    df <- df %>%
      mutate(n = nchar(!!as.name(var_species)))

    n1 <- max(df$n) + 1

    df <- df %>%
      mutate(n= 1+ maxchar -n)

    df <- df %>%
      rowwise() %>%
      mutate(spc = strrep("\u00a0", n)) %>%
      mutate(s = paste0(" {.emph ", !!as.name(var_species),"}", spc," (Group ",!!as.name(var_group_AMBI),")"))

    similar <- df$s
  }else{
    similar <- c()
  }
  return(similar)
}



get_user_entry <- function(i, name, list, df_species,
                          var_species="species",
                          var_group_AMBI="group",
                          nsimilar=10){

  n0similar <- -1

  x <- NA

  list_ok <- 1:length(list)

  cli::cli_h2("{i} {.emph {name}}")

  msg <- c("enter an integer value from {.emph 0} to {.emph {length(list)}} or press {.emph Enter} to skip. ",
           "{.emph ", col_green("s"), "} - see similar names. ",
           "{.emph ", col_red("x"), "} - abort interactive assignment.")

  list_ok <- c(0, list_ok)
  list_ok <- as.character(list_ok)

  cli_div(theme = list(span.emph = list(color = "blue")))
  cli::cli_alert_info(msg)
  cli::cli_end()

  while(is.na(x)){

    x <- readline(prompt = ">> ")


    if(tolower(x)=="s"){
      # user entered "s" - show similar species
      similar <- list_similar(df_species, name,
                              n0similar, nsimilar,
                            var_species, var_group_AMBI)
      if(length(similar)>0){
          n0similar <- n0similar + nsimilar
          if(n0similar <= 0){
            cli::cli_inform("Names occurring close to {.emph {name}} when arranged alphabetically...")
            }
          cli::cli_ul(similar)
          if(length(similar) < nsimilar){
            cli::cli_inform("...reached end of list")
          }
      }
    }

    if(x==""){
      # user pressed Enter without entering any other text
      cli::cli_alert_info("{.emph {name}} - skipped")
      x <- -1
    }else if(tolower(x)=="x"){
      # user entered "x" - this aborts interactive species assignment
      cli::cli_alert_warning(col_red("interactive species assignment cancelled"))
      x <- -99
    }else{
      if(x %in% list_ok){
        x <- as.numeric(x)
        selected <- c("Not assigned", list)[x+1]
        selected <- ifelse(x==0, selected, paste0("Category ",selected))
        msg_ok <- "{.emph {name}} - {selected}"
        cli::cli_alert_success(msg_ok)
      }else{
        if(tolower(x)!="s"){
          cli_div(theme = list(span.emph = list(color = "red")))
          cli::cli_alert_danger("invalid selection: {.emph {x}}")
          cli::cli_end()
        }
        cli_div(theme = list(span.emph = list(color = "blue")))
        cli::cli_alert_info(msg)
        cli::cli_end()
        x <- NA
      }
    }
  }

  return(x)
}



# auxiliary function to convert numeric group to roman numerals
roman <- function(n, roman_numbers=c("I","II","III","IV","V")){
  return(roman_numbers[n])
  }

# auxiliary function to give warnings for numbers of individuals and species
ambi_warnings <- function(df, by, quiet=F){

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


  nc <- ncol(df)
  if(nrow(df)>0){
    if(quiet!=T){
      for(i in 1:nrow(df)){
        info <- rep(NA_character_, nc-1)
        for(j in 1:(nc-1)){
          info[j] <- paste0(names(df)[j], " ", df[i, j])
        }
        info <- paste0(info, collapse = ", ")
        cli::cli_warn(paste0(info,": ",df[i, "warning"]))
      }
    }
    return(df)
  }else{
    return(NULL)
  }

}

utils::globalVariables(c(":="))
