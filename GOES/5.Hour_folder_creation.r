#set the main directory to your updated_folders folder with all the different days of GOES files
main_directory <- "I:\\GOES16\\TEMP\\UPDATED_FOLDERS"
subfolders <- list.dirs(main_directory, full.names = TRUE, recursive = FALSE)

for (subfolder in subfolders) {
  files <- list.files(subfolder, full.names = TRUE)
  
  for (file in files) {
    if (file.info(file)$isdir == FALSE) {
      filename <- basename(file)
      parts <- strsplit(filename, "-")[[1]]
      hour <- substr(parts[3], 1, 2)
      
      target_directory <- file.path(subfolder, paste0("hour", hour))
      
      if (!dir.exists(target_directory)) {
        dir.create(target_directory)
      }
      
      file.rename(file, file.path(target_directory, filename))
    }
  }
}
