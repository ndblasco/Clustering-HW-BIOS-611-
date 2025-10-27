library(plotly)
library(tidyverse)

test_data <- read_csv("derived_data/task2_test.csv")

htmlwidgets::saveWidget(
# Interactive 3D scatter plot with plotly
plot_ly(test_data, x = ~x, y = ~y, z = ~z, color = ~shell, colors = RColorBrewer::brewer.pal(4, "Set1"),
        type = 'scatter3d', mode = 'markers') %>%
  layout(scene = list(xaxis = list(title = 'X'),
                      yaxis = list(title = 'Y'),
                      zaxis = list(title = 'Z')),
         title = 'Concentric Shells Dataset'),
file = "figures/task2_testplot.html",
selfcontained = FALSE
)