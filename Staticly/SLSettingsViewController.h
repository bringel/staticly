//
//  SLSettingsViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 11/11/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSettingsViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableViewCell *currentUserCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *currentSiteCell;

@end
