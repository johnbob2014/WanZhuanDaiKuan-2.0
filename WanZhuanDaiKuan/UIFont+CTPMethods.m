//
//  UIFont+CTPMethods.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/22.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "UIFont+CTPMethods.h"

@implementation UIFont (CTPMethods)

+(UIFont *)fontWithFamilyNames:(int)fontIndex size:(int)fontSize{
    UIFont *font=[UIFont fontWithName:[UIFont familyNames][fontIndex] size:fontSize];
    return font;
}

@end
