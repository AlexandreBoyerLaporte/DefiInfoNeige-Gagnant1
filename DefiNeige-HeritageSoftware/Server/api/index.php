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

//  This script needs to install Flight micro-framework
//  http://flightphp.com

require_once 'flight/Flight.php';
require_once '../headers.php';

header('Content-type: text/plain');

Flight::route('/searchRoadSidesNearLocation/@apiKey/@longitude/@latitude','searchRoadSidesNearLocation');
Flight::route('/getRoadSideForRoadSideID/@apiKey/@roadSideID','getRoadSideForRoadSideID');
Flight::route('/getSnowRemovedPercentage/@apiKey','getSnowRemovedPercentage');
Flight::route('/createNewUser/@apiKey','createNewUser');
Flight::route('/userParkedCar/@apiKey/@userID/@roadSideID','userParkedCar');
Flight::route('/userUnparkedCar/@apiKey/@userID','userUnparkedCar');
Flight::route('/saveDeviceToken/@apiKey/@userID/@deviceToken','saveDeviceToken');
Flight::start();


function searchRoadSidesNearLocation($apiKey, $longitude, $latitude)
{
    if (verifyValidAPIKey($apiKey))
    {
        $roadGetter = new MapRoadSideGetter();
        $roadGetter->outputRoadSidesNearLocation($longitude, $latitude);
    }
}


function getRoadSideForRoadSideID($apiKey, $roadSideID)
{
    if (verifyValidAPIKey($apiKey))
    {
        $roadGetter = new MapRoadSideGetter();
        $roadGetter->getRoadSideForRoadSideID($roadSideID);
    }
}

function getSnowRemovedPercentage($apiKey)
{
    if (verifyValidAPIKey($apiKey))
    {
        $statusGetter = new StatusGetter();
        $statusGetter->outputSnowRemovedPercentage();
    }
}


function createNewUser($apiKey)
{
    if (verifyValidAPIKey($apiKey))
    {
        $userActionManager = new UserActionManager();
        $userActionManager->createNewUser();
    }
}


function userParkedCar($apiKey, $userID, $roadSideID)
{
    if (verifyValidAPIKey($apiKey))
    {
        $userActionManager = new UserActionManager();
        $userActionManager->userParkedCar($userID, $roadSideID);
    }
}


function userUnparkedCar($apiKey, $userID)
{
    if (verifyValidAPIKey($apiKey))
    {
        $userActionManager = new UserActionManager();
        $userActionManager->userUnparkedCar($userID);
    }
}


function saveDeviceToken($apiKey, $userID, $deviceToken)
{
    if (verifyValidAPIKey($apiKey))
    {
        $updateManager = new UpdateManger();
        $updateManager->saveDeviceToken($userID, $deviceToken);
    }
}


function verifyValidAPIKey($requestAPIKey)
{
    global $isLiveServer, $apiDevKey, $apiLiveKey;
    
    $apiKeyIsValid = false;
    
    if ($isLiveServer && $requestAPIKey == $apiLiveKey)
    {
        $apiKeyIsValid = true;
    }
    else if (!$isLiveServer && $requestAPIKey == $apiDevKey)
    {
        $apiKeyIsValid = true;
    }
    
    if (!$apiKeyIsValid)
    {
        die(print("-10"));
    }
    
    return true;
}
