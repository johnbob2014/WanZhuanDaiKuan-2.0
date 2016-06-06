//
//  LoanViewController.h
//  房贷计算器
//
//  Created by 张保国 on 15/7/12.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanViewController : UIViewController <UITextFieldDelegate>

@property (assign,nonatomic) int loanType;
@property (assign,nonatomic) int viewIdentifier;

@property (strong,nonatomic)  UILabel *tileLabel;
@property (strong,nonatomic)  UITextField *aTotalTextField;
@property (strong,nonatomic)  UITextField *iRateForYearTextField;
@property (strong,nonatomic)  UITextField *nMonthCountsTextField;
@property (strong,nonatomic)  UILabel *nInfoLabel;
@property (strong,nonatomic)  UISlider *nMonthCountsSlider;
@property (strong,nonatomic)  UISegmentedControl *repayTypeSeg;
@property (strong,nonatomic)  UIStepper *nMonthCountsStepper;

//分期付款时，“贷款利率”显示为“手续费”或“手续费率”
@property (strong,nonatomic) UILabel *iRateLabel;

-(NSString *)yearInfo:(int)nMonthCounts;
@end
