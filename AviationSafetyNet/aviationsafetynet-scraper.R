##----------------------------------------------------------------------------------------------------##
##                     SCRAPER FOR THE AVIATION SAFETY NETWORK ACCIDENT DATABASE                      ##
##----------------------------------------------------------------------------------------------------##


## R version 3.4.3 (2017-11-30)

## Author: Lisa Hehnke (dataplanes.org | @DataPlanes)

## Data source: https://aviation-safety.net/database/


#-------#
# Setup #
#-------#

# Install and load packages using pacman
if (!require("pacman")) install.packages("pacman")
library(pacman)

p_load(data.table, magrittr, rvest, stringi, tidyverse)


#--------------------------#
# Create URLs for scraping #
#--------------------------#

# Create base URL for each year
year <- seq(from = 1919, to = 2019, 1) # data available from 1919 onwards
base_url <- paste0("https://aviation-safety.net/database/dblist.php?Year=", year)

# Get page numbers for each year
get_pagenumber <- function(url) {
  url %>%
    html_session() %>%
    html_nodes("div.pagenumbers") %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    unlist() %>%
    stri_sub(-1) %>% # extract page numbers from urls
    as.numeric() %>%
    sort() %>%
    tail(1) %>% # get highest page number
    ifelse(purrr::is_empty(.), 1, .) # replace empty values with 1
}

pagenumbers <- unlist(lapply(base_url, get_pagenumber))

# Create full URLs for each year
accidents_year <- data.frame(year, pagenumbers)

accidents_year %<>% 
  uncount(pagenumbers) %>%
  group_by(year) %>%
  mutate(pagenumbers = 1:n())

urls <- paste0("https://aviation-safety.net/database/dblist.php?Year=", accidents_year$year, "&lang=&page=", accidents_year$pagenumbers)


#-----------------#
# Scrape database #
#-----------------#

# Scrape accident data
get_table <- function(url) {
  url %>%
    read_html() %>%
    html_table(header = TRUE, fill = TRUE) 
} 

aviationsafetynet_accident_data <- lapply(urls, get_table)

# Convert list to data frame
aviationsafetynet_accident_data <- do.call(rbind, lapply(aviationsafetynet_accident_data, data.frame))

# Remove empty variables (Var.7, pic) and rename variables (fat., cat)
aviationsafetynet_accident_data %<>%
  select(date, type, registration, operator, fat., location, cat ) %>%
  rename(fatalities = fat., category = cat)

# Export data
saveRDS(aviationsafetynet_accident_data, "aviationsafetynet_accident_data.rds")