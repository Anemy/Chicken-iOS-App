//
//  StartViewController.m
//  ChickenApp
//
//  Created by Austin Louden on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import "StartViewController.h"
#import "UISlider+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIButton.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface StartViewController ()
@property (nonatomic, strong) NSDictionary *friend;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) UILabel *dollarLabel;
@property (nonatomic, strong) FUIButton *playButton;
@property (nonatomic, strong) NSNumber *amountNumber;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation StartViewController

- (id)initWithFriend:(NSDictionary *)friend
{
    if (self = [super init]) {
        self.friend = friend;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor peterRiverColor];
    self.amountNumber = [NSNumber numberWithInt:1];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50.0, 50.0, 270.0, 10.0)];
    slider.center = self.view.center;
    slider.frame = CGRectMake(slider.frame.origin.x, slider.frame.origin.y - 40.0, slider.frame.size.width, slider.frame.size.height);
    
    self.numbers = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10)];
    NSInteger numberOfSteps = ((float)[self.numbers count] - 1);
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    
    slider.continuous = YES; // NO makes it call only once you let go
    [slider addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    [slider configureFlatSliderWithTrackColor:[UIColor cloudsColor]
                                  progressColor:[UIColor turquoiseColor]
                                     thumbColor:[UIColor greenSeaColor]];
    
    [self.view addSubview:slider];
    
    self.dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 250.0)];
    self.dollarLabel.center = self.view.center;
    self.dollarLabel.frame = CGRectMake(self.dollarLabel.frame.origin.x, self.dollarLabel.frame.origin.y - 200.0, self.dollarLabel.frame.size.width, self.dollarLabel.frame.size.height);
    self.dollarLabel.text = @"$1";
    self.dollarLabel.font = [UIFont boldFlatFontOfSize:120.0];
    self.dollarLabel.textAlignment = NSTextAlignmentCenter;
    self.dollarLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.dollarLabel];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, slider.frame.origin.y + 40.0, self.view.frame.size.width-20.0, 100)];
    self.descLabel.numberOfLines = 0;
    self.descLabel.text = [NSString stringWithFormat:@"Start a game by sending $%@ to %@", self.amountNumber, [self.friend objectForKey:@"display_name"]];
    self.descLabel.font = [UIFont boldFlatFontOfSize:32.0f];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.descLabel];
    
    self.playButton = [[FUIButton alloc] initWithFrame:CGRectMake(50.0, 140.0, 240.0, 60.0)];
    [self.playButton addTarget:self
                        action:@selector(playChicken)
              forControlEvents:UIControlEventTouchUpInside];
    self.playButton.buttonColor = [UIColor emerlandColor];
    self.playButton.shadowColor = [UIColor nephritisColor];
    self.playButton.shadowHeight = 3.0f;
    self.playButton.cornerRadius = 6.0f;
    self.playButton.titleLabel.font = [UIFont boldFlatFontOfSize:20];
    [self.playButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.playButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.playButton setTitle:@"Play chicken!" forState:UIControlStateNormal];
    self.playButton.center = self.view.center;
    self.playButton.frame = CGRectMake(self.playButton.frame.origin.x, CGRectGetMaxY(self.descLabel.frame) + 50.0f, self.playButton.frame.size.width, self.playButton.frame.size.height);
    [self.view addSubview:self.playButton];
    
    
}

- (void)valueChanged:(UISlider *)sender {
    // round the slider position to the nearest index of the numbers array
    NSUInteger index = (NSUInteger)(sender.value + 0.5);
    [sender setValue:index animated:NO];
    self.amountNumber = self.numbers[index]; // <-- This numeric value you want
    self.dollarLabel.text = [NSString stringWithFormat:@"$%@", self.amountNumber];
    self.descLabel.text = [NSString stringWithFormat:@"Start a game by sending $%@ to %@", self.amountNumber, [self.friend objectForKey:@"display_name"]];
}

- (void)playChicken
{
    NSLog(@"PLAYING CHICKING WITH AMOUNT NUMBER %@", self.amountNumber);
    NSString *userRequested = [self.friend valueForKey:@"id"];//phone number of mason requested / payed
    NSDate *date = [NSDate date];
    NSString *theNote = [NSString stringWithFormat:@"Chicken %f", [date timeIntervalSince1970]];
    float amountToPay = [self.amountNumber floatValue] * 100.0;
    
    void(^handlerTwo)(VENTransaction *, BOOL, NSError *) = ^(VENTransaction *transaction, BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Pay %@ failure.", userRequested);
            NSLog(@"%@",[error localizedDescription]);
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
                                           amount:amountToPay
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
