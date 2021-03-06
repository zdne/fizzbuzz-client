//
//  ZNFizzBuzzTableViewController.m
//  FizzBuzz
//
//  Created by Zdenek Nemec on 5/27/14.
//  Copyright (c) 2014 Zdenek Nemec. All rights reserved.
//

#import "ZNFizzBuzzTableViewController.h"
#import "ZNFizzBuzzClient.h"
#import "ZNFizzBuzzAnswer.h"
#import "MBProgressHUD.h"

@interface ZNFizzBuzzTableViewController ()
@property (strong, nonatomic) NSArray* results;
@end

@implementation ZNFizzBuzzTableViewController

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
    
    // Setup the refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh FizzBuzz"];
    [refresh addTarget:self action:@selector(solveFizzBuzz) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // Solve FizzBuzz
    [self solveFizzBuzz];
}

- (void)solveFizzBuzz
{
    if (!self.refreshControl.refreshing)
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    __block ZNFizzBuzzTableViewController* blockSelf = self;
    [[ZNFizzBuzzClient sharedFizzBuzzClient] solveFizzBuzzWithCompletion:^(NSError *error, NSArray *result) {
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [blockSelf.refreshControl endRefreshing];
        
        if (error) {
            NSLog(@"Error solving the FizzBuzz: %@", error.localizedDescription);
            return;
        }
        
        blockSelf.results = result;
        [blockSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
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
    if (self.results)
        return self.results.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    cell.textLabel.text = ((ZNFizzBuzzAnswer *)self.results[indexPath.row]).number;
    cell.detailTextLabel.text = ((ZNFizzBuzzAnswer *)self.results[indexPath.row]).value;
    
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)trash:(id)sender {
    self.results = nil;
    [self.tableView reloadData];
}

@end
