//
//  SLGithubLoginViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLGithubLoginViewController.h"
#import "SLGithubClient.h"
#import "SLUser.h"

@interface SLGithubLoginViewController ()

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
    NSString *userName = [[self usernameField] text];
    NSString *pass = [[self passwordField] text];
    
    SLUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SLUser" inManagedObjectContext:self.managedObjectContext];
    user.username = userName;
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
    [[[SLGithubClient sharedClient] requestSerializer] setAuthorizationHeaderFieldWithUsername:userName password:pass];

    [[SLGithubClient sharedClient] PUT:[NSString stringWithFormat:@"/authorizations/clients/%@",[[SLGithubClient sharedClient] clientID]]
                            parameters:@{@"client_secret" : [[SLGithubClient sharedClient] clientSecret],
                                         @"scopes" : @[@"repo"],
                                         @"note" : @"Key for Staticly, Jekyll site editor"}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                   if(response.statusCode == 200 || response.statusCode == 201){
                                       //The token came back
                                       NSDictionary *tokenResponse = responseObject;
                                       user.oauthToken = [tokenResponse objectForKey:@"token"];
                                       user.tokenID = [tokenResponse objectForKey:@"id"];
                                       //we don't want to send the username and password anymore
                                       [[[SLGithubClient sharedClient] requestSerializer] clearAuthorizationHeader];
                                       NSError *error;
                                       [self.managedObjectContext save:&error];
                                       NSLog(@"Successfully got a token");
                                   }
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   
                               }];
    
}
@end
