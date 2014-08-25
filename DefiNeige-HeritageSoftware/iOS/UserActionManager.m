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


#import "UserActionManager.h"
#import "UserSessionManger.h"
#import "PageRequest.h"
#import "Config.h"
#import "UpdateManager.h"

static NSString *createNewUserAPI = @"createNewUser";
static NSString *userParkedCarAPI = @"userParkedCar";
static NSString *userUnparkedCarAPI = @"userUnparkedCar";



#pragma mark - Private Interface

@interface UserActionManager (Private)

+ (void)createNewUserWithCompletion:(void (^)(NSInteger newUserID, NSError *error))block;

+ (void)userParkedOnRoadSideID:(NSInteger)roadSideID
                    withUserID:(NSInteger)userID
                    completion:(void (^)(NSError *error))block;

+ (void)userUnparkedWithUserID:(NSInteger)userID
                    completion:(void (^)(NSError *error))block;

@end



#pragma mark - Public Implementation

@implementation UserActionManager


+ (void)userParkedOnRoadSideID:(NSInteger)roadSideID
                    completion:(void (^)(NSError *))block
{
    if ([UserSessionManger userIsSignedIn])
    {
        NSInteger userID = [UserSessionManger userID];
        [UserActionManager userParkedOnRoadSideID:roadSideID withUserID:userID completion:block];
    }
    else
    {
        [UserActionManager createNewUserWithCompletion:^(NSInteger newUserID, NSError *error)
         {
             if (!error)
             {
                 [UserActionManager userParkedOnRoadSideID:roadSideID withUserID:newUserID completion:block];
             }
             else
             {
                 block(error);
             }
         }];
    }
}


+ (void)userUnparkedWithCompletion:(void (^)(NSError *))block
{
    if ([UserSessionManger userIsSignedIn])
    {
        NSInteger userID = [UserSessionManger userID];
        [UserActionManager userUnparkedWithUserID:userID completion:block];
    }
    else
    {
        [UserSessionManger setParkedRoadSideID:0];
    }
}

@end



#pragma mark - Private Implementation

@implementation UserActionManager (Private)

+ (void)createNewUserWithCompletion:(void (^)(NSInteger, NSError *))block
{
    NSString *apiSearchURLWithParams = [NSString stringWithFormat:@"%@%@/%@", [Config apiURL], createNewUserAPI, [Config apiKey]];
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
             //NSLog(@"CreateUserReturnString: %@", returnString);
             
             if (returnCode > 0)
             {
                 [UserSessionManger setUserID:returnCode];
                 [UpdateManager registerUserDeviceTokenWithCompletion:^(NSError *error)
                  {
                      
                  }];
             }
             else
             {
                 NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                 [errorDetail setValue:@"An error occured while creating new user." forKey:NSLocalizedDescriptionKey];
                 error = [NSError errorWithDomain:@"UserCreateError" code:1 userInfo:errorDetail];
             }
         }
         
         if (block)
         {
             block(returnCode,error);
         }
     }];
    [pageRequest start];
}


+ (void)userParkedOnRoadSideID:(NSInteger)roadSideID
                    withUserID:(NSInteger)userID
                    completion:(void (^)(NSError *))block
{
    NSString *apiSearchURLWithParams = [NSString stringWithFormat:@"%@%@/%@/%ld/%ld", [Config apiURL], userParkedCarAPI, [Config apiKey], userID, roadSideID];
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
             //NSLog(@"ParkCarReturnString: %@", returnString);
             
             if (returnCode > 0)
             {
                 [UserSessionManger setParkedRoadSideID:roadSideID];
             }
             else
             {
                 NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                 [errorDetail setValue:@"An error occured while parking car." forKey:NSLocalizedDescriptionKey];
                 error = [NSError errorWithDomain:@"UserParkCarError" code:1 userInfo:errorDetail];
             }
         }
         
         if (block)
         {
             block(error);
         }
     }];
    [pageRequest start];
}


+ (void)userUnparkedWithUserID:(NSInteger)userID
                    completion:(void (^)(NSError *))block
{
    NSString *apiSearchURLWithParams = [NSString stringWithFormat:@"%@%@/%@/%ld", [Config apiURL], userUnparkedCarAPI, [Config apiKey], userID];
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
             //NSLog(@"UnparkCarReturnString: %@", returnString);
             
             if (returnCode > 0)
             {
                 [UserSessionManger setParkedRoadSideID:0];
             }
             else
             {
                 NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                 [errorDetail setValue:@"An error occured while unparking car." forKey:NSLocalizedDescriptionKey];
                 error = [NSError errorWithDomain:@"UserUnparkCarError" code:1 userInfo:errorDetail];
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
