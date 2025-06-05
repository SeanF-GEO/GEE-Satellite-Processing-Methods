# Install and load required libraries
library(sf)
library(dplyr)

# Load the CSV file
csv_file <- "I:\\NetCDFS\\VIIRSJPSS1ActiveFires6-MinL2Swath375mV002\\NETCDF_OUTPUTS\\merged_FP_power.csv"
data <- read.csv(csv_file)

# Convert the data frame to an sf object
# Assuming the latitude and longitude columns are named "latitude" and "longitude"
sf_data <- st_as_sf(data, coords = c("longitude", "latitude"), crs = 4326)

# Reproject to UTM Zone 10
utm_data <- st_transform(sf_data, crs = 32610)

# Save the sf object as a shapefile
st_write(utm_data, "I:\\NetCDFS\\VIIRSJPSS1ActiveFires6-MinL2Swath375mV002_shapefile\\JPSS1ActiveFires375mV002.shp")
