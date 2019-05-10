# displaced local jobs if incented firm is not export-based (competes w/ local firms)
emp.effects$displaced.jobs <- 
  emp.effects$direct.employment * 
  (1 - incentive.info$export.based)

# multipler based on incented firms (weighed by export-based extent)
LR.multiplier.emp <-
  (econ.vars$LR.multiplier - 1) *
  emp.effects$direct.employment *
  incentive.info$export.based


# macro adjustment rate at which actual adjusts to post-multiplier employment
# defines first in series, then...
multiplier.emp <- numeric(length = length(years))
multiplier.emp[1] <-
  LR.multiplier.emp[1] * econ.vars$mult.adj.rate
# ... iterates through remaining years, defining based on previous values
# (it adds previous SR effect to remaining-to-be-seen LR effect, adjusted my multiplier adjustment rate)
# (Bartik calls this column "Adjustment to LR multipler"; this is misleading name -- it is given emply due to multiplier in a given year)
for (y in 2:length(years)) {
  multiplier.emp[y] <-
    multiplier.emp[y-1] +
    econ.vars$mult.adj.rate *
    (LR.multiplier.emp[y] - multiplier.emp[y-1])
  }

# extra local ownership
# (if local firms are receiving incentives)
extra.local.ownership <-
  local.ownership$local.incentive.extent * 
  local.ownership$local.purchasing.advantage * (
    emp.effects$direct.employment *
      (1 - ((1 - incentive.info$export.based) *
              local.ownership$share.local.biz.displaced)) )

### the reported ones:
# total net indirect effect
emp.effects$net.multiplier.and.displacement <-
  emp.effects$displaced.jobs +
  multiplier.emp +
  extra.local.ownership

# total net direct + indirect effect
# commented out b.c misleading to have with total, which also includes the ~other~ indirect effects
#outcomes$total.emp <-
#  outcomes$net.multiplier.and.displacement +
#  outcomes$direct.employment

# social PV --- check against Bartik -- it matches but I don't store because it's misleading. It's not all emply effects.
#outcomes$social.PV.all.emp <-
  sum(
    pv(
      (emp.effects$net.multiplier.and.displacement + 
         emp.effects$direct.employment),
       incentive.info$social.discount.rate))
  
