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


#import "UpdateManager.h"
#import "UserSessionManger.h"
#import "PageRequest.h"
#import "Config.h"

static NSString *saveDeviceTokenAPI = @"saveDeviceToken";



@implementation UpdateManager

+ (void)registerUserDeviceTokenWithCompletion:(void (^)(NSError *))block
{
    if (![UserSessionManger userIsSignedIn] || ![UserSessionManger hasDeviceToken])
    {
        NSLog(@"Does not have both UserID and DeviceToken");
    }
    
    NSInteger userID = [UserSessionManger userID];
    NSString *deviceToken = [UserSessionManger deviceToken];
    
    NSString *apiSearchURLWithParams = [NSString stringWithFormat:@"%@%@/%@/%ld/%@", [Config apiURL], saveDeviceTokenAPI, [Config apiKey], userID, deviceToken];
    NSURL *url = [NSURL URLWithString:apiSearchURLWithParams];
    
    PageRequest *pageRequest  = [[PageRequest alloc] init];
    [pageRequest setUpConnectionForURL:url
                        postParamaters:nil
                            completion:^(NSMutableData *data, NSError *error)
     {
         NSInteger returnCode = 0;
         
         if (!error)
         {
             NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             returnCode = [returnString integerValue];
             //NSLog(@"SaveUserDeviceTokenReturnString: %@", returnString);
             
             if (returnCode < 0)
             {
                 NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                 [errorDetail setValue:@"An error occured while registering user device token." forKey:NSLocalizedDescriptionKey];
                 error = [NSError errorWithDomain:@"RegisterDeviceTokenError" code:1 userInfo:errorDetail];
             }
         }
         
         if (block)
         {
             block(error);
         }
     }];
    [pageRequest start];
}

@end
