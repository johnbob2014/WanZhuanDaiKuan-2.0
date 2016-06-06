//
//  UIImage+CTPMethods.h
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/26.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CTPMethods)

/*! @brief CTP自定义函数，获取指定大小的缩略图。
 
 * 使用时要导入"UIImage+CTPMethods.h"
 
 * @attention 无注意事项
 
 * @param sourceImage 源图像
 
 * @param limitSize 缩略图大小
 
 * @return 返回缩略图
 
 */

+ (UIImage *)thumbImageFromImage:(UIImage *)sourceImage limitSize:(CGSize)limitSize;

@end
