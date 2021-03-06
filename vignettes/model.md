---
title: "Forecasting Colombia's Presidential Elections: A Multinomial Hierarchical Dynamic Linear Model"
output:
  html_document:
    keep_md: true
    code_folding: hide
---

TODO: explain model

### Observation model

$$\large V_i | N_i, \Pi_i \sim \text{Multinomial}(N_i, \Pi_i)$$

### Components of polled voters' preferences

$$\large \text{softmax}^{-1}(\Pi_i) = \underbrace{P_{t_i}}_{\text{Real Pref.}} + \underbrace{B_{h_i}}_{\text{House Effect}} + \underbrace{S_i}_{\text{Shocks/Error}}$$

### Reverse dynamics for voter's real preferences

$$\large \underbrace{P_t}_{\text{Pref. This Week}} = \underbrace{P_{t+1}}_{\text{Pref. Next Week}} + \underbrace{W_t}_{\text{Shocks/Innovations}}$$

### Prior for components

$$ \large
\begin{align}
& W_t \sim N(0,\Sigma_W) \\
& P_T \sim N(\mu_P, \sigma_P^2 I) \\
& B_{h} \sim N(0, \sigma_B^2 I) \\
& S_{i} \sim N(0, \sigma_S^2 I) \\
\end{align}
$$

### Hyperpriors

$$ \large
\begin{align}
& \Sigma_W =\text{diag}(\sigma_W)\cdot\Omega\cdot\text{diag}(\sigma_W)\\
& \sigma_W \sim \text{Cauchy}(0, 2.5) \\
& \Omega \sim \text{LKJCorr}(2) \\
& \sigma_P \sim \sigma_B \sim \sigma_S \sim \sigma_W
\end{align}
$$

### The complete model:
$$
\begin{align}
& V_i | N_i, \Pi_i \sim \text{Multinomial}(N_i, \Pi_i) \\
& \text{softmax}^{-1}(\Pi_i) = P_{t_i} + B_{h_i} + S_i \\
& P_t = P_{t+1} + W_t \\
& W_t \sim N(0,\Sigma_W) \\
& P_T \sim N(\mu_P, \sigma_P^2 I) \\
& B_{h} \sim N(0, \sigma_B^2 I) \\
& S_{i} \sim N(0, \sigma_S^2 I) \\
\end{align}
$$
