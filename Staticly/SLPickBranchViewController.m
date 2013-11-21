//
//  SLPickBranchViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 11/15/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLPickBranchViewController.h"
#import "SLBranch.h"
#import "SLGithubClient.h"
#import "SLUser.h"

@interface SLPickBranchViewController ()

@property (strong, nonatomic) NSMutableArray *branches;

@end

@implementation SLPickBranchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)branches{
    if(_branches == nil){
        _branches = [[NSMutableArray alloc] init];
    }
    return _branches;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *user = [[[SLGithubClient sharedClient] currentUser] username];
    NSString *repoName = [self.selectedRepository name];
    NSString *token = [[[SLGithubClient sharedClient] currentUser] oauthToken];
    NSString *url = [NSString stringWithFormat:@"/repos/%@/%@/git/refs", user, repoName];
    [[SLGithubClient sharedClient] GET:url parameters:@{@"access_token" : token}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSHTTPURLResponse *response = task.response;
                                   if(response.statusCode == 200){
                                       NSArray *branches = responseObject;
                                       [self.branches addObjectsFromArray:branches];
                                       [self.tableView reloadData];
                                   }
        
    }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   NSLog(@"Whoops: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *components = [[[self.branches objectAtIndex:indexPath.row] objectForKey:@"ref"] componentsSeparatedByString:@"/"];
    cell.textLabel.text = [components lastObject];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //the user picked a branch, so we should make an SLBranch, and dismiss the modal view controllers
    //now we can download commits and junk
    
    SLBranch *branch = [NSEntityDescription insertNewObjectForEntityForName:@"SLBranch" inManagedObjectContext:self.managedObjectContext];
    NSDictionary *branchDict = [self.branches objectAtIndex:indexPath.row];
    
    branch.refName = [branchDict objectForKey:@"ref"];
    branch.url = [branchDict objectForKey:@"url"];
    branch.repository = self.selectedRepository;
    self.selectedRepository.currentSite = [NSNumber numberWithBool:YES];
    //Set this branch as the default and save
    [[SLGithubClient sharedClient] setCurrentSite:self.selectedRepository];
    [[[SLGithubClient sharedClient] currentSite] setDefaultBranch:branch];

    NSError *error;
    [self.managedObjectContext save:&error];
    
    bool firstRun = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
    if(firstRun){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self performSegueWithIdentifier:@"unwindSegue" sender:self];
    }
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
