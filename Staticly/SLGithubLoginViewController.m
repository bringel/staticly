//
//  SLGithubLoginViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "SLGithubLoginViewController.h"
#import "SLGithubClient.h"
#import "SLUser.h"
#import "SLUserRepositoryBrowserViewController.h"

@interface SLGithubLoginViewController ()

@property (strong, nonatomic) SLUser *authenticatedUser;

@end

@implementation SLGithubLoginViewController

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

- (IBAction)loginButtonPressed:(id)sender {
    //Use this to check if we're running for the first time
    //Changes where we want to segue because this view controller can also
    //be pushed from the Settings VC to add a new user.
    bool firstRun = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
    
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    overlayView.mode = MRProgressOverlayViewModeIndeterminateSmall;
    
    NSString *userName = [[self usernameField] text];
    NSString *pass = [[self passwordField] text];
    
    SLUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SLUser" inManagedObjectContext:self.managedObjectContext];
    user.username = userName;
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
    void (^successBlock)(NSURLSessionDataTask  *, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response.statusCode == 200 || response.statusCode == 201){
            //The token came back
            NSDictionary *tokenResponse = responseObject;
            user.oauthToken = [tokenResponse objectForKey:@"token"];
            user.tokenID = [tokenResponse objectForKey:@"id"];
            user.currentUser = [NSNumber numberWithBool:YES];
            //we don't want to send the username and password anymore
            [[[SLGithubClient sharedClient] requestSerializer] clearAuthorizationHeader];
            NSError *error;
            [self.managedObjectContext save:&error];
            self.authenticatedUser = user;
            NSLog(@"Successfully got a token");
            if(firstRun){
                [self performSegueWithIdentifier:@"showRepositoryBrowser" sender:self];
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    
    void (^failBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        //We should probably handle this error somewhere. I just don't know where
    };
    
    [[[SLGithubClient sharedClient] requestSerializer] setAuthorizationHeaderFieldWithUsername:userName password:pass];
    [[SLGithubClient sharedClient] PUT:[NSString stringWithFormat:@"/authorizations/clients/%@",[[SLGithubClient sharedClient] clientID]]
                            parameters:@{@"client_secret" : [[SLGithubClient sharedClient] clientSecret],
                                         @"scopes" : @[@"repo"],
                                         @"note" : @"Key for Staticly, Jekyll site editor"}
                               success: successBlock
                               failure:failBlock];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showRepositoryBrowser"]){
        SLUserRepositoryBrowserViewController *repositoryBrowser = segue.destinationViewController;
        repositoryBrowser.managedObjectContext = self.managedObjectContext;
        repositoryBrowser.currentUser = self.authenticatedUser;
    }
}
@end
