//
//  FriendsViewController.m
//  ChickenApp
//
//  Created by Austin Louden on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "FriendsViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "ChickenAPIClient.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "StartViewController.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Choose a friend";
    
    self.friends = [NSArray array];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-20.0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
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

    NSString *url = [NSString stringWithFormat:@"users/%@/friends", [[[[Venmo sharedInstance] session] user] externalId]];
    NSDictionary *parameters = @{@"access_token": [[Venmo sharedInstance] session].accessToken};
    [[ChickenAPIClient sharedClient] GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.friends = [responseObject objectForKey:@"data"];
        //NSLog(@"FRIENDS %@", self.friends);
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
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
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSURL *url = [NSURL URLWithString:[[self.friends objectAtIndex:indexPath.row] objectForKey:@"profile_picture_url"]];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Chicken.png"]];
    cell.textLabel.text = [[self.friends objectAtIndex:indexPath.row] objectForKey:@"display_name"];
    
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StartViewController *startController = [[StartViewController alloc] initWithFriend:[self.friends objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:startController animated:YES];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
