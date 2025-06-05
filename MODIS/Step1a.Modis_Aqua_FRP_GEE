// Here is a Earth Engine script to export fire radiative power (FRP) and QA data for MODIS Aqua
// Using The MODIS/061/MYD14A1 Dataset

// Define the region of interest (coordinates in order: [minLng, minLat, maxLng, maxLat])
var region = ee.Geometry.Rectangle([-119.5, 43, -118, 44]);

// Define the date range
// I recommend only doing a month at a time. 
var startDate = ee.Date('2021-08-01');
var endDate = ee.Date('2021-08-31');

// Function to create a list of dates
function getDateList(start, end) {
  var nDays = end.difference(start, 'day').subtract(1); // Calculate the number of days in the range
  return ee.List.sequence(0, nDays).map(function(day) {
    return start.advance(day, 'day').format('YYYY-MM-dd'); // Create a list of dates in 'YYYY-MM-dd' format
  });
}

// Generate list of dates
var dateList = getDateList(startDate, endDate); // Generate a list of dates from startDate to endDate

// Function to export data
function exportData(dataset, descriptionPrefix, date, region, frpBand, qaBand, frpScaleFactor, fireMaskBand) {
  // Reproject the dataset to EPSG:32610 with a scale of 1000 meters
  var reprojectedDataset = dataset.reproject({
    crs: 'EPSG:32610',
    scale: 1000
  });

  // Select, scale, and clip the FRP band
  var frp = reprojectedDataset.select(frpBand).multiply(frpScaleFactor).clip(region);
  // Select and clip the FireMask band
  var fireMask = reprojectedDataset.select(fireMaskBand).clip(region);

  // Create masks for fire confidence levels 7, 8, 9
  // 7: Fire (low confidence, land or water), 8: Fire (nominal confidence, land or water), 9: Fire (high confidence, land or water)
  var fireConfidenceMask = fireMask.eq(7).or(fireMask.eq(8)).or(fireMask.eq(9));

  // Select and clip the QA band
  var qa = reprojectedDataset.select(qaBand).clip(region);

  // Create masks for day and night based on QA band
  var dayMask = qa.bitwiseAnd(0x04).neq(0); // Day is when the 2nd bit is set
  var nightMask = qa.bitwiseAnd(0x04).eq(0); // Night is when the 2nd bit is not set

  // Apply fire confidence masks to FRP for day and night
  var dayFrp = frp.updateMask(dayMask).updateMask(fireConfidenceMask);
  var nightFrp = frp.updateMask(nightMask).updateMask(fireConfidenceMask);
  
  // Mask for day and night based on the fire confidence levels
  var dayQA = fireMask.updateMask(dayMask).updateMask(fireConfidenceMask);
  var nightQA = fireMask.updateMask(nightMask).updateMask(fireConfidenceMask);

  // Create an object to hold the bands to be exported
  var bandsToExport = {
    Day_FRP: dayFrp,
    Night_FRP: nightFrp,
    Day_QA: dayQA,
    Night_QA: nightQA
  };

  // Export each band to Google Drive
  for (var band in bandsToExport) {
    Export.image.toDrive({
      image: bandsToExport[band],
      description: descriptionPrefix + '_' + band + '_' + date.format('YYYYMMdd').getInfo(), 
      folder: 'GEE_FRP_Aqua', // Folder name in Google Drive
      fileNamePrefix: descriptionPrefix + '_' + band + '_' + date.format('YYYYMMdd').getInfo(), 
      scale: 1000, 
      region: region, 
      crs: 'EPSG:32610', // Coordinate reference system
      maxPixels: 1e13 
    });
  }
}

// Loop through each date to process and export Aqua data
dateList.evaluate(function(dates) {
  dates.forEach(function(dateStr) {
    var date = ee.Date(dateStr); // Convert the date string back to an ee.Date object
    
    // Filter MYD14A1 (Aqua) dataset for the current date
    var AquaDataset = ee.ImageCollection('MODIS/061/MYD14A1')
                          .filterDate(date, date.advance(1, 'day')) // Filter images by date
                          .filterBounds(region) // Filter images by region
                          .first(); 

    // Define scale factors
    var frpScaleFactor = 0.1;

    if (AquaDataset) {
      // Process and export Aqua data
      exportData(AquaDataset, 'Aqua', date, region, 'MaxFRP', 'QA', frpScaleFactor, 'FireMask');
    } else {
      print('No Aqua data for date: ' + date.format('YYYY-MM-dd').getInfo()); // Print message if no data is available
    }
  });
});

