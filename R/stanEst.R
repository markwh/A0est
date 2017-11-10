
#' Estimate A0 
#' 
#' Fits model for A0 of one of several variants using Hamiltonian Monte Carlo.
#' 
#' @param A0data A list of data required, including known parameters
#' @param variant Which A0 variant to use: withLatent, noLatent, flatA0, flatBoth 
#' @param cores Number of processing cores for running chains in parallel. 
#'   See \code{?rstan::sampling}. Defaults to \code{parallel::detectCores}.
#' @param chains A positive integer specifying the number of Markov chains. 
#'   The default is 3.
#' @param iter Number of iterations per chain (including warmup). Defaults to 2000.
#' @param method Either "sampling" (default) which runs the MC sampler, or "optimizing" 
#'   which optimizes to find the maximum a posteriori estimate.
#' @param ... Other arguments passed to rstan::sampling() for customizing the 
#'   Monte Carlo sampler
#' @useDynLib A0est, .registration = TRUE 
#' @import rstan
#' @import Rcpp
#' @import methods
#' @export

A0_estimate <- function(A0data, 
                        variant = c("withLatent", "noLatent", "flatA0", "flatBoth"), 
                        cores = getOption("mc.cores", default = parallel::detectCores()),
                        chains = 3L,
                        iter = 2000L,
                        method = c("sampling", "optimizing"),
                        ...) {
  variant <- match.arg(variant)
  method <- match.arg(method)
  
  A0inputs <- A0data
  
  stanfit <- stanmodels[[paste0("A0_", variant)]]
  
  if (method == "sampling") {
    out <- sampling(stanfit, data = A0inputs, 
                    cores = cores, chains = chains, iter = iter,  
                    pars = c("A0", "sigma_logA"),
                    ...)
  } else {
    out <- optimizing(stanfit, data = A0inputs, 
                      ...)
  }

  
  out
}

