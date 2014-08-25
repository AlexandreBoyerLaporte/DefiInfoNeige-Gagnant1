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


class StatusGetter extends DBInteractor
{
    public function outputSnowRemovedPercentage()
    {
        $stmtString1 = "SELECT COUNT(*) FROM RoadSides"
                    . " WHERE RoadStatus=1";
        $stmt1 = $this->dbConnection->prepare($stmtString1);
        try {
            $stmt1->execute();
            $roadSideClearedCount = $stmt1->fetchColumn();
        } catch (Exception $ex) {
            //print_r($ex);
            print "-1";
            die();
        }
        
        $stmtString2 = "SELECT COUNT(*) FROM RoadSides";
        $stmt2 = $this->dbConnection->prepare($stmtString2);
        try {
            $stmt2->execute();
            $roadSideTotalCount = $stmt2->fetchColumn();
        } catch (Exception $ex) {
            //print_r($ex);
            print "-1";
            die();
        }
        
        $percentage = ($roadSideClearedCount / $roadSideTotalCount) * 100;
        $percentageRounded = round($percentage,0);
        
        print $percentageRounded;
    }
}

