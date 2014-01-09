//
//  SLBranchesViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/6/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLBranchesViewController.h"
#import "SLGithubSessionManager.h"
#import "SLBranch.h"
#import "SLCommit.h"

@interface SLBranchesViewController ()

@property (strong, nonatomic) NSArray *branches;

@end

@implementation SLBranchesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self _fetchBranches];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_fetchBranches{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    NSString *fetchString = [NSString stringWithFormat:@"/repos/%@/git/refs/heads", self.selectedSite.fullName];
    
    SLGithubSessionManager *manager = [SLGithubSessionManager sharedManager];
    
    [manager GET:fetchString parameters:@{@"access_token" : self.currentUser.oauthToken}
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             if(response.statusCode == 200){
                 self.branches = [responseObject copy];
                 [overlayView dismiss:YES];
                 [self.tableView reloadData];
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@", error);
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.branches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"branchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *refName = [[self.branches objectAtIndex:indexPath.row] objectForKey:@"ref"];
    NSArray *parts = [refName componentsSeparatedByString:@"/"];
    
    cell.textLabel.text = [parts lastObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLBranch *branch = [NSEntityDescription insertNewObjectForEntityForName:@"SLBranch" inManagedObjectContext:self.managedObjectContext];
    
    branch.refName = [[self.branches objectAtIndex:indexPath.row] objectForKey:@"ref"];
    branch.url = [[self.branches objectAtIndex:indexPath.row] objectForKey:@"url"];
    branch.site = self.selectedSite;
    branch.defaultBranch = @(YES);
    NSError *error;
    [self.managedObjectContext save:&error];
    
    SLCommit *commit = [NSEntityDescription insertNewObjectForEntityForName:@"SLCommit" inManagedObjectContext:self.managedObjectContext];
    NSDictionary *commitData = [[self.branches objectAtIndex:indexPath.row] objectForKey:@"object"];
    commit.sha = [commitData objectForKey:@"sha"];
    commit.url = [commitData objectForKey:@"url"];
    
    commit.branch = branch;
    
    [self.managedObjectContext save:&error];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
