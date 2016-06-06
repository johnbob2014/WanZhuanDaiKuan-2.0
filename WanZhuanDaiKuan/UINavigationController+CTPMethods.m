//
//  UINavigationController+CTPMethods.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/28.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "UINavigationController+CTPMethods.h"

@implementation UINavigationController (CTPMethods)

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //IOS8.0以下，只支持竖屏
    UIInterfaceOrientationMask orientation=UIInterfaceOrientationMaskPortrait;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        //IOS8.0（含）以上，支持竖屏、横屏
        orientation=UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return orientation;
}

@end
