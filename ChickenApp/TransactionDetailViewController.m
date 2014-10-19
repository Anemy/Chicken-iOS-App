//
//  TransactionDetailViewController.m
//  ChickenApp
//
//  Created by Titus on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TransactionDetailViewController ()
@end

@implementation TransactionDetailViewController

- (id)initWithData:(NSData *)data
{
    if (self = [super init]) {
        NSLog(@"Recieving data: %@", data);
        self.person = data;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *targetName = [NSString stringWithFormat:@"%@",
                            [[[self.person valueForKey:@"target"] valueForKey:@"user"] valueForKey:@"display_name"]];
    
    //UI Text label displaying user's name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,220,400,100)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.userInteractionEnabled=NO;
    NSString *txt = [NSString stringWithFormat:@"Play %@ in Chicken?",targetName];
    [nameLabel setText:txt];
    [self.view addSubview:nameLabel];
    NSLog(@"Recieving data: %@", self.person);
    
    //UI image view displaying your icon
    UIImageView *youImageView =[[UIImageView alloc] initWithFrame:CGRectMake(20,120,60,60)];
    youImageView.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    youImageView.layer.borderWidth = 1.0f;
    youImageView.layer.cornerRadius = 60.0f / 2.0f;
    youImageView.layer.masksToBounds = YES;
    NSURL *youImageURL = [NSURL URLWithString:
                       [[self.person valueForKey:@"actor"] valueForKey:@"profile_picture_url"]];
    [youImageView sd_setImageWithURL:youImageURL];
    [self.view addSubview:youImageView];
    
   //Just say VS
   UILabel *vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(130,120,100,100)];
   vsLabel.textColor = [UIColor blackColor];
   vsLabel.backgroundColor=[UIColor clearColor];
   vsLabel.userInteractionEnabled=NO;
   NSString *vstxt = [NSString stringWithFormat:@"VS"];
   [vsLabel setFrame:CGRectMake(120,120,400,100)];
   [vsLabel setText:vstxt];
   [self.view addSubview:vsLabel];
                                                                               
    //UI image view displaying their icon
    UIImageView *themImageView =[[UIImageView alloc] initWithFrame:CGRectMake(220,120,60,60)];
    themImageView.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
    themImageView.layer.borderWidth = 1.0f;
    themImageView.layer.cornerRadius = 60.0f / 2.0f;
    themImageView.layer.masksToBounds = YES;
    NSURL *themImageURL = [NSURL URLWithString:[[[self.person valueForKey:@"target"] valueForKey:@"user"] valueForKey:@"profile_picture_url"]];
    [themImageView sd_setImageWithURL:themImageURL];
    [self.view addSubview:themImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(makeRequest) forControlEvents:UIControlEventTouchUpInside];
                                                                            
    NSString *buttonTXT = [NSString stringWithFormat: @"Play 1 dollar against %@",targetName];
                                                                               
    [button setTitle:buttonTXT forState:UIControlStateNormal];
    button.frame = CGRectMake(40.0, 280.0, 240.0, 40.0);
    [self.view addSubview:button];
}

- (void) makeRequest {
    NSString *userRequested = @"6107374306";//phone number of mason requested / payed
    NSString *theNote = @"Testing API don't do anything";
    float amountToPay = 100.0;
    
    void(^handlerTwo)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Pay %@ for 0.01 failure.", userRequested);
        }
        else {
            NSLog(@"Pay %@ for 0.01 sucess!", userRequested);
            
            //now make the request (you don't want to request without paying!!
            void(^handler)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
                if (error) {
                    NSLog(@"Ask %@ for %f failure.", userRequested,amountToPay);
                }
                else {
                    NSLog(@"Ask %@ for %f sucees!! :))))", userRequested, amountToPay);
                }
            };
            
            [[Venmo sharedInstance] sendRequestTo:userRequested
                                           amount:amountToPay*2
                                             note:theNote
                                completionHandler:handler];
        }
    };
    [[Venmo sharedInstance] sendPaymentTo:userRequested
                                   amount:amountToPay
                                     note:theNote
                        completionHandler:handlerTwo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
