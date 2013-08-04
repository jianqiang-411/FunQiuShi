//
//  AppUltility.m
//  FunQiuShi
//
//  Created by lakkey on 13-6-9.
//
//

#import "AppUltility.h"

@implementation AppUltility

// 显现简单消息框
+ (void)showBoxWithMessage:(NSString* )strMessage {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}



@end
