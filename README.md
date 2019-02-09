# aviation-accidents-data

This repo contains scraping functions for (1) aviation accident data from the Aviation Safety Network database and (2) aviation accident data from the Plane Crash Info database.

## Aviation Safety Net

Script for automated scraping of the aviation accident data provided in the Aviation Safety Network database (https://aviation-safety.net/database/).

The scraped dataset covers the years 1919-2019 and contains the following variables (see https://aviation-safety.net/database/legend.php for more information):
* **date**: date of occurrence (local time)
* **type**: manufacturer and model of the aircraft
* **registration**: registration mark of the aircaft 	
* **operator**: company, organisation or individual operating the aircraft 	
* **fatalities**: number of fatalities  	
* **location**: location of the accident
* **category**: accident category


## Plane Crash Info

Script for automated scraping of the aviation accident data provided in the Plane Crash Info database (http://www.planecrashinfo.com/database.htm).

The scraped dataset covers the years 1920-2019 and contains the following variables:
* **ac\n type**: aircraft type
* **cn / ln**: construction or serial number / line or fuselage number
* **date**: date of the accident	
* **fatalities**: total number of fatalities aboard (passengers / crew)
* **flight #**: flight number assigned by the aircraft operator  	
* **ground**: total number of fatalities on the ground
* **location**: location of the accident
* **operator**: airline or operator of the aircraft
* **registration**: ICAO registration of the aircraft
* **route**: complete or partial route flown prior to the accident
* **summary**: brief description of the accident and, if known, the cause
* **time**: local time
