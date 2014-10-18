//
//  TransactionsTableViewController.m
//  ChickenApp
//
//  Created by Titus on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "TransactionsTableViewController.h"

@interface TransactionsTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *pastTrades;

@end

@implementation TransactionsTableViewController

UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pastTrades = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     [self.view addSubview:self.tableView];
    
    //create a loading icon
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(100.0, 100.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];

    //Load all of the user's transactions
    //get their past transactions
    NSString *pastTransactions = [NSString stringWithFormat:@"https://api.venmo.com/v1/payments?access_token=%@",[[Venmo sharedInstance] session].accessToken];
    
    NSURL *pastTransactionsURL = [[NSURL alloc] initWithString:pastTransactions];
    NSLog(@"%@", pastTransactions);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:pastTransactionsURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Yo we got errors fetching past transactions");
        } else {
            NSLog(@"Yo we got that DATA!!1! past transactions");
            
            NSError *localError = nil;
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            
            if (localError != nil) {
                NSLog(@"Yo local error != nil, tryna parse that json");
                //break;
                
            }
            else {
                
                NSArray *results = [parsedObject valueForKey:@"data"];
                NSLog(@"Count %lu", (unsigned long)results.count);
                
                
                for (NSDictionary *transaction in results) {
                    NSLog(@"Transaction found!! : %@ added that to the table yo.",[transaction valueForKey:@"status"]);
                    if([transaction valueForKey:@"status"] == ) {
                        [self.pastTrades addObject:transaction];
                        [self.tableView reloadData];
                    }
                    
                    /*for (NSString *key in transaction) {
                     NSLog(@"Count %d", results.count);
                     }*/
                }
                
                //adding the table view
        
                
                [indicator stopAnimating];
            }
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Return the number of rows in the section.
    return [self.pastTrades count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }//UITableViewCellStyleDefault
    
    NSLog(@"Attempt to load data into cell.");
    cell.textLabel.text = [NSString stringWithFormat:@"Status: %@",[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"status"]];
    //check if data is there
    if([[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"target"] valueForKey:@"user"] != nil) {
        NSLog(@"Adding data to cell.");
        NSObject *targetUser = [[[self.pastTrades objectAtIndex:indexPath.row] valueForKey:@"target"] valueForKey:@"user"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Target: %@", [targetUser valueForKey:@"display_name"]];
    } else {
        cell.detailTextLabel.text = @"Public";
    }
    
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailViewController *detailTransaction = [[TransactionDetailViewController alloc] initWithData:[self.pastTrades objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailTransaction animated:YES];
}


@end
