//
//  SLSitesViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLSitesViewController.h"
#import "SLSite.h"
#import "SLGithubSessionManager.h"
#import "SLBranchesViewController.h"

@interface SLSitesViewController ()

@property (strong, nonatomic) NSMutableArray *sites;
@property (strong, nonatomic) SLSite *selectedSite;

@end

@implementation SLSitesViewController

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
    [self _fetchSites];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)sites{
    if(_sites == nil){
        _sites = [[NSMutableArray alloc] init];
    }
    return _sites;
}

- (void)_fetchSites{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    NSString *fetchString = [NSString stringWithFormat:@"/users/%@/repos", self.currentUser.username];
    
    SLGithubSessionManager *manager = [SLGithubSessionManager sharedManager];
    
    [manager GET:fetchString parameters:@{@"access_token" : self.currentUser.oauthToken}
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             if(response.statusCode == 200){
                 NSArray *responseData = responseObject;
                 self.sites = [responseData copy];
                 [overlayView dismiss:YES];
                 [self.tableView reloadData];
                 
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             
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
    return self.sites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"siteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.sites objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.sites objectAtIndex:indexPath.row] objectForKey:@"full_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *selected = [self.sites objectAtIndex:indexPath.row];
    
    NSFetchRequest *siteRequest = [[NSFetchRequest alloc] initWithEntityName:@"SLSite"];
    NSPredicate *siteNamePredicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"name", [selected objectForKey:@"name"]];
    siteRequest.predicate = siteNamePredicate;
    
    NSError *error;
    NSArray *sites = [self.managedObjectContext executeFetchRequest:siteRequest error:&error];
    
    SLSite *site;
    if(sites.count == 0){
        site = [NSEntityDescription insertNewObjectForEntityForName:@"SLSite" inManagedObjectContext:self.managedObjectContext];
    
        site.name = [selected objectForKey:@"name"];
        site.fullName = [selected objectForKey:@"full_name"];
        
    }
    else{
        site = [sites firstObject];
    }
    site.currentSite = @(YES);
    [self.managedObjectContext save:&error];
    self.selectedSite = site;
    
    [self performSegueWithIdentifier:@"showBranches" sender:self];
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
    if([segue.identifier isEqualToString:@"showBranches"]){
        SLBranchesViewController *branchesVC = (SLBranchesViewController *)segue.destinationViewController;
        branchesVC.managedObjectContext = self.managedObjectContext;
        branchesVC.currentUser = self.currentUser;
        branchesVC.selectedSite = self.selectedSite;
    }
}


@end
