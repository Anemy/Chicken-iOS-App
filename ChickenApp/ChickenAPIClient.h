#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ChickenAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end