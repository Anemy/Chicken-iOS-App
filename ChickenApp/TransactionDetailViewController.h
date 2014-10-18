//
//  TransactionDetailViewController.h
//  ChickenApp
//
//  Created by Titus on 10/18/14.
//  Copyright (c) 2014 Rhys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Venmo-iOS-SDK/Venmo.h>

@interface TransactionDetailViewController : UIViewController
@property (nonatomic, retain) NSData *person;
- (id)initWithData:(NSData *)data;

@end
