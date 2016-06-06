//
//  EntryLoanRETVC.h
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/8/22.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"

@interface EntryLoanRETVC : UITableViewController<RETableViewManagerDelegate>

@property (strong,readonly,nonatomic) RETableViewManager *manager;
@property (strong,readonly,nonatomic) RETableViewSection *requiredSection;
@property (strong,readonly,nonatomic) RETableViewSection *optionalSection;

@property (nonatomic) NSUInteger loanType;

@end
