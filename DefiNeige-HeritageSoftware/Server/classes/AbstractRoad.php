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

abstract class AbstractRoad
{
    protected abstract function parseProperties($propertiesDic);
    protected abstract function createGeoPoint();
    protected abstract function writePropertiesToDatabase($dbConnection);
    
    
    protected $ID;
    
    
    public function __construct() 
    {
        $this->coordinates = array();
    }
    
    
    public function parseFromJSON($roadDic)
    {
        $propertiesDic      = $roadDic["properties"];
        $geometryDic        = $roadDic["geometry"];
        $coordinatessArray  = $geometryDic["coordinates"];
        
        $this->parseProperties($propertiesDic);
        
        $geometryType = $geometryDic["type"];
        
        // This is a temporary solution to multi-lines.  We simply use the first set for now.
        if ($geometryType == "MultiLineString")
        {
            $coordinatessArray = $coordinatessArray[0];
        }
        
        foreach ($coordinatessArray as $coordsXYArray)
        {
            $geoPoint = $this->createGeoPoint();
            $geoPoint->parseFromJSONCoordArray($coordsXYArray);
            array_push($this->coordinates, $geoPoint); 
        }
    }
    
    
    public function writeToDatabase($dbConnection)
    {
        $this->writePropertiesToDatabase($dbConnection);
        $this->writeGeoPointsToDatabase($dbConnection);
    }
    
    
    protected function writeGeoPointsToDatabase($dbConnection)
    {
        foreach ($this->coordinates as $geoPoint)
        {
            $geoPoint->writeToDatabase($dbConnection,$this->ID);
        }
    }
}

