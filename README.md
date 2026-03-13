---

## Repository Contents

The repository includes scripts required to:

- Process field data used for model parameterization
- Estimate mosquito mortality associated with larviciding
- Calibrate the mathematical model
- Run intervention simulations
- Generate figures used in the manuscript

---

## Requirements

The code was developed in **R**.

Required R packages include:

- `deSolve`
- `rstan`
- `ggplot2`
- `dplyr`
- `sf`
- `cowplot`
- `boot`

Install packages using:

```r
install.packages(c("deSolve","ggplot2","dplyr","sf","cowplot","boot"))
