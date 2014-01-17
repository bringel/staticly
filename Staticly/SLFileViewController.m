//
//  SLFileViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/15/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLFileViewController.h"

@interface SLFileViewController ()

@property (strong, nonatomic) NSString *frontMatter;
@property (strong, nonatomic) NSString *body;

@end

@implementation SLFileViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setFile:(SLBlob *)file{
    NSString *fileContent = [[NSString alloc] initWithData:file.content encoding:NSASCIIStringEncoding];
    
    NSArray *parts = [fileContent componentsSeparatedByString:@"---"];
    //I happen to know that the first object in this array will be @""
    self.frontMatter = [parts objectAtIndex:1];
    self.body = [parts lastObject];
    self.textView.text = self.body;
    
    NSError *error;
    NSArray *objects = [YAMLSerialization objectsWithYAMLString:self.frontMatter options:kYAMLReadOptionStringScalars error:&error];
    NSLog(@"%@", objects);
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    
    barButtonItem.title = @"Menu";
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button{
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController{
    
}
@end
