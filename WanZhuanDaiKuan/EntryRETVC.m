//
//  EntryRETVC.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/8/20.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "EntryRETVC.h"
#import "EntryLoanRETVC.h"
#import <iAd/iAd.h>

#import "InAppListRETVC.h"
#import "ShareRETVC.h"

@interface EntryRETVC ()<ADBannerViewDelegate>

@property (strong,readwrite,nonatomic) RETableViewManager *manager;

@end

@implementation EntryRETVC

#define WS(ws) __typeof (&*self) __weak weakSelf=self

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=NSLocalizedString(@"玩转贷款2.0",@"导航栏标题");
    
    WS(weakSelf);
        
    RETableViewSection *section1=[RETableViewSection section];
    [self.manager addSection:section1];
    
    NSString *t1=[[NSString alloc]initWithFormat:@"💰 %@",NSLocalizedString(@"单一贷款",@"")];
    [section1 addItem:[RETableViewItem itemWithTitle:t1 accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        EntryLoanRETVC *singleLoanRETVC=[[EntryLoanRETVC alloc]initWithStyle:UITableViewStyleGrouped];
        singleLoanRETVC.loanType=0;
        [weakSelf.navigationController pushViewController:singleLoanRETVC animated:YES];
    }]];
    
    NSString *t2=[[NSString alloc]initWithFormat:@"💸 %@",NSLocalizedString(@"组合贷款",@"")];
    [section1 addItem:[RETableViewItem itemWithTitle:t2 accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        EntryLoanRETVC *singleLoanRETVC=[[EntryLoanRETVC alloc]initWithStyle:UITableViewStyleGrouped];
        singleLoanRETVC.loanType=1;
        [weakSelf.navigationController pushViewController:singleLoanRETVC animated:YES];
    }]];
    
    NSString *t3=[[NSString alloc]initWithFormat:@"💳 %@",NSLocalizedString(@"分期付款",@"")];
    [section1 addItem:[RETableViewItem itemWithTitle:t3 accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        EntryLoanRETVC *singleLoanRETVC=[[EntryLoanRETVC alloc]initWithStyle:UITableViewStyleGrouped];
        singleLoanRETVC.loanType=2;
        [weakSelf.navigationController pushViewController:singleLoanRETVC animated:YES];
    }]];
    
    RETableViewSection *section2=[RETableViewSection section];
    [self.manager addSection:section2];
    
    NSString *t4=[[NSString alloc]initWithFormat:@"🔑 %@",NSLocalizedString(@"购买和恢复", @"")];
    [section2 addItem:[RETableViewItem itemWithTitle:t4 accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        InAppListRETVC *inApp=[[InAppListRETVC alloc]initWithStyle:UITableViewStyleGrouped];
        inApp.title=NSLocalizedString(@"应用程序内购买项目",@"");
        [self.navigationController pushViewController:inApp animated:YES];
    }]];
    
    NSString *t5=[[NSString alloc]initWithFormat:@"🎯 %@",NSLocalizedString(@"分享", @"")];
    [section2 addItem:[RETableViewItem itemWithTitle:t5 accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        ShareRETVC *share=[[ShareRETVC alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:share animated:YES];
    }]];
    
    //设置下一页返回按钮的标题
    UIBarButtonItem *backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"返回","") style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    
    //[self addBannerView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}

#pragma mark - Getter & Setter
-(RETableViewManager *)manager{
    if (!_manager) {
        _manager=[[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
    }
    return _manager;
    
}

#pragma mark - ADBannerViewDelegate
-(void)addBannerView{
    ADBannerView *adView=[[ADBannerView alloc]initWithAdType:ADAdTypeBanner];
    adView.delegate=self;
        adView.frame=CGRectMake(0,self.view.frame.size.height-95, self.view.frame.size.width,100);
    //NSLog(@"%.2f,%.2f,%.2f,%.2f",adView.frame.origin.x,adView.frame.origin.y,adView.frame.size.height,adView.frame.size.width);
    [self.view addSubview:adView];
    [adView setHidden:YES];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
    //NSLog(@"%.2f,%.2f,%.2f,%.2f",banner.frame.origin.x,banner.frame.origin.y,banner.frame.size.width,banner.frame.size.height);
    [UIView animateWithDuration:3.0 animations:^{
        //banner.hidden=NO;
    }];
    
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //NSLog(@"%@ %@",NSStringFromSelector(_cmd),[error localizedDescription]);
    [UIView animateWithDuration:3.0 animations:^{
        banner.hidden=YES;
    }];

}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
}
@end
