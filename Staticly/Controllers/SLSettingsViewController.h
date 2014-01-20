//
//  SLSettingsViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 1/16/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSettingsViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)donePresed:(id)sender;
- (IBAction)unwindFromNewUser:(UIStoryboardSegue *)sender;
- (IBAction)unwindFromNewSite:(UIStoryboardSegue *)sender;

@end
