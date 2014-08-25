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


class PushQueueHandler extends DBInteractor
{
    public function sendQueuePushNotifications()
    {
        global $isLiveServer, $ckLiveLoc, $ckDevLoc, $ckLivePassword, $ckDevPassword;
        
        if ($isLiveServer)
        {
            $ckLoc = $ckLiveLoc;
            $ckPassword = $ckLivePassword;
        }
        else
        {
            $ckLoc = $ckDevLoc;
            $ckPassword = $ckDevPassword;
        }
        
        $query = "SELECT * FROM PushQueue"
                . " WHERE Sent=0"
                . " ORDER BY DateAdded DESC";
        $statement = $this->dbConnection->prepare($query);
        try {
            $statement->execute();
        } catch (Exception $ex) {
            print_r($ex);
        }
        
        while ($row = $statement->fetch(PDO::FETCH_ASSOC))
        {
            //print_r($row);
            
            $pushID = $row['ID'];
            $userID = $row['UserID'];
            $message = $row['Message'];
            $roadSideID = $row['AffectedID'];
            
            $pushInfoDic = array(
                "road_side_id" => $roadSideID
            );
            
            NotificationUtility::sendPushNotificationToUserWithCKInfo($this->dbConnection, $userID, $ckLoc, $ckPassword, $message, 1, false, $pushInfoDic);
            
            $query2 = "UPDATE PushQueue SET Sent=1"
                    . " WHERE ID=:ID";
            $params2 = array(":ID" => $pushID);
            $statement2 = $this->dbConnection->prepare($query2);
            try {
                $statement2->execute($params2);
            } catch (Exception $ex) {
                print_r($ex);
            }
        }
    }
}

