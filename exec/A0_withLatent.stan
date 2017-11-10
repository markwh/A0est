
data {

  // Dimensions
  int<lower=0> nt; // number of observation times
  vector[nt] dA;
  real logA0_hat;
  real logA0_sd;
  real<lower=0> sigmalogA_hat;
  real<lower=0> sigmalogA_sd;
  real<lower=0> sigmalogA0;
}

transformed data {
  real<lower = 0> minA0;
  
  minA0 = 1 - min(dA);
}

parameters {
  
  real<lower = minA0> A0;
  real<lower=0> sigma_logA;
  real logA_mean;
}


transformed parameters {
  vector[nt] logA;
  real logA0;
  
  logA = log(A0 + dA);
  logA0 = log(A0);
}



model {
  
  logA0 ~ normal(logA0_hat, logA0_sd);
  sigma_logA ~ normal(sigmalogA_hat, sigmalogA_sd);
  logA ~ normal(logA_mean, sigma_logA);
  logA_mean ~ normal(log(A0), sigmalogA0);
  
  target += -logA;
  target += -logA0;

}
