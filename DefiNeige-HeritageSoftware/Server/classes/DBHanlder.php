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


class DBHanlder
{
    public static function databaseConnection()
    {
        global $isLiveServer, $dbServerName, $dbUserName, $dbPassword, $dbNameDev, $dbNameLive;
        
        if ($isLiveServer)
        {
            $dbName = $dbNameLive;
        }
        else
        {
            $dbName = $dbNameDev;
        }
        
        try
        {
            $dbConnection = new PDO("sqlsrv:Server=$dbServerName;Database=$dbName", $dbUserName, $dbPassword);
            $dbConnection->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
        } 
        catch (PDOException $ex) 
        {
            //print_r($ex);
            die("Error connecting");
        }
        
        return $dbConnection;
    }
}

