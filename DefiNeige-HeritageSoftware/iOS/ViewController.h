

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
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.




#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapRoadSideStore.h"
#import "MapRoadSide.h"


@interface ViewController : UIViewController<UIViewControllerAnimatedTransitioning,
                                            UIViewControllerTransitioningDelegate,
                                            MKMapViewDelegate>

@property (strong,nonatomic) NSArray *roads;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOverlayConstraint;

@property (nonatomic) BOOL didDisplayRoads;

@property (strong,nonatomic) MapRoadSide *selectedRoadSide;

@property (strong,nonatomic) MapRoadSide *parkedRoadSide;

@property (weak, nonatomic) IBOutlet UILabel *streetNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromStreetLabel;

@property (weak, nonatomic) IBOutlet UILabel *toStreetLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (weak, nonatomic) IBOutlet UIButton *parkingButton;

@property (weak, nonatomic) IBOutlet UIButton *parkButton;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic) BOOL receivedNotification;

@property (strong,nonatomic) CLLocationManager *manager;


@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;

@property (nonatomic) BOOL didHandlePushNotification;


@property (weak,nonatomic) MKPointAnnotation *parkingAnnotation;

@property (strong,nonatomic) MKMapCamera *previousCamera;

@end
