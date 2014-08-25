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


class PushQueueFeeder extends DBInteractor
{
    const PushTypeMoveCar       = 0;
    const PushTypeChangedStatus = 1;
    
    public function resolveNotificationsForPushQueue()
    {
        $this->notificationsForMoveCar();
        $this->notificationsForRoadSideStatusChanged();
    }
    
    
    private function notificationsForMoveCar()
    {
        $startTime = date("Y/m/d H:i:s", strtotime("+15 minutes"));
        $endTime = date("Y/m/d H:i:s", strtotime("+20 minutes"));
        
        $stmtString = "SELECT * FROM RoadSides"
                . " WHERE (RoadStatus=2 AND DatePlannedStart > :StartTimePlanned AND DatePlannedStart <= :EndTimePlanned)"
                . " OR (RoadStatus=3 AND DateReplannedStart > :StartTimeReplanned AND DateReplannedStart <= :EndTimeReplanned)";
        $params = array(":StartTimePlanned"     => $startTime,
                        ":EndTimePlanned"       => $endTime,
                        ":StartTimeReplanned"     => $startTime,
                        ":EndTimeReplanned"       => $endTime);
        $stmt = $this->dbConnection->prepare($stmtString);
        try {
            $stmt->execute($params);
        } catch (Exception $ex) {
            print_r($ex);
            die();
        }
        
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
        {
            $roadSideID = $row['ID'];
            $this->findUsersParkedOnRoadSideAndAddToPushQueueForType($roadSideID, PushQueueFeeder::PushTypeMoveCar);
        }
    }
    
    
    private function notificationsForRoadSideStatusChanged()
    {
        $stmtString = "SELECT * FROM ChangedRoadSidesQueue";
        $stmt = $this->dbConnection->prepare($stmtString);
        try {
            $stmt->execute();
        } catch (Exception $ex) {
            //print_r($ex);
            //die();
        }
        
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
        {
            $roadSideID = $row['RoadSideID'];
            $this->findUsersParkedOnRoadSideAndAddToPushQueueForType($roadSideID, PushQueueFeeder::PushTypeChangedStatus);
            $this->deleteChangedRoadSideFromQueue($roadSideID);
        }
    }
    
    
    private function findUsersParkedOnRoadSideAndAddToPushQueueForType($roadSideID,$pushType)
    {
        $stmtStr = "SELECT UserID From UserParkedRoadSides"
                . " WHERE RoadSideID=:RoadSideID";
        $params = array(":RoadSideID" => $roadSideID);
        $stmt = $this->dbConnection->prepare($stmtStr);
        try {
            $stmt->execute($params);
        } catch (Exception $ex) {
            //print_r($ex);
            //die();
        }
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
        {
            $userID = $row['UserID'];
            $this->addUserNotificationToPushQueueForType($userID, $roadSideID, $pushType);
        }
    }
    
    
    private function addUserNotificationToPushQueueForType($userID,$roadSideID,$pushType)
    {
        if ($pushType == PushQueueFeeder::PushTypeMoveCar)
        {
            $message = "Le déneigement de votre rue va commencé.";
        }
        else if  ($pushType == PushQueueFeeder::PushTypeChangedStatus)
        {
            $message = "Le statut de votre rue a changé.";
        }
        
        $stmtStr = "INSERT INTO PushQueue (UserID,Message,Type,AffectedID)"
                . " VALUES (:UserID,:Message,:Type,:AffectedID)";
        $params = array(":UserID"       => $userID,
                        ":Message"      => $message,
                        ":Type"         => $pushType,
                        ":AffectedID"   => $roadSideID);
        $stmt = $this->dbConnection->prepare($stmtStr);
        try {
            $stmt->execute($params);
        } catch (Exception $ex) {
            //print_r($ex);
            //die();
        }
    }
    
    
    private function deleteChangedRoadSideFromQueue($roadSideID)
    {
        $deleteString = "DELETE FROM ChangedRoadSidesQueue"
                        . " WHERE RoadSideID=:RoadSideID";
        $params = array(":RoadSideID" => $roadSideID);
        $deleteStatement = $this->dbConnection->prepare($deleteString);
        try {
            $deleteStatement->execute($params);
        } catch (Exception $ex) {
            //print_r($ex);
            //die();
        }
    }
}

