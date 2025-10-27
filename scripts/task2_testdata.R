source("scripts/functions.R") 

library(tidyverse)
# Test the function
set.seed(123)
test_data <- generate_shell_clusters(n_shells = 4, k_per_shell = 100, max_radius = 10, noise_sd = 0.1)

write_csv(test_data, "derived_data/task2_test.csv")