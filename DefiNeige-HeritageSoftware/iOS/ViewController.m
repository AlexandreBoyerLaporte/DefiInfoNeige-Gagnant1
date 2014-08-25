
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


#import "ViewController.h"
#import "InfoController.h"
#import "RoadCell.h"
#import "RoadSideCell.h"
#import "RoadSidePolyline.h"
#import "RoadSideAnnotation.h"
#import "SupportController.h"
#import "UserActionManager.h"
#import "UserSessionManger.h"
#import "PushNotificationUtility.h"

@interface ViewController ()

@end

@implementation ViewController

static CLLocationDistance defaultDistance = 1200;

+ (NSDateFormatter *) sharedFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter)
    {
        NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_CA"];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setLocale:frLocale];
        
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    MKMapCamera *camera = [MKMapCamera camera];
  
    [camera setCenterCoordinate:CLLocationCoordinate2DMake(45.4960399, -73.5539902)];
    
    [camera setAltitude:defaultDistance];
    
    [[self mapView] setCamera:camera
                     animated:NO];
    
    [[self mapView] setShowsUserLocation:YES];
    
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"Nav_Bg"]
                                                      forBarMetrics:UIBarMetricsDefault];
//
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:43.f/255.f
                                                                              green:55.f/255.f
                                                                               blue:79.f/255.f
                                                                              alpha:1]];
//
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

    
    [self setTitle:@"Info Neige"];
    

    
    [self configureOverlayViewWithSelectedRoadSide:[self selectedRoadSide]
                                          animated:NO
                        shouldPerformHideAnimation:NO];
    
    if (![self parkedRoadSide])
    {
        [[self parkingButton] setHidden:YES];
    }
    
    [[self parkingButton] setImage:[[UIImage imageNamed:@"P_Sign"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                          forState:UIControlStateNormal];
    
    [[[self parkingButton] imageView] setTintColor:[UIColor whiteColor]];
    
    
    UIImage *parkingButtonBackgroundImage = [[self parkingButton] backgroundImageForState:UIControlStateNormal];
    
    [[self parkingButton] setBackgroundImage:[parkingButtonBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                   forState:UIControlStateNormal];
    
    
    [[self parkButton] setBackgroundImage:[[UIImage imageNamed:@"Button_Park"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                    forState:UIControlStateNormal];
    
    [[self parkButton] setBackgroundImage:[[UIImage imageNamed:@"Button_Unpark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                 forState:UIControlStateSelected];
    
    UIImage *searchButtonBackgroundImage = [[self searchButton] backgroundImageForState:UIControlStateNormal];
    
    [[self searchButton] setBackgroundImage:[searchButtonBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                   forState:UIControlStateNormal];
    
    UIImage *targetImage = [[UIImage imageNamed:@"Target"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [[[self searchButton] imageView] setTintColor:[UIColor whiteColor]];
    
    [[self searchButton] setImage:targetImage
                         forState:UIControlStateNormal];
    
    [[self userLocationButton] setImage:[UIImage imageNamed:@"Icon_Localisation"]
                               forState:UIControlStateNormal];
    
    [[self userLocationButton] setImage:[UIImage imageNamed:@"Icon_Localisation-1"]
                               forState:UIControlStateSelected];
    
    [[self userLocationButton] setBackgroundImage:[UIImage imageNamed:@"Button_Localisation_Blue"]
                                         forState:UIControlStateNormal];
    
    [[self userLocationButton] setBackgroundImage:[UIImage imageNamed:@"Button_Localisation_White"]
                                         forState:UIControlStateSelected];
    
    
    [self searchArea:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived)
                                                 name:pushNotificationID
                                               object:nil];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([PushNotificationUtility pushNotificationType] == PushNotificationTypeNotRunning && ![self didHandlePushNotification])
    {
        
        [self setDidHandlePushNotification:YES];
        
        if ([UserSessionManger parkedRoadSideID])
        {
            [MapRoadSideStore mapRoadSideForRoadSideID:[UserSessionManger parkedRoadSideID]
                                            completion:^(MapRoadSide *mapRoadSide, NSError *error) {
                                                
                                                if (!error)
                                                {
                                                    [self setParkedRoadSide:mapRoadSide];
                                                    
                                                    [[self mapView] removeAnnotation:[self parkingAnnotation]];
                                                    
                                                    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
                                                    
                                                    [pointAnnotation setCoordinate:[[[self parkedRoadSide] middleLocation] coordinate]];
                                                    
                                                    [[self mapView] addAnnotation:pointAnnotation];
                                                    
                                                    [self setParkingAnnotation:pointAnnotation];
                                                    
                                                    if ([[self parkedRoadSide] roadStatus] == RoadSideStatusCleared)
                                                    {
                                                        [[self parkingButton] setTintColor:[UIColor colorWithRed:69.f/255.f
                                                                                                           green:148.f/255.f
                                                                                                            blue:75.f/255.f
                                                                                                           alpha:0.9]];
                                                    }
                                                    else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusSnowed)
                                                    {
                                                        [[self parkingButton] setTintColor:[UIColor colorWithRed:32.f/255.f
                                                                                                           green:174.f/255.f
                                                                                                            blue:239.f/255.f
                                                                                                           alpha:0.9]];
                                                    }
                                                    else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusScheduled)
                                                    {
                                                        [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                           green:171.f/255.f
                                                                                                            blue:2.f/255.f
                                                                                                           alpha:0.9]];
                                                        
                                                    }
                                                    else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusRescheduled)
                                                    {
                                                        [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                           green:171.f/255.f
                                                                                                            blue:2.f/255.f
                                                                                                           alpha:0.9]];
                                                    }
                                                    else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusWillBeRescheduled)
                                                    {
                                                        [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                           green:171.f/255.f
                                                                                                            blue:2.f/255.f
                                                                                                           alpha:0.9]];
                                                    }
                                                    else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusNoParking)
                                                    {
                                                        [[self parkingButton] setTintColor:[UIColor colorWithRed:166.f/255.f
                                                                                                           green:42.f/255.f
                                                                                                            blue:42.f/255.f
                                                                                                           alpha:0.9]];
                                                    }
                                                    
                                                    [[self parkingButton] setHidden:NO];
                                                    
                                                    [self parkinTouhched:nil];
                                                    
                                                    [self configureOverlayViewWithSelectedRoadSide:[self parkedRoadSide]
                                                                                          animated:YES
                                                                        shouldPerformHideAnimation:NO];
                                                }
                                            }];
        }
    }
}





- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) notificationReceived
{

    if ([UserSessionManger parkedRoadSideID])
    {
        [MapRoadSideStore mapRoadSideForRoadSideID:[UserSessionManger parkedRoadSideID]
                                        completion:^(MapRoadSide *mapRoadSide, NSError *error) {

                                            if (!error)
                                            {
                                                [self setParkedRoadSide:mapRoadSide];
                                                
                                                [[self mapView] removeAnnotation:[self parkingAnnotation]];

                                                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];

                                                [pointAnnotation setCoordinate:[[[self parkedRoadSide] middleLocation] coordinate]];

                                                [[self mapView] addAnnotation:pointAnnotation];

                                                [self setParkingAnnotation:pointAnnotation];

                                                if ([[self parkedRoadSide] roadStatus] == RoadSideStatusCleared)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:69.f/255.f
                                                                                                       green:148.f/255.f
                                                                                                        blue:75.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusSnowed)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:32.f/255.f
                                                                                                       green:174.f/255.f
                                                                                                        blue:239.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusScheduled)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                       green:171.f/255.f
                                                                                                        blue:2.f/255.f
                                                                                                       alpha:0.9]];
                                                    
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusRescheduled)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                       green:171.f/255.f
                                                                                                        blue:2.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusWillBeRescheduled)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                       green:171.f/255.f
                                                                                                        blue:2.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusNoParking)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:166.f/255.f
                                                                                                       green:42.f/255.f
                                                                                                        blue:42.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                
                                                [[self parkingButton] setHidden:NO];
                                            }
                                        }];
    }
}


- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *) childViewControllerForStatusBarStyle
{
    return nil;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue
                  sender:(id)sender
{
    UIViewController *controller = [segue destinationViewController];
    
    [controller setTransitioningDelegate:self];
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[InfoController class]])
    {
        InfoController *controller = (InfoController *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIGraphicsBeginImageContextWithOptions([[self view] bounds].size, NO, 0);
        
        [[self view] drawViewHierarchyInRect:[[self view] frame]
                          afterScreenUpdates:YES];
        
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIImage *image = snapshotImage;
        

        [[controller backgroundImageView] setImage:image];
        
        [[transitionContext containerView] addSubview:[controller view]];
        
        [[controller view] setAlpha:0];
        
        [[controller containerView] setTransform:CGAffineTransformMakeScale(2, 2)];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [[controller view] setAlpha:1];
                             
                             [[controller containerView] setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished) {
                             
                             
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    else if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[InfoController class]])
    {
        ViewController *viewController = (ViewController *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        InfoController *controller     = (InfoController *) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [[transitionContext containerView] addSubview:[viewController view]];
        
        [[transitionContext containerView] addSubview:[controller view]];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [[controller view] setAlpha:0];
                             
                             [[controller containerView] setTransform:CGAffineTransformMakeScale(2, 2)];;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    else if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[SupportController class]])
    {
        SupportController *controller = (SupportController *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIGraphicsBeginImageContextWithOptions([[self view] bounds].size, NO, 0);
        
        [[self view] drawViewHierarchyInRect:[[self view] frame]
                          afterScreenUpdates:YES];
        
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIImage *image = snapshotImage;
        
        [[controller backgroundImageView] setImage:image];
        
        [[transitionContext containerView] addSubview:[controller view]];
        
        [[controller view] setAlpha:0];
        
        [[controller containerView] setTransform:CGAffineTransformMakeScale(2, 2)];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [[controller view] setAlpha:1];
                             
                             [[controller containerView] setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished) {
                             
                             
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    else if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[SupportController class]])
    {
        ViewController *viewController = (ViewController *) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        SupportController *controller     = (SupportController *) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [[transitionContext containerView] addSubview:[viewController view]];
        
        [[transitionContext containerView] addSubview:[controller view]];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             [[controller view] setAlpha:0];
                             
                             [[controller containerView] setTransform:CGAffineTransformMakeScale(2, 2)];;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    
}


- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[RoadSidePolyline class]])
    {
        MapRoadSide *side = nil;
        
        for (MapRoadSide *currentRoad in [self roads])
        {
            if ([currentRoad roadSideID] == [(RoadSidePolyline *) overlay roadSideID])
            {
                side = currentRoad;
            }
        }
        
        if (!side)
        {
            side = [self parkedRoadSide];
        }

        MKPolyline *route = overlay;
        
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        
        [routeRenderer setLineWidth:5];
        
        [routeRenderer setLineCap:kCGLineCapSquare];
        
        routeRenderer.strokeColor = [self colorForRoadStatus:[side roadStatus]];
        
        return routeRenderer;
    }
        
    return nil;
}

- (void) mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([[view annotation] isKindOfClass:[RoadSideAnnotation class]])
    {
        if ([[self parkedRoadSide] roadSideID] == [(RoadSideAnnotation *)[view annotation] roadSideID])
        {
            BOOL shouldDoHidingAnimation = NO;
            
            if ([self selectedRoadSide])
            {
                shouldDoHidingAnimation = YES;
            }
            
            [self setPreviousCamera:[[self mapView] camera]];
            
            MKMapCamera *camera = [MKMapCamera camera];
            
            CLLocationCoordinate2D coordinate = [[view annotation] coordinate];
            
            coordinate.latitude -= 0.0005;
            
            [camera setCenterCoordinate:coordinate];
            
            [camera setAltitude:500];
            
            
            [[self mapView] setCamera:camera
                             animated:YES];
            
            
            [self configureOverlayViewWithSelectedRoadSide:[self parkedRoadSide]
                                                  animated:YES
                                shouldPerformHideAnimation:shouldDoHidingAnimation];
            
            
            [self setSelectedRoadSide:[self parkedRoadSide]];
            
            [self updateOverlays];
        }
        else
        {
            for (MapRoadSide *currentRoad in [self roads])
            {
                if ([(RoadSideAnnotation *)[view annotation] roadSideID] == [currentRoad roadSideID])
                {
                    BOOL shouldDoHidingAnimation = NO;
                    
                    if ([self selectedRoadSide])
                    {
                        shouldDoHidingAnimation = YES;
                    }
                    
                    [self setPreviousCamera:[[self mapView] camera]];
                    
                    MKMapCamera *camera = [MKMapCamera camera];
                    
                    CLLocationCoordinate2D coordinate = [[view annotation] coordinate];
                    
                    coordinate.latitude -= 0.0005;
                    
                    [camera setCenterCoordinate:coordinate];
                    
                    [camera setAltitude:500];
                    
                    
                    [[self mapView] setCamera:camera
                                     animated:YES];
                    
                    
                    [self configureOverlayViewWithSelectedRoadSide:currentRoad
                                                          animated:YES
                                        shouldPerformHideAnimation:shouldDoHidingAnimation];
                    
                    
                    [self setSelectedRoadSide:currentRoad];
                    
                    [self updateOverlays];
                    
                    break;
                }
            }
        }
    }
}


- (void) mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self setSelectedRoadSide:nil];
    
    [self updateOverlays];
    
    if ([self previousCamera])
    {
        [[self previousCamera] setAltitude:defaultDistance];
        
        [[self mapView] setCamera:[self previousCamera]
                         animated:YES];
    }
    
    [self setPreviousCamera:nil];
    
    [self configureOverlayViewWithSelectedRoadSide:nil
                                          animated:YES
                        shouldPerformHideAnimation:NO];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
        
    }
    else if ([annotation isKindOfClass:[RoadSideAnnotation class]])
    {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"RoadSideID"];

        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"RoadSideID"];
        }

        for (MapRoadSide *currentRoad in [self roads])
        {
            if ([(RoadSideAnnotation *)annotation roadSideID] == [currentRoad roadSideID])
            {
                [annotationView setImage:[self annotationImageForRoadStatus:[currentRoad roadStatus]]];

                break;
            }
        }
        
        if ([(RoadSideAnnotation *)annotation roadSideID] == [[self parkedRoadSide] roadSideID])
        {
            [annotationView setImage:[self annotationImageForRoadStatus:[[self parkedRoadSide] roadStatus]]];
        }
        
        if ([self selectedRoadSide])
        {
            if ([(RoadSideAnnotation *) annotation roadSideID] == [[self selectedRoadSide] roadSideID])
            {
                [annotationView setAlpha:1];
            }
            else
            {
                [annotationView setAlpha:0];
            }
        }
        else
        {
            [annotationView setAlpha:1];
        }
    
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:@"ParkingSpace"];
        
        [annotationView setImage:[UIImage imageNamed:@"Pin_Parking"]];
        
        [annotationView setCenterOffset:CGPointMake(0, -15)];
        
        return annotationView;
    }
    
    return nil;
}



- (void) mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D userLocation = [[[[self mapView] userLocation] location] coordinate];
    
    CLLocationCoordinate2D mapCenter = [[self mapView] centerCoordinate];
    
    if (userLocation.latitude != mapCenter.latitude || userLocation.longitude != mapCenter.latitude)
    {
        [[self userLocationButton] setSelected:NO];
    }
}

- (IBAction)searchArea:(id)sender
{
    
    NSMutableArray *overlays = [[NSMutableArray alloc] init];
    
    for (id<MKOverlay> overlay in [[self mapView] overlays])
    {
        if ([overlay isKindOfClass:[RoadSidePolyline class]])
        {
            if ([(RoadSidePolyline *) overlay roadSideID] != [[self parkedRoadSide] roadSideID])
            {
                [overlays addObject:overlay];
            }
        }
    }
    
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (id<MKAnnotation> annotation in [[self mapView] annotations])
    {
        if ([annotation  isKindOfClass:[RoadSideAnnotation class]])
        {
            if ([(RoadSideAnnotation *) annotation roadSideID] != [[self parkedRoadSide] roadSideID])
            {
                    [annotations addObject:annotation];
            }
        }
    }

    [[self mapView] removeOverlays:overlays];
    
    [[self mapView] removeAnnotations:annotations];
    
    MKMapCamera *camera = [MKMapCamera camera];
    
    [camera setCenterCoordinate:[[self mapView] centerCoordinate]];
    
    [camera setAltitude:defaultDistance];
    
    [[self mapView] setCamera:camera
                     animated:YES];
    
    UIImage *animatingImage = [UIImage animatedImageNamed:@"loading"
                                                 duration:1];
    
    [[self searchButton] setImage:animatingImage
                         forState:UIControlStateNormal];
    
    if ([UserSessionManger parkedRoadSideID])
    {
    
        [MapRoadSideStore mapRoadSideForRoadSideID:[UserSessionManger parkedRoadSideID]
                                        completion:^(MapRoadSide *mapRoadSide, NSError *error) {
                                            
                                            if (!error)
                                            {
                                                [self setParkedRoadSide:mapRoadSide];
                                                
                                                [[self mapView] removeAnnotation:[self parkingAnnotation]];
                                                
                                                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
                                                
                                                [pointAnnotation setCoordinate:[[[self parkedRoadSide] middleLocation] coordinate]];
                                                
                                                [[self mapView] addAnnotation:pointAnnotation];
                                                
                                                [self setParkingAnnotation:pointAnnotation];
                                                
                                                if ([[self parkedRoadSide] roadStatus] == RoadSideStatusCleared)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:69.f/255.f
                                                                                                       green:148.f/255.f
                                                                                                        blue:75.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusSnowed)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:32.f/255.f
                                                                                                       green:174.f/255.f
                                                                                                        blue:239.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusScheduled)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                       green:171.f/255.f
                                                                                                        blue:2.f/255.f
                                                                                                       alpha:0.9]];
                                                    
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusRescheduled)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                       green:171.f/255.f
                                                                                                        blue:2.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusWillBeRescheduled)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                                                                       green:171.f/255.f
                                                                                                        blue:2.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusNoParking)
                                                {
                                                    [[self parkingButton] setTintColor:[UIColor colorWithRed:166.f/255.f
                                                                                                       green:42.f/255.f
                                                                                                        blue:42.f/255.f
                                                                                                       alpha:0.9]];
                                                }
                                                
                                                [[self parkingButton] setHidden:NO];
                                            }
                                        }];
    }
    
    [MapRoadSideStore mapRoadSidesNearLocation:[[self mapView] centerCoordinate]
                                    completion:^(NSArray *mapRoadSides, NSError *error)
                                    {
                                        if ([mapRoadSides count])
                                        {
                                            [self setRoads:mapRoadSides];
                                            [self displayRoadsWithSelectedRoad:nil];
                                        }
                                        else
                                        {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aucune donnée disponible"
                                                                                            message:@"Aucune donnée n'est disponible pour cette endroit."
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil];
                                            [alert show];
                                        }
                                        
                                        UIImage *targetImage = [[UIImage imageNamed:@"Target"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                        
                                        
                                        [[self searchButton] setImage:targetImage
                                                             forState:UIControlStateNormal];
                                        
                                    }];
}


- (IBAction)goToMyLocation:(id)sender
{
    MKMapCamera *camera = [MKMapCamera camera];
    
    [camera setCenterCoordinate:[[[[self mapView] userLocation] location] coordinate]];
    
    [camera setAltitude:defaultDistance];
    
    [[self mapView] setCamera:camera
                     animated:YES];
    
    [[self userLocationButton] setSelected:YES];
}


- (IBAction)park:(id)sender
{
    if (   [[self selectedRoadSide] roadSideID] != [[self parkedRoadSide] roadSideID]
        || ![self parkedRoadSide])
    {
        [self setParkedRoadSide:[self selectedRoadSide]];
        
        [[self parkingButton] setHidden:NO];
        
        [sender setSelected:YES];
        
        [[self mapView] removeAnnotation:[self parkingAnnotation]];
        
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        
        [pointAnnotation setCoordinate:[[[self parkedRoadSide] middleLocation] coordinate]];
        
        [[self mapView] addAnnotation:pointAnnotation];
        
        [self setParkingAnnotation:pointAnnotation];
        
        if ([[self parkedRoadSide] roadStatus] == RoadSideStatusCleared)
        {
            [[self parkingButton] setTintColor:[UIColor colorWithRed:69.f/255.f
                                                               green:148.f/255.f
                                                                blue:75.f/255.f
                                                               alpha:0.9]];
        }
        else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusSnowed)
        {
            [[self parkingButton] setTintColor:[UIColor colorWithRed:32.f/255.f
                                                               green:174.f/255.f
                                                                blue:239.f/255.f
                                                               alpha:0.9]];
        }
        else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusScheduled)
        {
            [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                               green:171.f/255.f
                                                                blue:2.f/255.f
                                                               alpha:0.9]];
            
        }
        else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusRescheduled)
        {
            [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                               green:171.f/255.f
                                                                blue:2.f/255.f
                                                               alpha:0.9]];
        }
        else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusWillBeRescheduled)
        {
            [[self parkingButton] setTintColor:[UIColor colorWithRed:255.f/255.f
                                                               green:171.f/255.f
                                                                blue:2.f/255.f
                                                               alpha:0.9]];
        }
        else if ([[self parkedRoadSide]  roadStatus] == RoadSideStatusNoParking)
        {
            [[self parkingButton] setTintColor:[UIColor colorWithRed:166.f/255.f
                                                               green:42.f/255.f
                                                                blue:42.f/255.f
                                                               alpha:0.9]];
        }
        
        [UserActionManager userParkedOnRoadSideID:[[self parkedRoadSide] roadSideID]
                                       completion:^(NSError *error) {
                                           
                                       }];
    }
    else
    {
        [[self mapView] removeAnnotation:[self parkingAnnotation]];
        
        [self setParkingAnnotation:nil];
        
        [sender setSelected:NO];
        
        [[self parkingButton] setHidden:YES];
        
        [self setParkedRoadSide:nil];
        
        [UserActionManager userUnparkedWithCompletion:nil];
    }
    

}


- (IBAction)parkinTouhched:(id)sender
{
    if( [self parkingAnnotation])
    {
        [self setPreviousCamera:[[self mapView] camera]];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        MKMapCamera *camera = [MKMapCamera camera];
        
        [camera setCenterCoordinate:[[self parkingAnnotation] coordinate]];
        
        [camera setAltitude:500];
        
        [[self mapView] setCamera:camera
                         animated:YES];
        

        
        for (id<MKAnnotation> annotation in [[self mapView] annotations])
        {
            if ([annotation isKindOfClass:[RoadSideAnnotation class]])
            {
                if ([(RoadSideAnnotation *) annotation roadSideID] == [[self parkedRoadSide] roadSideID])
                {
                    [[self mapView] selectAnnotation:annotation
                                            animated:NO];
                }
            }
        }

    }
}




- (void) displayRoadsWithSelectedRoad:(MapRoadSide *) selectedRoad
{
    for (MapRoadSide *currentRoad in [self roads])
    {
        BOOL isRoadSelected = NO;
        
        if ([currentRoad roadSideID] == [selectedRoad roadSideID])
        {
            isRoadSelected = YES;
        }
        
        if ([currentRoad roadSideID] != [[self parkedRoadSide] roadSideID])
        {
            [self displayRoadSide:currentRoad
                         selected:isRoadSelected];
        }
    }
    
    [self displayRoadSide:[self parkedRoadSide]
                 selected:NO];
}





- (void) updateOverlays
{
    for (id<MKOverlay> overlay in [[self mapView] overlays])
    {
        MKOverlayPathRenderer *renderer = (MKOverlayPathRenderer *) [[self mapView] rendererForOverlay:overlay];
        
        if ([overlay isKindOfClass:[RoadSidePolyline class]])
        {
            if ([self selectedRoadSide])
            {
                if ([(RoadSidePolyline *) overlay roadSideID] == [[self selectedRoadSide] roadSideID])
                {
                    [renderer setAlpha:1];
                }
                else
                {
                    [renderer setAlpha:0.3];
                }
            }
            else
            {
                [renderer setAlpha:1];
            }
        }
    }
    
    for (id<MKAnnotation> annotation in [[self mapView] annotations])
    {
        MKAnnotationView *view = [[self mapView] viewForAnnotation:annotation];
        
        if ([annotation isKindOfClass:[RoadSideAnnotation class]])
        {
            if ([self selectedRoadSide])
            {
                if ([(RoadSideAnnotation *) annotation roadSideID] == [[self selectedRoadSide] roadSideID])
                {
                    [view setAlpha:1];
                }
                else
                {
                    [view setAlpha:0];
                }
            }
            else
            {
                [view setAlpha:1];
            }
        }
    }
}



- (void) displayRoadSide:(MapRoadSide *) side
                selected:(BOOL) isSelected
{
    CLLocationCoordinate2D coords[[[side coordinates] count]];
    
    for (NSInteger i = 0; i < [[side coordinates] count]; i++)
    {
        coords[i] = [[[side coordinates] objectAtIndex:i] coordinate];
    }
    
    RoadSidePolyline *polyline = [RoadSidePolyline polylineWithCoordinates:coords
                                                                     count:[[side coordinates] count]];
    
    [polyline setRoadSideID:[side roadSideID]];
    
    [[self mapView] addOverlay:polyline
                         level:MKOverlayLevelAboveRoads];
    
    
    RoadSideAnnotation *annotation = [[RoadSideAnnotation alloc] init];
    
    [annotation setCoordinate:[[side middleLocation] coordinate]];
    
    [annotation setRoadSideID:[side roadSideID]];
    
    [[self mapView] addAnnotation:annotation];
}










- (UIColor *) colorForRoadStatus:(RoadSideStatus) status
{
    UIColor *color = nil;
    
    
    if (status == RoadSideStatusCleared)
    {
        color = [UIColor colorWithRed:69.f/255.f
                                green:148.f/255.f
                                 blue:75.f/255.f
                                alpha:1];
    }
    else if (status == RoadSideStatusSnowed)
    {
        color = [UIColor colorWithRed:32.f/255.f
                                green:174.f/255.f
                                 blue:239.f/255.f
                                alpha:1];


    }
    else if (status == RoadSideStatusScheduled)
    {
        color = [UIColor colorWithRed:255.f/255.f
                                green:171.f/255.f
                                 blue:2.f/255.f
                                alpha:1];
    }
    else if (status == RoadSideStatusRescheduled)
    {
        color = [UIColor colorWithRed:255.f/255.f
                                green:171.f/255.f
                                 blue:2.f/255.f
                                alpha:1];
    }
    else if (status == RoadSideStatusWillBeRescheduled)
    {
        color = [UIColor colorWithRed:255.f/255.f
                                green:171.f/255.f
                                 blue:2.f/255.f
                                alpha:1];
    }
    else if (status == RoadSideStatusNoParking)
    {
        color = [UIColor colorWithRed:166.f/255.f
                                green:42.f/255.f
                                 blue:42.f/255.f
                                alpha:1];
        
    }
    
    return color;
}


- (UIImage *) annotationImageForRoadStatus:(RoadSideStatus) roadStatus
{
    UIImage *image = nil;
    
    if (roadStatus == RoadSideStatusCleared)
    {
        image = [UIImage imageNamed:@"Dot_Green"];
    }
    else if (roadStatus == RoadSideStatusSnowed)
    {
        image = [UIImage imageNamed:@"Dot_Blue"];
    }
    else if (roadStatus == RoadSideStatusScheduled)
    {
        image = [UIImage imageNamed:@"Dot_Yellow"];
    }
    else if (roadStatus == RoadSideStatusRescheduled)
    {
        image = [UIImage imageNamed:@"Dot_Yellow"];
    }
    else if (roadStatus == RoadSideStatusWillBeRescheduled)
    {
        image = [UIImage imageNamed:@"Dot_Yellow"];
    }
    else if (roadStatus == RoadSideStatusNoParking)
    {
        image = [UIImage imageNamed:@"Dot_Red"];
    }
    
    return image;
}


- (void) configureOverlayViewWithSelectedRoadSide:(MapRoadSide *) roadSide
                                         animated:(BOOL) animated
                       shouldPerformHideAnimation:(BOOL) performHideAnimation
{
    __weak ViewController *weakSelf = self;
    
    void(^confiugreForSelectedRoad)(void) = ^{
        
        [[weakSelf streetNameLabel] setText:[roadSide streetName]];
        
        [[weakSelf fromStreetLabel] setText:[NSString stringWithFormat:@"Entre %@",[roadSide streetFrom]]];
        
        [[weakSelf toStreetLabel] setText:[NSString stringWithFormat:@"et %@",[roadSide streetTo]]];
        
        if ([roadSide roadStatus] == RoadSideStatusCleared)
        {
            [[weakSelf statusLabel] setText:@"Déneigée"];
             
            [[weakSelf statusLabel] setTextColor:[UIColor colorWithRed:69.f/255.f
                                                                 green:148.f/255.f
                                                                  blue:75.f/255.f
                                                                 alpha:1]];
            [[weakSelf statusImageView] setImage:[UIImage imageNamed:@"Status_Green"]];
        }
        else if ([roadSide roadStatus] == RoadSideStatusSnowed)
        {
            [[weakSelf statusLabel] setTextColor:[UIColor colorWithRed:32.f/255.f
                                                                 green:174.f/255.f
                                                                  blue:239.f/255.f
                                                                 alpha:1]];
            
            [[weakSelf statusLabel] setText:@"Enneigée"];
            
            [[weakSelf statusImageView] setImage:[UIImage imageNamed:@"Status_Blue"]];
        }
        else if ([roadSide roadStatus] == RoadSideStatusScheduled)
        {
            [[weakSelf statusLabel] setTextColor:[UIColor colorWithRed:255.f/255.f
                                                                 green:171.f/255.f
                                                                  blue:2.f/255.f
                                                                 alpha:1]];
            [[weakSelf statusImageView] setImage:[UIImage imageNamed:@"Status_Yellow"]];
            
            NSString *dateString = [[ViewController sharedFormatter] stringFromDate:[roadSide plannedDateStart]];
            
            NSString *statusText = [NSString stringWithFormat:@"Planifiée pour le %@",dateString];
            
            [[weakSelf statusLabel] setText:statusText];
        }
        else if ([roadSide roadStatus] == RoadSideStatusRescheduled)
        {
            [[weakSelf statusLabel] setTextColor:[UIColor colorWithRed:255.f/255.f
                                                                 green:171.f/255.f
                                                                  blue:2.f/255.f
                                                                 alpha:1]];
            [[weakSelf statusImageView] setImage:[UIImage imageNamed:@"Status_Yellow"]];
            
            NSString *dateString = [[ViewController sharedFormatter] stringFromDate:[roadSide replannedDateStart]];
            
            NSString *statusText = [NSString stringWithFormat:@"Replanifiée pour le %@",dateString];

            [[weakSelf statusLabel] setText:statusText];
        }
        else if ([roadSide roadStatus] == RoadSideStatusWillBeRescheduled)
        {
            [[weakSelf statusLabel] setTextColor:[UIColor colorWithRed:255.f/255.f
                                                                 green:171.f/255.f
                                                                  blue:2.f/255.f
                                                                 alpha:1]];
            [[weakSelf statusImageView] setImage:[UIImage imageNamed:@"Status_Yellow"]];
            
            NSString *statusText = @"Sera replanifiée ultérieurement";
            
            [[weakSelf statusLabel] setText:statusText];
        }
        else if ([roadSide roadStatus] == RoadSideStatusNoParking)
        {
            [[weakSelf statusLabel] setTextColor:[UIColor colorWithRed:166.f/255.f
                                                                 green:42.f/255.f
                                                                  blue:42.f/255.f
                                                                 alpha:1]];
            
            [[weakSelf statusImageView] setImage:[UIImage imageNamed:@"Status_Red"]];
            
            [[weakSelf statusLabel] setText:@"Déneigement en cours"];
        }
        
        
        if ([[self parkedRoadSide] roadSideID] == [roadSide roadSideID])
        {
            [[self parkButton] setSelected:YES];
        }
        else
        {
            [[self parkButton] setSelected:NO];
        }
        
    };
    
    if (!roadSide)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 [[self topOverlayConstraint] setConstant:[[self view] frame].size.height];
                                 
                                 [[self view] layoutIfNeeded];
                             }
                             completion:nil];
        }
        else
        {
            [[self topOverlayConstraint] setConstant:[[self view] frame].size.height];
            
            [[self view] layoutIfNeeded];
        }

    }
    else if (performHideAnimation && animated)
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             [[self topOverlayConstraint] setConstant:[[self view] frame].size.height];
                             
                             [[self view] layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             
                             confiugreForSelectedRoad();
                             
                             [UIView animateWithDuration:0.25
                                              animations:^{
                                                  
                                                  CGFloat constant = [[self view] frame].size.height - [[self overlayView] frame].size.height;
                                                  
                                                  [[self topOverlayConstraint] setConstant:constant];
                                                  
                                                  [[self view] layoutIfNeeded];
                                              }
                                              completion:nil];
                         }];
    }
    else
    {
        confiugreForSelectedRoad();
        
        if (animated)
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 CGFloat constant = [[self view] frame].size.height - [[self overlayView] frame].size.height;
                                 
                                 [[self topOverlayConstraint] setConstant:constant];
                                 
                                 [[self view] layoutIfNeeded];
                             }
                             completion:nil];
        }
        
        else
        {
            CGFloat constant = [[self view] frame].size.height - [[self overlayView] frame].size.height;
            
            [[self topOverlayConstraint] setConstant:constant];
            
            [[self overlayView] layoutIfNeeded];
        }
    }
    
    
}


@end
