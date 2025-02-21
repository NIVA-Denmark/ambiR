% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AMBI.R
\name{AMBI}
\alias{AMBI}
\title{Calculates AMBI, the AZTI Marine Biotic Index}
\source{
Borja, A., Franco, J., Pérez, V. (2000) A marine biotic index to establish the
ecological quality of soft bottom benthos within European estuarine and
coastal environments. Marine Pollution Bulletin 40(12): 1100-1114.
\url{https://doi.org/10.1016/S0025-326X(00)00061-8}
}
\usage{
AMBI(
  df,
  by = NULL,
  var_rep = NA_character_,
  var_species = "species",
  var_count = "count",
  df_species = NULL,
  var_group_AMBI = "group",
  quiet = F,
  interactive = F
)
}
\arguments{
\item{df}{a dataframe of species observations}

\item{by}{a vector of column names found in \code{df} by which calculations
should be grouped \emph{e.g. c("station","date")}}

\item{var_rep}{\emph{optional} column name in \code{df} which contains the name of
the column identifying replicates. If replicates are used,
the AMBI index will be calculated for each replicate before
an average is calculated for each combination of \code{by}
variables. If the Shannon diversity index \code{H} is calculated
this will be done for species counts collected within \code{by}
groups without any consideration of replicates.}

\item{var_species}{name of the column in \code{df} containing species names}

\item{var_count}{name of the column in \code{df} containing count/density/abundance}

\item{df_species}{\emph{optional} dataframe of user-specified species groups. By default,
the function matches species in \code{df} with the official species
list from AZTI. If a dataframe with a user-defined list of
species is provided here, then a check will first be made
against this list before searching the AZTI species list.}

\item{var_group_AMBI}{\emph{optional} name of the column in \code{df_species}
containing the groups for the AMBI index calculations. These
should be specified as integer values from 1 to 7. Any other
values will be ignored. If \code{df_species} is not specified
then \code{var_group_AMBI} will be ignored.}

\item{quiet}{warnings about low numbers of species and/or individuals
are contained in the \code{warnings} dataframe. By default
(\code{quiet = FALSE}) these warnings are also shown in the console.
If the function is called with the parameter \code{quiet = TRUE}
then warnings will not be displayed in the console.}

\item{interactive}{(default \code{FALSE}) if a species name in the input data is not
found in the AZTI species list, then this will be seen in
the output dataframe \code{matched}. If \emph{interactive} mode is
selected, the user will be given the opportunity to assign
\emph{manually} a species group (\emph{I, II, III, IV, V}) or to
mark the species as \emph{not assigned} to a species group (see
details).}
}
\value{
a list of three dataframes:
\itemize{
\item \code{AMBI} : results of the AMBI index calculations. For each unique
combination of \code{by} variables, the following values are calculated:
\itemize{
\item \code{AMBI} : the AMBI index value
\item \code{N} : the number of individuals
\item \code{S} : the number of species
\item \code{H} : the Shannon diversity index
\item \code{fNA} : the fraction of individuals \emph{not assigned}, that is, matched to
a species in the AZTI species with \emph{Group 0}. Note that this is
different from the number of rows where no match was found. These
are excluded from the totals.
}
\item \code{matched} : the original dataframe with columns added from the species list.
Contains the following columns:
\itemize{
\item \code{group} : showing the species group. Any species/taxa in \code{df} which were not
matched will have an \code{NA} value in this column.
\item \code{RA} : indicating that the species is
\emph{reallocatable} according to the AZTI list. That is, it could be re-assigned to
a different species group.
\item \code{source} : this column is included only if a user-specified list was
provided \code{df_species}, or if species groups were assigned interactively.
An \emph{'I'} in this column indicates that the group was assigned interactively.
A \emph{'U'} shows that the group information came from a user-provided species
list. An \emph{NA} value indicates that no interactive or user-provided changes
were applied.
}
\item \code{warnings} : a dataframe showing warnings for any combination of \code{by}
variables a warning where
\itemize{
\item The percentage of individuals not assigned to a group is higher than 20\%
\item The (not null) number of species is less than 3
\item The (not null) number of individuals is less than 6
}
}
}
\description{
Matches a list of species counts with the AMBI species list
and calculates the AMBI index.
}
\details{
\subsection{AMBI method}{

Species can be matched to one of five groups, the distribution of individuals between the groups
reflecting different levels of stress on the ecosystem.
\itemize{
\item \emph{Group I}. Species very sensitive to organic enrichment
and present under unpolluted conditions (initial state). They include the
specialist carnivores and some deposit- feeding \emph{tubicolous polychaetes}.
\item \emph{Group II}. Species indifferent to enrichment, always present in low densities with
non-significant variations with time (from initial state, to slight unbalance).
These include suspension feeders, less selective carnivores and scavengers.
\item \emph{Group III}. Species tolerant to excess organic matter enrichment. These species
may occur under normal conditions, but their populations are stimulated by
organic enrichment (slight unbalance situations). They are surface
deposit-feeding species, as \emph{tubicolous spionids}.
\item \emph{Group IV}. Second-order opportunistic species (slight to pronounced unbalanced
situations). Mainly small sized \emph{polychaetes}: subsurface deposit-feeders,
such as \emph{cirratulids}.
\item \emph{Group V}. First-order opportunistic species (pronounced unbalanced
situations). These are deposit- feeders, which proliferate in reduced
sediments.
}

The distribution of these ecological groups, according to their sensitivity to
pollution stress, provides a BI with eight levels, from 0 to 7

\emph{Biotic Coefficient = (0.0 * GI + l.5 * GII + 3.0 * GIII + 4.5 * GIV + 6.0 * GV)}

where:

\emph{Gn := fraction of individuals in Group n [I, II, III, IV, V]}

Under certain circumstances, the AMBI index should not be used:
\itemize{
\item The percentage of individuals not assigned to a group is higher than 20\%
\item The (not null) number of species is less than 3
\item The (not null) number of individuals is less than 6
}

In these cases the function will still perform the calculations but will
also return a warning.(see below)
}

\subsection{Results}{

The output of the function consists of a list of three dataframes:
\itemize{
\item \code{AMBI} containing the calculated \code{AMBI} index, as well as other information.
\item \code{matched} showing the species matches used
\item \code{warnings} containing any warnings generated regarding numbers of of species
or numbers of individuals
}
}

\subsection{\emph{quiet} mode}{

By default, any warnings generated be shown in the console as well as
being stored in the output. If the function is called with the
argument \code{quiet = TRUE} then warnings in the console will be suppressed.
}

\subsection{Species matching and \emph{interactive} mode}{

By default, the function will first check for a species list supplied in the
function call using the argument \code{df_species}. If this is specified, the species
names in the input data will be matched with this list first. If no alternative
species list is provided (this is the default situation) then the function will
go directly  to matching with the AZTI species list.

Any species names in the input for which a match was not found in a user-provided
species list are then matched with names in the AZTI list. After this, if no
match is found then the species will be recorded with a an \code{NA}value for species group.

By checking the output from the first function call, the user can identify species
names not matched and if necessary provide a user-defined list to specify the
species group before running the function a second time

\emph{TO DO: example needed!}

If the function is called with the argument \code{interactive = TRUE} then the user
will be asked to assign a species group (\emph{I, II, III, IV, V}) for any species
names which were not identified. The user does this by typing \emph{1, 2, 3, 4} or
\emph{5} and pressing \emph{Enter}. Alternatively, the user can type \emph{0} to mark the species
as recognized but not assigned to a group. By typing \emph{Enter} without
any number the species will be recorded as unidentified (\code{NA}). This is the
same result which would have been returned when calling the function in
non-interactive mode. There are two other options: \emph{s} will display a list of
10 species names which occur close to the unrecognized name when names are sorted
in alphabetical order. Entering \emph{s} a second time will display the next 10 names,
and so on. Finally, entering \emph{x} will abort the interactive species assignment.
Any species groups assigned manually at this point wil be discarded and the
calculations will process as in the non-interactive mode.

Any user-provided group information will be recorded in the \code{matched} results.
}
}
\examples{

AMBI(test_data, by=c("station"), var_rep="replicate")

df <- data.frame(station = c("1","1","2","2","2"),
species = c("Acidostoma neglectum",
            "Acrocirrus validus",
            "Acteocina bullata",
            "Austrohelice crassa",
            "Capitella nonatoi"),
            count = c(2, 4, 5, 3, 7))

 AMBI(df, by = c("station"))


}
