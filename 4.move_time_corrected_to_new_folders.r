# Load required packages
library(tools)
library(stringr)

# Function to organize raster files
organize_rasters <- function(src_root) {
  # Define the path for the updated folders
  updated_root <- file.path(src_root, "UPDATED_FOLDERS")
  
  # Create the updated root directory if it does not exist
  if (!dir.exists(updated_root)) {
    dir.create(updated_root)
  }
  
  # Get list of all files in the source root directory and its subdirectories
  files <- list.files(src_root, pattern = "*.tif$", recursive = TRUE, full.names = TRUE)
  
  for (file in files) {
    # Extract the relevant part of the file name
    file_name <- basename(file)
    # Extract month and year from the file name
    date_part <- str_extract(file_name, "[A-Za-z]+-\\d{2}")

    # Create the new folder path based on the date part
    new_folder <- file.path(updated_root, date_part)
    
    # Create the new folder if it does not exist
    if (!dir.exists(new_folder)) {
      dir.create(new_folder)
    }
    
    # Define the destination file path
    dest_file <- file.path(new_folder, file_name)
    
    # Copy the file to the new destination
    file.copy(file, dest_file, overwrite = TRUE)
  }
  
  print("Files have been organized successfully.")
}

# Set the source root directory
#example GOES16_TEMP folder
src_root <- "I:\GOES_LOCATION\GOES16_TEMP"

# Call the function to organize raster files
organize_rasters(src_root)
