//
//  SLFileViewController.m
//  Staticly
//
//  Created by Bradley Ringel on 1/15/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLFileViewController.h"
#import "SLYAMLEntryCell.h"

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
//        self.yamlTableView.delegate = self;
//        self.yamlTableView.dataSource = self;
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        self.yamlTableView.translatesAutoresizingMaskIntoConstraints = NO;
//        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [self.yamlTableView addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)pan:(UIPanGestureRecognizer *)gesture{
//    CGPoint beginPoint, translation;
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//            beginPoint = [gesture locationInView:self.yamlTableView];
//            break;
//        case UIGestureRecognizerStateEnded:
//            translation = [gesture translationInView:self.yamlTableView];
//            if(translation.y < beginPoint.y){
//                //move the tableview up
//                [UIView animateWithDuration:2.0 animations:^{
//                    //since there should only be one object, we can get the first one
//                    NSLayoutConstraint *heightConstraint = [self.yamlTableView.constraints firstObject];
//                    heightConstraint.constant = 0;
//                }];
//            }
//            break;
//        default:
//            break;
//    }
//}

- (void)setFile:(SLBlob *)file{
    NSString *fileContent = [[NSString alloc] initWithData:file.content encoding:NSASCIIStringEncoding];
    
//    NSArray *parts = [fileContent componentsSeparatedByString:@"---"];
//    //I happen to know that the first object in this array will be @""
//    self.frontMatter = [parts objectAtIndex:1];
//    self.body = [parts lastObject];
//    self.textView.text = self.body;
//    self.yamlMapping = nil;
//    
//    [self.yamlTableView reloadData];
//    CGFloat tableHeight = self.yamlMapping.count * [self.yamlTableView rowHeight];
//
//    NSArray *tableViewContstraints = [self.yamlTableView constraints];
//    for(NSLayoutConstraint *c in tableViewContstraints){
//        if(c.firstAttribute == NSLayoutAttributeHeight){
//            c.constant = tableHeight;
//        }
//    }
//    //do soemthing to fix the funky scrolling here
//    self.yamlTableView.contentOffset = CGPointZero;
//
    self.textView.text = fileContent;
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

//- (NSDictionary *)yamlMapping{
//    if(_yamlMapping == nil){
//        NSError *error;
//        _yamlMapping = [[YAMLSerialization objectsWithYAMLString:self.frontMatter options:kYAMLReadOptionStringScalars error:&error] firstObject];
//    }
//    
//    return _yamlMapping;
//}

//- (void)_loadYAMLView{
//    
//    NSError *error;
//    NSArray *yamlObjects = [YAMLSerialization objectsWithYAMLString:self.frontMatter options:kYAMLReadOptionMutableContainers error:&error];
//    
//    NSDictionary *mapping = [yamlObjects firstObject];
//    int mappingCount = [mapping count];
//    
//    
//}

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

//#pragma mark - UITableViewDelegate
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"yamlCell";
//    
//    SLYAMLEntryCell *cell = [self.yamlTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    
//    
//    NSArray *keys = [self.yamlMapping allKeys];
//    NSObject *something = [self.yamlMapping objectForKey:[keys objectAtIndex:indexPath.row]];
//    
//    cell.textField.placeholder = [keys objectAtIndex:indexPath.row];
//    [cell.textField.floatingLabel sizeToFit];
//    cell.textField.floatingLabel.font = [UIFont boldSystemFontOfSize:13];
//    cell.textField.floatingLabel.textColor = [UIColor blackColor];
//    if([something isKindOfClass:[NSString class]]){
//        cell.textField.text = (NSString *)something;
//    }
//    else{
//        //this is an array I hope
//        cell.textField.text = [(NSArray *)something description];
//    }
//    
//    return cell;
//}
//
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return [self.yamlMapping count];
//}

@end
