//
//  SLLoginViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 1/2/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLLoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
