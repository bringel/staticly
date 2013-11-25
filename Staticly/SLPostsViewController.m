//
//  SLPostsViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLPostsViewController.h"
#import "SLGithubLoginViewController.h"
#import "SLGithubClient.h"
#import "SLRepository.h"
#import "SLBranch.h"
#import "SLCommit.h"

@interface SLPostsViewController ()

@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *drafts;

@end

@implementation SLPostsViewController

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
    
    //my guess is that this isn't really the proper place to be checking for this. Maybe it should happen in the app delegate?
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLUser"];
    NSError *error;
    NSArray *users = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //we need a user. show the login screen
        [self performSegueWithIdentifier:@"showLoginViewController" sender:self];
    }
    
    
    else if([[[[SLGithubClient sharedClient] currentSite] defaultBranch] commit] == nil){
        //If the commit is null, there's a good chance we should try and get it.
        NSString *user = [[[SLGithubClient sharedClient] currentUser] username];
        NSString *repoName = [[[SLGithubClient sharedClient] currentSite] name];
        NSString *ref = [[[[SLGithubClient sharedClient] currentSite] defaultBranch] refName];
        NSString *urlString = [NSString stringWithFormat:@"/repos/%@/%@/git/%@", user, repoName, ref];
        NSString *token = [[[SLGithubClient sharedClient] currentUser] oauthToken];
        //Get the branch which will give us the commit sha
        
        void (^successBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject) {
            NSHTTPURLResponse *response = task.response;
            if(response.statusCode == 200){
                NSDictionary *repoData = (NSDictionary *)responseObject;
                SLCommit *commit = [NSEntityDescription insertNewObjectForEntityForName:@"SLCommit" inManagedObjectContext:self.managedObjectContext];
                NSDictionary *commitData = [repoData objectForKey:@"object"];
                commit.type = [commitData objectForKey:@"type"];
                commit.sha = [commitData objectForKey:@"sha"];
                commit.url = [commitData objectForKey:@"url"];
                
                NSError *error;
                [[[[SLGithubClient sharedClient] currentSite] defaultBranch] setCommit:commit];
                [self.managedObjectContext save:&error];
                
                NSLog(@"%@",commit);
            }
        };
        void (^failBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"That's not good: %@", error);
        };
        
        NSURLSessionDataTask *task = [[SLGithubClient sharedClient] GET:urlString parameters:@{@"access_token" : token}
                                   success: successBlock failure:failBlock];
        
        while(task.state != NSURLSessionTaskStateCompleted){
            NSLog(@"Waiting for the task to complete");
        }
        //get the commit so that we can get the tree
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
    if([segue.identifier isEqualToString:@"showLoginViewController"]){
        UINavigationController *navController = segue.destinationViewController;
        
        ((SLGithubLoginViewController *)navController.topViewController).managedObjectContext = self.managedObjectContext;
    }
}



@end
