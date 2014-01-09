//
//  SLMenuViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/6/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLMenuViewController.h"
#import "SLLoginViewController.h"
#import "SLGithubSessionManager.h"
#import "SLCommit.h"
#import "SLTree.h"
#import "SLBlob.h"
#import "SLSite.h"
#import "SLBranch.h"

@interface SLMenuViewController ()

@end

@implementation SLMenuViewController

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
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshCurrentSite:)];
    self.toolbarItems = @[refreshButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshCurrentSite:(id)sender{
    //First things first is to fetch the commit that the default branch points to
    //We may also want to check to see if there is a new commit first
    NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"defaultBranch == YES"];
    NSOrderedSet *defaultBranch = [[[[SLGithubSessionManager sharedManager] currentSite] branches] filteredOrderedSetUsingPredicate:currentPredicate];
    SLCommit *head = [[defaultBranch firstObject] commit];
    
    void (^blobSuccessBlock)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask * task, id responseObject){
        
    };
    
    void (^blobFailBlock)(NSURLSessionDataTask *, NSError *) = ^void (NSURLSessionDataTask *task, NSError *error){
        
    };
    
    void (^treeSuccessBlock)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject){
        
    };
    
    void (^treeFailBlock)(NSURLSessionDataTask *, NSError *) = ^void (NSURLSessionDataTask *task, NSError *error){
        
    };
    
    void (^commitSuccessBlock)(NSURLSessionDataTask *, id) = ^void (NSURLSessionDataTask *task, id responseObject){
        NSError *error;

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response.statusCode == 200){
            NSDictionary *commitData = responseObject;
            //loop through all the parents and get those
            for(NSDictionary *parent in [commitData objectForKey:@"parents"]){
                SLCommit *p = [NSEntityDescription insertNewObjectForEntityForName:@"SLCommit" inManagedObjectContext:self.managedObjectContext];
                p.sha = [parent objectForKey:@"sha"];
                p.url = [parent objectForKey:@"url"];
                [head addParentsObject:p];
                
                [self.managedObjectContext save:&error];
            }
            //create a tree
            SLTree *tree = [NSEntityDescription insertNewObjectForEntityForName:@"SLTree" inManagedObjectContext:self.managedObjectContext];
            tree.url = [commitData valueForKeyPath:@"tree.url"];
            tree.sha = [commitData valueForKeyPath:@"tree.sha"];
            tree.commit = head;
            
            [self.managedObjectContext save:&error];
            
            //go and get that tree
            SLGithubSessionManager *manager = [SLGithubSessionManager sharedManager];
            NSString *username = [[manager currentUser] username];
            NSString *siteName = [[manager currentSite] name];
            
            NSString *treeGetString = [NSString stringWithFormat:@"/repos/%@/%@/git/trees/%@",username,siteName,tree.sha];
            [manager GET:treeGetString parameters:@{@"access_token" : [[manager currentUser] oauthToken]} success:treeSuccessBlock failure:treeFailBlock];
        }
    };
    
    void (^commitFailBlock)(NSURLSessionDataTask *, NSError *) = ^void (NSURLSessionDataTask *task, NSError *error){
        
    };
    
    
}

/*
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
*/
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Temporarily this is the settings button, later it will moved
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"showSettings" sender:self];
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showSettings"]){
        //Later this will be a settings view controller, but for right now
        //login is all we have
        SLLoginViewController *loginVC = (SLLoginViewController *)[(UINavigationController *)[segue destinationViewController] topViewController];
        loginVC.managedObjectContext = self.managedObjectContext;
    }
}


@end
