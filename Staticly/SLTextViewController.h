//
//  SLTextViewController.h
//  Staticly
//
//  Created by Bradley Ringel on 1/13/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBlob.h"

@interface SLTextViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) SLBlob *file;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
