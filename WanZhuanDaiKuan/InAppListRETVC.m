//
//  InAppListRETVC.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/9/28.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "InAppListRETVC.h"
#import "InAppPurchaseViewController.h"

@interface InAppListRETVC ()
@property (strong,nonatomic) RETableViewManager *manager;

@end

@implementation InAppListRETVC
#define WS(ws) __typeof (&*self) __weak weakSelf=self

#pragma mark - Getter & Setter
-(RETableViewManager *)manager{
    if (!_manager) {
        _manager=[[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
    }
    return _manager;
    
}

#pragma mark - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:NSLocalizedString(@"点击下列项目进行购买或恢复",@"") footerTitle:@""];
    [self.manager addSection:section];
    
    RETableViewItem *item=[RETableViewItem itemWithTitle:[[NSString alloc]initWithFormat:@"📅 %@", NSLocalizedString(@"将还款信息添加到日历 ¥6.0", @"")] accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",@"") message:NSLocalizedString(@"您将要购买“将还款信息添加到日历”功能，价格¥6.0，是否继续？",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"不需要此功能",@"") otherButtonTitles:NSLocalizedString(@"购买",@""),NSLocalizedString(@"恢复",@""),nil];
        alert.tag=15;
        [alert show];
    }];
    
    [section addItem:item];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        if (alertView.tag==15) {
            if (buttonIndex==alertView.firstOtherButtonIndex) {
                //用户点击”购买“
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"购买！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                [alert show];
                InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
                inApp.title=NSLocalizedString(@"应用程序内购买信息",@"");
                inApp.transactionType=TransactionTypePurchase;
                [self.navigationController pushViewController:inApp animated:YES];
            }
            
            if (buttonIndex==alertView.firstOtherButtonIndex+1) {
                //用户点击”恢复“
                InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
                inApp.title=NSLocalizedString(@"应用程序内购买信息",@"");
                inApp.transactionType=TransactionTypeRestore;
                [self.navigationController pushViewController:inApp animated:YES];
            }
            //
            //            if (buttonIndex==alertView.firstOtherButtonIndex+2) {
            //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"查看功能介绍！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //                [alert show];
            //            }
            //
        }
    }
}

@end
