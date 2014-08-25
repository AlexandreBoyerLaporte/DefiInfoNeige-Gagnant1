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


#import "UserSessionManger.h"

#define USER_ID_KEY             @"USER_ID_KEY"
#define PARKED_ROADSIDE_ID_KEY  @"PARKED_ROAD_ID_KEY"
#define DEVICE_TOKEN_KEY        @"DEVICE_TOKEN_KEY"



@implementation UserSessionManger

+ (BOOL)userIsSignedIn
{
    if ([UserSessionManger userID] > 0)
    {
        return YES;
    }
    
    return NO;
}


+ (NSInteger)userID
{
    NSInteger userID = [[NSUserDefaults standardUserDefaults] integerForKey:USER_ID_KEY];
    
    return userID;
}


+ (void)setUserID:(NSInteger)userID
{
    [[NSUserDefaults standardUserDefaults] setInteger:userID forKey:USER_ID_KEY];
}


+ (BOOL)userIsParked
{
    if ([UserSessionManger parkedRoadSideID] > 0)
    {
        return YES;
    }
    
    return NO;
}


+ (NSInteger)parkedRoadSideID
{
    NSInteger roadSideID = [[NSUserDefaults standardUserDefaults] integerForKey:PARKED_ROADSIDE_ID_KEY];
    
    return roadSideID;
}


+ (void)setParkedRoadSideID:(NSInteger)roadSideID
{
    [[NSUserDefaults standardUserDefaults] setInteger:roadSideID forKey:PARKED_ROADSIDE_ID_KEY];
}


+ (BOOL)hasDeviceToken
{
    if ([UserSessionManger deviceToken] != nil)
    {
        return YES;
    }
    
    return NO;
}


+ (NSString *)deviceToken
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:DEVICE_TOKEN_KEY];
    
    return deviceToken;
}


+ (void)setDeviceToken:(NSString *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:DEVICE_TOKEN_KEY];
}

@end
