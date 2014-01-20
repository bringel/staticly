//
//  SLFileViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/15/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLFileViewController.h"

@interface SLFileViewController ()

@property (strong, nonatomic) NSString *frontMatter;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSDictionary *yamlMapping;

@end

@implementation SLFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.yamlTableView.delegate = self;
        self.yamlTableView.dataSource = self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.yamlTableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setFile:(SLBlob *)file{
    NSString *fileContent = [[NSString alloc] initWithData:file.content encoding:NSASCIIStringEncoding];
    
    NSArray *parts = [fileContent componentsSeparatedByString:@"---"];
    //I happen to know that the first object in this array will be @""
    self.frontMatter = [parts objectAtIndex:1];
    self.body = [parts lastObject];
    self.textView.text = self.body;
    
    [self.yamlTableView reloadData];
    
}

- (NSString *)frontMatter{
    if(_frontMatter == nil){
        NSString *fileContent = [[NSString alloc] initWithData:self.file.content encoding:NSASCIIStringEncoding];
        if(fileContent == nil){
            return nil;
        }
        NSArray *parts = [fileContent componentsSeparatedByString:@"---"];
        if(parts.count != 1){
            _frontMatter = [parts objectAtIndex:1];
        }
    }
    
    return _frontMatter;
}

- (NSDictionary *)yamlMapping{
    if(_yamlMapping == nil){
        NSError *error;
        _yamlMapping = [[YAMLSerialization objectsWithYAMLString:self.frontMatter options:kYAMLReadOptionStringScalars error:&error] firstObject];
    }
    
    return _yamlMapping;
}

- (void)_loadYAMLView{
    
    NSError *error;
    NSArray *yamlObjects = [YAMLSerialization objectsWithYAMLString:self.frontMatter options:kYAMLReadOptionMutableContainers error:&error];
    
    NSDictionary *mapping = [yamlObjects firstObject];
    int mappingCount = [mapping count];
    
    
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    
    barButtonItem.title = @"Menu";
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button{
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController{
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"entryCell";
    
    UITableViewCell *cell = [self.yamlTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Testing";
    return cell;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    CGFloat tableHeight = self.yamlMapping.count * [self.yamlTableView rowHeight];
//    CGRect oldFrame = self.yamlTableView.frame;
//    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, tableHeight);
//    self.yamlTableView.frame = newFrame;
//    [self.view setNeedsUpdateConstraints];
//    [self.view layoutIfNeeded];
//
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.yamlTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:tableHeight];
//    heightConstraint.priority = UILayoutPriorityRequired;
//    [self.view addConstraint:heightConstraint];
//    [self.view setNeedsUpdateConstraints];
//    [self.view layoutIfNeeded];
    
    NSArray *tableViewContstraints = [self.yamlTableView constraints];
    for(NSLayoutConstraint *c in tableViewContstraints){
        if(c.firstAttribute == NSLayoutAttributeHeight){
            c.constant = tableHeight;
        }
    }
    
    [self.view setNeedsUpdateConstraints];
    return [self.yamlMapping count];
}

@end
