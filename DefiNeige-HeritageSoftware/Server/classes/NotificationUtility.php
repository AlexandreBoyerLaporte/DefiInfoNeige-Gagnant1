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


class NotificationUtility
{
    const ParamKeyExtraInfo         = "extra_info";
    
    const AppleSandboxPushServer    = "ssl://gateway.sandbox.push.apple.com:2195";
    const AppleLivePushServer       = "ssl://gateway.push.apple.com:2195";
    
    
    public static function sendPushNotificationToUserWithCKInfo($dbConnection, $userID, $ckLocation, $ckPassPhrase, $pushMessage, $badgeCount, $isLiveServer, $extraInfoDic=null)
    {
        $deviceTokens = self::deviceTokensForUserID($dbConnection, $userID);
        
        foreach ($deviceTokens as $deviceToken)
        {
            self::sendPushNotificationToAppleServerForDevice($deviceToken, $ckLocation, $ckPassPhrase, $pushMessage, $badgeCount, $isLiveServer, $extraInfoDic);
        }
    }
    
    
    private static function sendPushNotificationToAppleServerForDevice($deviceToken, $ckLocation, $ckPassPhrase , $pushMessage, $badgeCount, $isLiveServer, $extraInfoDic=null)
    {
        // Create stream context
        $ctx = stream_context_create();
        stream_context_set_option($ctx, 'ssl', 'local_cert', $ckLocation);
        stream_context_set_option($ctx, 'ssl', 'passphrase', $ckPassPhrase);
        
        // Open a connection to the APNS server
        if ($isLiveServer)
        {
            $applePushSever = self::AppleLivePushServer;
        }
        else
        {
            $applePushSever = self::AppleSandboxPushServer;
        }
        $err = null;
        $errstr = null;
        $fp = stream_socket_client(
                $applePushSever,
                $err,
                $errstr, 
                60, 
                STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, 
                $ctx);

        if (!$fp)
        {
            //exit("Failed to connect: $err $errstr" . PHP_EOL);
            exit("-200");
        }
        
        // Create the payload body
        $body['aps'] = array(
            'alert' => $pushMessage,
            'sound' => 'default',
            'badge' => $badgeCount,
            self::ParamKeyExtraInfo => $extraInfoDic);

        // Encode the payload as JSON
        $payload = json_encode($body);

        // Build the binary notification
        $msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

        // Send it to the server
        $result = fwrite($fp, $msg, strlen($msg));

        if (!$result)
        {
            //echo 'Message not delivered' . PHP_EOL;
            echo "-201";
        }
        
        // Close the connection to the server
        fclose($fp);
    }
    
    private static function deviceTokensForUserID($dbConnection, $userID)
    {
        $deviceTokens = array();
        
        $query = "SELECT * FROM UserDeviceTokensIOS"
                . " WHERE UserID=:UserID"
                . " ORDER BY DateAdded DESC";
        $params = array(":UserID" => $userID);
        $statement = $dbConnection->prepare($query);
        try {
            $statement->execute($params);
        } catch (Exception $ex) {
            print_r($ex);
        }
        
        while ($row = $statement->fetch(PDO::FETCH_ASSOC))
        {
            $deviceToken = $row['DeviceToken'];
            array_push($deviceTokens, $deviceToken);
        }
        
        return $deviceTokens;
    }
}

