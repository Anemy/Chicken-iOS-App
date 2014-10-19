//
//  TransactionsTableViewController.m
//  ChickenApp
//
//  Created by Titus on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "ChickenAPIClient.h"
#import "DoubleUpViewController.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"

@interface TransactionsTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *pastTrades;

@end

@implementation TransactionsTableViewController

UIActivityIndicatorView *indicator;
int currentCellFill = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Current Games";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                  highlightedColor:[UIColor belizeHoleColor]
                                      cornerRadius:3
                                   whenContainedIn:[UINavigationBar class], nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont flatFontOfSize:15.0]
       } forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldFlatFontOfSize:18],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.pastTrades = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    __weak TransactionsTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
        
    }];
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)refreshData
{
    NSDictionary *parameters = @{@"access_token": [[Venmo sharedInstance] session].accessToken};
    [[ChickenAPIClient sharedClient] GET:@"payments" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //self.pastTrades = [responseObject objectForKey:@"data"];
        NSLog(@"Size of transaction history before filter: %lu", (unsigned long)[self.pastTrades count]);
        
        NSMutableArray *disallowedUsers = [NSMutableArray array];
        
        for(NSDictionary *transaction in [responseObject objectForKey:@"data"]) {
            //check if data is there
            if([[transaction valueForKey:@"target"] valueForKey:@"user"] != nil) {
                //and also it's a pending request (can be action:pay/charge)
                //and also the word ChickenBet is in the note
                //NSLog(@"Is %@ == pending?", [transaction valueForKey:@"status"]);
                //NSLog(@"Is %@ == Chicken?", [transaction valueForKey:@"note"]);
                
                //increase the amount of cells to be displayed if allowed
                int allowAdd = 1;
                
                //see if target is self or other
                NSString *username = [[[[Venmo sharedInstance] session] user] username];
                NSString *othername = [[[transaction valueForKey:@"target"] valueForKey:@"user"] valueForKey:@"username"];
                NSString *targetUser;
                
                if([username isEqualToString:othername]) {//you are targ
                    targetUser = [[transaction valueForKey:@"actor"] valueForKey:@"username"];
                }
                else { //targ other
                    targetUser = [[[transaction valueForKey:@"target"] valueForKey:@"user"] valueForKey:@"username"];
                }
                
                for(int i = 0; i < disallowedUsers.count; i++) {
                    if([[disallowedUsers objectAtIndex:i] isEqualToString:targetUser]) {
                        allowAdd = 0;
                        break;
                    }
                }
                if(allowAdd == 0)
                    continue;
                
                NSString *transactionNote = [transaction valueForKey:@"note"];
                NSLog(@"NOTE: %@ from user %@ with status %@", transactionNote, targetUser, [transaction valueForKey:@"status"]);
                
                if([[transaction valueForKey:@"status"] isEqualToString:@"pending"]
                   && [transactionNote containsString:@"Chicken"]){
                    //increase the amount of cells to be displayed if allowed
                    [self.pastTrades addObject:transaction];
                    [disallowedUsers addObject:targetUser];
                }
                else if([[transaction valueForKey:@"status"] isEqualToString:@"settled"]
                        && [transactionNote containsString:@"Settle"]){
                    //increase the amount of cells to be displayed if allowed
                    [disallowedUsers addObject:targetUser];
                    NSLog(@"settle regist");
                }
                else if([[transaction valueForKey:@"status"] isEqualToString:@"settled"]
                        && [transactionNote containsString:@"Keep"]){
                    //increase the amount of cells to be displayed if allowed
                    [disallowedUsers addObject:targetUser];
                }
                
            }
        }
        
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"request failed with error: %@", error);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.pastTrades count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"here\n");
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
        
    NSString *actorName = [[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"actor"] valueForKey:@"display_name"];
    
    
    NSString *targetName = [[[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"target"] valueForKey:@"user"] valueForKey:@"display_name"];
    
    //need to check the type of this, might be error
    NSString *amount = [[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"amount"];
    
    NSLog(@"%@ is charging %@ an amount of %@ with action %@",
          actorName,
          targetName,
          amount,
          [[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"action"]
          );
    

    
    //type 1 action you are charging someone
    if([[[[[Venmo sharedInstance] session] user] displayName] isEqualToString:actorName]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@",targetName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Owes you $%@", [[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"amount"]];
        
        NSURL *url = [NSURL URLWithString:[[[[self.pastTrades objectAtIndex:indexPath.row] objectForKey:@"target"] objectForKey:@"user"] objectForKey:@"profile_picture_url"]];
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Chicken.png"]];
        
    }
    
    //type 2 you are being charged
    else {
        NSURL *url = [NSURL URLWithString:[[[self.pastTrades objectAtIndex:indexPath.row] objectForKey:@"actor"] objectForKey:@"profile_picture_url"]];
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Chicken.png"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ is charging you $%@",
                               actorName,
                               [[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"amount"]];
        //NSLog(@"%@", [self.pastTrades objectAtIndex:indexPath.row]);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Double up, settle, or keep!"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *actorName = [[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"actor"] valueForKey:@"display_name"];
    
    //type 1 action you are charging someone
    if([[[[[Venmo sharedInstance] session] user] displayName] isEqualToString:actorName]){
        NSLog(@"their turn");
        return;
    }
    
    //type 2 you are being charged
    else {
        NSLog(@"your turn");
        NSDictionary *transaction = [self.pastTrades objectAtIndex:indexPath.row];
        DoubleUpViewController *doubleUpController = [[DoubleUpViewController alloc] initWithTransaction:transaction];
        [self.navigationController pushViewController:doubleUpController animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end


