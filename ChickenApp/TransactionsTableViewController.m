//
//  TransactionsTableViewController.m
//  ChickenApp
//
//  Created by Titus on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "ChickenAPIClient.h"

@interface TransactionsTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *pastTrades;

@end

@implementation TransactionsTableViewController

UIActivityIndicatorView *indicator;
int currentCellFill = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pastTrades = [NSArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     [self.view addSubview:self.tableView];
    
    //create a loading icon
//    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicator.frame = CGRectMake(100.0, 100.0, 40.0, 40.0);
//    indicator.center = self.view.center;
//    [self.view addSubview:indicator];
//    [indicator bringSubviewToFront:self.view];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
//    [indicator startAnimating];

    //Load all of the user's transactions
    //get their past transactions
    
    NSDictionary *parameters = @{@"access_token": [[Venmo sharedInstance] session].accessToken};
    [[ChickenAPIClient sharedClient] GET:@"payments" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.pastTrades = [responseObject objectForKey:@"data"];
        NSLog(@"Size of transaction history before filter: %lu", (unsigned long)[self.pastTrades count]);
        currentCellFill = 0;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"request failed with error: %@", error);
    }];
    
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
    NSInteger cellCount = 0;
    
    for(int i = 0; i < [self.pastTrades count]; i++) {
        //check if data is there
        if([[[self.pastTrades objectAtIndex:i] valueForKey:@"target"] valueForKey:@"user"] != nil) {
            //and also it's a pending request (can be action:pay/charge)
            //and also the word ChickenBet is in the note
            NSLog(@"Is %@ == pending?", [[self.pastTrades objectAtIndex:i] valueForKey:@"status"]);
            NSLog(@"Is %@ == ChickenBet?", [[self.pastTrades objectAtIndex:i] valueForKey:@"note"]);
            if([[[self.pastTrades objectAtIndex:i] valueForKey:@"status"] isEqualToString:@"pending"]
               && [[[self.pastTrades objectAtIndex:i] valueForKey:@"note"] isEqualToString:@"Chicken"]){
                //increase the amount of cells to be displayed
                NSLog(@"Increase size of table");
                cellCount++;
            }
        }
    }
    
    NSLog(@"Cell counts: %ld",(long)cellCount);
    
    return cellCount;//[self.pastTrades count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"here\n");
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //check if data is there
    for(int i = currentCellFill; i < [self.pastTrades count]; i++) {
        currentCellFill++;
        //check if a user is defined as target
        //and also it's a pending request (can be action:pay/charge)
        //and also the word ChickenBet is in the note
        //NSLog(@"Is %@ == pending?", [[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"status"]);
        if([[[self.pastTrades objectAtIndex:i] valueForKey:@"target"] valueForKey:@"user"] != nil
           && [[[self.pastTrades objectAtIndex:i] valueForKey:@"status"] isEqualToString:@"pending"]
           && [[[self.pastTrades objectAtIndex:i] valueForKey:@"note"] isEqualToString:@"Chicken"]){
            NSLog(@"Adding data to cell.");
            
            NSString *actorName = [[[self.pastTrades objectAtIndex:i] valueForKey:@"actor"] valueForKey:@"display_name"];
            
            
            NSString *targetName = [[[[self.pastTrades objectAtIndex:i] valueForKey:@"target"] valueForKey:@"user"] valueForKey:@"display_name"];
            
            //need to check the type of this, might be error
            NSString *amount = [[self.pastTrades objectAtIndex:i] valueForKey:@"amount"];
            
            NSLog(@"%@ is charging %@ an amount of %@ with action %@",
                  actorName,
                  targetName,
                  amount,
                  [[self.pastTrades objectAtIndex:i] valueForKey:@"action"]
                  );
            
            //type 1 action you are charging someone
            if([[[[[Venmo sharedInstance] session] user] displayName] isEqualToString:actorName]){
                cell.textLabel.text = [NSString stringWithFormat:@"%@",targetName];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Owes you $%@", [[self.pastTrades objectAtIndex:i] valueForKey:@"amount"]];
            }
            
            //type 2 you are being charged
            else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ is charging you $%@",
                                       actorName,
                                       [[self.pastTrades objectAtIndex:i] valueForKey:@"amount"]];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Play Double   |  Settle  |   Keep"];
            }
            
            //place holding filling data on cell
           // NSObject *targetUser = [[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"target"] valueForKey:@"user"];
            
            break;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailViewController *detailTransaction = [[TransactionDetailViewController alloc] initWithData:[self.pastTrades objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailTransaction animated:YES];
}


@end


