
#import "ChickenAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.venmo.com/v1/";

@implementation ChickenAPIClient

+ (instancetype)sharedClient {
    static ChickenAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ChickenAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end