### This is the driver ###

# Source all the required files
# Run the model and generate outputs

## ##########################

# Clear all stored parameters:
rm(list=ls())

library(shiny)
library(deSolve)
library(ggplot2)
library(dplyr)
#library(gridGraphics)   # Disable this after testing to avoid messing up Shiny
#library(shinyjs)
#library(shinythemes)
source("ODEModel.R")
source("ODEMosquitoParameters.R")
source("ODEAuxiliaryFunctions.R")
source("ODEControlMeasuresParameters.R")
source("ODETransmissionParameters_singlescenario.R")
source("ODEInterventions.R")
#source("ODEInterventions - FirstPass.R")
source("ODEModelOutput.R")
source("FeedingCycle.R")
source("multiplot.R")
## Get parameter for a specific specie ######

##NOTE: Different start time for LAR and BIO will crush at the max time entered - to be fixed



# Turn on required specie

MOSQUITO_PARAMETERS_1 = getAnGambiaeParameters()


# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 365

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************

#Source reduction, coverage value, time it is on
INITIAL_SRE_COVERAGE = 0.0
INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#LArvaciding, coverage value, time it is on
INITIAL_LAR_COVERAGE = 0.05
INITIAL_LAR_TIME     = 0

#Biological, coverage value, time it is on
INITIAL_BIO_COVERAGE = 0.0
INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#ATSB, coverage value, time it is on
INITIAL_ATSB_COVERAGE = 0.0
INITIAL_ATSB_TIME     = 0

#Space Spraying, coverage value, time it is on
INITIAL_SSP_COVERAGE = 0.00
INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Odor Traps, coverage value, time it is on
INITIAL_OBT_COVERAGE = 0.00
INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#LLINs, coverage value, time it is on
INITIAL_ITN_COVERAGE = 0.6
INITIAL_ITN_TIME     = 0
#IRS
INITIAL_IRS_COVERAGE = 0.0
INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#House modification
INITIAL_HOU_COVERAGE = 0.0
INITIAL_HOU_TIME     = 0
#Personal Protection measure
INITIAL_PPM_COVERAGE = 0.0
INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#Cattle - Systemic
INITIAL_ECS_COVERAGE = 0.0
INITIAL_ECS_TIME     = 0
#Cattle - Topical
INITIAL_ECT_COVERAGE = 0.0
INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
INITIAL_OVI_COVERAGE = 0.0
INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
INTERVENTION_PARAMETERS = getInterventionsParameters(
  #Source Reduction
  SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
  #Larvaciding
  LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
  #Biological Control
  BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,
  
  #ATSB
  ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
  #Space Spraying
  SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
  #Odor Traps
  OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
  #LLINs
  ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
  #IRS
  IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
  #House Modification
  HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
  #Personal Protection Measure
  PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
  #Cattle - Systemic
  ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
  #Cattle - topical
  ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
  #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
  OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)

#Pass in interventions parameter with updated coverage and the specie

theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS, speciesSpecificParameters=MOSQUITO_PARAMETERS_1)



## Initialize the model
initState <<- calculateInitialState(theta)


## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
IVM_traj_0 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"daspk")
IVM_traj_0<-IVM_traj_0 [-c(1,2), ]





#
##############
##################
#########################################


# Turn on required specie

MOSQUITO_PARAMETERS_1 = getAnGambiaeParameters()
#MOSQUITO_PARAMETERS_2 = getAnArabiensisParameters()
#MOSQUITO_PARAMETERS_3 = getAnFunestusParameters()

# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 365

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************

#Source reduction, coverage value, time it is on
INITIAL_SRE_COVERAGE = 0.0
INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#LArvaciding, coverage value, time it is on
INITIAL_LAR_COVERAGE = 0.1
INITIAL_LAR_TIME     = 0

#Biological, coverage value, time it is on
INITIAL_BIO_COVERAGE = 0.0
INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#ATSB, coverage value, time it is on
INITIAL_ATSB_COVERAGE = 0.0
INITIAL_ATSB_TIME     = 0

#Space Spraying, coverage value, time it is on
INITIAL_SSP_COVERAGE = 0.00
INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Odor Traps, coverage value, time it is on
INITIAL_OBT_COVERAGE = 0.00
INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#LLINs, coverage value, time it is on
INITIAL_ITN_COVERAGE = 0.8
INITIAL_ITN_TIME     = 0
#IRS
INITIAL_IRS_COVERAGE = 0.0
INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#House modification
INITIAL_HOU_COVERAGE = 0.0
INITIAL_HOU_TIME     = 0
#Personal Protection measure
INITIAL_PPM_COVERAGE = 0.0
INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#Cattle - Systemic
INITIAL_ECS_COVERAGE = 0.0
INITIAL_ECS_TIME     = 0
#Cattle - Topical
INITIAL_ECT_COVERAGE = 0.0
INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
INITIAL_OVI_COVERAGE = 0.0
INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
INTERVENTION_PARAMETERS = getInterventionsParameters(
  #Source Reduction
  SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
  #Larvaciding
  LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
  #Biological Control
  BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,
  
  #ATSB
  ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
  #Space Spraying
  SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
  #Odor Traps
  OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
  #LLINs
  ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
  #IRS
  IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
  #House Modification
  HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
  #Personal Protection Measure
  PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
  #Cattle - Systemic
  ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
  #Cattle - topical
  ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
  #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
  OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)

#Pass in interventions parameter with updated coverage and the specie

theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS, speciesSpecificParameters=MOSQUITO_PARAMETERS_1)



## Initialize the model
initState <<- calculateInitialState(theta)


## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
IVM_traj_2 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"daspk")
IVM_traj_2<-IVM_traj_2[-c(1,2), ]





#
###########################
#############################################
############################################################














# Turn on required specie

MOSQUITO_PARAMETERS_1 = getAnGambiaeParameters()


# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 365

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************

#Source reduction, coverage value, time it is on
INITIAL_SRE_COVERAGE = 0.0
INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#LArvaciding, coverage value, time it is on
INITIAL_LAR_COVERAGE = 0.6
INITIAL_LAR_TIME     = 0

#Biological, coverage value, time it is on
INITIAL_BIO_COVERAGE = 0.0
INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#ATSB, coverage value, time it is on
INITIAL_ATSB_COVERAGE = 0.0
INITIAL_ATSB_TIME     = 0

#Space Spraying, coverage value, time it is on
INITIAL_SSP_COVERAGE = 0.00
INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Odor Traps, coverage value, time it is on
INITIAL_OBT_COVERAGE = 0.00
INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#LLINs, coverage value, time it is on
INITIAL_ITN_COVERAGE = 0.8
INITIAL_ITN_TIME     = 0
#IRS
INITIAL_IRS_COVERAGE = 0.0
INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#House modification
INITIAL_HOU_COVERAGE = 0.0
INITIAL_HOU_TIME     = 0
#Personal Protection measure
INITIAL_PPM_COVERAGE = 0.0
INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#Cattle - Systemic
INITIAL_ECS_COVERAGE = 0.0
INITIAL_ECS_TIME     = 0
#Cattle - Topical
INITIAL_ECT_COVERAGE = 0.0
INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
INITIAL_OVI_COVERAGE = 0.0
INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
INTERVENTION_PARAMETERS = getInterventionsParameters(
  #Source Reduction
  SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
  #Larvaciding
  LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
  #Biological Control
  BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,
  
  #ATSB
  ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
  #Space Spraying
  SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
  #Odor Traps
  OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
  #LLINs
  ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
  #IRS
  IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
  #House Modification
  HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
  #Personal Protection Measure
  PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
  #Cattle - Systemic
  ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
  #Cattle - topical
  ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
  #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
  OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)

#Pass in interventions parameter with updated coverage and the specie

theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS, speciesSpecificParameters=MOSQUITO_PARAMETERS_1)



## Initialize the model
initState <<- calculateInitialState(theta)


## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
IVM_traj_4 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"daspk")
IVM_traj_4<-IVM_traj_4[-c(1,2), ]










#############
###########################33
############################################3


# Turn on required specie

MOSQUITO_PARAMETERS_1 = getAnGambiaeParameters()

# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 365

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************

#Source reduction, coverage value, time it is on
INITIAL_SRE_COVERAGE = 0.0
INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#LArvaciding, coverage value, time it is on
INITIAL_LAR_COVERAGE = 0.7
INITIAL_LAR_TIME     = 0

#Biological, coverage value, time it is on
INITIAL_BIO_COVERAGE = 0.0
INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#ATSB, coverage value, time it is on
INITIAL_ATSB_COVERAGE = 0.0
INITIAL_ATSB_TIME     = 0

#Space Spraying, coverage value, time it is on
INITIAL_SSP_COVERAGE = 0.00
INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Odor Traps, coverage value, time it is on
INITIAL_OBT_COVERAGE = 0.00
INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#LLINs, coverage value, time it is on
INITIAL_ITN_COVERAGE = 0.8
INITIAL_ITN_TIME     = 0
#IRS
INITIAL_IRS_COVERAGE = 0.0
INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#House modification
INITIAL_HOU_COVERAGE = 0.0
INITIAL_HOU_TIME     = 0
#Personal Protection measure
INITIAL_PPM_COVERAGE = 0.0
INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#Cattle - Systemic
INITIAL_ECS_COVERAGE = 0.0
INITIAL_ECS_TIME     = 0
#Cattle - Topical
INITIAL_ECT_COVERAGE = 0.0
INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
INITIAL_OVI_COVERAGE = 0.0
INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
INTERVENTION_PARAMETERS = getInterventionsParameters(
  #Source Reduction
  SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
  #Larvaciding
  LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
  #Biological Control
  BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,
  
  #ATSB
  ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
  #Space Spraying
  SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
  #Odor Traps
  OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
  #LLINs
  ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
  #IRS
  IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
  #House Modification
  HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
  #Personal Protection Measure
  PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
  #Cattle - Systemic
  ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
  #Cattle - topical
  ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
  #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
  OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)

#Pass in interventions parameter with updated coverage and the specie

theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS, speciesSpecificParameters=MOSQUITO_PARAMETERS_1)



## Initialize the model
initState <<- calculateInitialState(theta)


## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
IVM_traj_6 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"daspk")
IVM_traj_6<-IVM_traj_6[-c(1,2), ]







####
#################################3
###################################################

# Turn on required specie

MOSQUITO_PARAMETERS_1 = getAnGambiaeParameters()


# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 365

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************

#Source reduction, coverage value, time it is on
INITIAL_SRE_COVERAGE = 0.0
INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#LArvaciding, coverage value, time it is on
INITIAL_LAR_COVERAGE = 0.8
INITIAL_LAR_TIME     = 0

#Biological, coverage value, time it is on
INITIAL_BIO_COVERAGE = 0.0
INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#ATSB, coverage value, time it is on
INITIAL_ATSB_COVERAGE = 0.0
INITIAL_ATSB_TIME     = 0

#Space Spraying, coverage value, time it is on
INITIAL_SSP_COVERAGE = 0.00
INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Odor Traps, coverage value, time it is on
INITIAL_OBT_COVERAGE = 0.00
INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#LLINs, coverage value, time it is on
INITIAL_ITN_COVERAGE = 0.8
INITIAL_ITN_TIME     = 0
#IRS
INITIAL_IRS_COVERAGE = 0.0
INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#House modification
INITIAL_HOU_COVERAGE = 0.0
INITIAL_HOU_TIME     = 0
#Personal Protection measure
INITIAL_PPM_COVERAGE = 0.0
INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#Cattle - Systemic
INITIAL_ECS_COVERAGE = 0.0
INITIAL_ECS_TIME     = 0
#Cattle - Topical
INITIAL_ECT_COVERAGE = 0.0
INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
INITIAL_OVI_COVERAGE = 0.0
INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
INTERVENTION_PARAMETERS = getInterventionsParameters(
  #Source Reduction
  SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
  #Larvaciding
  LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
  #Biological Control
  BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,
  
  #ATSB
  ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
  #Space Spraying
  SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
  #Odor Traps
  OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
  #LLINs
  ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
  #IRS
  IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
  #House Modification
  HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
  #Personal Protection Measure
  PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
  #Cattle - Systemic
  ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
  #Cattle - topical
  ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
  #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
  OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)

#Pass in interventions parameter with updated coverage and the specie

theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS, speciesSpecificParameters=MOSQUITO_PARAMETERS_1)



## Initialize the model
initState <<- calculateInitialState(theta)


## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
IVM_traj_8 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"daspk")
IVM_traj_8<-IVM_traj_8[-c(1,2), ]











########
##########################33
############################################3
#############################################


# Turn on required specie

MOSQUITO_PARAMETERS_1 = getAnGambiaeParameters()


# simulation runs per day - enter the end time
INITIAL_MODELRUNTIME_VALUE   = 365

#Enter the coverage for a specific intervetion
# To turn it on  - enter the required time which is < the max model run time
# To turn it off - enter INITIAL_MODELRUNTIME_VALUE + 1

###************************************************************

#Source reduction, coverage value, time it is on
INITIAL_SRE_COVERAGE = 0.0
INITIAL_SRE_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#LArvaciding, coverage value, time it is on
INITIAL_LAR_COVERAGE = 1
INITIAL_LAR_TIME     = 0

#Biological, coverage value, time it is on
INITIAL_BIO_COVERAGE = 0.0
INITIAL_BIO_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#ATSB, coverage value, time it is on
INITIAL_ATSB_COVERAGE = 0.0
INITIAL_ATSB_TIME     = 0

#Space Spraying, coverage value, time it is on
INITIAL_SSP_COVERAGE = 0.00
INITIAL_SSP_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Odor Traps, coverage value, time it is on
INITIAL_OBT_COVERAGE = 0.00
INITIAL_OBT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#LLINs, coverage value, time it is on
INITIAL_ITN_COVERAGE = 0.8
INITIAL_ITN_TIME     = 0
#IRS
INITIAL_IRS_COVERAGE = 0.0
INITIAL_IRS_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#House modification
INITIAL_HOU_COVERAGE = 0.0
INITIAL_HOU_TIME     = 0
#Personal Protection measure
INITIAL_PPM_COVERAGE = 0.0
INITIAL_PPM_TIME     = INITIAL_MODELRUNTIME_VALUE + 1
#Cattle - Systemic
INITIAL_ECS_COVERAGE = 0.0
INITIAL_ECS_TIME     = 0
#Cattle - Topical
INITIAL_ECT_COVERAGE = 0.0
INITIAL_ECT_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

#Resting and Ovipositing - OviTraps -assuming same coverage for ATSB and SSP
INITIAL_OVI_COVERAGE = 0.0
INITIAL_OVI_TIME     = INITIAL_MODELRUNTIME_VALUE + 1

## Get intervetions parameters - LLINs for testing
#INTERVENTION_PARAMETERS = getInterventionsParameters(ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME)

## Get intervetions parameters
INTERVENTION_PARAMETERS = getInterventionsParameters(
  #Source Reduction
  SREcov=INITIAL_SRE_COVERAGE,time_SRE_on=INITIAL_SRE_TIME,
  #Larvaciding
  LARcov=INITIAL_LAR_COVERAGE,time_LAR_on=INITIAL_LAR_TIME,
  #Biological Control
  BIOcov=INITIAL_BIO_COVERAGE,time_BIO_on=INITIAL_BIO_TIME,
  
  #ATSB
  ATSBcov=INITIAL_ATSB_COVERAGE,time_ATSB_on=INITIAL_ATSB_TIME,
  #Space Spraying
  SSPcov=INITIAL_SSP_COVERAGE,time_SSP_on=INITIAL_SSP_TIME,
  #Odor Traps
  OBTcov=INITIAL_OBT_COVERAGE,time_OBT_on=INITIAL_OBT_TIME,
  #LLINs
  ITNcov=INITIAL_ITN_COVERAGE,time_ITN_on=INITIAL_ITN_TIME,
  #IRS
  IRScov=INITIAL_IRS_COVERAGE,time_IRS_on=INITIAL_IRS_TIME,
  #House Modification
  HOUcov=INITIAL_HOU_COVERAGE,time_HOU_on=INITIAL_HOU_TIME,
  #Personal Protection Measure
  PPMcov=INITIAL_PPM_COVERAGE,time_PPM_on=INITIAL_PPM_TIME,
  #Cattle - Systemic
  ECScov=INITIAL_ECS_COVERAGE,time_ECS_on=INITIAL_ECS_TIME,
  #Cattle - topical
  ECTcov=INITIAL_ECT_COVERAGE,time_ECT_on=INITIAL_ECT_TIME,
  #Resting & Ovipositing - Ovitraps --same for ATSB, SSP
  OVIcov=INITIAL_OVI_COVERAGE,time_OVI_on=INITIAL_OVI_TIME)

#Pass in interventions parameter with updated coverage and the specie

theta <<- getTheta(interventionParameters=INTERVENTION_PARAMETERS, speciesSpecificParameters=MOSQUITO_PARAMETERS_1)



## Initialize the model
initState <<- calculateInitialState(theta)


## Run the model - eventually produce different IVM_traj for different scenarios, eg., 1 intervention, 2 inter, etc
IVM_traj_10 <<- runODE(INITIAL_MODELRUNTIME_VALUE,1,initState,theta,"daspk")
IVM_traj_10<-IVM_traj_10[-c(1,2), ]


time <- as.data.frame(IVM_traj_0$time)
eir0<-as.data.frame( IVM_traj_0$EIR)
eir2<-as.data.frame( IVM_traj_2$EIR)
eir4<-as.data.frame( IVM_traj_4$EIR)
eir6<-as.data.frame( IVM_traj_6$EIR)
eir8<-as.data.frame( IVM_traj_8$EIR)
eir10<-as.data.frame( IVM_traj_10$EIR)


new_eir <- cbind(time,eir0,eir2,eir4,eir6,eir8,eir10)

new_eir <- new_eir %>% rename( time=`IVM_traj_0$time`, 
                               `0%` =`IVM_traj_0$EIR`,
                               `20%`= `IVM_traj_2$EIR`,
                               `40%` = `IVM_traj_4$EIR`,
                               `60%` = `IVM_traj_6$EIR`,
                               `80%` = `IVM_traj_8$EIR`,
                               `100%` = `IVM_traj_10$EIR`)


library(ggplot2)
# 
# ggplot(data = new_eir) +
#   geom_line(aes(x = time, y = `20%`, color = "20%", linetype = "20%"), size = 0.6) +
#   geom_line(aes(x = time, y = `40%`, color = "40%", linetype = "40%"), size = 0.6) +
#   geom_line(aes(x = time, y = `60%`, color = "60%", linetype = "60%"), size = 0.6) +
#   geom_line(aes(x = time, y = `80%`, color = "80%", linetype = "80%"), size = 0.6) +
#   geom_line(aes(x = time, y = `100%`, color = "100%", linetype = "100%"), size = 0.6) +
#   geom_hline(yintercept = 1, linetype = "solid") +
#   labs(x = "Time (Days)", y = "Entomological Inoculation Rate", 
#        color = "LARV Coverages \n for 80% ITN", linetype = "LARV Coverages \n for 80% ITN") +
#   scale_color_manual(
#     values = c( "20%" = "blue", "40%" = "red", "60%" = "green", "80%" = "purple", "100%" = "black")
#   ) +
#   scale_linetype_manual(
#     values = c("20%" = "F1", "40%" = "F4448444", "60%" = "42", "80%" = "13", "100%" = "1343")
#   ) +
#   theme_classic() +
#   theme(
#     plot.title = element_text(hjust = 0.5),
#     axis.text.x = element_text(angle = 45, hjust = 1),
#     legend.position = "right",
#     axis.title = element_text(face = "bold", size = 20),
#     axis.text = element_text(face = "bold", size = 16),
#     legend.title = element_text(face = "bold", size = 16),
#     legend.text = element_text(size = 14)
#   )



larv60_plot<-ggplot(data = new_eir) +
  geom_line(aes(x = time, y = `0%`, color = "0%", linetype = "0%"), size = 1.75) +
  geom_line(aes(x = time, y = `20%`, color = "20%", linetype = "20%"), size = 1.75) +
  geom_line(aes(x = time, y = `40%`, color = "40%", linetype = "40%"), size = 1.75) +
  geom_line(aes(x = time, y = `60%`, color = "60%", linetype = "60%"), size = 1.75) +
  geom_line(aes(x = time, y = `80%`, color = "80%", linetype = "80%"), size = 1.75) +
  geom_line(aes(x = time, y = `100%`, color = "100%", linetype = "100%"), size = 1.75) +
  geom_hline(yintercept = 1, linetype = "solid") +
  labs(x = "Time (Days)", y = "Entomological Inoculation Rate", 
       color = "LARV Coverages \n for 80% ITN", linetype = "LARV Coverages \n for 80% ITN") +
  scale_color_manual(
    values = c("0%" = "pink", "20%" = "blue", "40%" = "red", "60%" = "green", "80%" = "purple", "100%" = "black")
  ) +
  scale_linetype_manual(
    values = c("0%" = "F2","20%" = "F1", "40%" = "F4448444", "60%" = "42", "80%" = "13", "100%" = "1343")
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 90, size = 12),  # Adjust the size for better visibility
    axis.text.y = element_text(size = 12),  # Adjust the size for better visibility
    axis.title.x = element_text(size = 20),  # Adjust the size for better visibility
    axis.title.y = element_text(size = 20),
    legend.position = "right",
    legend.title = element_text( size = 20),
    legend.text = element_text(size = 20)
  )

ggsave("ITN80_plot.png", plot = larv60_plot, width = 10, height = 6, units = "in", dpi = 300)



