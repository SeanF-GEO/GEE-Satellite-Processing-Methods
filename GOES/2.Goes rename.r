# Load the stringr library
library(stringr)

# Set the path to the main directory containing the sub folders
# this folder should have sub folders of TEMP or FRP individual days GOES files
main_dir_path <- "I:\GOES_STUDYLOCATION\GOES16_TEMP"

# Function to process TIF files in a given directory
process_tif_files <- function(dir_path) {
  # Get a list of all TIF files in the directory and store it in 'tif_files'
  tif_files <- list.files(dir_path, pattern = ".tif$", full.names = TRUE)
  
  # Check if there are any TIF files in the directory
  if (length(tif_files) == 0) {
    return() # No files to process
  }
  
  # Start looping through each TIF file
  for (tif_file in tif_files) {
    
    # Extract the year, day of the year, hour, and minute from the file name
    file_name <- basename(tif_file)
    year <- substr(file_name, 1, 4)
    day_of_year <- substr(file_name, 5, 7)
    hour <- substr(file_name, 8, 9)
    minute <- substr(file_name, 10, 11)
    
    # Convert the day of the year to a date
    date <- as.Date(paste(year, day_of_year, sep = "-"), "%Y-%j")
    
    # Check if the date conversion was successful
    if (is.na(date)) {
      warning(paste("Invalid date in file name:", file_name))
      next
    }
    
    # Get the day of the month and month name
    day_of_month <- format(date, "%d")
    month_name <- format(date, "%B")
    
    # Construct the new file name change temp to power depending on data type
    new_file_name <- paste(month_name, "-", day_of_month, "-", hour, "-", minute, "_temp_band.tif", sep = "")
    
    # Rename the TIF file with the new file name
    new_file_path <- file.path(dir_path, new_file_name)
    if (file.rename(tif_file, new_file_path)) {
      print(paste("Renamed:", file_name, "to", new_file_name))
    } else {
      warning(paste("Failed to rename:", file_name))
    }
  }
}

# Get a list of all subdirectories in the main directory
sub_dirs <- list.dirs(main_dir_path, recursive = TRUE, full.names = TRUE)

# Process each subdirectory
for (sub_dir in sub_dirs) {
  process_tif_files(sub_dir)
}
