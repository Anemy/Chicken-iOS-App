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

@interface StartViewController ()
@property (nonatomic, strong) NSDictionary *friend;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) UILabel *dollarLabel;
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
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50.0, 50.0, 270.0, 10.0)];
    slider.center = self.view.center;
    slider.frame = CGRectMake(slider.frame.origin.x, slider.frame.origin.y, slider.frame.size.width, slider.frame.size.height);
    
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
    
    
}

- (void)valueChanged:(UISlider *)sender {
    // round the slider position to the nearest index of the numbers array
    NSUInteger index = (NSUInteger)(sender.value + 0.5);
    [sender setValue:index animated:NO];
    NSNumber *number = self.numbers[index]; // <-- This numeric value you want
    self.dollarLabel.text = [NSString stringWithFormat:@"$%@", number];
    NSLog(@"sliderIndex: %i", (int)index);
    NSLog(@"number: %@", number);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
