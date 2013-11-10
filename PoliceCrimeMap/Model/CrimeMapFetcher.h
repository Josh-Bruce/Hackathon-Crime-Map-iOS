//
//  CrimeMapFetcher.h
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

#define NSLOG_POLICE NO

@interface CrimeMapFetcher : NSObject

// Get all crimes withing locations
+ (NSDictionary *)crimesForLocation:(CLLocation *)location;

// Get crime with ID
+ (NSDictionary *)crimeForId:(NSString *)crimId;

@end