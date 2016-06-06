//
//  ShareViewController.h
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController<WXApiDelegate,MFMessageComposeViewControllerDelegate>

@end
