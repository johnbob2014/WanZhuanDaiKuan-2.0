//
//  SingleLoanRETVC.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/8/20.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "SingleLoanRETVC.h"

@interface SingleLoanRETVC ()

@property (strong,readwrite,nonatomic) RETableViewManager *manager;
@property (strong,readwrite,nonatomic) RETableViewSection *requiredSection;
@property (strong,readwrite,nonatomic) RETableViewSection *requiredSection2;
@property (strong,readwrite,nonatomic) RETableViewSection *optionalSection;
@property (strong,nonatomic) RETableViewSection *buttonSection;

@property (strong,nonatomic) RETextItem *totalTextItem;
@property (strong,nonatomic) RETextItem *rateTextItem;
@property (strong,nonatomic) RENumberItem *monthNumberItem;
@property (strong,nonatomic) RESegmentedItem *repayTypeSegItem;

@property (strong,nonatomic) RETextItem *totalTextItem2;
@property (strong,nonatomic) RETextItem *rateTextItem2;
@property (strong,nonatomic) RENumberItem *monthNumberItem2;
@property (strong,nonatomic) RESegmentedItem *repayTypeSegItem2;

@property (strong,nonatomic) REDateTimeItem *dateTimeItem;
@property (strong,nonatomic) RETextItem *nameTextItem;


@end

@implementation SingleLoanRETVC

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self

#pragma mark - Getter & Setter
-(RETableViewManager *)manager{
    if (!_manager) {
        _manager=[[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
        
    }
    return _manager;
    
}

-(REDateTimeItem *)dateTimeItem{
    if (!_dateTimeItem) {
        _dateTimeItem=[REDateTimeItem itemWithTitle:@"首次还款日期" value:[NSDate date] placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
        _dateTimeItem.inlineDatePicker=YES;
    }
    return _dateTimeItem;
}

-(RETextItem *)nameTextItem{
    if (!_nameTextItem) {
        _nameTextItem=[RETextItem itemWithTitle:@"还款提醒标签" value:@"" placeholder:@"还款提醒标签"];
    }
    return _nameTextItem;
}

#pragma mark - Lifecycle
-(void) viewDidLoad{
    [super viewDidLoad];
    
    switch (self.loanType) {
        case 0:
            self.requiredSection=[self createSingleLoanSection];
            [self.manager addSection:self.requiredSection];
            self.title=@"单一贷款";
            break;
        case 1:
            self.requiredSection=[[self createMultiLoanSection] firstObject];
            self.requiredSection2=[[self createMultiLoanSection] lastObject];
            [self.manager addSectionsFromArray:@[self.requiredSection,self.requiredSection2]];
            self.title=@"组合贷款";
            break;
        case 2:
            self.requiredSection=[self createFenqiLoanSection];
            [self.manager addSection:self.requiredSection];
            self.title=@"分期付款";
            break;
            
        default:
            break;
    }
    
    self.optionalSection=[self createOptionalSection];
    self.buttonSection=[self createButtonSection];
    
    [self.manager addSectionsFromArray:@[self.optionalSection,self.buttonSection]];

}

-(RETableViewSection *)createSingleLoanSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:@"单一贷款"];
    
    self.totalTextItem=[RETextItem itemWithTitle:@"贷款总额" value:nil placeholder:@"贷款总额"];
    self.rateTextItem=[RETextItem itemWithTitle:@"贷款利率" value:nil placeholder:@"贷款利率"];
    self.monthNumberItem=[RENumberItem itemWithTitle:@"贷款期次" value:@"" placeholder:@"贷款期次"];
    self.repayTypeSegItem=[RESegmentedItem itemWithTitle:@"还款方式"
                                  segmentedControlTitles:@[@"等额本金",@"等额本息"]
                                                   value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    
    
    [section addItemsFromArray:@[self.totalTextItem,self.rateTextItem,self.monthNumberItem,self.repayTypeSegItem]];
    return section;
}

-(NSArray *)createMultiLoanSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:@"贷款一"];
    
    self.totalTextItem=[RETextItem itemWithTitle:@"贷款总额" value:nil placeholder:@"贷款总额"];
    self.rateTextItem=[RETextItem itemWithTitle:@"贷款利率" value:nil placeholder:@"贷款利率"];
    self.monthNumberItem=[RENumberItem itemWithTitle:@"贷款期次" value:@"" placeholder:@"贷款期次"];
    self.repayTypeSegItem=[RESegmentedItem itemWithTitle:@"还款方式"
                                  segmentedControlTitles:@[@"等额本金",@"等额本息"]
                                                   value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    [section addItemsFromArray:@[self.totalTextItem,self.rateTextItem,self.monthNumberItem,self.repayTypeSegItem]];
    
    RETableViewSection *section2=[RETableViewSection sectionWithHeaderTitle:@"贷款二"];
    self.totalTextItem2=[RETextItem itemWithTitle:@"贷款总额" value:nil placeholder:@"贷款总额"];
    self.rateTextItem2=[RETextItem itemWithTitle:@"贷款利率" value:nil placeholder:@"贷款利率"];
    self.monthNumberItem2=[RENumberItem itemWithTitle:@"贷款期次" value:@"" placeholder:@"贷款期次"];
    self.repayTypeSegItem2=[RESegmentedItem itemWithTitle:@"还款方式"
                                  segmentedControlTitles:@[@"等额本金",@"等额本息"]
                                                   value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    
    
    [section2 addItemsFromArray:@[self.totalTextItem2,self.rateTextItem2,self.monthNumberItem2,self.repayTypeSegItem2]];
    return @[section,section2];
}

-(RETableViewSection *)createFenqiLoanSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:@"分期付款"];
    
    self.totalTextItem=[RETextItem itemWithTitle:@"分期总额" value:nil placeholder:@"分期总额"];
    self.rateTextItem=[RETextItem itemWithTitle:@"手续费（率）" value:nil placeholder:@"手续费（率）"];
    self.monthNumberItem=[RENumberItem itemWithTitle:@"分期期次" value:@"" placeholder:@"分期期次"];
    self.repayTypeSegItem=[RESegmentedItem itemWithTitle:@"计息方式"
                                  segmentedControlTitles:@[@"手续费",@"手续费率"]
                                                   value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    
    
    [section addItemsFromArray:@[self.totalTextItem,self.rateTextItem,self.monthNumberItem,self.repayTypeSegItem]];
    return section;
}


-(RETableViewSection *)createOptionalSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:@"可选项"];
    
    [section addItem:self.dateTimeItem];
    [section addItem:self.nameTextItem];
    
    return section;
}

- (RETableViewSection *)createButtonSection
{
    RETableViewSection *section = [RETableViewSection section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"开始计算" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        
        
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
    return section;
}

@end
