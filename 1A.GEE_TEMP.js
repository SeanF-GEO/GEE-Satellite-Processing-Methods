// Google Earth Engine Script to select GOES16 or GOES17 Temp rasters 


// Define your study region as a rectangle
var studyRegion = ee.Geometry.Rectangle([-119.5, 43, -118, 44]);

// Load the NOAA/GOES/16/FDCC image collection
// Change to 17 if you want to download GOES17
var collection = ee.ImageCollection("NOAA/GOES/16/FDCC")
  // Filter the collection by geographic region
  .filterBounds(studyRegion)
  // Filter the collection by date
  // Filter only one day at a time
  .filterDate("2021-08-08", "2021-08-09");

// Get the number of images in the filtered collection
var n = collection.size().getInfo();

// Loop through the filtered collection
for (var i = 0; i < n; i++) {
  // Get the i-th image in the filtered collection
  var image = ee.Image(collection.toList(n, i).get(0));
  
  // Select and scale the "Temp" band
  var tempBand = image.select("Temp").multiply(0.0549367).add(400);
  
  // Get the image ID
  var imageId = image.id().getInfo();
  
  // Export the scaled Temp band to Google Drive
  Export.image.toDrive({
    image: tempBand,
    description: imageId + "_Temp", 
    fileNamePrefix: imageId + "_Temp", 
    crs: 'EPSG:32610', // Specify the CRS as UTM Zone 10N
    region: studyRegion, // Use the region specified in the studyRegion
    scale: 2000, // Set the scale to 2000 to maintain the original resolution
    maxPixels: 1e12 // Increase max pixels to handle larger images if needed
  });
}