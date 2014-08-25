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


class GeoPoint
{
    public static $GeoPointTypeRoad        = "GeoPointTypeRoad";
    public static $GeoPointTypeRoadSide    = "GeoPointTypeRoadSide";
    
    
    private $geoPointType;
    private $x;
    private $y;
    private $longitude;
    private $latitude;
    
    
    public function __construct($geoPointType) 
    {
        $this->geoPointType = $geoPointType;
    }
    
    
    public function parseFromJSONCoordArray($coordsXYArray)
    {
        $this->x = $coordsXYArray[0];
        $this->y = $coordsXYArray[1];
    }
    
    
    public function writeToDatabase($dbConnection, $foreignID)
    {
        if ($this->geoPointType == GeoPoint::$GeoPointTypeRoad)
        {
            $query = "INSERT INTO GeoPoints (RoadID,X,Y)"
                    . " VALUES (:RoadID,:X,:Y)";
            $params = array(':RoadID'       => $foreignID,
                            ':X'            => $this->x,
                            ':Y'            => $this->y);
        }
        else if ($this->geoPointType == GeoPoint::$GeoPointTypeRoadSide)
        {
            $query = "INSERT INTO GeoPoints (RoadSideID,X,Y)"
                    . " VALUES (:RoadSideID,:X,:Y)";
            $params = array(':RoadSideID'   => $foreignID,
                            ':X'            => $this->x,
                            ':Y'            => $this->y);
        }
        
        $statement = $dbConnection->prepare($query);
        
        try
        {
            $statement->execute($params);
        }
        catch (PDOException $e)
        {
            print_r($e);
        }
    }
}