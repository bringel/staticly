//
//  SLMenuViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 1/6/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLSite.h"

@interface SLMenuViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)refreshSite:(SLSite *)site;

@end
