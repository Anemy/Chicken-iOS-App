//
//  ViewController.m
//  ChickenApp
//
//  Created by Titus on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "ViewController.h"
#import "TransactionsTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FriendsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor peterRiverColor];
    
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chicken.png"]];
    logoImage.frame = CGRectMake(0, 0, 200, 200);
    logoImage.center = self.view.center;
    logoImage.frame = CGRectMake(logoImage.frame.origin.x, logoImage.frame.origin.y - 100, 200, 200);
    [self.view addSubview:logoImage];
    
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 40.0)];
    [button addTarget:self
               action:@selector(showTransactions)
     forControlEvents:UIControlEventTouchUpInside];
    button.buttonColor = [UIColor turquoiseColor];
    button.shadowColor = [UIColor greenSeaColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button setTitle:@"Current Games" forState:UIControlStateNormal];
    button.center = self.view.center;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + 80.0f, button.frame.size.width, button.frame.size.height);
    [self.view addSubview:button];
    
    FUIButton *newButton = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 40.0)];
    [newButton addTarget:self
               action:@selector(showFriends)
     forControlEvents:UIControlEventTouchUpInside];
    newButton.buttonColor = [UIColor emerlandColor];
    newButton.shadowColor = [UIColor nephritisColor];
    newButton.shadowHeight = 3.0f;
    newButton.cornerRadius = 6.0f;
    newButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [newButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [newButton setTitle:@"Play Chicken!" forState:UIControlStateNormal];
    newButton.center = self.view.center;
    newButton.frame = CGRectMake(newButton.frame.origin.x, newButton.frame.origin.y + 30.0f, newButton.frame.size.width, newButton.frame.size.height);
    [self.view addSubview:newButton];
    

    
    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    
    NSLog(@"In view loading.");
    
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments, VENPermissionAccessProfile, VENPermissionAccessFriends]
    withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            
            NSLog(@"Hey it loaded your access token!? %@", [[Venmo sharedInstance] session].accessToken);
        }
        else {
            NSLog(@"NO :( WORK");
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

//user hits show transaction table
- (void)showTransactions {
    TransactionsTableViewController *transactions = [[TransactionsTableViewController alloc] init];
    [self.navigationController pushViewController:transactions animated:YES];
}

- (void)showFriends {
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    [self.navigationController pushViewController:friendsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
