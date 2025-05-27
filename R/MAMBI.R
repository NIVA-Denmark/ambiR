#' Calculates M-AMBI, the multivariate AZTI Marine Biotic Index
#'
#' @description
#' Calculate M-AMBI the multivariate AMBI index, based on the three separate
#' species diversity metrics:
#'
#'  * AMBI index `AMBI`.
#'  * Shannon Wiener diversity index `H'`
#'  * Species richness `S`.
#'
#' @details
#'
#' The input dataframe `df` should contain the three metrics `AMBI`, `H'` and `S`,
#' identified by the column names `var_AMBI` (default `"AMBI"`), `var_H`
#' (default `"H"`) and `var_S` (default `"S"`).
#'
#' If any of these three metrics is not found in the input data, then the function
#'  will return an error.
#'
#' `AMBI` is calculated using the [AMBI()] function. `H'` can be calculated
#' using the [Hdash()] function but it is also included as additional output from
#' [AMBI()] when called with the non-default argument `H = TRUE`. `S` is an output
#' from both functions [AMBI()] and [Hdash()].
#'
#' This means that the input to `MAMBI()` can be generated from species count
#' data using only using the [AMBI()] function.
#'
#'
#' @source
#' _"AMBI, richness and diversity, combined with the use, in a further
#' development, of factor analysis together with discriminant analysis, is
#' presented as an objective tool (named here M-AMBI) in assessing
#' ecological quality status"_ (Muxika et al. 2007)
#'
#' Borja, A., Franco, J., Pérez, V. (2000) A marine biotic index to establish the
#' ecological quality of soft bottom benthos within European estuarine and
#' coastal environments. Marine Pollution Bulletin 40(12): 1100-1114.
#' <https://doi.org/10.1016/S0025-326X(00)00061-8>
#'
#' Muxika, I., Borja, A., Bald, J. (2007) Using historical data, expert judgement
#' and multivariate analysis in assessing reference conditions and benthic
#' ecological status, according to the European Water Framework Directive.
#' Marine Pollution Bulletin, 55: 16-29.
#' <https://doi.org/10.1016/j.marpolbul.2006.05.025>
#'
#' @param df          a dataframe of diversity metrics
#' @param by          a vector of column names found in `df` by which calculations
#'                    should be grouped  _e.g._ `c("station")`. If grouping columns
#'                    are specified, then the mean values of the 3 metrics will
#'                    be calculated within each group before calculating `M-AMBI`
#'                    (default `NULL`)
#' @param var_AMBI    name of the column in `df` containing `AMBI` index (default
#'                    `"AMBI"`)
#' @param var_H       name of the column in `df` containing `H'` Shannon species
#'                    diversity  (default `"H"`)
#' @param var_S       name of the column in `df` containing `S` species richness
#'                    (default `"S"`)
#'
#' @param limits_AMBI named vector with length 2, specifying the values of `AMBI`
#'                    corresponding to _(i)_ worst possible condition (`"bad"`)
#'                    where `M-AMBI` and `EQR` are equal to 0.0 and _(ii)_ the
#'                    best possible condition (`"high"`) where `M-AMBI` and `EQR`
#'                    are equal to 1.0. Default `c("bad" = 6, "high" = 0)`.
#'
#' @param limits_H    named vector with length 2, specifying the values of `H'`
#'                    corresponding to _(i)_ worst possible condition (`"bad"`)
#'                    where `M-AMBI` and `EQR` are equal to 0.0 and _(ii)_ the
#'                    best possible condition (`"high"`) where `M-AMBI` and `EQR`
#'                    are equal to 1.0. Default `c("bad" = 0, "high" = NA)`.
#'                    If the `"bad"` value is `NA` then the lowest value
#'                    occurring in `df` and if `"high"` is `NA` then the highest
#'                    value will be used.
#'
#' @param limits_S    named vector with length 2, specifying the values of `S`
#'                    corresponding to _(i)_ worst possible condition (`"bad"`)
#'                    where `M-AMBI` and `EQR` are equal to 0.0 and _(ii)_ the
#'                    best possible condition (`"high"`) where `M-AMBI` and `EQR`
#'                    are equal to 1.0. Default `c("bad" = 0, "high" = NA)`.
#'                    If the `"bad"` value is `NA` then the lowest value
#'                    occurring in `df` and if `"high"` is `NA` then the highest
#'                    value will be used.
#'
#' @param bounds      A named vector (_length 4_) of EQR boundary values used to
#'                    normalise M-AMBI to  EQR values where the boundary between
#'                     _Good_ and _Moderate_ ecological status is 0.6. They
#'                     specify the values of M-AMBI corresponding to the boundaries
#'                     between _(i)_ _Poor_ and _Bad_ status (`"PB"`), _(ii)_
#'                     _Moderate_ and _Poor_ status (`"MP"`), _(iii)_ _Good_ and
#'                     _Moderate_ status (`"GM"`), and _(iv)_ _High_ and _Good_
#'                     status (`"HG"`). Default `c("PB" = 0.2, "MP" = 0.39,
#'                     "GM" = 0.53, "HG" = 0.77)`
#'
#' @return a dataframe containing results of the M-AMBI index calculations.
#' For each unique combination of `by` variables, the following values are
#' calculated:
#'    - `M-AMBI` : the M-AMBI index value
#'    - `X`,`Y`,`Z` : factor scores giving coordinates in the new factor space.
#'
#' If no `by` variables are specified (`by = NULL`), then `M-AMBI` will be
#' calculated for each row in `df`.
#'
#' In addition, the dataframe returned contains 2 _extra_ rows. These contain
#' the limits applied for each of the metrics, corresponding to `"bad"`
#' (`M-AMBI` = 0.0) and `"high"` (`M-AMBI` = 1.0), as specified in the arguments
#' `limits_AMBI`, `limits_H`, `limits_S` or taken from data.
#'
#' @seealso [AMBI()] which calculates the indices required as input for `MAMBI()`.
#'
#' @import tidyr
#' @import dplyr
#' @import cli
#' @importFrom stats cov loadings princomp varimax
#' @examples
#'
#' df <- data.frame(station = c(1, 1, 1, 2, 2, 2, 3, 3),
#'                  replicates = c("a", "b", "c", "a", "b", "c", "a", "b"),
#'                  AMBI = c(1.8, 1.5, 1.125, 1.875, 2.133, 1.655, 3.5, 4.75),
#'                  H = c(1.055, 0.796, 0.562, 2.072, 2.333, 1.789, 1.561, 1.303),
#'                  S = c(3, 3, 2, 12, 12, 10, 5, 6))
#'
#' MAMBI(df, by = c("station"))
#'
#'
#' @export

MAMBI <- function(df,
                  by = NULL,
                  var_H = "H",
                  var_S = "S",
                  var_AMBI = "AMBI",
                  limits_AMBI = c("bad" = 6,"high" = 0),
                  limits_H = c("bad" = 0,"high" = NA),
                  limits_S = c("bad" = 0,"high" = NA),
                  bounds = c("PB" = 0.2, "MP" = 0.39, "GM" = 0.53, "HG" = 0.77)
){


  Bounds <- Status <- NULL

  missing <- c()

  for(var in c(by, var_AMBI, var_H, var_S)){
    if(!var %in% names(df)){
      missing <- c(missing, var)
    }
  }
  if(length(missing)>0){
    msg <- paste0(missing, collapse="','")
    msg <- paste0(length(missing),
                  " column(s) not found in observation data: '", msg, "'")
    stop(msg)
  }


  # aggregate by groups if necessary
  if(!is.null(by)){
    df <- df %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(by))) %>%
      dplyr::summarise(across(all_of(c(var_AMBI, var_H, var_S)),
                              \(x) mean(x, na.rm = TRUE)),
                       .groups="drop")
  }


  # take the 3 columns with AMBI, H' and S
  m <- df %>%
    select(all_of(c(var_AMBI, var_H, var_S)))

  # rename the columns
  names(m) <- c("AMBI","H","S")

  # create a data frame of limits for the
  # 3 metrics corresponding to M-AMBI = 0.0
  # and M-AMBI = 1.0
  limits <- data.frame(limits_AMBI,
                       limits_H,
                       limits_S)

  names(limits) <- c("AMBI","H","S")

  # if the user has specified Bad and High limits
  # these will be used. If any are not specified,
  # take them from data
  for(i in 1:ncol(limits)){
    if(is.na(limits["bad",i])){
      if(i==1){
        limits["bad",i] <- max(m[,i], na.rm=T)
      }else{
        limits["bad",i] <- min(m[,i], na.rm=T)
      }
    }
    if(is.na(limits["high",i])){
      if(i==1){
        limits["high",i] <- min(m[,i], na.rm=T)
      }else{
        limits["high",i] <- max(m[,i], na.rm=T)
      }
    }
  }

  # join the data frames for limits and observations
  m <- bind_rows(m, limits)

  # do factor analysis
  pca <- princomp(cor = T, covmat = cov(m))

  # get loadings
  load <- loadings(pca) %*% diag(pca$sdev)

  # varimax rotation
  vmx <- loadings(varimax(load))

  # get scores
  scores <- scale(m) %*% vmx
  colnames(scores) <- c("x", "y", "z")

  # get the MAMBI results
  # essentially we are projecting the vectors for each
  # combination of x, y, z onto the vector from "bad" to "high"
  # how far along the vector from M-AMBI = 0.0 to M-AMBI = 1.0
  mambi <- .mambi(scores)

  # from M-AMBI scores get the normalised EQR (GM=0.6)
  # using the specified boundaries for PB, MP, GM and HG
  eqr <-  sapply(mambi, .eqr, bounds=bounds)
  class <-  sapply(eqr, .class)

  # join the metric limits (2 rows) to the original data
  limits$Bounds <- c("Bad","High")

  df <- df %>%
    bind_rows(limits) %>%
    relocate("Bounds", .before=var_AMBI)

  # join the results (x, y, z, MAMBI, EQR) to the original data
  df <- df %>%
    bind_cols(scores)

  df$MAMBI <- mambi
  df$Status <- class
  df$EQR <- eqr

  df <- df %>%
    mutate(Status=ifelse(is.na(Bounds),Status,NA))

  return(df)
}

# ---------------- auxiliary functions ----------------------

# auxiliary function to calculate EQR from M-MAMBI
.eqr <- function(mambi, bounds){
  # bounds=c("PB"=0.2, "MP"=0.39, "GM"=0.53, "HG"=0.77)

  b1 <- bounds[bounds>=mambi]
  if(length(b1)>0){
    eqr1 <- 1-0.2*length(b1)
    b1 <- max(b1)
  }else{
    eqr1 <- 1
    b1 <- 1
  }
  b0 <- bounds[bounds<mambi]
  if(length(b0)>0){
    eqr0 <- 0.2*length(b0)
    b0 <- max(b0)
  }else{
    b0 <- 0
    eqr0 <- 0
  }

  eqr <- eqr0 + (eqr1-eqr0) * ((mambi-b0) / (b1-b0) )

  eqr <- ifelse(eqr>1, 1, eqr)
  eqr <- ifelse(eqr<0, 0, eqr)
  return(eqr)
}

# auxiliary function to return status class from EQR
.class <- function(eqr, class_names = c("Bad","Poor","Mod","Good","High")){
  eqr <- ifelse(eqr<0,0,eqr)
  eqr <- ifelse(eqr>1,1,eqr)
  ix <- floor(eqr * 5)
  ix <- ifelse(ix==5,5,ix+1)

  class <- class_names[ix]

  return(class)
}

# auxiliary function to calculate M-MAMBI from PCR scores
# assumes the last two rows are scores for Bad and High
.mambi<- function(scores){
  n <- nrow(scores)

  f <- scores
  sum_seg2 <- 0

  for(i in 1:ncol(f)){
    seg2 <- (scores[n-1,i] - scores[n,i])^2
    sum_seg2 <- sum_seg2 + seg2
    for(j in 1:nrow(f)){
      v <- (f[j,i] - scores[n-1,i])/(scores[n,i] - scores[n-1,i])
      f[j,i] <- v * seg2
    }
  }
  res <- f[,1]

  for(i in 1:nrow(f)){
    sumf <- sum(f[i,], na.rm=T)
    sumf <- sumf / sum_seg2
    res[i] <- sumf
  }
  return(res)
}
