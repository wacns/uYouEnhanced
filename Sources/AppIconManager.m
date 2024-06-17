#import "AppIconManager.h"

@implementation AppIconManager

+ (void)setIcon:(NSString *)appIcon completion:(void (^)(BOOL))completion {
    [[UIApplication sharedApplication] setAlternateIconName:appIcon completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error setting alternate icon %@: %@", appIcon, error.localizedDescription);
        }
        completion(error != nil);
    }];
}

+ (void)doesNotSupport {
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:nil];
}

@end
