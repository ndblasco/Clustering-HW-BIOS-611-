source("scripts/functions.R") 
library(tidyverse)
library(cluster)

set.seed(123)

n_shells <- 4
k_per_shell <- 100
noise_sd <- 0.1
d_threshold <- 1

max_radius_values <- seq(10, 0, by = -1)

estimated_clusters <- numeric(length(max_radius_values))

for (i in seq_along(max_radius_values)) {
  max_radius <- max_radius_values[i]
  
  # Generate data
  data <- generate_shell_clusters(n_shells, k_per_shell, max_radius, noise_sd)
  x_mat <- as.matrix(data %>% select(x, y, z))
  
  # Run clusGap with spectral clustering wrapper
  gap_result <- clusGap(x_mat, FUN = spectral_clustering, K.max = 6, B = 50)
  
  # Extract estimated number of clusters (maximizing gap statistic)
  est_k <- maxSE(gap_result$Tab[, "gap"], gap_result$Tab[, "SE.sim"], method = "Tibs2001SEmax")
  
  estimated_clusters[i] <- est_k
  cat("max_radius =", max_radius, "Estimated clusters =", est_k, "\n")
}

results_df <- tibble(
  max_radius = max_radius_values,
  est_clusters = estimated_clusters
)

write_csv(results_df, "derived_data/task2_simulation.csv")