# use specified incentive type to retrieve VA ratios for chosen incentive
incentive.cost_perc.VA <-
  incentive.info$incentive.types[incentive.info$incentive.type][,] * incentive.info$scaling.factor

incentive.cost_perc.VA

## fill out incentive amts for 20+ years out
# this follows Bartik in making incentive amt for years 20+
# equal to the cumulative depreciation of the first twenty years, by year 40 (so year 21 incentive = year 1 depreciation;
# (year 22 incentive = years 1+2 cumulative depreciation, etc.))
incentive.cost_perc.VA <-
  append(incentive.cost_perc.VA,
         cumsum(incentive.cost_perc.VA * 
                  (incentive.info$depreciation.incented.capital *
                     incentive.info$perc.offset.depreciation))
         )
# For years > 40 out, the last value repeats (because cumulative summing of first 20 years' depreciation no longer adds anything)
incentive.cost_perc.VA <-
  append(incentive.cost_perc.VA,
         rep(incentive.cost_perc.VA[40],
             times = max(years) - 40))
###

# re-engineer dollar amount from PV amount, applying secular growth rate
incentive.cost.dollars <-
  incentive.cost_perc.VA * 
  growing(incentive.info$VA.FTE * incentive.info$number.jobs)

## calculate PV at SDR
incentive.cost.PV.SDR <-
  pv(incentive.cost.dollars,
     rate = incentive.info$social.discount.rate)

## calculate "PV forever at firm discount rate, as % of value-added"
# for first 80 years:
incentive.cost.PV.firm <-
  pv(incentive.cost.dollars,
     rate = incentive.info$firm.discount.rate)
      
# remaining:
# (this is what Bartik does to caclculate "remaining PV into infinity")
incentive.cost.PV.firm <-
  append(incentive.cost.PV.firm,
         incentive.cost.PV.firm[80] *
           (incentive.cost.PV.firm[80] /
              incentive.cost.PV.firm[79] ) /
           (1 - (incentive.cost.PV.firm[80] /
                   incentive.cost.PV.firm[79] ))
  )

#######
### NOTE: seemingly you should be able to make it so not all jobs come online immediately!
### currently this is not the case and would take some changes around here. I.e., in calculating PV of VA forever
### addendum: it seems if you make incentive not conditional on investment, it models it this way--- i.e. Bartik's "conditional on investment"
### means that that investment all happens in year 1. Weird, but it seems like alternatives can be accommodated thru the "extent conditional" parameter.
#######

# incentive amt : VA added ratio, discounted from firm's perspective:
# this is what Bartik calls "PV forever at FDR of chosen incentive"
# and which shows up as the "calculated input" for "baseline incentive" in the inputs & outputs tab
incentive.info$amount.as.perc.VA <-
  sum(incentive.cost.PV.firm) /
  ( (incentive.info$VA.FTE *
       incentive.info$number.jobs) /
      (1 - (1 + econ.vars$grwth) /
         (1 + incentive.info$firm.discount.rate)) )

#this weighs incentive cost by effectiveness and ensures below 1.
incentive.info$weighed.effectiveness <-
  ifelse(incentive.cost_perc.VA * incentive.info$cost.effectiveness >= 1,
         0.9999,
         incentive.cost_perc.VA * incentive.info$cost.effectiveness)
