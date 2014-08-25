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


#import "MapRoadSide.h"
#import "Utility.h"

#define ToRadian(x) ((x) * M_PI/180)
#define ToDegrees(x) ((x) * 180/M_PI)

#define ROAD_STATUS_CODE_SNOWED             0
#define ROAD_STATUS_CODE_CLEARED            1
#define ROAD_STATUS_CODE_PLANNED            2
#define ROAD_STATUS_CODE_REPLANNED          3
#define ROAD_STATUS_CODE_WILLBEREPLANNED    4
#define ROAD_STATUS_CODE_NOPARKING          5



#pragma mark - Private Interface

@interface MapRoadSide (Private)

- (CLLocation *)calculateMiddleCoordinate:(NSArray *)coordinates;
- (CLLocationCoordinate2D)midpointBetweenCoordinate:(CLLocationCoordinate2D)c1
                                      andCoordinate:(CLLocationCoordinate2D)c2;
- (RoadSideStatus)roadSideStatusForStatusCode:(NSInteger)statusCode;
- (void)setRoadStatusForCurrentStatusCodeAndPlannedDates;
- (NSDate *)dateForParamSQLDate:(NSString *)paramDate;
- (BOOL)checkIfCurrentTimeIsDuringPlannedOrReplannedTime;

@end



#pragma mark - Public Implementation

@implementation MapRoadSide

- (NSString *)description
{
    NSString *description = [[NSString alloc] init];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"RoadSideID: %ld\n", [self roadSideID]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"RoadID: %ld\n", [self roadID]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StreetName: %@\n", [self streetName]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StreetOn: %@\n", [self streetOn]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StreetFrom: %@\n", [self streetFrom]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StreetTo: %@\n", [self streetTo]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StartAddress: %@\n", [self startAddress]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"EndAddress: %@\n", [self endAddress]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"Orientation: %@\n", [self orientation]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"Link: %@\n", [self link]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"Borough: %@\n", [self borough]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StreetType: %@\n", [self streetType]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"TrafficOrientation: %ld\n", [self trafficOrientation]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"RoadStatus: %ld\n", [self status]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"DatePlannedStart: %@\n", [[self plannedDateStart] description]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"DatePlannedEnd: %@\n", [[self plannedDatedEnd] description]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"DateReplannedStart: %@\n", [[self replannedDateStart] description]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"DateReplanedEnd: %@\n", [[self replannedDateEnd] description]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"StreetTo: %@\n", [self streetTo]]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"MiddleCoord:%@\n", [[self middleLocation] description]]];
    
    description = [description stringByAppendingString:[NSString stringWithFormat:@"Coordinates:\n"]];
    for (CLLocation *location in [self coordinates])
    {
        description = [description stringByAppendingString:[NSString stringWithFormat:@"%@\n", [location description]]];
    }
    
    return description;
}


- (void)parseFromJSONDic:(NSDictionary *)jsonDic
{
    [self setRoadSideID:[[jsonDic objectForKey:@"RoadSideID"] integerValue]];
    [self setRoadID:[[jsonDic objectForKey:@"RoadID"] integerValue]];
    [self setStreetName:[jsonDic objectForKey:@"StreetName"]];
    [self setStreetOn:[jsonDic objectForKey:@"StreetOn"]];
    [self setStreetFrom:[jsonDic objectForKey:@"StreetFrom"]];
    [self setStreetTo:[jsonDic objectForKey:@"StreetTo"]];
    [self setStartAddress:[jsonDic objectForKey:@"StartAddress"]];
    [self setEndAddress:[jsonDic objectForKey:@"EndAddress"]];
    [self setOrientation:[jsonDic objectForKey:@"Orientation"]];
    [self setLink:[jsonDic objectForKey:@"LienF"]];
    [self setBorough:[jsonDic objectForKey:@"Borough"]];
    [self setStreetType:[jsonDic objectForKey:@"Type"]];
    [self setTrafficOrientation:[[jsonDic objectForKey:@"CirculationCode"] integerValue]];
    [self setStatus:[[jsonDic objectForKey:@"RoadStatus"] integerValue]];
    [self setScheduledDate:[self dateForParamSQLDate:[jsonDic objectForKey:@"DatePlannedStart"]]];
    [self setRoadStatus:[self roadSideStatusForStatusCode:[self status]]];
    [self setPlannedDateStart:[self dateForParamSQLDate:[jsonDic objectForKey:@"DatePlannedStart"]]];
    [self setPlannedDatedEnd:[self dateForParamSQLDate:[jsonDic objectForKey:@"DatePlannedEnd"]]];
    [self setReplannedDateStart:[self dateForParamSQLDate:[jsonDic objectForKey:@"DateReplannedStart"]]];
    [self setReplannedDateEnd:[self dateForParamSQLDate:[jsonDic objectForKey:@"DateReplannedEnd"]]];
    
    NSMutableArray *coordinatesMut = [[NSMutableArray alloc] init];
    NSArray *geoPointsJSONArray = [jsonDic objectForKey:@"GeoPoints"];
    for (NSDictionary *geoPointDic in geoPointsJSONArray)
    {
        CLLocationDegrees latitude = [[geoPointDic objectForKey:@"Latitude"] doubleValue];
        CLLocationDegrees longitude = [[geoPointDic objectForKey:@"Longitude"] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [coordinatesMut addObject:location];
    }
    [self setCoordinates:[NSArray arrayWithArray:coordinatesMut]];
    
    [self setMiddleLocation:[self calculateMiddleCoordinate:[self coordinates]]];
    
    [self setRoadStatusForCurrentStatusCodeAndPlannedDates];
}

@end




#pragma mark - Private Implementation

@implementation MapRoadSide (Private)

- (CLLocation *)calculateMiddleCoordinate:(NSArray *)coordinates
{
    CLLocation *middleLocation = nil;
    
    if ([coordinates count] > 0)
    {
        double count = (double)[coordinates count];
        double middleIndex = (count-1)/2;
        int floorIndex = floor(middleIndex);
        int ceilIndex = ceil(middleIndex);
        CLLocation *floorLocation = [coordinates objectAtIndex:floorIndex];
        CLLocation *ceilLocation = [coordinates objectAtIndex:ceilIndex];
        CLLocationCoordinate2D middleCoordinate2D = [self midpointBetweenCoordinate:[floorLocation coordinate] andCoordinate:[ceilLocation coordinate]];
        middleLocation = [[CLLocation alloc] initWithLatitude:middleCoordinate2D.latitude longitude:middleCoordinate2D.longitude];
    }
    
    return middleLocation;
}


- (CLLocationCoordinate2D)midpointBetweenCoordinate:(CLLocationCoordinate2D)c1
                                      andCoordinate:(CLLocationCoordinate2D)c2
{
    c1.latitude = ToRadian(c1.latitude);
    c2.latitude = ToRadian(c2.latitude);
    CLLocationDegrees dLon = ToRadian(c2.longitude - c1.longitude);
    CLLocationDegrees bx = cos(c2.latitude) * cos(dLon);
    CLLocationDegrees by = cos(c2.latitude) * sin(dLon);
    CLLocationDegrees latitude = atan2(sin(c1.latitude) + sin(c2.latitude), sqrt((cos(c1.latitude) + bx) * (cos(c1.latitude) + bx) + by*by));
    CLLocationDegrees longitude = ToRadian(c1.longitude) + atan2(by, cos(c1.latitude) + bx);
    
    CLLocationCoordinate2D midpointCoordinate;
    midpointCoordinate.longitude = ToDegrees(longitude);
    midpointCoordinate.latitude = ToDegrees(latitude);
    
    return midpointCoordinate;
}


- (RoadSideStatus)roadSideStatusForStatusCode:(NSInteger)statusCode
{
    RoadSideStatus roadSideStatus;
    
    if (statusCode == ROAD_STATUS_CODE_SNOWED)
    {
        roadSideStatus = RoadSideStatusSnowed;
    }
    else if (statusCode == ROAD_STATUS_CODE_CLEARED)
    {
        roadSideStatus = RoadSideStatusCleared;
    }
    else if (statusCode == ROAD_STATUS_CODE_PLANNED)
    {
        roadSideStatus = RoadSideStatusScheduled;
    }
    else if (statusCode == ROAD_STATUS_CODE_REPLANNED)
    {
        roadSideStatus = RoadSideStatusRescheduled;
    }
    
    return roadSideStatus;
}


- (void)setRoadStatusForCurrentStatusCodeAndPlannedDates
{
    RoadSideStatus roadSideStatus;
    
    if ([self status] == ROAD_STATUS_CODE_SNOWED)
    {
        roadSideStatus = RoadSideStatusSnowed;
    }
    else if ([self status] == ROAD_STATUS_CODE_CLEARED)
    {
        roadSideStatus = RoadSideStatusCleared;
    }
    else if ([self status] == ROAD_STATUS_CODE_PLANNED)
    {
        roadSideStatus = RoadSideStatusScheduled;
    }
    else if ([self status] == ROAD_STATUS_CODE_REPLANNED)
    {
        roadSideStatus = RoadSideStatusRescheduled;
    }
    else if ([self status] == ROAD_STATUS_CODE_WILLBEREPLANNED)
    {
        roadSideStatus = RoadSideStatusWillBeRescheduled;
    }
    
    if ([self status] == ROAD_STATUS_CODE_REPLANNED || [self status] == ROAD_STATUS_CODE_PLANNED)
    {
        if ([self checkIfCurrentTimeIsDuringPlannedOrReplannedTime])
        {
            [self setRoadStatus:RoadSideStatusNoParking];
        }
    }
}


- (NSDate *)dateForParamSQLDate:(NSString *)paramDate
{
    NSDate *dateValue = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    dateValue = [formatter dateFromString:paramDate];
    
    return dateValue;
}


- (BOOL)checkIfCurrentTimeIsDuringPlannedOrReplannedTime
{
    BOOL isDuringNoParkingTime = false;
    
    if ([self status] == ROAD_STATUS_CODE_PLANNED)
    {
        isDuringNoParkingTime = [Utility isDate:[NSDate date] inRangeFirstDate:[self plannedDateStart] lastDate:[self plannedDatedEnd]];
    }
    else if ([self status] == ROAD_STATUS_CODE_REPLANNED)
    {
        isDuringNoParkingTime = [Utility isDate:[NSDate date] inRangeFirstDate:[self replannedDateStart] lastDate:[self replannedDateEnd]];
    }
    
    return isDuringNoParkingTime;
}

@end
