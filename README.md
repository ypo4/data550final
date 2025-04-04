# data550final

## Project Overview 
This project explores various factors that may affect sleep efficiency (e.g., deep sleep percentage, awakenings, caffeine intake, alcohol consumption, exercise frequency, etc.). We use regression models and data visualizations to investigate how these variables relate to sleep efficiency.

## File Structure 
- **data/**  
  - `Sleep_Efficiency.csv`: The raw dataset (or a subset/fake data if privacy is a concern).
- **fp.Rmd**  
  - The main R Markdown report, containing data reading, cleaning, analysis, and plotting code.
- **Makefile**  
  - Automates the build process for the report (HTML). Run `make` in your terminal to build `fp.html`.
- **README.md**  
  - Project documentation and instructions.

## How to Generate the Final Report 
   git clone https://github.com/ypo4/data550final.git
   cd data550final
   install.packages(c("tidyverse", "ggplot2", "glmnet", 
                  "foreign", "corrplot", "ggcorrplot", "knitr"))
  make report
## Illustration
In the “# Table 1: Descriptive Statistics” section of fp.Rmd, kable(desc_stats) is used to generate a table summarizing the descriptive statistics of some key variables in the data (such as average age, average sleep duration, etc.).

In the code block in the “## Caffeine Consumption vs. Sleep Efficiency” section, ggplot is used to draw a scatter plot of caffeine consumption and sleep efficiency, and color it by gender. You can also see other visualizations in “## Correlation between factors related to sleep efficiency” or “## Alcohol Consumption vs. Bedtime”.


