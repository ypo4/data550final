# ---------- Dockerfile -----------------
# Base image with R + Ubuntu
FROM rocker/r-ubuntu                   

# Install pandoc for RMarkdown rendering
RUN apt-get update && apt-get install -y \
    pandoc \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev

# Set working directory inside container
WORKDIR /project                        

# Create folders that match host layout
RUN mkdir Code Data Output report

# Copy project files into image
COPY Makefile .
COPY .Rprofile .
COPY renv.lock .
COPY renv/activate.R renv/
COPY renv/settings.json renv/



# Restore package environment
RUN Rscript -e "renv::restore(prompt = FALSE)"

COPY Code Code
COPY Data Data
COPY final_report.Rmd .
# ---------- ENTRY POINT ----------
# 1) knit report via Makefile
# 2) move html into /project/report so it ends up in mounted volume
CMD make && mv final_report.html report/
