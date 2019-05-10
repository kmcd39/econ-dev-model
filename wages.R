## "Baseline unemployment history" in Bartik - I rename "Absent incentive unemployment"
# this is what the local unemployment rate would be, absent incentive
# it's structured as: initial unemployment rate reverts to LR "equilibrium" rate at a convergence rate
# all 3 of those factors are input vars.
# (define w/ loop as i do w/ multiplier induced emp)
absent.incentive.emp <-
  numeric(length = length(years))
absent.incentive.emp[1] <- econ.vars$inital.UR

for (y in 2:length(years)) {
  absent.incentive.emp[y] <-
    absent.incentive.emp[y-1] +
    econ.vars$UR.convergence *
    (econ.vars$LR.UR - absent.incentive.emp[y-1])
}

## wage calculations are complicated...

# it starts with a "side calculation of wages scaled to current model"
# he uses observations from his 2015 paper 
# "How Effects of Local Labor Demand Shocks Vary with the Initial Local Unemployment Rate" -- https://research.upjohn.org/up_workingpapers/202/
# The intuition is that while positive employment shocks are more beneficial in already depressed areas,
# incr in wages is lower when unemployment is already low -- smaller reserve army of unemmployed ! 
# ie.,  dW / dEmp is lower when unemployment is already higher

# ...this section ~isn't~ wholly transparent, as the actual numbers from the paper referenced don't appear to be published.
# below does directly recreate his side calc for this model:
# "Natural log of employment rate"
bartik.2015.ln.emply <- c(-0.06391,
                          -0.10531,
                          -0.0428 )
bartik.2015.wage.elasticity <- c( 0.5864716,
                                  0.3327944,
                                  0.721311 )
bartik.2015.unemp <- 1 - exp(bartik.2015.ln.emply)

UR_ln.emply <- 
  lm(formula = formula("wage.elasticity ~ ln.emply"),
     data = data.frame("wage.elasticity" = bartik.2015.wage.elasticity,
                       "ln.emply" = bartik.2015.ln.emply,
                       "unemp" = bartik.2015.unemp))

# "Predicted wage elasticity" in Bartik -- specifically, initial wage elasticity, given initial UR
# uses relationship modeled above to estimate
initial.wage.elasticity <- 
  (UR_ln.emply$coefficients["(Intercept)"] +
  log(1 - econ.vars$inital.UR) * UR_ln.emply$coefficients["ln.emply"]) %>%
  unname()

# "multiplicative factor"
# Need to develop intuition for this. It is used in extranexously in wage.elasticity calc, but also
# used to weight the unemployment-wage elasiticity relationship in same calc (see below)
multiplicative.factor <-
  econ.vars$wage_initial.employment.elasticity / 
  initial.wage.elasticity

## I deviate from Bartik in terms of how results are calculated here because I take issue with some of the logic
# see the word doc for rationale. Basically i skip an unnecessary step that creates an extraneous variable with a misleading name ("baseline wages by year")
## Elasticity of wages at each given unemployment rate absent incentives
# I also simplify this calculation, which for Bartik has an extra x*(1/x) -- complexity is commented out
wage.elasticity <-
  (econ.vars$wage_initial.employment.elasticity ) + #(initial.wage.elasticity * multiplicative.factor) +
  (unname(UR_ln.emply$coefficients["ln.emply"]) * multiplicative.factor) *
  (log(1 - absent.incentive.emp) -
     log(1 - econ.vars$inital.UR))

#...convert above to dollars...
dollar.wage_employment <-
  wage.elasticity *
  growing(econ.vars$avg.wage)
  
# and weigh counterfactual unemployment with changes due to incentives
# (this references "future" sheets in Bartik, this must be re-run later with refreshed agg. emp.)
emp.effects$total.jobs <- refresh.emply()

get.total.wage.change <- function() {
  total.wage.change <- 
    numeric(length = length(years))
  
  total.wage.change[1] <- 
    dollar.wage_employment[1] * emp.effects$total.jobs[1]
  
  for (y in 2:length(years)) {
    total.wage.change[y] <-
      total.wage.change[y-1] * 
      (1 - econ.vars$depreciation_wage.effect.on.emp) +
      (emp.effects$total.jobs[y] - emp.effects$total.jobs[y-1]) *
      dollar.wage_employment[y]
  }
  total.wage.change
}

# here on won't check until it is re-run with feedback effects added in.
income.effects$total.wage.change <-
  get.total.wage.change()

# "Gain to locally owned businesses from wage change"
# (this one depends on 'side calc of local ownership')
'income.effects$local.biz.gain.from.local.wages <-
  income.effects$total.wage.change *
  (1 - )
'  

  
  
#(this last part I also might have an issue with--- see word document?)
