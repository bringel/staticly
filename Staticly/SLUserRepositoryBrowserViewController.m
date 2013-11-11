//
//  SLUserRepositoryBrowserViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 11/11/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLUserRepositoryBrowserViewController.h"
#import "SLGithubClient.h"
#import "SLRepository.h"

@interface SLUserRepositoryBrowserViewController ()

@property (strong, nonatomic) NSArray *repositories;

@end

@implementation SLUserRepositoryBrowserViewController

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
    
    //We should load all the repositories that the user has so they can select one to use
    [[SLGithubClient sharedClient] setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    [[SLGithubClient sharedClient] GET:@"/user/repos" parameters: @{@"access_token" : [self.currentUser oauthToken]}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                   if(response.statusCode == 200){
                                       NSArray *repos = responseObject;
                                       for(NSDictionary *repo in repos){
                                           //This will crash if any of these objects are NSNull.
                                           //FIXME
                                           SLRepository *newRepository = [NSEntityDescription insertNewObjectForEntityForName:@"SLRepository" inManagedObjectContext:self.managedObjectContext];
                                           newRepository.name = [repo objectForKey:@"name"];
                                           newRepository.fullName = [repo objectForKey:@"full_name"];
                                           newRepository.homepage = [repo objectForKey:@"homepage"];
                                           newRepository.repoID = [repo objectForKey:@"id"];
                                           NSError *error;
                                           [self.managedObjectContext save:&error];
                                       }
                                       [self.tableView reloadData];
                                       NSLog(@"Got a bunch of repositories");
                                   }
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   NSLog(@"Uh Oh, something went wrong getting repositories: %@", error);
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
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"repoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    SLRepository *repository = [self.repositories objectAtIndex:indexPath.row];
    cell.textLabel.text = repository.name;
    cell.detailTextLabel.text = repository.fullName;
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
