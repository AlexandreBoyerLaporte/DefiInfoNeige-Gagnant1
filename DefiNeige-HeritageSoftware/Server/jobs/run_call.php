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

require_once dirname(__FILE__) . '/../headers.php';


function transferJob()
{
    $dataTransferer = new DataTransferer();
    $dataTransferer->resetDatabase();
    $dataTransferer->parseAllJSONData();
}


function convertJob()
{
    global $outputtedConversionLoc;
    
    $inputString = file_get_contents($outputtedConversionLoc, FILE_USE_INCLUDE_PATH);
    $geoPointConverter = new GeoPointConverter();
    $geoPointConverter->inputGeoPointsConverted($inputString);
}


function roadCentersJob()
{
    $roadCenterCalculator = new RoadCenterCalculator();
    $roadCenterCalculator->calculateRoadCenters();
}


function cityAPIPullJob()
{
    $cityAPIHandler = new CityAPIHandler();
    $cityAPIHandler->pullUpdatesFromCityAPI();
}


function pushFeederJob()
{
    $pushQueueFeeder = new PushQueueFeeder();
    $pushQueueFeeder->resolveNotificationsForPushQueue();
}


function pushJob()
{
    $pushQueueHandler = new PushQueueHandler();
    $pushQueueHandler->sendQueuePushNotifications();
}