##----------------------------------------------------------------------------------------------------##
##                          SCRAPER FOR THE PLANECRASHINFO ACCIDENT DATABASE                          ##
##----------------------------------------------------------------------------------------------------##


## R version 3.4.3 (2017-11-30)

## Author: Lisa Hehnke (dataplanes.org | @DataPlanes)
## Credit for parts of the script goes to Sarah Wagner (https://www.inwt-statistics.com/read-blog/plane-crash-data-part-1-web-scraping-469.html).

## Data source: http://www.planecrashinfo.com/database.htm


#-------#
# Setup #
#-------#

# Install and load packages using pacman
if (!require("pacman")) install.packages("pacman")
library(pacman)

p_load(magrittr, rvest, tidyverse)


#--------------------------#
# Create URLs for scraping #
#--------------------------#

# Create base URL for each year
year <- seq(from = 1920, to = 2019, 1) # data available from 1920 onwards
base_url <- paste0("http://www.planecrashinfo.com/", year, "/", year, ".htm") 

# Get number of reported accidents per year
get_number_accidents <- function(url) {
  url %>%
    read_html() %>%
    html_table(header = TRUE, fill = TRUE) %>%
    .[[1]] %>% 
    nrow
  } 

number_accidents <- unlist(lapply(base_url, get_number_accidents))

# Create full URL for each accident report
accidents_year <- data.frame(year, number_accidents)

accidents_year %<>% 
  uncount(number_accidents) %>%
  group_by(year) %>%
  mutate(number = 1:n())

urls <- paste0("http://www.planecrashinfo.com/", accidents_year$year, "/", accidents_year$year, "-", accidents_year$number, ".htm") 


#-----------------#
# Scrape database #
#-----------------#

# Scrape accident reports
## Approach adapted from https://www.inwt-statistics.com/read-blog/plane-crash-data-part-1-web-scraping-469.html.
get_table <- function(url) {
  url %>%
    read_html() %>%
    html_table(header = TRUE, fill = TRUE) %>%
    data.frame %>%
    setNames(c("vars", "vals")) %>%
    spread(vars, vals) %>% 
    .[-1]
} 

planecrashinfo_accident_data <- lapply(urls, get_table)

# Convert list to data frame
planecrashinfo_accident_data %<>% 
  bind_rows %>% 
  setNames(gsub(":", "", colnames(.)) %>% tolower)

# Export data
saveRDS(planecrashinfo_accident_data, "planecrashinfo_accident_data.rds")