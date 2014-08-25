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


class MapRoadSideGetter extends DBInteractor
{
    public function outputRoadSidesNearLocation($longitude, $latitude)
    {
        $mapRoadSidesArray = array();
        
        $longitudeRange = 0.003075;
        $latitudeRange = 0.00211125;
        $minLong = $longitude - $longitudeRange;
        $maxLong = $longitude + $longitudeRange;
        $minLat = $latitude - $latitudeRange;
        $maxLat = $latitude + $latitudeRange;
        
        $statementString = "SELECT * FROM Roads,RoadSides"
                        . " WHERE Roads.ID=RoadSides.RoadID"
                        . " AND Roads.CenterLongitude>:minLong AND Roads.CenterLongitude<:maxLong"
                        . " AND Roads.CenterLatitude>:minLat AND Roads.CenterLatitude<:maxLat";
        $params = array(":minLong" => $minLong,
                        ":maxLong" => $maxLong,
                        ":minLat" => $minLat,
                        ":maxLat" => $maxLat);
        $statement = $this->dbConnection->prepare($statementString);
        
        try {
            $statement->execute($params);
        } catch (Exception $exc) {
            print_r($exc);
        }
        
        while($roadAndRoadSideRow = $statement->fetch(PDO::FETCH_ASSOC))
        {
            $mapRoadSideDic = $this->createMapRoadSideDicFromJointRow($roadAndRoadSideRow);
            array_push($mapRoadSidesArray, $mapRoadSideDic);
        }
        
        $json = json_encode($mapRoadSidesArray);
        echo $json;
    }
    
    
    public function getRoadSideForRoadSideID($roadSideID)
    {
        $statementString = "SELECT * FROM Roads,RoadSides"
                        . " WHERE Roads.ID=RoadSides.RoadID"
                        . " AND RoadSides.ID=:RoadSideID";
        $params = array(":RoadSideID" => $roadSideID);
        $statement = $this->dbConnection->prepare($statementString);

        try {
            $statement->execute($params);
        } catch (Exception $exc) {
            print_r($exc);
            die();
        }
        
        $roadAndRoadSideRow = $statement->fetch(PDO::FETCH_ASSOC);
        $mapRoadSideDic = $this->createMapRoadSideDicFromJointRow($roadAndRoadSideRow);
        $json = json_encode($mapRoadSideDic);
        echo $json;
    }
    
    
    private function createMapRoadSideDicFromJointRow($roadAndRoadSideRow)
    {
        $roadSideID = $roadAndRoadSideRow['ID'];
        $roadAndRoadSideRow['RoadSideID'] = $roadSideID;
        unset($roadAndRoadSideRow['ID']);
        
        $statementString = "SELECT * FROM GeoPoints"
                . " WHERE RoadSideID=:RoadSideID";
        $params = array(":RoadSideID" => $roadSideID);
        $statement = $this->dbConnection->prepare($statementString);

        try {
            $statement->execute($params);
        } catch (Exception $exc) {
            print_r($exc);
        }
        
        $geoPointsArray = array();
        
        while($row = $statement->fetch(PDO::FETCH_ASSOC))
        {
            array_push($geoPointsArray, $row);
        }
        
        $roadAndRoadSideRow['GeoPoints'] = $geoPointsArray;
        
        return $roadAndRoadSideRow;
    }
}

