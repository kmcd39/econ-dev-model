## this function returns a discounted flow
# converts amounts into present values at each point in time.
pv <- function(cf, rate, t = years) {
  cf /
    (1 + rate) ^ (t-1)
  
}

## this returns an initial value's growth over time at each period t assuming secular growth rate.
# helpful b/c a lot of things in Bartik grow by the secular (baseline 12% growth rate). 
growing <- function(x, rate = econ.vars$grwth, t = years) {
  rep(x,length(t)) *
    (1 + rate) ^ (t-1)
}

## initialize lists for storing output and other sig. series
emp.effects <- list()
income.effects <- list()
outcomes <- list()

## initializes components of agg. emplment.
emp.effects$higher.wage.effect <- rep(0, length(years))
emp.effects$higher.prop.effect  <- rep(0, length(years))
emp.effects$demandside.tax.effect  <- rep(0, length(years))
emp.effects$demandside.spend.effect  <- rep(0, length(years))
emp.effects$supplyside.tax.effect  <- rep(0, length(years))
emp.effects$supplyside.spend.effect  <- rep(0, length(years))
emp.effects$demandside.locally.incented.effect <- rep(0, length(years))


## ## refreshes aggregate employment effect measure
refresh.emply <- function() {
    emp.effects$direct.employment +
    emp.effects$net.multiplier.and.displacement +
    emp.effects$higher.wage.effect +
    emp.effects$higher.prop.effect +
    emp.effects$demandside.tax.effect +
    emp.effects$demandside.spend.effect +
    emp.effects$supplyside.tax.effect +
    emp.effects$supplyside.spend.effect +
    emp.effects$demandside.locally.incented.effect
}

# initialize agg. measure
emp.effects$total.jobs <- refresh.emply()
