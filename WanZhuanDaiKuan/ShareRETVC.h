//
//  ShareRETVC.h
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/9/30.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>

@interface ShareRETVC : UITableViewController<RETableViewManagerDelegate,WXApiDelegate,MFMessageComposeViewControllerDelegate>

@end
