//
//  CrimeMapFetcher.m
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CrimeMapFetcher.h"

@implementation CrimeMapFetcher

+ (NSDictionary *)executeCrimeMapFetchRequest:(NSString *)query
{
	// Create query string
	query = [NSString stringWithFormat:@"%@", query];
	query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// NSLog
	if (NSLOG_POLICE)
		NSLog(@"[%@ %@] set %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
	
	// Get the JSON data
	NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	
	// Create dictionary from JSON data via serialization
	NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
	
	// Check for error
	if (error)
		NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
	
	// NSLog
	if (NSLOG_POLICE)
		NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
	
	// Return
	return results;
}

+ (NSDictionary *)crimesForLocation:(CLLocation *)location
{
	// Create dictionary
	NSMutableDictionary *crimes = [[NSMutableDictionary alloc] init];
	// Url for crimes at location
	NSString *url = [NSString stringWithFormat:@"http://data.police.uk/api/crimes-at-location?date=%@&lat=%f&lng=%f", [NSDate date], location.coordinate.latitude, location.coordinate.longitude];
	
	// Get the crimes for location and date
	crimes = [[CrimeMapFetcher executeCrimeMapFetchRequest:url] mutableCopy];
	
	// Return dictionary
	return crimes;
}

@end