# ----------------------------------------------------------
# Makefile for Final Project: Sleep Efficiency
# Author: Yilin Zhang
# ----------------------------------------------------------

# Declare phony targets (not associated with real files)
.PHONY: all install report clean

# Default target: build the final HTML report
all: report

# Render the R Markdown report
report:
	Rscript -e "rmarkdown::render('final_report.Rmd', output_format = 'html_document')"

# Restore the project environment using renv (required rule: "install")
install:
	Rscript -e "renv::restore()"

# Clean: remove the generated HTML report
clean:
	rm -f final_report.html

