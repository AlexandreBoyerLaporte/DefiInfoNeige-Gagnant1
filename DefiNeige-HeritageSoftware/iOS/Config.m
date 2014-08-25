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


#import "Config.h"

static bool isLiveServer = false;
static NSString *liveServerAPIURL   = @"https://examplelive.com/api/";
static NSString *devServerAPIURL    = @"https://exampledev.com/api/";
static NSString *liveServerAPIKey   = @"example_live_api_key";
static NSString *devServerLiveKey   = @"example_dev_api_key";



@implementation Config

+ (BOOL)isLiveServer
{
    return isLiveServer;
}


+ (NSString *)apiURL
{
    if ([Config isLiveServer])
    {
        return liveServerAPIURL;
    }
    else
    {
        return devServerAPIURL;
    }
}


+ (NSString *)apiKey
{
    if ([Config isLiveServer])
    {
        return liveServerAPIKey;
    }
    else
    {
        return devServerLiveKey;
    }
}

@end
