rm(list = ls())

# analysis timeframe
years <- seq(1:80)

###### incentive design parameters
incentive.info <- list()

# multiplicative scaling of incentive amount
incentive.info$scaling.factor <- 1

# # jobs incented
incentive.info$number.jobs <- 10000

# depreciation of incented employment
incentive.info$incented.employment.depreciation <- 0.00

# dummy var to describe basic incentive structure
# (1=baseline, 2=upfront, 3=uniform, 4=uniform20only, 5=free regime)
incentive.info$incentive.type <- 1

# incentive structures stored in .csv; copied from Bartik (contains first 20 yrs, rest are calculated)
incentive.info$incentive.types <- read.csv("addl parameters.csv",
                                           header = TRUE)

# firm sensitivity to "pure" costs
incentive.info$firm.cost.elasticity <- 10

### depreciation and incentive after 20 years vars
# In Bartik's workbook these are calculated from the 'Two summary sheets' tab
# Baseline annual depreciation rate of capital (after year 20)
incentive.info$depreciation.incented.capital <- 0.0259

# what % of depreciation is offset?
incentive.info$perc.offset.depreciation <- 1.00
#
# there are two calculated vars I leave out here: "after only 20 years" employment depreciation and "Dummy for assigned probability"
#
# adjustment rate to get from SR to LR economic outcomes (esp. re: employment)
incentive.info$adjustment.rate <- 0.09

# Extent incentive is simply cost reduction not conditional on marginal investment
incentive.info$conditional.extent <- 0

# Incentive effectiveness to cost ratio (e.g. job training services, manufacturing extension services)
incentive.info$cost.effectiveness <- 1

# Extent to which incentive effectiveness to cost ratio gets translated into higher profits
incentive.info$profit.incidence <- 1.00

# % of incented firms that are export-based
incentive.info$export.based <- 1.00

# value added per job in incented firms
#   (average value-added in 2015 per job in 31 export-base industries)
incentive.info$VA.FTE <- 177258.351452856

incentive.info$firm.discount.rate <- 0.12

incentive.info$social.discount.rate <- 0.03

# (following two moved from wages vars)
# Wage premia of incented industy (baseline is zero)
incentive.info$incented.wage.premia <- 0

# Wage premia of other jobs than incented jobs
incentive.info$other.wage.premia <- 0

############################################################

###### demand feedback vars
demand.feedback <- list()

# % of fiscal costs financed by spending cuts (remainder is tax increase)
demand.feedback$cuts.financing <- 0.50

# Initial cost of destroying one job due to spending cuts ($33,963 is central Serrato value, 13093 to 56,373 is 90% confidence interval, and 14333 is cost in low growth areas)
# (change in public spending : change in jobs ratio)
demand.feedback$spending.cuts_jobs.destroyed.ratio <- 33963.18

# % of tax changes due to business taxes (44.1% default due to E&Y)
demand.feedback$business.tax.incidence <- 0.441

# % of personal taxes paid by bottom 90% (58.2% from ITEP, average over all states)
demand.feedback$bottom.90p.incidence <- 0.582

# Initial cost to destroy one job from tax changes for bottom 90% (from Zidar paper)
# (change in taxes : change in jobs ratio)
demand.feedback$tax.incr_jobs.destroyed.ratio <- 39177.80

# "Tax increase to jobs destroyed ratio for top 10% taxes  (default here is set at very high number",
#   $100 quintillion, to reflect Zidar results of zero effect of taxes 
demand.feedback$tax.rich_jobs.destroyed.ratio <- 1000000000000000000000000000


############################################################

###### property variables
property.vars <- list()

# Housing price elasticity (0.451 is Bartik (1991); Saiz implies 1.038 in San Jose, 0.255 in Greensboro
# (this is housing price : jobs elasticity)
property.vars$housing.price.elasticity <- 0.451

# Baseline housing price elasticity (=.451, do not change unless you know what you're doing)
property.vars$baseline.housing.price.elasticity <- 0.451

# % of owner-occupied housing  that is locally owned
# (should rename this variable because current one seems to not make sense (% pied a terres?))
property.vars$housing.locally.owned <- 1.00

# % of of non-financial corporations that are locally owned
property.vars$corporations.locally.owned <- 0.10

# % of non-financial unincorporated bizs that are locally owned
property.vars$other.firms.locally.owned <- 0.50


############################################################

## local ownership
local.ownership <- list()

# Locally owned firm is given incentives (can be varied as percentages, or simply set to zero or one)
local.ownership$local.incentive.extent <- 0.00

# Local purchasing advantage (extra multiplier due to local ownership)
local.ownership$local.purchasing.advantage <- 0.25

# Share of local businesses among displaced (if locally-owned businesses are not export-based, 
#    extent to which their sales displace other locally-owned businesses)
local.ownership$share.local.biz.displaced <- 0.25


############################################################

## education
education.vars <- list()

# School spending elasiticity effect on future earnings (.7743 is Jackson Johnson Persico estimate; 
#    .5525 is nonpoor value; .386 is Krueger class size estimate, which is close to pre-K effect)
education.vars$ed.spending_future.earnings <- 0.7743

# Moretti ed spillover multiplier (1.86 is his value)
education.vars$ed.spillover <- 1.86

# Share of ed spending out of total spending (22.1% operating average, 21.4% overall average)
education.vars$share.ed.spending <- 0.221

# Direct benefit of education spending other than increased future earnings for children
#      (default is that parents value dollar for dollar)
education.vars$addl.ed.benefit <-  1

# Marg Propensity Local Consumption
education.vars$local.MPC <- 0.5

############################################################

## labor foce/wages/UR
econ.vars <- list()

# Growth Rate of wages, Value Added (this is economy's secular growth rate in productivity and wages)
econ.vars$grwth <- 0.012
  
## following two moved from basic economic assumptions
econ.vars$LR.multiplier <- 2.50

econ.vars$mult.adj.rate <- 0.50

# Baseline UR (baseline=6.2%) (Assumed initial unemployment rate when incentive program is adopted)
econ.vars$inital.UR <- 6.2 / 100

# Long Run UR (where economy is headed towards)
econ.vars$LR.UR <- 4.5 / 100

# UR rate of convergence (10% is baseline) 
#   (How rapidly economy tends to converge from baseline UR to LR UR, per year)
econ.vars$UR.convergence <- 0.10

# Base wages (from BEA)(wages per FTE worker)
econ.vars$avg.wage <- 59431.26

# Wage elasticity wrt employment at 6.2% UR (0.2 is lit average, 
#     .588 is Bartik estimate for immediate effect at 6.2% unemployment,
#     .538 or .460 are two alternative averages from  Bartik (2015)
econ.vars$wage_initial.employment.elasticity <- 0.200

# Depreciation of wage effect per year (empirical estimate from Bartik 2015, Table 1);
#     4% is prior average from literature, but this does not instrument, and includes nominal wage stuff, and other biases
econ.vars$depreciation_wage.effect.on.emp <- 0.129

# Baseline LFPR elasticity at 6.2% UR (model is 0.23154)
# (labor force participation rate)
econ.vars$LFPR.elasticity <- 0.23154

# Baseline emloy to LF elasticity at 6.2% UR (model is .476)
econ.vars$emp_LFPR.elasticity <- 0.476

# Baseline wage premia spillover (2.84 is Bartik 1993, 0.93 is Beaudry direct wage effect, 2.17 is housing cost controlled effect)
econ.vars$wage.premia.spillover <- 0.93

# Base wages in export-base industries, from BEA using Bartik (2017a) classificaiton of export-base (exact number is in cell f10, DO NOT CHANGE THAT CELL)
econ.vars$base.export.wages <- 84631

# Depreciation of LFPR effect (this is directly done -- not used in baseline model)
econ.vars$LFPR.depreciation <- 0.00

# LFP outmigration & death deflator - on or off (this is modeled depreciation of LFPR due to outmigration and death)

# depreciation for Employ rate effect (average depreciation rate of elasticity) (Based on Bartik 2015 paper)

############################################################

## fiscal effects
fiscal.effects <- list()

# Property tax income elasticity (baseline=.86) (for average state in Anderson and Shimul)
fiscal.effects$prop.tax_income.elasticity <- 0.86

# Sales tax income elasticity (baseline=.811) (for average state, from Bruce/Fox/Tuttle)
fiscal.effects$sales.tax_income.elasticity <- 0.86

# Personal income tax income elasticity (baseline=1.832)(for avg state, from Bruce/Fox/Tuttle)
fiscal.effects$PIT_income.elasticity <- 1.832

# Other Government Rev income elas (baseline=.811)
fiscal.effects$other.govt.rev_income.elasticity <- 0.811

# Elasticity of Direct General Expenditure w/r/t population (baseline=1)
fiscal.effects$spending_pop.elasticity <- 1

# Multiplier for how personal income per FTE for impact of THESE jobs compares with AVERAGE
#     (Ratio of Pers income per FTE for these created jobs vs national avg)
# (i dont understand this param rn)
fiscal.effects$these.jobs <- 1

# Intergovernmental revenue pop elast (baseline=1)
fiscal.effects$intergov.rev_pop.elasticity <- 1

 
