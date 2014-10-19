//
//  DoubleUpViewController.m
//  ChickenApp
//
//  Created by Austin Louden on 10/19/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "DoubleUpViewController.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface DoubleUpViewController ()
@property (nonatomic, strong) NSDictionary *friend;
@property (nonatomic, strong) NSNumber *pastAmount;
@property (nonatomic, strong) NSString *transactionID;
@end

@implementation DoubleUpViewController

- (id)initWithTransaction:(NSDictionary *)transaction
{
    if (self = [super init]) {
        self.friend = [transaction valueForKey:@"actor"];
        self.pastAmount = [transaction valueForKey:@"amount"];
        self.transactionID = [transaction valueForKey:@"id"];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Chicken";
    
    self.view.backgroundColor = [UIColor peterRiverColor];
    
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
    
    
    UILabel *chickenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, self.view.frame.size.width, 200.0f)];
    chickenLabel.text = @"Are you chicken?";
    chickenLabel.font = [UIFont boldFlatFontOfSize:32.0f];
    chickenLabel.textColor = [UIColor whiteColor];
    chickenLabel.numberOfLines = 0;
    chickenLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:chickenLabel];
    
    
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 40.0)];
    [button addTarget:self
               action:@selector(doubleUp)
     forControlEvents:UIControlEventTouchUpInside];
    button.buttonColor = [UIColor alizarinColor];
    button.shadowColor = [UIColor pomegranateColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button setTitle:@"DOUBLE UP" forState:UIControlStateNormal];
    button.center = self.view.center;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y - 70.0f, button.frame.size.width, button.frame.size.height);
    [self.view addSubview:button];
    
    FUIButton *button2 = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 40.0)];
    [button2 addTarget:self
               action:@selector(settle)
     forControlEvents:UIControlEventTouchUpInside];
    button2.buttonColor = [UIColor sunflowerColor];
    button2.shadowColor = [UIColor tangerineColor];
    button2.shadowHeight = 3.0f;
    button2.cornerRadius = 6.0f;
    button2.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button2 setTitle:@"SETTLE" forState:UIControlStateNormal];
    button2.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + 70.0, button.frame.size.width, button.frame.size.height);
    [self.view addSubview:button2];
    
    FUIButton *button3 = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 40.0)];
    [button3 addTarget:self
                action:@selector(keep)
      forControlEvents:UIControlEventTouchUpInside];
    button3.buttonColor = [UIColor turquoiseColor];
    button3.shadowColor = [UIColor greenSeaColor];
    button3.shadowHeight = 3.0f;
    button3.cornerRadius = 6.0f;
    button3.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button3 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button3 setTitle:@"KEEP" forState:UIControlStateNormal];
    button3.frame = CGRectMake(button2.frame.origin.x, button2.frame.origin.y + 70.0, button2.frame.size.width, button2.frame.size.height);
    [self.view addSubview:button3];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doubleUp
{
    NSString *userRequested = [self.friend valueForKey:@"id"];
    NSString *theNote = @"Chicken";
    float amountToPay = [self.pastAmount floatValue] * 100.0;
    
    void(^handlerTwo)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Pay %@ failure.", userRequested);
        }
        else {
            NSLog(@"Pay %@ success!", userRequested);
            
            //now make the request (you don't want to request without paying!!
            void(^handler)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
                if (error) {
                    NSLog(@"Ask %@ for %f failure.", userRequested,amountToPay);
                }
                else {
                    NSLog(@"Ask %@ for %f success!! :))))", userRequested,amountToPay);
                    [self.navigationController popViewControllerAnimated:YES];
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

- (void) settle {
    //send them half the money they sent you. We're trying to break even here!
    NSString *userRequested = [self.friend valueForKey:@"id"];
    NSString *theNote = @"Settled";
    float amountToPay = [self.pastAmount floatValue] * 100.0;
    
    void(^handlerTwo)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Pay %@ failure.", userRequested);
        }
        else {
            NSLog(@"Pay %@ success!", userRequested);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [[Venmo sharedInstance] sendPaymentTo:userRequested
                                   amount:amountToPay/2
                                     note:theNote
                        completionHandler:handlerTwo];
}

- (void) keep {
    //send them half the money they sent you. We're trying to break even here!
    NSString *userRequested = [self.friend valueForKey:@"id"];
    NSString *theNote = @"Keep";
    float amountToPay = 1.0;
    
    void(^handlerTwo)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Pay %@ failure.", userRequested);
        }
        else {
            NSLog(@"Pay %@ success!", userRequested);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [[Venmo sharedInstance] sendPaymentTo:userRequested
                                   amount:amountToPay
                                     note:theNote
                        completionHandler:handlerTwo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
