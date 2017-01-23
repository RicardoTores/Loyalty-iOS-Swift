//
//  Util.m
//  Kartis
//
//  Created by BaoAnh on 2/20/15.
//  Copyright (c) 2015 BaoAnh. All rights reserved.
//

#import "Util.h"
#import <UIKit/UIKit.h>
#import "Colectivo-Swift.h"

static Util *_util;

@implementation Util

+ (id)sharedInstant{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _util = [[Util alloc]init];
    });
    return _util;
}

- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)showMessage:(UIViewController *) viewController messageWith:(NSString *)message{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alertView show];
    UIAlertController *alert    = [UIAlertController alertControllerWithTitle:nil
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *OK       = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    
    [alert addAction:OK];
    if (viewController == nil)
        [alert presentationController];
    else
        [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)openBrownserWithLink:(NSString *)link{
    if (link && link.length > 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link]];
    }
}
- (void)showHub:(BOOL)isShow{
    AppDelegate* app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (isShow) {
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    }else{
        [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
    }
}
- (NSString *)getAppVerison{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
- (UIColor*)transformedColor:(NSString*)strColor {
    NSArray *arrColor = [strColor componentsSeparatedByString:@","];
    if (arrColor == nil || arrColor.count != 3) {
        return [UIColor whiteColor];
    }
    CGFloat red = [[arrColor objectAtIndex:0] floatValue] / 255.0;
    CGFloat green = [[arrColor objectAtIndex:1] floatValue] / 255.0;
    CGFloat blue = [[arrColor objectAtIndex:2] floatValue] / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //    [arrColor getObjects:0];
}


-(NSString *) timeLeftSinceDate:(NSDate *)dateT
{
    NSDate *now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitMonth |
                        NSCalendarUnitYear| NSCalendarUnitWeekOfMonth;
    NSDateComponents *comp = [cal components:unit
                                    fromDate:dateT
                                      toDate:now
                                     options:0];
    NSInteger years = comp.year;
    NSInteger months = comp.month;
    NSInteger weeks = comp.weekOfMonth;
    NSInteger days = comp.day;
    NSInteger hours = comp.hour;
    NSInteger mins = comp.minute;
    
    NSString* timeLeft = @"now";
    if(years > 0) {
        timeLeft = [NSString stringWithFormat:@"%ldyr ago", (long)years];
        return timeLeft;
    }
    if(months > 0) {
        timeLeft = [NSString stringWithFormat:@"%ldM ago", (long)months];
        return timeLeft;
    }
    if(weeks > 0) {
        timeLeft = [NSString stringWithFormat:@"%ldw ago", (long)weeks];
        return timeLeft;
    }
    if(days > 0) {
        timeLeft = [NSString stringWithFormat:@"%ldd ago", (long)days];
        return timeLeft;
    }
    if(hours > 0) {
        timeLeft = [NSString stringWithFormat:@"%ldh ago", (long)hours];
        return timeLeft;
    }
    if(mins > 0) {
        timeLeft = [NSString stringWithFormat:@"%ldm ago", (long)mins];
        return timeLeft;
    }
    return timeLeft;
}


@end
