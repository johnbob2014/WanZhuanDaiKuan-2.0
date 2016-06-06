//
//  DetailsTableViewController.h
//  房贷计算器
//
//  Created by 张保国 on 15/7/3.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModelObject.h"

@interface DetailsTableViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) DataModelObject *dataModelObject;
@property(assign,nonatomic) BOOL isVIP;

@end
