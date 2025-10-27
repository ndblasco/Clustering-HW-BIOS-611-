source("scripts/functions.R") 
library(tidyverse)
library(cluster)

dimensions <- 6:2
side_lengths <- 10:1
k_per_cluster <- 100
noise_sd <- 1.0

results <- list()

set.seed(123)

for (n in dimensions) {
  for (L in side_lengths) {
    cat("Running: dimension =", n, ", side_length =", L, "\n")
    
    df <- generate_hypercube_clusters(n, k_per_cluster, L, noise_sd)
    imputed <- df %>% select(-cluster)
    
    # Estimate optimal number of clusters
    r <- clusGap(imputed %>% as.matrix(), kmeans, K.max = 8, B=50, nstart=20, iter.max=50)
    optimal_k <- maxSE(r$Tab[, "gap"], r$Tab[, "SE.sim"], method = "Tibs2001SEmax")
    
    results[[length(results) + 1]] <- tibble(
      dimension = n,
      side_length = L,
      estimated_clusters = optimal_k
    )
  }
}

results_df <- bind_rows(results)
write_csv(results_df, "derived_data/task1_results.csv")