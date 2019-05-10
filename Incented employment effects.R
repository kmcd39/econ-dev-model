# this weighs incentive amount as % firm PV by its effectiveness, and ensure it does not exceed 100%
weighed.effectiveness.total <-
  ifelse(incentive.info$amount.as.perc.VA * incentive.info$cost.effectiveness >= 1,
       0.9999,
       incentive.info$amount.as.perc.VA * incentive.info$cost.effectiveness)

####### 
### NOTE: as I note in the 'incentive costs' part, Bartik makes it so all jobs come online immediately
#### IF the incentive amt is conditional on actual investment. 
#### If we want to adapt to that they come on gradually, changes would have to be made throughout this sheet.ed thru the "exent conditional" parameter.
#### discussion of his treatment is in appendix A of the paper.
#######

incentive.info$inducement.rate <-
  (1 - (1 / 
          ((1 - weighed.effectiveness.total) ^
             -incentive.info$firm.cost.elasticity)))
#######
### NOTE: There seems to be a mistake in the Bartik's workbook, although one that would only matter in specific circumstances
### He weighs "incented jobs" in the conditional regime by depreciation of incented employment
### but doesn't weigh incented jobs in the "non-conditional cost reduction" regime by this employment depreciation amt.
### this would be a problem if both of those things are non-zero (they are both zero in the baseline)
### ---I switch the order of the deprceciation weighing to resolve this issue ( tho obvi doesn't matter in the baseline). Now it happens at the end, applied to the agg. induced jobs, rather than at the beginning, applied to tjust conditional induced jobs
## (or is it right because the 10,000 initial jobs all happen at once if conditional, whereas if conditional everything is already weighted by grwth? idk)
#######
incentive.info$induced.jobs_conditional <-
  incentive.info$number.jobs * incentive.info$inducement.rate * (1 - incentive.info$conditional.extent)

incentive.info$induced.jobs_UNconditional.LR <- # will be weighed by "Extent incentive is simply cost reduction not conditional on marginal investment"
  append(0,
         (incentive.info$number.jobs * 
            (1 - ((1 - incentive.info$weighed.effectiveness)) ^ 
               incentive.info$firm.cost.elasticity))
         )[1:80]

library(dplyr)

incentive.info$induced.jobs_UNconditional.SR <-
  incentive.info$induced.jobs_UNconditional.LR * incentive.info$adjustment.rate

# fcnal form of this eqn is discussed in paper; pg 119 in appendix c and all of appendix d
incentive.info$induced.jobs_UNconditional.SR <-
  incentive.info$induced.jobs_UNconditional.SR +
  (1 - incentive.info$adjustment.rate) * 
  lag(incentive.info$induced.jobs_UNconditional.SR) %>%
  replace(1, 0) # lag turns first term into NA; this turns it back into 0

# combines the two job effects, weighing each by extent incentive conditional. Note weird quirk of how Bartik treats this:
incentive.info$induced.jobs_actual <-
  (1 - incentive.info$conditional.extent) * incentive.info$induced.jobs_conditional +
  incentive.info$conditional.extent * incentive.info$induced.jobs_UNconditional.SR
  

# note that the following calculation happens earlier in excel workbook; i put it here to correct mistake i noted.
incentive.info$induced.depreciated.jobs <-
  incentive.info$induced.jobs_actual * 
  ((1 - incentive.info$incented.employment.depreciation) ^ (years-1))

# store in new dataframe for storing important series / output series (initialized in 'helper fcns.R')
emp.effects$direct.employment <-
  incentive.info$induced.depreciated.jobs

########
# "PV of job years over 80 years in regime that prevails"
# used in outputs
outcomes$social.PV.direct.emp <-
  sum(
    pv(incentive.info$induced.depreciated.jobs,
       incentive.info$social.discount.rate))
