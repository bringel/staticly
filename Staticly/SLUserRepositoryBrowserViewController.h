//
//  SLUserRepositoryBrowserViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 11/11/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLUser.h"

@interface SLUserRepositoryBrowserViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) SLUser *currentUser;

@end
