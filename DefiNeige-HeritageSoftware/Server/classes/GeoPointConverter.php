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

//
// GeoPointConverter is a class used with conversion tool http://leware.net/geo/utmgoogle.htm
//


class GeoPointConverter extends DBInteractor
{
    public function outputMTMGeoPoints()
    {
        $query = "SELECT * FROM GeoPoints";
        $statement =  $this->dbConnection->prepare($query);
        if ($statement->execute())
        {
            while ($row = $statement->fetch(PDO::FETCH_ASSOC))
            {
                echo $row['X']." ".$row['Y']."\n";
            }
        }
    }
    
    
    public function inputGeoPointsConverted($inputString)
    {
        $selectQuery = "SELECT ID FROM GeoPoints";
        $selectStatement = $this->dbConnection->prepare($selectQuery);
        $selectStatement->execute();
        
        $lines = explode("\n", $inputString);
        
        foreach ($lines as $line)
        {
            $pieces = explode(" ", $line);

            foreach ($pieces as $piece)
            {
                if (strpos($piece,',') !== false)
                {
                    $longAndLat = explode(",", $piece);
                    $latitude = trim($longAndLat[0]);
                    $longitude = trim($longAndLat[1]);
                    
                    $row = $selectStatement->fetch(PDO::FETCH_ASSOC);
                    
                    $updateQuery = "UPDATE GeoPoints"
                            . " SET Longitude=:Longitude,Latitude=:Latitude"
                            . " WHERE ID=:ID";
                    $updateParams = array(":Longitude" => $longitude,
                                          ":Latitude" => $latitude,
                                          ":ID" => $row['ID']);
                    $updateStatement = $this->dbConnection->prepare($updateQuery);
                    
                    try 
                    {
                        $updateStatement->execute($updateParams);
                    } 
                    catch (Exception $ex) 
                    {
                        print_r($ex);
                    }
                }
            }
        }
    }
}