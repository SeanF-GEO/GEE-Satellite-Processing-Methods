library(raster)

# Set the root folder path
# example GOES16_TEMP folder
root_folder <- "I:\GOES_LOCATION\GOES16_TEMP"

# Get the names of all the subfolders in the root folder
subfolder_names <- list.dirs(root_folder, full.names = TRUE, recursive = FALSE)

# Loop through the subfolders and update the file names in each subfolder
for (i in 1:length(subfolder_names)) {
  subfolder <- subfolder_names[i]
  
  # Get the names of all the files in the subfolder
  file_names <- list.files(subfolder, pattern = "*.tif$", full.names = TRUE)
  
  # Create a list to store the new file names
  new_file_names <- list()
  
  # Loop through the file names and update the time part of each name
  for (j in 1:length(file_names)) {
    file_name <- basename(file_names[j])
    
    # Convert the file name
    date_time <- strptime(substr(file_name, 1, 20), format = "%B-%d-%H-%M")
    
    # Subtract 7 hours from the time (depending on day light saving your might have to convert to 8)
    date_time <- date_time - 7 * 60 * 60
    
    # Convert the updated time back to a character string in the desired format
    # make sure to change temp to power depending on FRP or Temp files
    new_file_name <- strftime(date_time, format = "%B-%d-%H-%M_temp_band.tif")
    
    # Store the new file name in the list
    new_file_names[[j]] <- new_file_name
    
    # Rename the file
    file.rename(file.path(subfolder, file_name), file.path(subfolder, new_file_name))
  }
  
  # Use the new file names to create a list of the updated raster objects
  raster_list <- lapply(new_file_names, function(x) raster(file.path(subfolder, x)))
}
