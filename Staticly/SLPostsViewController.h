//
//  SLPostsViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPostsViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)unwindFromBranchController:(UIStoryboardSegue *)unwindSegue;
@end
