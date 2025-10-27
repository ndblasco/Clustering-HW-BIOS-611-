.PHONY: clean

all: report.html

derived_data:
	mkdir -p derived_data
figures:
	mkdir -p figures


clean: 
	rm -rf derived_data/*
	rm -rf figures/*

mkdir -p derived_data
mkdir -p figures

# Task 1
derived_data/task1_results.csv: scripts/task1_simulation.R scripts/functions.R
	Rscript scripts/task1_simulation.R

figures/task1_plot.png: derived_data/task1_results.csv scripts/task1_plot.R
	Rscript scripts/task1_plot.R

# Task 2
derived_data/task2_test.csv: scripts/task2_testdata.R scripts/functions.R
	Rscript scripts/task2_testdata.R

figures/task2_testplot.html: derived_data/task2_test.csv scripts/task2_testplot.R
	Rscript scripts/task2_testplot.R

derived_data/task2_simulation.csv: scripts/task2_simulation.R scripts/functions.R
	Rscript scripts/task2_simulation.R

figures/task2_plot.png: derived_data/task2_simulation.csv scripts/task2_plot.R
	Rscript scripts/task2_plot.R

report.html: Clustering_HW.Rmd figures/task1_plot.png figures/task2_testplot.html figures/task2_plot.png scripts/functions.R scripts/render_report.R
	Rscript --vanilla scripts/render_report.R

