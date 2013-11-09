//
//  CrimeMapFetcher.h
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

#define NSLOG_POLICE YES

@interface CrimeMapFetcher : NSObject

+ (NSDictionary *)crimesForLocation:(CLLocation *)location;

@end