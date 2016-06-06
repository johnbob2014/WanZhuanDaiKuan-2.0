//
//  AboutVC.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/9/30.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel2;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel3;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel4;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel5;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel6;
@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text=NSLocalizedString(@"玩转贷款2.0", @"");
    self.functionLabel1.text=NSLocalizedString(@"1.分期付款、房贷、车贷，贷贷精通", @"");
    self.functionLabel2.text=NSLocalizedString(@"2.分期付款计算实际利率", @"");
    self.functionLabel3.text=NSLocalizedString(@"3.将还款信息添加到日历", @"");
    self.functionLabel4.text=NSLocalizedString(@"4.翔实清晰的贷款明细", @"");
    self.functionLabel5.text=NSLocalizedString(@"5.内置计算器方便实用", @"");
    self.functionLabel6.text=NSLocalizedString(@"6.体积小，无广告，无插件", @"");
    self.buttomLabel.text=NSLocalizedString(@"2015 CTP Technology Co.,Ltd", @"");
}

@end
