# Load necessary libraries
library(deSolve)
library(ggplot2)
library(dplyr)

# Define the modified ODE model with new equations
model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    # Compartmental equations based on your new model
    dEL <-  betaCom * NV - muEL * (1 + ((EL + LL) / (K ))) * EL - EL / durEL
    dLL <- EL / durEL - muLL * (1 + gamma * ((EL + LL) / (K ))) * LL - LL / durLL
    dPL <- (LL + LL_LAR + LL_BIO + LL_LAR_BIO) / durLL - muPL * PL - PL / durPL
    dSV <- 0.5 * PL / durPL - lambdaV * SV - muVCom * SV
    dEV <- lambdaV * SV - lambdaV * SVLag * exp(-muVCom * durEV) - muVCom * EV
    dIV <- lambdaV * SVLag * exp(-muVCom * durEV) - muVCom * IV
    dSH <- -(NV / NH) * a_theta * (IV / NV) * bh * SH + recRate * IH
    dIH <- (NV / NH) * a_theta * (IV / NV) * bh * SH - recRate * IH
    
    return(list(c(dEL, dLL, dPL, dSV, dEV, dIV, dSH, dIH)))
  })
}

# Parameters (update these according to your new model)
parameters <- c(
  durEL = 6.640000e+00,muEL = 3.400000e-02,muLL = 3.500000e-02,
  durLL = 6.640000e+00, muPL = 2.500000e-01, durPL = 6.640000e-01, bh = 5.000000e-01,
  LL_LAR=0.7,LL_BIO=0.6,LL_LAR_BIO=0.9,durEV = 1.000000e+01,gamma = 1.325000e+01,
  lambdaV = 1.337987e-02, muVCom = 0.315, SVLag=0.5,
  a_theta = 0.3,  recRate = 0.15,
  NV = 72161.13, NH = 2000, K = 100, betaCom = 2.119000e+01 
)

initial_state <- c(
  EL = 0, LL = 0, PL = 0, SV = 0.99, EV = 0, IV = 0,
  SH = 0.99, IH = 0
)

# Time sequence
time_seq <- seq(0, 100, by = 1)

# Function to run the model simulation
run_simulation <- function(params) {
  out <- ode(y = initial_state, times = time_seq, func = model, parms = params)
  return(out)
}

# Initialize results data frame for sensitivity analysis
sensitivity_results <- data.frame()

# Define ranges for parameters
param_ranges <- list(   
  betaCom = seq(15, 25, length.out = 5),         
  muEL = seq(0.02, 0.05, length.out = 5),        
  durEL = seq(5, 8, length.out = 5),             
  muLL = seq(0.03, 0.05, length.out = 5),        
  durLL = seq(5, 8, length.out = 5),             
  muPL = seq(0.2, 0.3, length.out = 5),          
  durPL = seq(0.5, 3.0, length.out = 5),         
  lambdaV = seq(0.008, 0.03, length.out = 5),     
  muVCom = seq(0.1, 0.5, length.out = 5),       
  durEV = seq(8, 12, length.out = 5),            
  a_theta = seq(0.05, 0.5, length.out = 5),    # No change
  bh = seq(0.4, 0.6, length.out = 5),             
  recRate = seq(0.05, 0.2, length.out = 5)         
)

# Run sensitivity analysis for each parameter
for (param_name in names(param_ranges)) {
  for (param_value in param_ranges[[param_name]]) {
    params <- parameters
    params[param_name] <- param_value
    out <- run_simulation(params)
    final_infected_H <- out[nrow(out), "IH"]  # Assuming you're interested in IH
    sensitivity_results <- rbind(sensitivity_results, data.frame(Parameter = param_name, Value = param_value, FinalInfected_H = final_infected_H))
  }
}

# Calculate sensitivity indices using correlation
sensitivity_indices <- sensitivity_results %>%
  group_by(Parameter) %>%
  summarize(SensitivityIndex = cor(Value, FinalInfected_H))

# Visualize sensitivity indices
ggplot(sensitivity_indices, aes(x = Parameter, y = SensitivityIndex)) +
  geom_bar(stat = "identity", fill = "black") +
  coord_flip() +
  labs(title = "",
       x = "Parameters", y = "Sensitivity Index") +
  theme_minimal()+
  theme(
    axis.title = element_text(face = "bold", size = 20),
    axis.text = element_text(face = "bold", size = 16),
    legend.title = element_text(face = "bold", size = 16),
    legend.text = element_text(size = 14)
  )
