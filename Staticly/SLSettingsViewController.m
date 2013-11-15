//
//  SLSettingsViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 11/11/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLSettingsViewController.h"
#import "SLAppDelegate.h"
#import "SLUser.h"
#import "SLRepository.h"
#import "SLPickSiteViewController.h"
#import "SLPickUsersViewController.h"
#import "SLButtonCell.h"

@interface SLSettingsViewController ()

@property (strong, nonatomic) SLUser *currentUser;
@property (strong, nonatomic) SLRepository *currentSite;

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

- (NSManagedObjectContext *)managedObjectContext{
    if(_managedObjectContext == nil){
        _managedObjectContext = [(SLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSFetchRequest *userRequest = [[NSFetchRequest alloc] initWithEntityName:@"SLUser"];
    NSFetchRequest *siteRequest = [[NSFetchRequest alloc] initWithEntityName:@"SLRepository"];
    NSBlockOperation *userBlock = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error;
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"%K == TRUE", @"currentUser"];
        userRequest.predicate = userPredicate;
        NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];
        self.currentUser = [users firstObject];
        self.currentUserCell.textLabel.text = self.currentUser.username;
        [self.currentUserCell.textLabel sizeToFit];
    }];
    
    NSBlockOperation *siteBlock = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error;
        NSPredicate *sitePredicate = [NSPredicate predicateWithFormat:@"%K == TRUE", @"currentSite"];
        siteRequest.predicate = sitePredicate;
        NSArray *sites = [self.managedObjectContext executeFetchRequest:siteRequest error:&error];
        self.currentSite = [sites firstObject];
        self.currentSiteCell.textLabel.text = self.currentSite.name;
        [self.currentSiteCell.textLabel sizeToFit];

    }];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperation:userBlock];
    [mainQueue addOperation:siteBlock];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setSites:(NSArray *)sites{
//    if(_sites != sites){
//        _sites = sites;
//        [self.tableView reloadData];
//    }
//}
//
//- (void)setUsers:(NSArray *)users{
//    if(_users != users) {
//        _users = users;
//        [self.tableView reloadData];
//    }
//}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    switch (section) {
//        case 0:
//            return [self.users count] + 1;
//            break;
//        case 1:
//            return [self.sites count] + 1;
//            break;
//        default:
//            return 0;
//            break;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier;
//    if(indexPath.section == 0){
//        CellIdentifier = @"userCell";
//    }
//    else if(indexPath.section == 1){
//        CellIdentifier = @"siteCell";
//    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    if(indexPath.row == self.users.count + 1 || indexPath.row == self.sites.count + 1){
//        cell = [SLButtonCell buttonCellForSection:indexPath.section];
//    }
//    else{
//        if(indexPath.section == 0){
//            cell.textLabel.text = [[self.users objectAtIndex:indexPath.row] username];
//        }
//        else if(indexPath.section == 1){
//            
//        }
//    }
//    
//    return cell;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    switch (section) {
//        case 1:
//            return @"Users";
//            break;
//        case 2:
//            return @"Sites";
//            break;
//        default:
//            return nil;
//            break;
//    }
//}

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
    if(indexPath.section == 0){
        [self performSegueWithIdentifier:@"showUsers" sender:self];
    }
    else if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"showSites" sender:self];
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"showUsers"]){
        [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
    }
    else if([segue.identifier isEqualToString:@"showSites"]){
        [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
    }
}



@end
