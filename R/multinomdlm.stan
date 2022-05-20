// file in R/multinomdlm.stan
data {
    int<lower=0> N;                    // Num. of polls/eleccions
    int<lower=2> C;                    // Num. candidates
    int<lower=1> H;                    // Num. house/pollster
    int<lower=1> T;                    // Num. weeks
    array[N] int<lower=1, upper=T> t;  // Week for the ith poll/election
    array[N] int<lower=1, upper=H> h;  // House/pollster of ith poll/election
    array[N] vector<lower=0>[C+1] V;   // Poll/eleccion results, V[C+1] is Other
}

// TODO: check R/model.stan as template