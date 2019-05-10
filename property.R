
### this begins with a side calc to allocate property ownership by certain groups
# Gets real estate values from 2017 Fed Flow of Funds Report for various years, in billions of dollars
# Bartik seemingly transcribes 3 years but then only uses 2?
real.estate.values <-
  list("households" = 
         c(#19647.1,
           20289.2, 21567.6),
       "non.financial.corps" =
         c(#10234.2,
           11378.4, 12522.6),
       "non.financial.noncorp.biz" =
         c(#9818.8,
           10190.8, 10985.8))

real.estate.values$average <-
  unlist(lapply(real.estate.values, mean))

## puts the avg real estate val distribution btwn 2014 and 2015 as ratio to 2015 total FTE...
# (hardcoded number is Bartik's 2015 total FTE)
# and applies secular grwth rate
real.estate.values$ratio_FTE <-
  lapply((real.estate.values$average /
            132352 * 10 ^ 6),
          growing)

# find extra prop value due to new jobs
# total jobs has to be refreshed.
get.prop.val.change <- function(x) {
  
  x * 
    emp.effects$total.jobs *
    property.vars$housing.price.elasticity
}

real.estate.values$extra.value <-
  lapply(real.estate.values$ratio_FTE,
         get.prop.val.change)

get.prop.local.cap.gains <- function(x) {
  
  real.estate.values$local.cap.gains$households <-
  real.estate.values$extra.value$households - lag(real.estate.values$extra.value$households, default = 0) *
  property.vars$housing.locally.owned

  real.estate.values$local.cap.gains$non.financial.corps <-
    real.estate.values$extra.value$non.financial.corps - lag(real.estate.values$extra.value$non.financial.corps, default = 0) *
    property.vars$corporations.locally.owned
  
  real.estate.values$local.cap.gains$non.financial.noncorp.biz <-
    real.estate.values$extra.value$non.financial.noncorp.biz - lag(real.estate.values$extra.value$non.financial.noncorp.biz, default = 0) *
    property.vars$other.firms.locally.owned
 
  real.estate.values$local.cap.gains 
}

real.estate.values$local.cap.gains <-
  get.prop.local.cap.gains()
  