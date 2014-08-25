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


class RoadCenterCalculator extends DBInteractor
{
    public function calculateRoadCenters()
    {
        $statementString = "SELECT Roads.ID AS RoadID, GeoPoints.Longitude, GeoPoints.Latitude"
                . " FROM Roads,GeoPoints"
                . " WHERE Roads.ID=GeoPoints.RoadID"
                . " ORDER BY Roads.ID ASC";
        $statement = $this->dbConnection->prepare($statementString);
        $statement->execute();
        
        $lastRoadID = -1;
        $roadPoints = array();
        
        while ($row = $statement->fetch(PDO::FETCH_ASSOC))
        {
            $currentRowID = $row['RoadID'];
            
            if ($lastRoadID == -1) {
                $lastRoadID = $currentRowID;
            }
            else if ($lastRoadID != $currentRowID) {
                $this->calculateCenterPointForRoadPoints($lastRoadID, $roadPoints);
                $lastRoadID = $currentRowID;
                $roadPoints = array();
            }
            
            $point = array($row['Longitude'],$row['Latitude']);
            array_push($roadPoints, $point);
        }
    }
    
    
    private function calculateCenterPointForRoadPoints($roadID, $roadPoints)
    {
        $middleIndex = (count($roadPoints)- 1)/2;
        $floorIndex = floor($middleIndex);
        $ceilIndex = ceil($middleIndex);
        $floorRoadPoint = $roadPoints[$floorIndex];
        $ceilRoadPoint = $roadPoints[$ceilIndex];
        $longArray = array($floorRoadPoint[0],$ceilRoadPoint[0]);
        $latArray = array($floorRoadPoint[1],$ceilRoadPoint[1]);
        $averageLong = $this->calculateAverageValue($longArray);
        $averageLat = $this->calculateAverageValue($latArray);
        
        $this->writeCenterPointToDatabase($roadID, $averageLong, $averageLat);
    }
    
    
    private function calculateAverageValue($valuesArray)
    {
        $sum = 0;
        foreach ($valuesArray as $value){
            $sum = $sum + $value;
        }
        $average = $sum / count($valuesArray);
        return $average;
    }
    
    
    private function writeCenterPointToDatabase($roadID, $averageLong, $averageLat)
    {
        $statementString = "UPDATE Roads"
                . " SET CenterLongitude=:long,CenterLatitude=:lat"
                . " WHERE ID=:ID";
        $params = array(":long" => $averageLong,
                        ":lat" => $averageLat,
                        ":ID" => $roadID);
        $statement = $this->dbConnection->prepare($statementString);
        
        try {
            $statement->execute($params);
        } catch (Exception $ex) {
            print_r($ex);
        }
    }
}