//
//  UIDevice+CTPMethods.h
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/26.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (CTPMethods)
+ (NSString*)getDeviceVersion;
+ (NSString *)getCurrentDeviceModel;

+ (BOOL)isiPhone;
+ (BOOL)isiPhone4;
+ (BOOL)isiPhone5;
+ (BOOL)isiPhone6;

+ (BOOL)isiPad;

+ (BOOL)isiPod;

@end
