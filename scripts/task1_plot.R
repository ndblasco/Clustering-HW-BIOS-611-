library(tidyverse)
results_df <- read_csv("derived_data/task1_results.csv")

p <- ggplot(results_df, aes(x = side_length, y = estimated_clusters, color = factor(dimension))) +
  geom_line() +
  geom_point() +
  geom_hline(aes(yintercept = dimension, color = factor(dimension)), linetype = "dashed") +
  scale_x_reverse() +
  labs(title = "Estimated Number of Clusters vs Side Length",
       x = "Side Length (Distance Between Cluster Centers)",
       y = "Estimated Number of Clusters",
       color = "Dimension (True Number of Clusters)") +
  theme_minimal()

ggsave("figures/task1_plot.png", plot = p, width = 7, height = 5)