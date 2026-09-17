#' Calculates NSI, the Norwegian Sensitivity Index
#'
#' @description
#' [NSI()] matches a list of species counts with the Norwegian species list
#' and calculates *NSI* the Norwegian Sensitivity Index.
#' [(Borgersen et al, 2019)](#references)
#'
#' @references
#' Borgersen, G., Trannum, H.C., Gundersen, H., Vedal, J. (2019). Oppdatering av bløtbunnsartenes sensitivitetsverdier (Report No. 7366). Norsk institutt for vannforskning (NIVA).
#' <https://hdl.handle.net/11250/2600903>
#'
#' Rygg, B., Norling, K. (2013). Norwegian Sensitivity Index (NSI) for marine macroinvertebrates, and an update of Indicator Species Index (ISI). (Report No. 6475). Norsk institutt for vannforskning (NIVA). 46 pp.
#'
#' @details
#' If the function is called with the argument `check_species = TRUE` then
#' only species which are successfully matched with the specified species
#' list are included in the calculations. This is the default. If the function
#' is called with `check_species = FALSE`then all rows are counted.
#'
#' @seealso [ISI()] which calculates the Indicator Species Index, another Norwegian
#'  benthic diversity index.
#' For more details, see`vignette("other-indices").
#'
#' @param df          a dataframe of species observations
#' @param by          a vector of column names found in `df` by which calculations
#'                    should be grouped _e.g. c("station","date")_
#' @param var_species name of the column in `df` containing species names
#' @param var_count   name of the column in `df` containing count/density/abundance
#' @param df_species  _optional_ dataframe with user-specified species list.
#' @param version     _string_, version of the index to be calculated.
#'                    The default value is `"2018"`. The the only other valid
#'                    value for `version` is `"2012"`.
#'
#' @return a list of two dataframes:
#'
#'  * `NSI` : results of the NSI index calculations. For each unique
#'  combination of `by`variables the following values are calculated:
#'    - `NSI<version>` : the sensitivity index `NSI2018` or `NSI2012`
#'    - `S` : the number of species
#'    - `N` : the number of individuals
#'
#'  * `match` : the original dataframe with columns added from the species list.
#'  For a user-specified list provided `df_species`, all columns will be included.
#'  If the user-specified species list contains only a single column with species
#'   names, then a new column `match` will be created, with a value of `1` indicating
#'   a match and an `NA` value where no match was found.
#'  One of the following columns will be included, depending on the NSI version:
#'    - `ES100avg_2018` : species sensitivity values used to calculate `NSI2018`
#'    - `ES100avg_2012` : species sensitivity values used to calculate `NSI2012`
#'
#' @import tidyr
#' @import dplyr
#' @import cli
#'
#' @examples
#'
#' NSI(test_data_NO, by="station", var_species ="species", var_count="count")
#'
#' @export

NSI <- function(df,
               by = NULL,
               var_species = "species",
               var_count = "count",
               df_species = NULL,
               version = "2018"
){

  group_var <- p <- plnp <- species <- NSI_i <- NULL

  if(!"data.frame" %in% class(df)){
    msg <- paste0("NSI() was expecting the argument `df` to be a data.frame. You provided a an object of class '", class(df),"'")
    stop(msg)
  }
  if(!version %in% c("2012","2018")){
    msg <- paste0('Invalid value provided for `version`. Allowed values are "2012" or "2018".')
    stop(msg)
  }

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


    if(is.null(df_species)){
      # matching using the Norwegian species list
      df_species <- NO_species()

      df <- df %>%
        left_join(df_species, by=join_by(!!var_species==species))
      var_sensi <- paste0("ES100avg_", version) # an NA in this column indicates that species was not matched

    }else{
      # !is.null(df_species)

      if(!"data.frame" %in% class(df_species)){
        msg <- paste0("NSI() was expecting the argument df_species to be a data.frame. You provided an object of class '", class(df_species),"'")
        stop(msg)
      }

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
        var_sensi <- paste0("ES100avg_", version) # an NA in this column indicates that species was not matched
      }
      df <- df %>%
        left_join(df_species, by=join_by(!!var_species))
    }

    df_matched <- df

    df <- df %>%
      dplyr::filter(!is.na(!!as.name(var_sensi)))


  df <- df %>%
    dplyr::filter(!is.na(!!as.name(var_count))) %>%
    dplyr::filter(!!as.name(var_count) > 0)

  # there could be multiple records for each species if the observations
  # include station and replicate but we are calculating by station only
  # then we need to calculate sums of counts within selected groups
  sum_by <- c(by, var_species, var_sensi)

  df <- df %>%
    dplyr::group_by(across(all_of(sum_by))) %>%
    dplyr::summarise(!!as.name(var_count) := sum(!!as.name(var_count)),
                     .groups="drop")

  NSI_n <- paste0("NSI",version)

  df <- df %>%
    dplyr::group_by(across(all_of(by)))


  df <- df %>%
    mutate(NSI_i = !!as.name(var_count) * !!as.name(var_sensi))

  df <- df %>%
    dplyr::summarise(!!as.name(NSI_n) := (sum(NSI_i) / sum(!!as.name(var_count))) ,
                     N = sum(!!as.name(var_count), na.rm=T),
                     S=n(), .groups="drop")

  return(list(NSI=df, matched=df_matched))
}





