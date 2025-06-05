# Instructions for downloading GOES-16 and GOES-17 Temperature and FRP data from Google Earth Engine

## General Notes

- For more information, please see the links below
  - [GOES-16 FDCC Series ABI Level 2 Fire/Hot Spot Characterization CONUS  |  Earth Engine Data Catalog  |  Google for Developers](https://developers.google.com/earth-engine/datasets/catalog/NOAA_GOES_16_FDCC#description)
  - [GOES-17 FDCC Series ABI Level 2 Fire/Hot Spot Characterization CONUS  |  Earth Engine Data Catalog  |  Google for Developers](https://developers.google.com/earth-engine/datasets/catalog/NOAA_GOES_17_FDCC#description)
- For more recent fires post October-2022 use GOES-18 as it has replaced GOES-17
  - [GOES-18 FDCC Series ABI Level 2 Fire/Hot Spot Characterization CONUS  |  Earth Engine Data Catalog  |  Google for Developers](https://developers.google.com/earth-engine/datasets/catalog/NOAA_GOES_18_FDCC#description)
- When downloading GOES-17 some days will have a reduced number of images this is due to a cooling issue on the satellite.
  - [GOES-17 ABI Performance │ GOES-R Series](https://www.goes-r.gov/users/GOES-17-ABI-Performance.html)

## Step 1A. Google Earth Engine GOES-16/17 Temperature raster selection

## Step 1B. Google Earth Engine GOES-16/17 FRP raster selection

- Step 1A and 1B are very similar in the directions. You will use 1A for temperature and 1B for FRP.
- Make sure to change the variable collection from to 16 or 17 depending on the satellite you wish to use.
- You can only download 1 day at a time due to there being 288 GOES images in a single day

## Step 2. Renaming GOES files (R script)

- This R script renames the files to a more understandable format
- It is important to remember to change the file names to either temp or power for either temperature or FRP depending on files you are processing at the time.
- This script should be run on a folder that contains subfolders of every day. For instance, A fold named GOES-16TEMP with sub folders named Aug01 to Oct10
  - EX. I: \\GOES16\\TEMP

## Step 3. Converting time from UTC to PST (R script)

- This script converts the name of all GOES tifs from UTC to PST
- Again, similarly, to step 2 you must change the file names to either temp or power depending on the file type on line 32
- This script should be run on a folder that contains subfolders of every day. For instance, A fold named GOES-16TEMP with sub folders named Aug01 to Oct10
  - EX. I: \\GOES16\\TEMP

## Step 4. Move time corrected files to new folders (R script)

- This script moves the files into new folders based on the month and day of the files
- The new folder will be called UPDATED_FOLDERS
  - EX. I: \\GOES16\\TEMP\\UPDATED_FOLDERS

## Step 5. Create New Folders for each hour within each day (R script)

- This script moves files into hour folders within each day subfolder
- This will be used on the UPDATED_FOLDERS folder Step 4 created.

## Step 6. Mosaic 12 files in each hour folder into a single hour raster (python)

- The output raster will have the highest pixel value for a given cell over than hour period
- You will need ArcPro and python to run this script
- If this is your first-time using python with ArcPro remember you must change the python version, you are using from your default. To the one in your ArcPro program files folder.
  - I recommend reaching out to me or the GIS it help desk for help if you get stuck with this.
- This script will have to be run for each day individually
  - EX. I: \\GOES16\\TEMP\\UPDATED_FOLDERS\\August-08
