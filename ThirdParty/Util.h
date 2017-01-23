//
//  Util.h
//  Kartis
//
//  Created by BaoAnh on 2/20/15.
//  Copyright (c) 2015 BaoAnh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define UTIL        [Util sharedInstant]

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


@interface Util : NSObject

+ (id)sharedInstant;
- (BOOL) validEmail:(NSString*) emailString;
- (void)showMessage:(UIViewController *) viewController messageWith: (NSString *)message;
- (void)openBrownserWithLink:(NSString *)link;
- (void)showHub:(BOOL)isShow;
- (NSString *)getAppVerison;
- (UIColor*)transformedColor:(NSString*)strColor;

-(NSString *)timeLeftSinceDate:(NSDate *)dateT;

@end
