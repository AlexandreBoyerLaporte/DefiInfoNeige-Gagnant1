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


class UserActionManager extends DBInteractor
{
    public function createNewUser()
    {
        $stmtString = "INSERT INTO Users DEFAULT VALUES";
        $stmt = $this->dbConnection->prepare($stmtString);
        try {
            $stmt->execute();
            print $this->dbConnection->lastInsertId();
        } catch (Exception $ex) {
            //print_r($ex);
            print "-1";
        }
    }
    
    
    public function userParkedCar($userID, $roadSideID)
    {
        $stmtString = "SELECT COUNT(*) FROM UserParkedRoadSides"
                . " WHERE UserID=:UserID";
        $params = array(":UserID"   => $userID);
        $stmt = $this->dbConnection->prepare($stmtString);
        try {
            $stmt->execute($params);
            $rowCount = $stmt->fetchColumn();
        } catch (Exception $ex) {
            //print_r($ex);
            print "-1";
            die();
        }
        
        if ($rowCount > 0)
        {
            $stmtString = "UPDATE UserParkedRoadSides"
                    . " SET RoadSideID=:RoadSideID"
                    . " WHERE UserID=:UserID";
            $params = array(":RoadSideID"   => $roadSideID,
                            ":UserID"       => $userID);
            $stmt = $this->dbConnection->prepare($stmtString);
            try {
                $stmt->execute($params);
                print "1";
            } catch (Exception $ex) {
                //print_r($ex);
                print "-2";
            }
        }
        else
        {
            $stmtString = "INSERT INTO UserParkedRoadSides"
                    . " (UserID,RoadSideID)"
                    . " VALUES (:UserID,:RoadSideID)";
            $params = array(":UserID"       => $userID,
                            ":RoadSideID"   => $roadSideID);
            $stmt = $this->dbConnection->prepare($stmtString);
            try {
                $stmt->execute($params);
                print "1";
            } catch (Exception $ex) {
                //print_r($ex);
                print "-3";
            }
        }
    }
    
    
    public function userUnparkedCar($userID)
    {
        //print "UserID: $userID uparked car\n";
        
        $stmtString = "DELETE FROM UserParkedRoadSides"
                . " WHERE UserID=:UserID";
        $params = array(":UserID"   => $userID);
        $stmt = $this->dbConnection->prepare($stmtString);
        try {
            $stmt->execute($params);
            print "1";
        } catch (Exception $ex) {
            //print_r($ex);
            print "-1";
        }
    }
}

