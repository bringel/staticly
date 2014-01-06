//
//  SLBranchesViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 1/6/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLSite.h"
#import "SLUser.h"

@interface SLBranchesViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) SLUser *currentUser;
@property (strong, nonatomic) SLSite *selectedSite;

@end
