library(rmarkdown)
# Render the R Markdown file to HTML
rmarkdown::render(
  input = "Clustering_HW.Rmd",
  output_file = "report.html",
  output_format = "html_document",
  quiet = TRUE
)