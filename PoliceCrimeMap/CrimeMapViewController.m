//
//  CrimeMapViewController.m
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CrimeMapViewController.h"
#import "CrimeDetailViewController.h"

@interface CrimeMapViewController ()

@end

@implementation CrimeMapViewController

- (CLLocationManager *)locationManager
{
	if (!_locationManager) _locationManager = [[CLLocationManager alloc] init];
	return _locationManager;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Set overselves to be the map delegate
	self.mapView.delegate = self;
	// Set ourselves as the delegate
	self.locationManager.delegate = self;
	// Best accuracy
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	// Start updating the location
	[self.locationManager startUpdatingLocation];
}

- (IBAction)getLocation:(UIButton *)sender
{
	// Set ourselves as the delegate
	self.locationManager.delegate = self;
	// Best accuracy
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	// Start updating the location
	[self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	// Check if the location data is of type CLLocation
	if ([[locations firstObject] isKindOfClass:[CLLocation class]]) {
		// Get the location
		CLLocation *location = [locations firstObject];
		
		// Dispatch the API request onto another thread
		dispatch_queue_t crimeMapFetcher = dispatch_queue_create("crime map fetcher", NULL);
		dispatch_async(crimeMapFetcher, ^{
			// Get the crime data from Police Uk
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			self.crimeLocationData = [CrimeMapFetcher crimesForLocation:location];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			// Get back on the main thread
			dispatch_async(dispatch_get_main_queue(), ^{
				// Do something with the data
				for (NSDictionary *location in self.crimeLocationData) {
					MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
					point.coordinate = CLLocationCoordinate2DMake([[location valueForKeyPath:@"location.latitude"] doubleValue], [[location valueForKeyPath:@"location.longitude"] doubleValue]);
					point.title = [location valueForKeyPath:@"category"];
					point.subtitle = [[location valueForKeyPath:@"persistent_id"] description];
					// Add the annotation to the map
					[self.mapView addAnnotation:point];
				}
			});
		});
	}
	
	// Stop getting the location of the device
	[self.locationManager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	CLLocationCoordinate2D location = [userLocation coordinate];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 500, 500);
	[self.mapView setRegion:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detailCrime" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"detailCrime"]) {
		if ([segue.destinationViewController respondsToSelector:@selector(setCrimeId:)]) {
			CrimeDetailViewController *cmvc = (CrimeDetailViewController *)segue.destinationViewController;
			if ([sender isKindOfClass:[MKAnnotationView class]]) {
				MKAnnotationView *aView = sender;
				cmvc.crimeId = [[aView annotation] subtitle];
			}
		}
	}
}

@end