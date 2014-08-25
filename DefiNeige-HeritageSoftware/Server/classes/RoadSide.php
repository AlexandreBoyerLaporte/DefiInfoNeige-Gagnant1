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


class RoadSide extends AbstractRoad
{
    protected $roadID;
    protected $starAddress;
    protected $endAddress;
    protected $orientation;
    protected $streetName;
    protected $lienF;
    protected $borough;
    protected $type;
    
    
    protected function parseProperties($propertiesDic)
    {
        $this->ID           = $propertiesDic["COTE_RUE_ID"];
        $this->roadID       = $propertiesDic["ID_TRC"];
        $this->starAddress  = $propertiesDic["DEBUT_ADRESSE"];
        $this->endAddress   = $propertiesDic["FIN_ADRESSE"];
        $this->orientation  = $propertiesDic["ORIENTATION_F"];
        $this->streetName   = $propertiesDic["NOM_VOIE"];
        $this->lienF        = $propertiesDic["LIEN_F"];
        $this->borough      = $propertiesDic["ARRONDISSEMENT"];
        $this->type         = $propertiesDic["TYPE_F"];
    }
    
    
    protected function createGeoPoint()
    {
        return new GeoPoint(GeoPoint::$GeoPointTypeRoadSide);
    }
    
    
    protected function writePropertiesToDatabase($dbConnection)
    {
        $query = "INSERT INTO RoadSides (ID,RoadID,StartAddress,EndAddress,Orientation,StreetName,LienF,Borough,Type)"
            . " VALUES (:ID,:RoadID,:StartAddress,:EndAddress,:Orientation,:StreetName,:LienF,:Borough,:Type)";
        $params = array(':ID'           => $this->ID,
                        ':RoadID'       => $this->roadID,
                        ':StartAddress' => $this->starAddress,
                        ':EndAddress'   => $this->endAddress,
                        ':Orientation'  => $this->orientation,
                        ':StreetName'   => $this->streetName,
                        ':LienF'        => $this->lienF,
                        ':Borough'      => $this->borough,
                        ':Type'         => $this->type);
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