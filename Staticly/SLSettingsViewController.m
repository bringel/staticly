//
//  SLSettingsViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/16/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLSettingsViewController.h"
#import "SLButtonCell.h"
#import "SLUser.h"
#import "SLSite.h"
#import "SLLoginViewController.h"
#import "SLSitesViewController.h"
#import "SLGithubSessionManager.h"

@interface SLSettingsViewController ()

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *sites;

@end

@implementation SLSettingsViewController

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
    
    NSFetchRequest *userRequest = [[NSFetchRequest alloc] initWithEntityName:@"SLUser"];
    NSFetchRequest *siteRequest = [[NSFetchRequest alloc] initWithEntityName:@"SLSite"];
    
    NSError *error;
    self.users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];
    self.sites = [self.managedObjectContext executeFetchRequest:siteRequest error:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePresed:(id)sender{
    //these settings need to be saved also
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return self.users.count + 1;
    }
    else{
        return self.sites.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if(indexPath.row == self.users.count || indexPath.row == self.sites.count){
        CellIdentifier = @"buttonCell";
    }
    else if(indexPath.section == 0){
        CellIdentifier = @"userCell";
    }
    else{
        CellIdentifier = @"siteCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.section == 0){
        if(indexPath.row == self.users.count){
            ((SLButtonCell *)cell).buttonLabel.text = @"Add New User";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.textLabel.text = [[self.users objectAtIndex:indexPath.row] username];
            if([[[self.users objectAtIndex:indexPath.row] currentUser] boolValue]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    else{
        if(indexPath.row == self.sites.count){
            ((SLButtonCell *)cell).buttonLabel.text = @"Add New Site";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.textLabel.text = [[self.sites objectAtIndex:indexPath.row] name];
            cell.detailTextLabel.text = [[[self.sites objectAtIndex:indexPath.row] owner] username];
            if([[[self.sites objectAtIndex:indexPath.row] currentSite] boolValue]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == self.users.count){
            [self performSegueWithIdentifier:@"addNewUser" sender:self];
        }
        else{
            //set the user as selected
        }
    }
    else{
        if(indexPath.row == self.sites.count){
            [self performSegueWithIdentifier:@"addNewSite" sender:self];
        }
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"addNewUser"]){
        SLLoginViewController *loginVC = (SLLoginViewController *)segue.destinationViewController;
        loginVC.managedObjectContext = self.managedObjectContext;
        loginVC.presentedFromSettings = YES;
    }
    else if([segue.identifier isEqualToString:@"addNewSite"]){
        SLSitesViewController *sitesVC = (SLSitesViewController *)segue.destinationViewController;
        sitesVC.currentUser = [[SLGithubSessionManager sharedManager] currentUser];
        sitesVC.managedObjectContext = self.managedObjectContext;
        sitesVC.presentedFromSettings = YES;
    }
}

- (IBAction)unwindFromNewUser:(UIStoryboardSegue *)sender{
    
}

- (IBAction)unwindFromNewSite:(UIStoryboardSegue *)sender{
    
}

@end
