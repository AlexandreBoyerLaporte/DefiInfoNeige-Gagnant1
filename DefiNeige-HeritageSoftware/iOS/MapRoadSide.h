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


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef enum
{
    RoadSideStatusCleared,
    RoadSideStatusScheduled,
    RoadSideStatusRescheduled,
    RoadSideStatusWillBeRescheduled,
    RoadSideStatusSnowed,
    RoadSideStatusNoParking
}RoadSideStatus;


@interface MapRoadSide : NSObject

@property (nonatomic)           NSInteger roadSideID;
@property (nonatomic)           NSInteger roadID;
@property (strong,nonatomic)    NSString *streetOn;
@property (strong,nonatomic)    NSString *streetFrom;
@property (strong,nonatomic)    NSString *streetTo;
@property (strong,nonatomic)    NSString *startAddress;
@property (strong,nonatomic)    NSString *endAddress;
@property (strong,nonatomic)    NSString *orientation;
@property (strong,nonatomic)    NSString *streetName;
@property (strong,nonatomic)    NSString *link;
@property (strong,nonatomic)    NSString *borough;
@property (strong,nonatomic)    NSString *streetType;
@property (nonatomic)           NSInteger trafficOrientation;
@property (strong,nonatomic)    NSDate *scheduledDate;
@property (nonatomic)           NSInteger status;
@property (strong,nonatomic)    NSDate *plannedDateStart;
@property (strong,nonatomic)    NSDate *plannedDatedEnd;
@property (strong,nonatomic)    NSDate *replannedDateStart;
@property (strong,nonatomic)    NSDate *replannedDateEnd;
@property (nonatomic)           RoadSideStatus roadStatus;
@property (nonatomic)           CLLocation *middleLocation;
@property (strong,nonatomic)    NSArray *coordinates;

- (void)parseFromJSONDic:(NSDictionary *)jsonDic;

@end
