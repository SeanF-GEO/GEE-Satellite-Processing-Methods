# Load required libraries
library(dplyr)

# Define the root directory containing the subdirectories with CSV files and metadata
root_dir <- "I:\\NetCDFS\VIIRSJPSS1ActiveFires6-MinL2Swath375mV002\\NETCDF_OUTPUTS"

# List all subdirectories in the root directory
subdirs <- list.dirs(root_dir, full.names = TRUE, recursive = FALSE)

# Function to extract metadata from the metadata.txt file
extract_metadata <- function(metadata_file) {
  metadata_lines <- readLines(metadata_file)
  range_beginning_time <- sub(".*RangeBeginningTime: (.*)", "\\1", grep("RangeBeginningTime", metadata_lines, value = TRUE))
  range_ending_time <- sub(".*RangeEndingTime: (.*)", "\\1", grep("RangeEndingTime", metadata_lines, value = TRUE))
  satellite_instrument <- sub(".*SatelliteInstrument: (.*)", "\\1", grep("SatelliteInstrument", metadata_lines, value = TRUE))
  range_beginning_date <- sub(".*RangeBeginningDate: (.*)", "\\1", grep("RangeBeginningDate", metadata_lines, value = TRUE))
  
  return(list(
    RangeBeginningTime = range_beginning_time,
    RangeEndingTime = range_ending_time,
    SatelliteInstrument = satellite_instrument,
    RangeBeginningDate = range_beginning_date
  ))
}

# Process each subdirectory
for (subdir in subdirs) {
  # Path to the metadata file
  metadata_file <- file.path(subdir, "metadata.txt")
  
  # Ensure the metadata file exists
  if (file.exists(metadata_file)) {
    # Extract metadata
    metadata <- extract_metadata(metadata_file)
    
    # List all CSV files in the current subdirectory
    csv_files <- list.files(subdir, pattern = "\\.csv$", full.names = TRUE)
    
    # Process each CSV file in the subdirectory
    for (csv_file in csv_files) {
      # Read the CSV file
      data <- read.csv(csv_file)
      
      # Add metadata as new columns
      data <- data %>%
        mutate(
          RangeBeginningTime = metadata$RangeBeginningTime,
          RangeEndingTime = metadata$RangeEndingTime,
          SatelliteInstrument = metadata$SatelliteInstrument,
          RangeBeginningDate = metadata$RangeBeginningDate
        )
      
      # Save the modified CSV file
      write.csv(data, csv_file, row.names = FALSE)
    }
  } else {
    cat("Metadata file not found in", subdir, "\n")
  }
}
