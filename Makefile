# ----------------------------------------------------------
# Makefile for Final Project: Sleep Efficiency

# This Makefile compiles fp.Rmd into an HTML report.

#
# INTERNAL STRUCTURE:
# 1) data/ - stores the dataset (e.g. Sleep_Efficiency.csv)
# 2) fp.Rmd - main R Markdown report
# 3) Makefile - the file that automates the build process

#
# Usage:
# In terminal or Git Bash, navigate to the project folder and run:
#   make          (builds the default target, here it's 'report')
#   make clean    (removes generated output files, like fp.html)
# 
# ----------------------------------------------------------

# Declare phony targets 
# This ensures these targets are always executed when called
.PHONY: all report clean

# Define the default target
# When you type 'make' without arguments, it will run 'all',
# which depends on 'report'.
all: report

# ----------------------------------------------------------
# report: compile fp.Rmd into HTML
report:
	Rscript -e "rmarkdown::render('fp.Rmd', output_format='html_document')"

# ----------------------------------------------------------
# clean: remove generated/temporary files
clean:
	rm -f fp.html

