#' Finds the AphiaID for a taxon
#'
#' @description
#' Looks up a taxon name using the REST webservice provided by the World Register of
#'  Marine Species [(WoRMS 2026)](#references) and returns the AphiaID.
#'
#' @references
#' WoRMS Editorial Board (2026). World Register of Marine Species. Available from <https://www.marinespecies.org> at VLIZ
#'  \doi{doi:10.14284/170}
#'#'
#' @details
#' The function is called with the taxon/species name as the argument. If the name
#' is not found or if an error occurs trying to obtain a response from the webserive
#' then the function returns `NULL` and a warning is displayed.
#'
#' @param taxonname (character) scientific name for which we want to find the AphiaID
#'
#' @return
#' `AphiaID` AphiaID returned by WoRMS. `NA` if not found or an error occurred.
#'
#' @examples
#'
#' .getAphiaIDsingle("Abietinaria pulchra")
#'
#' @import cli
#'
#' @noRd

.getAphiaIDsingle <- function(taxonname=NA_character_){

   if(is.na(taxonname)){
    cli::cli_warn("getAphiaID: No name was provided")
    return(NA)
  }

  # avoid annoying the WoRMS folks when calling repeatedly :-)
  Sys.sleep(0.05)

  # trim text and remove 'sp.' from AMBI names - WoRMS doesn't use these
  taxonname <- trimws(taxonname)
  taxonname <- gsub(" spp\\.", "", taxonname)
  taxonname <- gsub(" sp\\.", "", taxonname)

  url <- sprintf("https://www.marinespecies.org/rest/AphiaIDByName/%s", taxonname)
  url <- URLencode(url)
  res <- httr::GET(url)

  if(httr::http_error(res) == TRUE){
    cli::cli_warn(paste0("Err ",httr::message_for_status(res), "[", url, "]"))
    return(NA)
  } else {
    if(httr::status_code(res)==200){
      return(httr::content(res))
    }else{
      msg <- httr::http_status(res)$reason
      msg <- paste0("getAphiaID: WoRMS returned '", msg, "' for '", taxonname, "'")
      cli::cli_warn(msg)
      return(NA)
    }
  }
}

#' @description
#' This is a wrapper for [.getAphiaIDsingle()] which can only be called with a single name
#' This function can be called with a vector of names.
#'
#' @details
#' The function is called with a vector of taxon/species name as the argument.
#' THe function then applies [.getAphiaIDsingle()] for each name.
#'
#' @param taxonname (character vector) of scientific names for which we want to find AphiaIDs
#'
#' @return
#' `AphiaID` vector of AphiaIDs returned by WoRMS. `NA` if not found or an error occurred.
#'
#' @examples
#'
#' .getAphiaID(c("Abietinaria pulchra","Abra alba"))
#'
#' @import cli
#'
#' @noRd

.getAphiaID<- function(taxonname=NA_character_){

  if(length(taxonname)==0) {
    cli::cli_warn("getAphiaID: No names were provided")
    return(NA)
  }

  AphiaIDs <- sapply(taxonname, .getAphiaIDsingle)

  return(AphiaIDs)

}

#' ------------ fuzzy match ---------------------------------------

#' Finds the AphiaID for a taxon
#'
#' @description
#' Looks up a taxon name using the REST webservice provided by the World Register of
#'  Marine Species [(WoRMS 2026)](#references) and returns the AphiaID.
#'
#' @references
#' WoRMS Editorial Board (2026). World Register of Marine Species. Available from <https://www.marinespecies.org> at VLIZ
#'  \doi{doi:10.14284/170}
#'#'
#' @details
#' The function is called with the taxon/species name as the argument. If the name
#' is not found or if an error occurs trying to obtain a response from the webserive
#' then the function returns `NULL` and a warning is displayed.
#'
#' @param taxonname (character) scientific name for which we want to find the AphiaID
#'
#' @return
#' `AphiaID` AphiaID returned by WoRMS. `NA` if not found or an error occurred.
#'
#' @examples
#'
#' .getAphiaIDsingle("Abietinaria pulchra")
#'
#' @import cli
#'
#' @noRd

.getAphiaIDsingleFuzzy <- function(taxonname=NA_character_){

  empty_result <-  list(AphiaID=NA, valid_name=NA_character_)

  if(is.na(taxonname)){
    cli::cli_warn("getAphiaID: No name was provided")
    return(empty_result)
  }

  # trim text and remove 'sp.' from AMBI names - WoRMS doesn't use these
  taxonname <- trimws(taxonname)
  taxonname <- gsub(" spp\\.", "", taxonname)
  taxonname <- gsub(" sp\\.", "", taxonname)

  url <- sprintf("https://www.marinespecies.org/rest/AphiaRecordsByMatchNames?scientificnames[]=%s", taxonname)
  url <- URLencode(url)
  res <- httr::GET(url)


  if(httr::http_error(res) == TRUE){
    cli::cli_warn(paste0("Err ",httr::message_for_status(res), "[", url, "]"))
    return(empty_result)
  } else {
    if(httr::status_code(res)==200){
      res <- httr::content(res)[[1]][[1]]
      aphiaID <- res$valid_AphiaID
      aphiaID <- ifelse(is.null(aphiaID), res$AphiaID, aphiaID)
      valid_name <- res$valid_name
      valid_name <- ifelse(is.null(valid_name), NA_character_, valid_name)
      valid_name <- ifelse(valid_name==taxonname, NA_character_, valid_name)
      res <- list(AphiaID=aphiaID, valid_name=valid_name)
      return(res)
    }else{
      msg <- httr::http_status(res)$reason
      msg <- paste0("getAphiaID: WoRMS returned '", msg, "' for '", taxonname, "'")
      cli::cli_warn(msg)
      return(empty_result)
    }
  }
}


#' @description
#' This is a wrapper for [.getAphiaIDsingleFuzzy()] which can only be called with a single name
#' This function can be called with a vector of names.
#'
#' @details
#' The function is called with a vector of taxon/species name as the argument.
#' THe function then applies [.getAphiaIDsingleFuzzy()] for each name.
#'
#' @param taxonname (character vector) of scientific names for which we want to find AphiaIDs
#'
#' @return
#' `AphiaID` vector of AphiaIDs returned by WoRMS. `NA` if not found or an error occurred.
#'
#' @examples
#'
#' .getAphiaIDsFuzzy(c("Abietinaria pulchra","Abra alba"))
#'
#' @import cli
#'
#' @noRd

.getAphiaIDsFuzzy <- function(taxonname=NA_character_){

  if(length(taxonname)==0) {
    cli::cli_warn("getAphiaID: No names were provided")
    return(NA)
  }

  AphiaIDs <- lapply(taxonname, .getAphiaIDsingleFuzzy)

  return(AphiaIDs)

}
