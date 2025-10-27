library(tidyverse)
library(cluster)

generate_hypercube_clusters <- function(n, k, side_length, noise_sd = 1.0) {
  # Create an empty list to hold the clusters
  all_points <- list()
  
  for (i in 1:n) {
    # Create a vector with all 0s and set the ith dimension to side_length
    center <- rep(0, n)
    center[i] <- side_length
    
    # Generate k points around this center using Gaussian noise
    cluster_points <- matrix(rnorm(n * k, mean = 0, sd = noise_sd), nrow = k, ncol = n)
    cluster_points <- sweep(cluster_points, 2, center, FUN = "+")
    
    # Create a data frame with cluster label
    cluster_df <- as.data.frame(cluster_points)
    cluster_df$cluster <- as.factor(i)
    
    all_points[[i]] <- cluster_df
  }
  
  # Combine all clusters into one data frame
  final_data <- do.call(rbind, all_points)
  
  return(final_data)
}


generate_shell_clusters <- function(n_shells, k_per_shell, max_radius, noise_sd = 0.1) {
  # Radii evenly spaced from some small radius (e.g., max_radius / (2 * n_shells)) to max_radius
  min_radius <- max_radius / (2 * n_shells)
  radii <- seq(min_radius, max_radius, length.out = n_shells)
  
  data_list <- lapply(seq_along(radii), function(shell_idx) {
    r <- radii[shell_idx]
    # Generate k_per_shell points uniformly on sphere surface with radius r + noise
    # Uniformly sample azimuthal (theta) and polar (phi) angles
    theta <- runif(k_per_shell, 0, 2 * pi)
    phi <- acos(runif(k_per_shell, -1, 1))  # cos(phi) uniform in [-1,1] for uniform sphere points
    
    # Add Gaussian noise to radius
    noisy_r <- r + rnorm(k_per_shell, mean = 0, sd = noise_sd)
    
    x <- noisy_r * sin(phi) * cos(theta)
    y <- noisy_r * sin(phi) * sin(theta)
    z <- noisy_r * cos(phi)
    
    tibble(x = x, y = y, z = z, shell = factor(shell_idx))
  })
  
  bind_rows(data_list)
}

spectral_clustering <- function(x, k, d_threshold = 1) {
  n <- nrow(x)
  
  # Compute adjacency matrix
  dist_mat <- as.matrix(dist(x))
  A <- matrix(0, n, n)
  A[dist_mat < d_threshold] <- 1
  diag(A) <- 0
  
  # Degree and Laplacian
  D <- diag(rowSums(A))
  
  # Handle disconnected graph (all zero degree)
  if (all(diag(D) == 0)) {
    return(rep(1, n))
  }
  D_inv_sqrt <- diag(1 / sqrt(diag(D) + 1e-10))
  L_sym <- diag(n) - D_inv_sqrt %*% A %*% D_inv_sqrt
  
  # Eigen decomposition
  eig <- eigen(L_sym, symmetric = TRUE)
  idx <- order(eig$values)
  eig_vectors <- eig$vectors[, idx[1:k]]

  # normalize
  row_norms <- sqrt(rowSums(eig_vectors^2))
  row_norms[row_norms == 0] <- 1   # avoid division by zero
  eig_vectors <- eig_vectors / row_norms
  
  # K-means
  km <- try(kmeans(eig_vectors, centers = k, nstart = 20), silent = TRUE)
  if (inherits(km, "try-error")) {
    warning("K-means failed; returning single cluster")
    return(list(cluster = rep(1, n)))
  }
  
  list(cluster = km$cluster)
}