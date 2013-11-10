//
//  CrimeDetailViewController.m
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CrimeDetailViewController.h"

@interface CrimeDetailViewController ()

@end

@implementation CrimeDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Get the crime
	if (self.crimeId) [self getCrimeWithId];
}

- (void)getCrimeWithId
{
	// Dispatch the API request onto another thread
	dispatch_queue_t crimeMapFetcher = dispatch_queue_create("crime map fetcher", NULL);
	dispatch_async(crimeMapFetcher, ^{
		// Get the crime with ID
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		self.crime = [CrimeMapFetcher crimeForId:self.crimeId];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		dispatch_async(dispatch_get_main_queue(), ^{
			// Update the UI
			[self updateUI];
		});
	});
}

- (void)updateUI
{
	// Update the UI
	for (NSArray *array in [self.crime objectForKey:@"outcomes"]) {
		self.outcomeTextView.text = [self.outcomeTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n", [[array valueForKeyPath:@"category.name"] description]]];
	}
	self.categoryTextView.text = [[self.crime valueForKeyPath:@"crime.category"] description];
	self.dateTextView.text = [[self.crime valueForKeyPath:@"crime.month"] description];
	self.locationTextView.text = [[self.crime valueForKeyPath:@"crime.location.street.name"] description];
}

@end