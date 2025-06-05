# Load required libraries
library(ncdf4)
library(terra)
library(sf)

# Define the input directory with the NetCDF files
input_dir <- "I:\\VIIRSJPSS1ActiveFires6-MinL2Swath375mV002"

# List all NetCDF files in the input directory
nc_files <- list.files(input_dir, pattern = "\\.nc$", full.names = TRUE)

# Function to save metadata to a text file
save_metadata <- function(nc_file, output_dir) {
  metadata <- capture.output(print(nc_file))
  metadata_path <- file.path(output_dir, "metadata.txt")
  writeLines(metadata, metadata_path)
}

# Iterate over each NetCDF file
for (nc_file_path in nc_files) {
  # Get the base name of the NetCDF file (without extension)
  file_base_name <- tools::file_path_sans_ext(basename(nc_file_path))
  
  # Create output directory for the current file
  output_dir <- file.path(input_dir, "NETCDF_OUTPUTS", file_base_name)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Open the NetCDF file to extract data
  nc_file <- nc_open(nc_file_path)
  
  # Save the metadata to a text file
  save_metadata(nc_file, output_dir)
  
  # Extract latitude and longitude
  lat <- ncvar_get(nc_file, "FP_latitude")
  lon <- ncvar_get(nc_file, "FP_longitude")
  
  # Check dimensions of latitude and longitude
  lat_dims <- dim(lat)
  lon_dims <- dim(lon)
  
  # Ensure latitude and longitude have the same dimensions
  if (!all(lat_dims == lon_dims)) {
    stop("Latitude and longitude dimensions do not match")
  }
  
  # Iterate over all variables in the NetCDF file
  for (var_name in names(nc_file$var)) {
    # Extract the variable
    var_data <- ncvar_get(nc_file, var_name)
    
    # Get dimensions of the variable
    dims <- dim(var_data)
    
    # Check if the variable has dimensions suitable for creating a CSV
    if (length(dims) == 1 && all(dims == lat_dims)) {
      # Combine latitude, longitude, and the one-dimensional variable into a data frame
      data <- data.frame(
        latitude = lat,
        longitude = lon,
        value = var_data
      )
      
      # Save the data frame to a CSV file
      output_path <- file.path(output_dir, paste0(var_name, ".csv"))
      write.csv(data, output_path, row.names = FALSE)
    } else {
      cat("Skipping variable", var_name, "due to unsuitable dimensions\n")
    }
  }
  
  # Close the NetCDF file
  nc_close(nc_file)
}
