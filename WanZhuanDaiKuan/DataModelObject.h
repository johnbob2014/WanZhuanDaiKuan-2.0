//
//  DataModelObject.h
//  房贷计算器
//
//  Created by 张保国 on 15/7/3.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModelObject : NSObject

//传递数据
@property(assign,nonatomic) int loanType;
@property(copy,nonatomic) NSString *loanName;

@property(assign,nonatomic) float aTotal1;
@property(assign,nonatomic) int nMonthCounts1;
@property(assign,nonatomic) float iRateForMonth1;
@property(assign,nonatomic) int repayType1;

@property(assign,nonatomic) float aTotal2;
@property(assign,nonatomic) int nMonthCounts2;
@property(assign,nonatomic) float iRateForMonth2;
@property(assign,nonatomic) int repayType2;

@property(assign,nonatomic) float aTotal3;
@property(assign,nonatomic) int nMonthCounts3;
@property(assign,nonatomic) float iRateForMonth3;
@property(assign,nonatomic) int repayType3;

//手续费或手续费率
@property(assign,nonatomic) float iCommission;
@property(assign,nonatomic) int iCommissionType;

//参与计算
@property(assign,nonatomic) float aTotal;
@property(assign,nonatomic) int nMonthCounts;
@property(assign,nonatomic) float iRateForMonth;
@property(assign,nonatomic) int repayType;

@property(strong,nonatomic) NSDate *startDate;

-(DataModelObject *)init;
-(DataModelObject *)initWithaTotal:(float)newaTotal withnMonthCounts:(int)newnMonthCounts withiRateForMonth:(float)newiRateForMonth withrepayType:(int)newrepayType;

-(NSDate *)dateByAddingMonth:(int)count;

-(float) totalInterest;
-(float) totalRepay;

@end
