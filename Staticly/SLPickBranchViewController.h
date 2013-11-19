//
//  SLPickBranchViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 11/15/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLUser.h"
#import "SLRepository.h"

@interface SLPickBranchViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) SLRepository *selectedRepository;

@end
