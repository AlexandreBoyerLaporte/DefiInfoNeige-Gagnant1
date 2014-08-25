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


class CityAPIHandler extends DBInteractor
{
    protected static $DATE_FORMAT = "Y-m-d\TH:i:s";
    
    
    public function pullUpdatesFromCityAPI()
    {
        $dateString = $this->dateParamForUpdatesSince();
        $result = $this->getResultsFromSoapAPIForDate($dateString);
        $this->parseResultAndUpdateDatabase($result);
    }
    
    
    private function getResultsFromSoapAPIForDate($dateString)
    {
        $client = new SoapClient("https://servicesenligne2.ville.montreal.qc.ca/api/infoneige/InfoneigeWebService?wsdl");
        $params = array("fromDate"      => $dateString,
                        "tokenString"   => "br40-32889fa7-9be0-4959-947a-da2d13e764db-acccd40f-0d5c-42ab-9f1b-dc759e207f30-9770e569-41ef-4611-9626-96a77699d778-e9156f55-5411-4768-a15e-a24944625035-7476c059-bba2-4732-aebf-18d7b5406985");
        $paramContainer = array("getPlanificationsForDate" => $params);
        $result = $client->GetPlanificationsForDate($paramContainer);
        //print_r($result);
        return $result;
    }
    
    
    private function parseResultAndUpdateDatabase($result)
    {
        $responseDic = $result->planificationsForDateResponse;
        
        $responseStatus = $responseDic->responseStatus;
        
        if ($responseStatus == 8 || $responseStatus == 14)
        {
            return;
        }
        
        $planificationsRoot = $responseDic->planifications;
        $planifications = $planificationsRoot->planification;
        
        foreach ($planifications as $planification)
        {
            //$muniID             = $planification['munid'];
            $roadSideID         = $planification->coteRueId;
            $roadStatus         = $planification->etatDeneig;
            $datePlannedStart   = $this->convertAPIDateToSQLDate($planification->dateDebutPlanif);
            $datePlannedEnd     = $this->convertAPIDateToSQLDate($planification->dateFinPlanif);
            $dateReplannedStart = $this->convertAPIDateToSQLDate($planification->dateDebutReplanif);
            $dateReplannedEnd   = $this->convertAPIDateToSQLDate($planification->dateFinReplanif);
            $dateLastPlanned    = $this->convertAPIDateToSQLDate($planification->dateMaj);
            
            if ($this->checkIfRoadSideUpdateHasChangedData($roadSideID,$dateLastPlanned))
            {
                $this->addRoadSideToChangedRoadSidesQueue($roadSideID, $roadStatus);
            }
            
            $stmtString = "UPDATE RoadSides SET"
                    . " RoadStatus=:RoadStatus,"
                    . " DatePlannedStart=:DatePlannedStart,"
                    . " DatePlannedEnd=:DatePlannedEnd,"
                    . " DateReplannedStart=:DateReplannedStart,"
                    . " DateReplannedEnd=:DateReplannedEnd,"
                    . " DateLastPlanned=:DateLastPlanned"
                    . " WHERE ID=:ID";
            $params = array(":RoadStatus"           => $roadStatus,
                            ":DatePlannedStart"     => $datePlannedStart,
                            ":DatePlannedEnd"       => $datePlannedEnd,
                            ":DateReplannedStart"   => $dateReplannedStart,
                            ":DateReplannedEnd"     => $dateReplannedEnd,
                            ":DateLastPlanned"      => $dateLastPlanned,
                            ":ID"                   => $roadSideID);
            $stmt = $this->dbConnection->prepare($stmtString);
            try {
                $stmt->execute($params);
            } catch (Exception $ex) {
                print_r($ex);
            }
        }
    }
    
    
    private function checkIfRoadSideUpdateHasChangedData($roadSideID,$newDateLastPlanned)
    {
        $stmtStr = "SELECT * FROM RoadSides"
                . "  WHERE ID=:RoadSideID";
        $params = array(":RoadSideID" => $roadSideID);
        $stmt = $this->dbConnection->prepare($stmtStr);
        try {
            $stmt->execute($params);
        } catch (Exception $ex) {
            print_r($ex);
        }
        $oldRoadSideRow = $stmt->fetch(PDO::FETCH_ASSOC);
        $oldDateLastPlanned = $oldRoadSideRow['DateLastPlanned'];
        
        // check if newDateLastPlaned is greater than oldDateLastPlanned
        if ($newDateLastPlanned > $oldDateLastPlanned)
        {
            return true;
        }
        
        return false;
    }
    
    
    private function addRoadSideToChangedRoadSidesQueue($roadSideID,$newStatus)
    {
        $stmtStr = "INSERT INTO ChangedRoadSidesQueue"
                . "  (RoadSideID, NewStatus)"
                . " VALUES (:RoadSideID, :NewStatus)";
        $params = array(":RoadSideID" => $roadSideID,
                        ":NewStatus" => $newStatus);
        $stmt = $this->dbConnection->prepare($stmtStr);
        try {
            $stmt->execute($params);
        } catch (Exception $ex) {
            print_r($ex);
        }
    }
    
    
    private function dateParamForUpdatesSince()
    {
        date_default_timezone_set("America/New_York");
        $date = date(CityAPIHandler::$DATE_FORMAT, strtotime('-7 minutes'));
        
        return $date;
    }
    
    
    private function convertAPIDateToSQLDate($apiDate)
    {
        $convertedDate = str_replace("T", " ", $apiDate);
        
        return $convertedDate;
    }
}

