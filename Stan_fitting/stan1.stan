data{
  int<lower=0> n; // number collections
  int<lower=0> yTotalDaily[n]; // Total caught per day
  real<lower=0> t[n]; // trapping day of 
  // to control priors
  int<lower=0> priorscale; // to control scale of prior
}
parameters{
  real<lower=0> a1;
  real<lower=0> b1;
  real<lower=0> a2;
  real<lower=0> b2;
  real<lower=0> phi_value;
}
transformed parameters{
  // parameters for negative binomial for data
  vector[n] lograte;
  
  for(q in 1:n) {
    lograte[q] =exp( 0.026734 + a1*cos(2*3.14*t[q]/366) + b1*sin(2*3.14*t[q]/366) +
  a2*cos(4*3.14*t[q]/366) + b2*sin(4*3.14*t[q]/366));
  }

}
model{
  // priors
  target += normal_lpdf(a1| 0, priorscale);
  target += normal_lpdf(b1| 0, priorscale);
  target += normal_lpdf(a2| 0, priorscale);
  target += normal_lpdf(b2| 0, priorscale);
  target += 2*cauchy_lpdf(phi_value| 0, priorscale);
  // likelihood  
  target += neg_binomial_2_log_lpmf(yTotalDaily | lograte, phi_value); 
}



// generated quantities{
//   
//   real pred_cases[n];
//   pred_cases = neg_binomial_2_rng(col(to_matrix(lograte),2) , phi_value);
// }