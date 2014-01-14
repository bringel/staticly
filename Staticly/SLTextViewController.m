//
//  SLTextViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/13/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLTextViewController.h"

@interface SLTextViewController ()

@property (strong, nonatomic) UIPopoverController *popover;

@end

@implementation SLTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.splitViewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFile:(SLBlob *)file{
    if(_file != file){
        NSString *fileText = [[NSString alloc] initWithData:[file content] encoding:NSASCIIStringEncoding];
        
        self.textView.text = fileText;
    }
}

#pragma mark - UISplitViewControllerDelegate

//Called when the master view controller is going to come onscreen again, should remove the
//button from the navigation bar
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    self.popover = pc;
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [barButtonItem setTitle:@"Menu"];
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController{
    
}

@end
