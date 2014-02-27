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
#import "SLSitesViewController.h"

@interface SLLoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) SLUser *currentUser;
@property (nonatomic) BOOL userNeedsTwoFactorAuth;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(self.userNeedsTwoFactorAuth){
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    else{
        return 1;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Two Factor Authentication";
    }
    else{
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(section == 1){
        return @"Please enter the One Time password and login again";
    }
    else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"entryCell";
    SLEntryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textField.delegate = self;
    if(indexPath.section == 1){
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.tag = 2;
        cell.textField.placeholder = @"One Time Password";
    }
    else if(indexPath.row == 0){
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
    NSString *twoFactor;
    if(self.userNeedsTwoFactorAuth){
        twoFactor = [[(SLEntryCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] textField] text];
    }
    
    NSFetchRequest *userRequest = [[NSFetchRequest alloc] initWithEntityName:@"SLUser"];
    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"username", username];
    userRequest.predicate = usernamePredicate;
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];
    
    SLUser *user;
    if(users.count == 0){
        user = [NSEntityDescription insertNewObjectForEntityForName:@"SLUser" inManagedObjectContext:self.managedObjectContext];
        user.username = username;
        user.currentUser = @(YES);
    }
    else{
        //This is an assumption that there is only one user that comes back with that username
        //hopefully
        user = [users firstObject];
    }
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    if(self.userNeedsTwoFactorAuth){
        [manager.requestSerializer setValue:twoFactor forHTTPHeaderField:@"X-GitHub-OTP"];
    }
    [manager PUT:[NSString stringWithFormat:@"/authorizations/clients/%@", [manager clientID]] parameters:@{@"client_secret" : [manager clientSecret], @"scope" : @[@"repo"]}
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSDictionary *tokenData = responseObject;
             if(response.statusCode == 200 || response.statusCode == 201){
                 user.oauthToken = [tokenData objectForKey:@"token"];
                 
                 NSError *error;
                 [self.managedObjectContext save:&error];
                 self.currentUser = user;
                 [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                 [manager.requestSerializer clearAuthorizationHeader];
                 if(self.presentedFromSettings){
                     [self performSegueWithIdentifier:@"unwindToSettings" sender:self];
                 }
                 else{
                     [self performSegueWithIdentifier:@"showSites" sender:self];
                 }
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             //TODO:
             //if the server returns a 401 here, check the headers for
             // "X-GitHub-OTP: required;:2fa-type"
             
             //then add a tableview cell to capture the one time password,
             // and set it to the X-GitHub-OTP header using setValue:forHTTPHeaderField:
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             if(response.statusCode == 401 && [response.allHeaderFields objectForKey:@"X-Github-OTP"]) {
                 self.userNeedsTwoFactorAuth = YES;
                 [self.tableView beginUpdates];
                 [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
                 [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
                 [self.tableView endUpdates];
                 
                 NSArray *tableViewConstraints = [self.tableView constraints];
                 //looping through these to find the height constraint so that the
                 //login "form" will resize nicely.
                 [tableViewConstraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     NSLayoutConstraint *c = obj;
                     if(c.firstAttribute == NSLayoutAttributeHeight){
                         CGFloat height = c.constant;
                         c.constant = (height + 104);
                         *stop = YES;
                     }
                 }];
                 [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
             }
             
             NSLog(@"%@", error);
         }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLEntryCell *cell = (SLEntryCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    [cell setSelected:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showSites"]){
        SLSitesViewController *sitesViewController = (SLSitesViewController *)segue.destinationViewController;
        sitesViewController.managedObjectContext = self.managedObjectContext;
        sitesViewController.currentUser = self.currentUser;
    }
}
@end
