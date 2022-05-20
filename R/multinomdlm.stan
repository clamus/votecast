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

// Parametrizing sd of variables via SNRs
transformed data {
    real<lower=0> snrP = 3;    // SNR^2 = var(P_t) / var(W_i) in equilibrium
    real<lower=0> snrPB = 2;   // SNR^2 = var(P_t) / var(B_h)
    real<lower=0> snrPBS = 3;  // SNR^2 = var(P_t + B_h) / var(S_i)
    vector<lower=0, upper=1>[C] softmaxP_T = rep_vector(1 / (C + 1), C);
    vector[C] muP_T = log(softmaxP_T) - mean(log(softmaxP_T));
    array[T-1] vector[C] zerosW = rep_array(rep_vector(0, C), T-1);
}

parameters {
    array[T] vector[C] P;
    array[T-1] vector[C] W;
    real<lower=0> sigmaW;
    array[H] row_vector[C] B;
    array[N] row_vector[C] S;
}

transformed parameters {
    array[N] vector[C+1] mlogitPi;  // Overparametrized vec of "logits"
    real<lower=0> sigmaP = snrP * sigmaW;
    real<lower=0> sigmaB = snrP / snrPB * sigmaW;
    real<lower=0> sigmaS = snrP / snrPBS * sqrt(1 + 1 / snrPB^2) * sigmaW;
    // Dynamic model for logits of vote preference
    for (i in T-1:1) {
        P[i] = P[i+1] + W[i];
    }
    
    // Adding logits of voter preference, house biases and polling shocks/noise
    // TODO: Allow B and S to be zero when include election data
    for (i in 1:N) {
        mlogitPi[i, 1:C] = P[t[i]] + B[h[i]]' + S[i]';
        mlogitPi[i, C+1] = 0;
    }
}

model {
    // Hyperpriors:
    sigmaW ~ cauchy(0, 2.5);

    // Priors:
    to_vector(to_matrix(S)) ~ normal(0, sigmaS);
    to_vector(to_matrix(B)) ~ normal(0, sigmaB);
    P[T] ~ normal(muP_T, sigmaP);
    W ~ multi_normal_cholesky(zerosW, rep_vector(sigmaW, C));  // Allow correlation later
    // P_t dynamic priors defined via transformed params
    
    // Likelihood
    for (i in 1:N) {
        V[i] ~ multinomial(softmax(mlogitPi[i]));
    }
}

