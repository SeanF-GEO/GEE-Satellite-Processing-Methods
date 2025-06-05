# Instructions for downloading MODIS Aqua and Terra FRP data from Google Earth Engine

## General notes

Here are the links to the GEE download page

[MOD14A1.061: Terra Thermal Anomalies & Fire Daily Global 1km  |  Earth Engine Data Catalog  |  Google for Developers](https://developers.google.com/earth-engine/datasets/catalog/MODIS_061_MOD14A1)

[MYD14A1.061: Aqua Thermal Anomalies & Fire Daily Global 1km  |  Earth Engine Data Catalog  |  Google for Developers](https://developers.google.com/earth-engine/datasets/catalog/MODIS_061_MYD14A1)

- The files that are created with this process include
  - Day FRP: Fire Radiative Power during the day.
  - Night FRP: Fire Radiative Power during the night.
  - Day QA: QA data indicating fire confidence during the day.
  - Night QA: QA data indicating fire confidence during the night.
- FRP is in Megawatts
- The Quality Flag has 4 values
  - 0 = no fire
  - 7 = Fire low confidence
  - 8 = Fire nominal confidence
  - 9 = fire high confidence
- The outputs are 1km pixel size

## Step 1a and 1b AQUA & TERRA DOWNLOAD

- Step 1a is for Aqua
- Step 1b is for Terra
- Other than selecting the satellite there is no other differences between the scripts
- On line 5 you will type in the coordinates of the study region you are interested in
- On lines 9&10 you will change the dates you are interested in studying. I recommend starting with a month at a time. 1 month = 120ish files
- Change the name of the folder you will be saying the files to your google drive on line 68
- These outputs do not have time, only a date and whether it was at night or day in UTC time.
  - Future analysis will have to be use in combination with FIRMS MODIS point data.
  - There seems to be hope that more specific times can be extracted from this point data for the GEE MODIS FRP cell data
