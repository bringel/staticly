//
//  SLLoginViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/2/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLLoginViewController.h"
#import "SLEntryCell.h"
#import "SLUser.h"
#import "SLGithubSessionManager.h"

@interface SLLoginViewController () <UITextFieldDelegate>

@end

@implementation SLLoginViewController

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
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CALayer *layer = [self.loginButton layer];
    layer.borderColor = self.loginButton.tintColor.CGColor;
    layer.borderWidth = 1.5f;
    layer.cornerRadius = 4.5f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"entryCell";
    SLEntryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textField.delegate = self;
    if(indexPath.row == 0){
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.tag = 0;
        cell.textField.placeholder = @"Username";
    }
    else{
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.tag = 1;
        cell.textField.secureTextEntry = YES;
        cell.textField.placeholder = @"Password";
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        //this is the username field
        [self resignFirstResponder];
        //find the password field and makeit become the first responder
        UIView *passwordField = [self.view viewWithTag:1];
        [passwordField becomeFirstResponder];
    }
    else{
        //this is the password field
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    MRProgressOverlayView *overlay = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    overlay.mode = MRProgressOverlayViewModeIndeterminateSmall;
    //time to get a new token
    SLGithubSessionManager *manager = [SLGithubSessionManager sharedManager];

    NSString *username = [[(SLEntryCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField] text];
    NSString *password = [[(SLEntryCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField] text];
    
    SLUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SLUser" inManagedObjectContext:self.managedObjectContext];
    user.username = username;
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    [manager POST:@"/authorizations" parameters:@{@"client_secret" : [manager clientSecret], @"client_id" : [manager clientID], @"scope" : @[@"repo"]}
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSDictionary *tokenData = responseObject;
             if(response.statusCode == 200 || response.statusCode == 201){
                 user.oauthToken = [tokenData objectForKey:@"token"];
                 
                 NSError *error;
                 [self.managedObjectContext save:&error];
                 
                 [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@", error);
         }];
}
@end
