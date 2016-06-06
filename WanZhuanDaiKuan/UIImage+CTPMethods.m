//
//  UIImage+CTPMethods.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/26.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "UIImage+CTPMethods.h"

@implementation UIImage (CTPMethods)

+ (UIImage *)thumbImageFromImage:(UIImage *)sourceImage limitSize:(CGSize)limitSize {
    if (sourceImage.size.width <= limitSize.width && sourceImage.size.height <= limitSize.height) {
        return sourceImage;
    }
    CGSize thumbSize;
    if (sourceImage.size.width / sourceImage.size.height > limitSize.width / limitSize.height){
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / sourceImage.size.width * sourceImage.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / sourceImage.size.height * sourceImage.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [sourceImage drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

@end
