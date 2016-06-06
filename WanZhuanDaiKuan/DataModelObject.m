//
//  DataModelObject.m
//  房贷计算器
//
//  Created by 张保国 on 15/7/3.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import "DataModelObject.h"

@implementation DataModelObject

-(DataModelObject *)init{
    DataModelObject *d=[DataModelObject alloc];
    d.loanType=0;
    d.loanName=nil;
    
    d.aTotal=0;
    d.nMonthCounts=0;
    d.iRateForMonth=0;
    d.repayType=0;

    d.aTotal1=0;
    d.nMonthCounts1=0;
    d.iRateForMonth1=0;
    d.repayType1=0;
    
    d.aTotal2=0;
    d.nMonthCounts2=0;
    d.iRateForMonth2=0;
    d.repayType2=0;
    
    d.aTotal2=3;
    d.nMonthCounts3=0;
    d.iRateForMonth3=0;
    d.repayType3=0;
    
    d.iCommission=0;
    d.iCommissionType=0;
    
    return d;
}

-(DataModelObject *)initWithaTotal:(float)newaTotal withnMonthCounts:(int)newnMonthCounts withiRateForMonth:(float)newiRateForMonth withrepayType:(int)newrepayType{
    DataModelObject *d=[[DataModelObject alloc]init];
    
    d.aTotal=newaTotal;
    d.nMonthCounts=newnMonthCounts;
    d.iRateForMonth=newiRateForMonth;
    d.repayType=newrepayType;
    
    return d;
}

-(float) totalInterest{
    float totalInterest=0;
    switch (_repayType) {
        case 0:
            //总利息（n+1）*a*i/2
            totalInterest=(_nMonthCounts+1)*_aTotal*_iRateForMonth/2;
            break;
        case 1:
            //总利息 Y=n*a*i*（1＋i）^n/[（1＋i）^n－1]-a
            totalInterest=_nMonthCounts*_aTotal*_iRateForMonth*powf(1+_iRateForMonth, _nMonthCounts)/(powf(1+_iRateForMonth, _nMonthCounts)-1)-_aTotal;
            break;
            
        default:
            break;
    }
    return totalInterest;
}

-(float) totalRepay{
    return _aTotal+[self totalInterest];
}

-(NSDate *)dateByAddingMonth:(int)count{
    //计算各期次的还款日期
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[dateFormatter stringFromDate:_startDate];
    
    NSInteger day=[[dateString substringWithRange:NSMakeRange(8, 2)]integerValue];
    NSInteger year=[[dateString substringWithRange:NSMakeRange(0, 4)]integerValue];
    NSInteger month=[[dateString substringWithRange:NSMakeRange(5, 2)]integerValue];
    for (int i=0; i<count; i++) {
        month++;
        if (month>12) {
            month=1;
            year+=1;
        }
    }
    
    //判断：不是每个月都有31号，2月只有28或29号
    if (day==31) {
        if (month==4||month==6||month==9||month==11) {
            day=30;
        }
    }
    if (month==2) {
        if (day>28) {
            day=28;
        }
    }
    
    NSString *endDateString=[[NSString alloc]initWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    NSDate *endDate=[dateFormatter dateFromString:endDateString];
    return endDate;
}
@end
