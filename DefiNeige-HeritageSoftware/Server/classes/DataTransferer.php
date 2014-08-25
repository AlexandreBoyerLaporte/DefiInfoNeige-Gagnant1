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


class DataTransferer extends DBInteractor
{
    private $shoudLimitTransfers    = false;
    private $limitTransferCount     = 10;
    
    
    public function getShoudLimitTransfers() 
    {
        return $this->shoudLimitTransfers;
    }
    
    
    public function getLimitTransferCount() 
    {
        return $this->limitTransferCount;
    }
    
    
    public function setShoudLimitTransfers($shoudLimitTransfers) 
    {
        $this->shoudLimitTransfers = $shoudLimitTransfers;
    }
    
    
    public function setLimitTransferCount($limitTransferCount) 
    {
        $this->limitTransferCount = $limitTransferCount;
    }
    
    
    public function resetDatabase()
    {
        $query = "DELETE FROM Roads; DELETE FROM RoadSides;";
        $statement = $this->dbConnection->prepare($query);
        
        try
        {
            $statement->execute();
        }
        catch (PDOException $e)
        {
            print_r($e);
        }
    }
    
    
    public function parseAllJSONData()
    {
        $this->parseRoads();
        $this->parseRoadSides();
    }
    
    
    public function parseRoads()
    {
        $geobaseJSONString = file_get_contents("GEOBASE.json");
        $rootJSON = json_decode($geobaseJSONString,true);
        $roads = $rootJSON["features"];

        $count = 0;
        foreach ($roads as $roadDic)
        {
            if ($this->shoudLimitTransfers && $count > ($this->limitTransferCount - 1))
            {
                break;
            }

            $road = new Road();
            $road->parseFromJSON($roadDic);
            $road->writeToDatabase($this->dbConnection);

            $count++;
        }
    }
    
    
    public function parseRoadSides()
    {
        $geobaseJSONString = file_get_contents("cote.json");
        $rootJSON = json_decode($geobaseJSONString,true);
        $roadSides = $rootJSON["features"];

        $count = 0;
        foreach ($roadSides as $roadSideDic)
        {
            if ($this->shoudLimitTransfers && $count > ($this->limitTransferCount - 1))
            {
                break;
            }
            
            $roadSide = new RoadSide();
            $roadSide->parseFromJSON($roadSideDic);
            $roadSide->writeToDatabase($this->dbConnection);

            $count++;
        }
    }
}