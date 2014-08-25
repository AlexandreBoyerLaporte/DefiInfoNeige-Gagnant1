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


#import "MapRoadSideStore.h"
#import "PageRequest.h"
#import "Config.h"

static NSString *searchRoadSidesNearLocationAPI = @"searchRoadSidesNearLocation";
static NSString *getRoadSideForRoadSideIDAPI = @"getRoadSideForRoadSideID";



#pragma mark - Private Interface

@interface MapRoadSideStore (Private)

+ (NSArray *)mapRoadSidesFromParsedJSON:(NSData *)jsonData;

+ (MapRoadSide *)mapRoadSideFromParsedJSON:(NSData *)jsonData;

@end



#pragma mark - Public Implementation

@implementation MapRoadSideStore

+ (void)mapRoadSidesNearLocation:(CLLocationCoordinate2D)location
                      completion:(void (^)(NSArray *, NSError *))block
{
    NSString *apiSearchURLWithParams = [NSString stringWithFormat:@"%@/%@/%@/%f/%f", [Config apiURL], searchRoadSidesNearLocationAPI, [Config apiKey], location.longitude, location.latitude];
    NSURL *url = [NSURL URLWithString:apiSearchURLWithParams];
    
    PageRequest *pageRequest  = [[PageRequest alloc] init];
    [pageRequest setUpConnectionForURL:url postParamaters:nil completion:^(NSMutableData *data, NSError *error)
    {
        NSArray *mapRoadSides = nil;
        
        if (!error)
        {
            //NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"ReturnString: %@", returnString);
            
            mapRoadSides = [MapRoadSideStore mapRoadSidesFromParsedJSON:data];
        }
        
        if (block)
        {
            block(mapRoadSides,error);
        }
    }];
    [pageRequest start];
}


+ (void)mapRoadSideForRoadSideID:(NSInteger)roadSideID
                      completion:(void (^)(MapRoadSide *, NSError *))block
{
    NSString *apiSearchURLWithParams = [NSString stringWithFormat:@"%@/%@/%@/%ld", [Config apiURL], getRoadSideForRoadSideIDAPI, [Config apiKey], roadSideID];
    NSURL *url = [NSURL URLWithString:apiSearchURLWithParams];
    
    PageRequest *pageRequest  = [[PageRequest alloc] init];
    [pageRequest setUpConnectionForURL:url postParamaters:nil completion:^(NSMutableData *data, NSError *error)
     {
         MapRoadSide *mapRoadSide = nil;
         
         if (!error)
         {
             //NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             //NSLog(@"ReturnString: %@", returnString);
             
             mapRoadSide = [MapRoadSideStore mapRoadSideFromParsedJSON:data];
         }
         
         if (block)
         {
             block(mapRoadSide,error);
         }
     }];
    [pageRequest start];
}

@end



#pragma mark - Private Implementation

@implementation MapRoadSideStore (Private)

+ (NSArray *)mapRoadSidesFromParsedJSON:(NSData *)jsonData
{
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:&error];
    
    NSMutableArray *mapRoadSidesMut = [[NSMutableArray alloc] init];
    
    for (NSDictionary *mapRoadSideDic in jsonArray)
    {
        MapRoadSide *mapRoadSide = [[MapRoadSide alloc] init];
        [mapRoadSide parseFromJSONDic:mapRoadSideDic];
        [mapRoadSidesMut addObject:mapRoadSide];
    }
    
    NSArray *mapRoadSides = [NSArray arrayWithArray:mapRoadSidesMut];
    
    return mapRoadSides;
}


+ (MapRoadSide *)mapRoadSideFromParsedJSON:(NSData *)jsonData
{
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:0
                                                              error:&error];
    
    MapRoadSide *mapRoadSide = [[MapRoadSide alloc] init];
    [mapRoadSide parseFromJSONDic:jsonDic];
    
    return mapRoadSide;
}

@end
