import arcpy
import os

#set your workspace to an individual day 
workspace = r'GOES16_TEMP\UPDATED_FOLDERS\August-02' 
arcpy.env.workspace = workspace

# List all subfolders in the workspace
subfolders = [f.path for f in os.scandir(workspace) if f.is_dir()]

for subfolder in subfolders:
    arcpy.env.workspace = subfolder
    tiff_list = arcpy.ListRasters("*.tif")

    if not tiff_list:
        continue  # Skip if no TIFF files are found

    output_path = subfolder
    output_name = f"{os.path.basename(subfolder)}.tif"
    output_raster = os.path.join(output_path, output_name)

    processed_tiff_list = []
    for tiff in tiff_list:
        temp_tiff = os.path.join(output_path, f"temp_{os.path.basename(tiff)}")
        arcpy.management.CopyRaster(
            in_raster=tiff,
            out_rasterdataset=temp_tiff,
            nodata_value="nan",
            pixel_type="32_BIT_FLOAT"
        )
        processed_tiff_list.append(temp_tiff)

    arcpy.management.MosaicToNewRaster(
        input_rasters=processed_tiff_list,
        output_location=output_path,
        raster_dataset_name_with_extension=output_name,
        pixel_type="32_BIT_FLOAT",
        number_of_bands=1,
        mosaic_method="MAXIMUM",
        mosaic_colormap_mode="FIRST"
    )

    print(f"Mosaic for {subfolder} completed successfully. Output raster saved as {output_raster}.")

    for temp_tiff in processed_tiff_list:
        arcpy.management.Delete(temp_tiff)