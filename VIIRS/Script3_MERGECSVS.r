# Load required libraries
library(dplyr)

# Define the root directory containing the subdirectories with CSV files
root_dir <- "I:\\NetCDFS\VIIRSJPSS1ActiveFires6-MinL2Swath375mV002\\NETCDF_OUTPUTS"

# List all subdirectories in the root directory
subdirs <- list.dirs(root_dir, full.names = TRUE, recursive = FALSE)

# Initialize an empty list to hold the data frames
all_data <- list()

# Process each subdirectory
for (subdir in subdirs) {
  # List all FP_power.csv files in the current subdirectory
  csv_files <- list.files(subdir, pattern = "FP_power\\.csv$", full.names = TRUE)
  
  # Read each CSV file and append it to the list
  for (csv_file in csv_files) {
    data <- read.csv(csv_file)
    all_data <- append(all_data, list(data))
  }
}

# Combine all data frames into one
merged_data <- bind_rows(all_data)

# Define the output path for the merged CSV file
output_file <- file.path(root_dir, "merged_FP_power.csv")

# Save the merged data frame to a CSV file
write.csv(merged_data, output_file, row.names = FALSE)

cat("Merged CSV file has been saved to:", output_file, "\n")
