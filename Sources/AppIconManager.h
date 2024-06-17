#import <Foundation/Foundation.h>

@interface AppIconManager : NSObject

+ (void)setIcon:(NSString *)appIcon completion:(void (^)(BOOL))completion;
+ (void)doesNotSupport;

@end
