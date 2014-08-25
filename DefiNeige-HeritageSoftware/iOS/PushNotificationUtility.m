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


#import "PushNotificationUtility.h"

#define ParamKeyAPS             @"aps"
#define ParamKeyExtraInfo       @"extra_info"
#define ParamKeyRoadSideID      @"road_side_id"



@implementation PushNotificationUtility

static PushNotificationType type;


+ (PushNotificationType) pushNotificationType
{
    return type;
}

+ (void)handlePushNotificationDictionary:(NSDictionary *)pushDictionary
{
    NSDictionary *apsDic = [pushDictionary objectForKey:ParamKeyAPS];
    NSDictionary *extraInfoDic = [apsDic objectForKey:ParamKeyExtraInfo];
    NSInteger roadSideID = [[extraInfoDic objectForKey:ParamKeyRoadSideID] integerValue];
    
    type = PushNotificationTypeRunning;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:pushNotificationID
                                                        object:nil];
    
    
    NSString *alertViewMessage = @"Le statut de votre rue a changé.";
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:alertViewMessage
                                                 message:nil
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
    
    NSLog(@"Push notificatoin RoadSideID: %ld", roadSideID);
}


+ (void)handleLaunchPushNotificationDictionary:(NSDictionary *)pushDictionary
{
    type = PushNotificationTypeNotRunning;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
