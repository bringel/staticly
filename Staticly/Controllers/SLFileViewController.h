//
//  SLFileViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 1/15/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBlob.h"
#import "SLYAMLEditView.h"

@interface SLFileViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet SLYAMLEditView *yamlEditView;

@property (strong, nonatomic) SLBlob *file;

@end
