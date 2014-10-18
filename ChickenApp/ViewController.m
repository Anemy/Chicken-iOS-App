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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    
    NSLog(@"In view loading.");
    
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments, VENPermissionAccessProfile]
    withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [[self navigationController] setNavigationBarHidden:YES animated:YES];
            NSLog(@"Hey it loaded your profile");
            VENUser *user = [[Venmo sharedInstance] session].user;
            NSLog(@"Hey it loaded your access token!? %@", [[Venmo sharedInstance] session].accessToken);
            
            //UI image view displaying their icon
            UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(130,20,60,60)];
            imageView.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
            imageView.layer.borderWidth = 1.0f;
            imageView.layer.cornerRadius = 60.0f / 2.0f;
            imageView.layer.masksToBounds = YES;
            NSURL *imageURL = [NSURL URLWithString:user.profileImageUrl];
            [imageView sd_setImageWithURL:imageURL];
            [self.view addSubview:imageView];
            
            //UI Text label displaying user's name
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,70,100,100)];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.userInteractionEnabled=NO;
            NSString *txt = [NSString stringWithFormat:@"Logged in as %@", user.displayName];
            [nameLabel setFrame:CGRectMake(50,80,400,100)];
            [nameLabel setText:txt];
            [self.view addSubview:nameLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(showTransactions)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"Show Current Transactions" forState:UIControlStateNormal];
            button.frame = CGRectMake(50.0, 140.0, 240.0, 40.0);
            [self.view addSubview:button];
        }
        else {
            NSLog(@"NO :( WORK");
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

//user hits show transaction table
- (void)showTransactions {
    TransactionsTableViewController *transactions = [TransactionsTableViewController alloc];
    [self.navigationController pushViewController:transactions animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
