<?php
//
//  This software is intended as a prototype for the Défi Info neige Contest.
//  Copyright (C) 2014 Heritage Software.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License
//
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/
//

$isLiveServer   = false;

// set app keys
$apiLiveKey                 = "example_live_api_key";
$apiDevKey                  = "example_dev_api_key";

// set database connection information
$dbServerName               = "example.database.windows.net";
$dbUserName                 = "example_username";
$dbPassword                 = "example_passord";
$dbNameLive                 = "example_live_database_name";
$dbNameDev                  = "example_dev_database_name";

// set location of data json files
$geoBaseJSONLoc             = dirname(__FILE__) . "/resources/GEOBASE.json";
$coteJSONLoc                = dirname(__FILE__) . "/resources/cote.json";

// set location of outputed conversion text file
$outputtedConversionLoc     = dirname(__FILE__) . "/resources/outputted_conversion.txt";

// set location of apple push notification certificate keys
$ckLiveLoc                  = dirname(__FILE__) . "/resources/cklive.pem";
$ckDevLoc                   = dirname(__FILE__) . "/resources/ckdev.pem";

// set apple push notification certificate passwords
$ckLivePassword             = "example_dev_password";
$ckDevPassword              = "exapmle_live_password";
