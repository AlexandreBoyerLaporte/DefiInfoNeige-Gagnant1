API

- File api/index.php needs to install the Flight micro_framework, found at http://flightphp.com


RESOURCES

- Need to add GEOBASE.json and cote.json files, which are supplied by the city of montreal
- Need to add outputted_conversiont.txt, which is outputted by conversion tool http://leware.net/geo/utmgoogle.htm 
- Need to add .pem files in order to connect to apple push server (tutorial here: http://www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1)


JOBS

- Jobs are structured based on Azure WebJobs.  They could be easily adapted to standard cron jobs
- There are 6 types of jobs
    1. TransferJob: Transfer data from JSON files to SQL database
    2. ConvertJob: Write the converted geo points (from http://leware.net/geo/utmgoogle.htm) to database
    3. RoadCenterJob: Calculate centers of roads to make searching by location easier
    4. CityAPIPullJob: Connects to city api to retrieve updates to roadside status (should be ran regularly)
    5. PushFeederJob: Calculates push notifications that need to be sent out, and adds to the push queue (should be ran regularly)
    6. PushJob: Sends push notifications in push queue (should be ran regularly)