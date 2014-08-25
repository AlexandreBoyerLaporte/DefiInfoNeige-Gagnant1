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


class Road extends AbstractRoad
{
    protected $streetOn;
    protected $streetFrom;
    protected $streetTo;
    protected $circulation;
    protected $coordinates;
    
    
    protected function parseProperties($propertiesDic)
    {
        $this->ID           = $propertiesDic["TRC_ID"];
        $this->streetOn     = $propertiesDic["SUR"];
        $this->streetFrom   = $propertiesDic["DE"];
        $this->streetTo     = $propertiesDic["A"];
        $this->circulation  = $propertiesDic["SENS_CIR"];
    }
    
    
    protected function createGeoPoint()
    {
        return new GeoPoint(GeoPoint::$GeoPointTypeRoad);
    }
    
    
    protected function writePropertiesToDatabase($dbConnection) 
    {
        $query = "INSERT INTO Roads (ID,StreetOn,StreetFrom,StreetTo,CirculationCode)"
            . " VALUES (:ID,:StreetOn,:StreetFrom,:StreetTo,:CirculationCode)";
        $params = array(':ID'               => $this->ID,
                        ':StreetOn'         => $this->streetOn,
                        ':StreetFrom'       => $this->streetFrom,
                        ':StreetTo'         => $this->streetTo,
                        ':CirculationCode'  => $this->circulation);
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