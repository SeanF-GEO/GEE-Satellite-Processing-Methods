Instructions for downloading VIIRS Data from Earthdata

General Notes:

you will need to make an account with NASA Earthdata before you can download any of the data

[Earthdata Search | Earthdata Search (nasa.gov)](https://search.earthdata.nasa.gov/search)

Step 1: Downloading the VIIRS data

After going to [Earthdata Search | Earthdata Search (nasa.gov)](https://search.earthdata.nasa.gov/search?fi=VIIRS)

-
    In the upper left corner type “active fire”  

- Under instruments select VIIRS  

- Set your calendar date time window in the upper left  

- To select your study region, you can either enter coordinates in the upper left corner, or you can use the box tool next to the calendar  

- The four datasets you want to select are the following  
    -

        VIIRS/NPP Active Fires 6-Min L2 Swath 375m V002  

  - VIIRS/ JPSS1 Active Fires 6-Min L2 Swath 375m V002  

  - VIIRS/ NPP Thermal Anomalies/Fire 6-Min L2 Swath 750m V002  

  - VIIRS/JPSS1 Thermal Anomalies/Fire 6-Min L2 Swath 750m V002  
        -

            You are looking to download the V002 data because it is the best for looking at past fires. NRT is better for current fires  

- To add a dataset for exporting just click the green plus + next to the name when you hover over it  

- When you are done. Click on my project button in the upper right corner to name your project and prepare the data for download and click download data  

# Step 2: Organization and converting NetCDFS to excel

Once you have downloaded the corresponding NetCDFS for each of the 4 Earthdata VIIRS outputs I recommend saving them into 4 folders named something like the image below.

Next you will use the script “Script1_VIIRS_EARTHDATA_NETCDF_TO_CSV” (R script)

-

For this script you will only need to specify a specific NetCDF folder on line 7  
    -

        Example: your VIIRSJPSS1 Active Fires 6-Min L2 Swath 375m V002 folder  

ADDITIONAL NOTES / ERRORS during this step

-
    On this step in both JPSS and NPP Thermal Anomalies 750m V002 out of the 262 NetCDFS 11 did not process and had an error. To deal with this I would just run the script. And if you hit a NetCDF with an error just move it out of the processing folder and rerun the script.  

- This issue did not happen with the JPSS and NPP Active Fire 375m V002 NETcdfs  

# Step 3: Update NetCDF excels with Satellite Time, Date, and Sensor Name

Once you have produced a sub directory folder for each NetCDF file containing metadata Excel files the next step is to add the satellite name, collection time, and data for each CSV

-
    You will use script “Script2_CSV_Metadata_addon” (R script)  

- You will need to update the file path on line 5 to be your NETCDF_OUTPUTS folder that was created on step 2.  
    -

        "I:\\\\NetCDFS\\VIIRSJPSS1ActiveFires6MinL2Swath375mV002\\\\NETCDF_OUTPUTS"  

# Step 4: Merging CSVs into One single CSV

This step joins together every FRP VIIRS excel into one single FRP CSV for all the days during your study time window. Also important to note the FRP is in MW and can be seen in the metadata files

-
    You will use script Script3_MERGECSVS (R script)  

- You will need to update the file path on line 5 to be your NETCDF_OUTPUTS folder that was created on step 2.  
    -

        "I:\\\\NetCDFS\\VIIRSJPSS1ActiveFires6MinL2Swath375mV002\\\\NETCDF_OUTPUTS"  

- It will save an output CSV named merged_FP_power.csv  
    -

        This CSV will have  

# Step 5: Converting Time and Date in CSV

When you open the CSV in Excel you will need to convert time from general to time and you need to change the data from general to short date

-
    \=TEXT(E2 - TIME(7,0,0), "HHMM")  

- \=TEXT(H2, "MMDDYYYY")  
    -

        Use the above two excel formulas to fix the CSV before converting to a shapefile  

  - The first formula will be used on a new column to convert the time from UTC to PST  

  - And the second formula will convert the date to a shorter date that is easy to sort while working in ArcPro  

# Step 6: Convert CSV to SHP

This script will convert your merged and edited CSV file from Step 5 to a final shapefile. You will need to change your file path on line 6 to your merged shapefile and you will need to select where you want to export your final shapefile on line 17

-
    The script you will run is named Script4_ConvertCSVtoShp (R script)  

<br/>
