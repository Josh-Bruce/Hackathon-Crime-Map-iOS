//
//  CrimeMapViewController.h
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrimeMapFetcher.h"

@import MapKit;

@interface CrimeMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDictionary *crimeLocationData;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end