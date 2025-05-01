# ---------- Dockerfile -----------------
# Base image with R + Ubuntu
FROM rocker/r-ubuntu                   

# Install pandoc for RMarkdown rendering
RUN apt-get update && apt-get install -y pandoc

# Set working directory inside container
WORKDIR /project                        

# Create folders that match host layout
RUN mkdir Code Data Output report

# Copy project files into image
COPY Code Code
COPY Data Data
COPY final_report.Rmd .
COPY Makefile .
COPY .Rprofile .
COPY renv.lock .
COPY renv/activate.R renv/settings.dcf renv/

# Restore package environment
RUN Rscript -e "renv::restore(prompt = FALSE)"

# ---------- ENTRY POINT ----------
# 1) knit report via Makefile
# 2) move html into /project/report so it ends up in mounted volume
CMD make && mv final_report.html report/
