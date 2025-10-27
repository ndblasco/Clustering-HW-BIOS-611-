library(tidyverse)
source("scripts/task2_simulation.R")

results_df <- read_csv("derived_data/task2_simulation.csv")

p <- ggplot(results_df, aes(x = max_radius, y = est_clusters)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  geom_hline(yintercept = n_shells, linetype = "dashed", color = "black") +
  labs(title = "Estimated Number of Clusters vs Max Radius",
       x = "Max Radius",
       y = "Estimated Number of Clusters") +
  theme_minimal()

ggsave("figures/task2_plot.png", plot = p, width = 7, height = 5)