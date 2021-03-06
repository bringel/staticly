//
//  SLPostsViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/13/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLPostsViewController.h"
#import "SLBlob.h"
#import "SLFileViewController.h"

@interface SLPostsViewController ()

@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *drafts;

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
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLBlob"];
    NSPredicate *postsPredicate = [NSPredicate predicateWithFormat:@"tree.path LIKE %@", @"_posts"];
    
    NSPredicate *draftsPredicate = [NSPredicate predicateWithFormat:@"tree.path LIKE %@", @"_drafts"];
    
    request.predicate = postsPredicate;
    
    NSError *error;
    self.posts = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    request.predicate = draftsPredicate;
    
    self.drafts = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return self.drafts.count;
    }
    else{
        return self.posts.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Drafts";
    }
    else{
        return @"Posts";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"postCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    SLBlob *post;
    if(indexPath.section == 0){
        post = [self.drafts objectAtIndex:indexPath.row];
    }
    else{
        post = [self.posts objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = post.path;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLBlob *selectedFile;
    if(indexPath.section == 0){
        selectedFile = [self.drafts objectAtIndex:indexPath.row];
    }
    else{
        selectedFile = [self.posts objectAtIndex:indexPath.row];
    }
    
    
    SLFileViewController *fileViewController = (SLFileViewController *)[[[self.splitViewController viewControllers] objectAtIndex:1] topViewController];
    fileViewController.file = selectedFile;
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
