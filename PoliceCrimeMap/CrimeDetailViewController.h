//
//  CrimeDetailViewController.h
//  PoliceCrimeMap
//
//  Created by Josh Bruce on 09/11/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrimeMapFetcher.h"

@interface CrimeDetailViewController : UIViewController

@property (strong, nonatomic) NSString *crimeId;
@property (strong, nonatomic) NSDictionary *crime;

@property (weak, nonatomic) IBOutlet UITextView *outcomeTextView;

@end