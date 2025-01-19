#' Calculates H' the Shannon diversity index
#'
#' @description
#' Matches a list of species counts with the AMBI species list
#' and calculates  H' the Shannon diversity index
#'
#' @details
#' If the function is called with `check_species = TRUE` then only species which
#' are succesfully matched with the specifed species list are included in the
#' calculations. This is the default. If the function is called with
#' `check_species = FALSE`then all rows are counted.
#'
#' @param df          a dataframe of species observations
#' @param by          a vector of column names found in `df` by which calculations
#'                    should be grouped _e.g. c("station","date")_
#' @param var_species name of the column in `df` containing species names
#' @param var_count   name of the column in `df` containing count/density/abundance
#' @param check_species boolean, default = TRUE. If TRUE, then only species found
#'                      in the species list are included in H' index. By default,
#'                      the AZTI species list is used.
#' @param df_species  _optional_ dataframe with user-specified species list.
#'
#' @return a list of two dataframes:
#'
#'  * `H` : results of the AMBI index calculations. For each unique
#'  combination of `by`variables the following values are calculated:
#'    - `H` : the Shannon Diversity Index, H'
#'    - `S` : the number of species
#'    - `N` : the number of individuals
#'
#'  * `match` : the original dataframe with columns added from the species list.
#'  For a user-specified list provided `df_species`, all columns will be included.
#'  If the user-specified species list contains only a single column with species
#'   names, then a new column `match` will be created, with a value of 1 indicating
#'   a match and an _NA_ value where no match was found.
#'
#'  For the default AZTI species list the following additional columns will be
#'  included:
#'    - `group` : showing the AMBI species group
#'    -  `RA` : indicating that the species is _reallocatable_ according to the
#'    AZTI list. That is, it could be re-assigned to a different species group.
#'
#' @import tidyr
#' @import dplyr
#' @import cli
#'
#' @examples
#'
#' Hdash(test_data, by=c("station"))
#'
#' @export

Hdash <- function(df, by=NULL,
                  var_species="species",
                  var_count="count",
                  check_species = TRUE,
                  df_species = NULL
){

  group_var <- p <- plnp <- species <- NULL

  for(var in c(by, var_species, var_count)){
    missing <- c()
    if(!var %in% names(df)){
      missing <- c(missing, var)
    }
  }
  if(length(missing)>0){
    msg <- paste0(missing, collapse="','")
    msg <- paste0(length(missing)," column(s) not found in observation data: '", msg, "'")
    stop(msg)
  }

  if(check_species==T){

    if(is.null(df_species)){
      # matching using the AZTI species list
      df_species <- AMBI_species()

      df <- df %>%
        left_join(df_species, by=join_by(!!var_species==species))
      match_var <- "group" # an NA in this column indicates that species was not matched

    }else{
      # !is.null(df_species)

      # matching using a user-specified species list
      missing <- c()
      for(var in c(var_species, group_var)){
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
      if(ncol(df_species)==1){
        df_species <- df_species %>%
          mutate(match=1)
        match_var <- "match" # an NA in this column indicates that species was not matched
      }
      df <- df %>%
        left_join(df_species, by=join_by(!!var_species))
    }

    df_matched <- df

    df <- df %>%
      dplyr::filter(!is.na(!!as.name(match_var)))
  }else{
    # check_species != TRUE
    df_matched <- NULL
  }

  df <- df %>%
    dplyr::filter(!is.na(!!as.name(var_count))) %>%
    dplyr::filter(!!as.name(var_count) > 0)

  # there could be multiple records for each species if the observations
  # include station and replicate but we are calculating by station only
  # then we need to calculate sums of counts within selected groups
  sum_by <- c(by, var_species)

  df <- df %>%
    dplyr::group_by(across(all_of(sum_by))) %>%
    dplyr::summarise(!!as.name(var_count) := sum(!!as.name(var_count)),
                     .groups="drop")


  df <- df %>%
    dplyr::group_by(across(all_of(by))) %>%
    mutate(p = !!as.name(var_count) / sum(!!as.name(var_count))) %>%
    arrange(across(all_of(by))) %>%
    mutate(plog2p = p * log2(p))

  df <- df %>%
    dplyr::group_by(across(all_of(by))) %>%
    dplyr::summarise(H = -1*sum(.data$plog2p, na.rm=T),
              N = sum(!!as.name(var_count), na.rm=T),
              S=n(), .groups="drop")

  return(list(H=df, matched=df_matched))

}
