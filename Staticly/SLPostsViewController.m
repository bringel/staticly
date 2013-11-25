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
    NSLog(@"Now we're inside SLPostsViewController's viewDidLoad:");
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //we need a user. show the login screen
        [self performSegueWithIdentifier:@"showLoginViewController" sender:self];
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
//This is where we are going to load all of the commit information because
//we just came from the branch view controller
- (IBAction)unwindFromBranchController:(UIStoryboardSegue *)unwindSegue{
    //put up our fancy spinner
    MRProgressOverlayView *overlay = [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];
    overlay.mode = MRProgressOverlayViewModeIndeterminateSmall;
    
    //First things first, get the rest of the commit information
    SLCommit *commit = [[[[SLGithubClient sharedClient] currentSite] defaultBranch] commit];
    NSString *repoName = [[[SLGithubClient sharedClient] currentSite] name];
    NSString *userName = [[[SLGithubClient sharedClient] currentUser] username];
    NSString *commitSha = [commit sha];
    NSString *accessToken = [[[SLGithubClient sharedClient] currentUser] oauthToken];
    NSString *getURL = [NSString stringWithFormat:@"/repos/%@/%@/git/commits/%@",userName, repoName, commitSha];
    
    
    //TODO: Stop this block from creating duplicates
#warning This block creates duplicate commits
    void (^successBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject){
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response.statusCode == 200){
            NSDictionary *responseData = (NSDictionary *)responseObject;
            commit.message = [responseData objectForKey:@"message"];
            NSArray *commitParents = [responseData objectForKey:@"parents"];
            NSError *error;
            for(NSDictionary *parentData in commitParents){
                //Should really try and fetch a commit with this sha first
                //and then create a new commit if we can't find one
                //This will lead to all sorts of dupicates right now

                SLCommit *parent = [NSEntityDescription insertNewObjectForEntityForName:@"SLCommit" inManagedObjectContext:self.managedObjectContext];
                parent.sha = [parentData objectForKey:@"sha"];
                parent.url = [parentData objectForKey:@"url"];
                [commit addParentsObject:parent];
                [self.managedObjectContext save:&error];
            }
            SLTree *rootTree = [NSEntityDescription insertNewObjectForEntityForName:@"SLTree" inManagedObjectContext:self.managedObjectContext];
            rootTree.url = [responseData valueForKeyPath:@"tree.url"];
            rootTree.sha = [responseData valueForKeyPath:@"tree.sha"];
            [self.managedObjectContext save:&error];
            
            NSString *treeGetURL = [NSString stringWithFormat:@"/repos/%@/%@/git/trees/%@", userName, repoName, rootTree.sha];
        }
    };
    
    void (^failBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@", error);
    };
    
    void (^treeSuccessBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject){
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response.statusCode == 200){
            NSArray *treeData = [responseObject objectForKey:@"tree"];
            //we're going to get back a bunch of tree references and blob references that
            //we then have to go and get
            for(NSDictionary *gitObject in treeData){
                NSString *objectType = [gitObject objectForKey:@"type"];
                if([objectType isEqualToString:@"tree"]){
                    
                }
                else if([objectType isEqualToString:@"blob"]){
                    
                }
            }
        }
    };
    
    void (^treeFailBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@", error);
    };
    
    void (^blobSuccessBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject){
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response.statusCode == 200){
            
        }
    };
    
    void (^blobFailBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@", error);
    };
    
    [[SLGithubClient sharedClient] GET:getURL parameters:@{@"access_token" : accessToken} success:successBlock failure:failBlock];
}

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
