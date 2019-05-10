source("baseline parameters.R")

source("helper fcns.R")

source("incentive costs.R")

source("incented employment effects.R")

source("multiplier and displacement.R")

# many of the subsequent circuits depend on a "total employment effect" series
# which is dependent on... many of the circuits. 
# This is handled by calling the "refresh.emply" helper fcn periodically in the following scripts-- and running
# the scripts over each time so they capture each other's feedback effects...

source("wages.R")

source("property.R")

#source("emp feedback from wages and prop.R")