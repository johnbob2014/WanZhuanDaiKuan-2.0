//
//  EntryLoanRETVC.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/8/22.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "EntryLoanRETVC.h"
#import "DetailsTableViewController.h"
#import "DataModelObject.h"
#import "InAppCaculatorViewController.h"
#import <iAd/iAd.h>


#define NumberAndDecimal @"0123456789.\n"
#define Number @"0123456789\n"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\n"

static NSString * const tableName=@"EntryLoanRETVC";

typedef BOOL (^onChangeCharacterInRange)(RETextItem *item, NSRange range, NSString *replacementString);

@interface EntryLoanRETVC ()<ADBannerViewDelegate>
@property (strong,readwrite,nonatomic) RETableViewManager *manager;
@property (strong,readwrite,nonatomic) RETableViewSection *requiredSection;
@property (strong,readwrite,nonatomic) RETableViewSection *requiredSection2;
@property (strong,readwrite,nonatomic) RETableViewSection *optionalSection;
@property (strong,nonatomic) RETableViewSection *buttonSection;

@property (strong,nonatomic) RETextItem *totalTextItem;
@property (strong,nonatomic) RETextItem *rateTextItem;
@property (strong,nonatomic) RETextItem *monthNumberItem;
@property (strong,nonatomic) RESegmentedItem *repayTypeSegItem;

@property (strong,nonatomic) RETextItem *totalTextItem2;
@property (strong,nonatomic) RETextItem *rateTextItem2;
@property (strong,nonatomic) RETextItem *monthNumberItem2;
@property (strong,nonatomic) RESegmentedItem *repayTypeSegItem2;

@property (strong,nonatomic) REDateTimeItem *dateTimeItem;
@property (strong,nonatomic) RETextItem *loanNameTextItem;

@property (strong,nonatomic) DataModelObject *dataModelObject;

@property (copy,nonatomic) onChangeCharacterInRange limitNumberAndDecimalBlock;
@property (copy,nonatomic) onChangeCharacterInRange limitNumberBlock;


@property (strong,nonatomic) NSUserDefaults *defaults;

@property (nonatomic) float aTotal;
@property (nonatomic) float iRateForMonth;
@property (nonatomic) int nMonthCounts;
@property (nonatomic) int repayType;

@property (nonatomic) float aTotal1;
@property (nonatomic) float iRateForMonth1;
@property (nonatomic) int nMonthCounts1;
@property (nonatomic) int repayType1;
@property (nonatomic) float aTotal2;
@property (nonatomic) float iRateForMonth2;
@property (nonatomic) int nMonthCounts2;
@property (nonatomic) int repayType2;

@property (nonatomic) float aTotal3;
@property (nonatomic) int nMonthCounts3;
@property (nonatomic) int repayType3;
@property (nonatomic) float iComission;
@property (nonatomic) int iComissionType;

@property (strong,nonatomic) NSDate *startDate;
@property (strong,nonatomic) NSString *loanName;

@end

@implementation EntryLoanRETVC
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
        _dateTimeItem=[REDateTimeItem itemWithTitle:NSLocalizedStringFromTable(@"首次还款日期",tableName,@"") value:[NSDate date] placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
        _dateTimeItem.inlineDatePicker=YES;
    }
    return _dateTimeItem;
}

-(RETextItem *)loanNameTextItem{
    if (!_loanNameTextItem) {
        _loanNameTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"还款提醒标签",tableName,@"") value:@"" placeholder:NSLocalizedStringFromTable(@"还款提醒标签",tableName,@"")];
        _loanNameTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    }
    return _loanNameTextItem;
}

-(onChangeCharacterInRange)limitNumberAndDecimalBlock{
    if (!_limitNumberAndDecimalBlock) {
        _limitNumberAndDecimalBlock=[self createLimitInputBlockWithAllowedSting:NumberAndDecimal];
    }
    return _limitNumberAndDecimalBlock;
}

-(onChangeCharacterInRange)limitNumberBlock{
    if (!_limitNumberBlock) {
        _limitNumberBlock=[self createLimitInputBlockWithAllowedSting:Number];
    }
    return _limitNumberBlock;
}

-(onChangeCharacterInRange)createLimitInputBlockWithAllowedSting:(NSString *)string{
    onChangeCharacterInRange block=^(RETextItem *item, NSRange range, NSString *replacementString){
        NSString *allowedString=string;
        NSCharacterSet *forbidenCharacterSet=[[NSCharacterSet characterSetWithCharactersInString:allowedString] invertedSet];
        NSArray *filteredArray=[replacementString componentsSeparatedByCharactersInSet:forbidenCharacterSet];
        NSString *filteredString=[filteredArray componentsJoinedByString:@""];
        
        if (![replacementString isEqualToString:filteredString]) {
            NSLog(@"The character 【%@】 is not allowed!",replacementString);
        }
        
        return [replacementString isEqualToString:filteredString];
    };
    
    return block;
}

-(DataModelObject *)dataModelObject{
    if (!_dataModelObject) {
        _dataModelObject=[DataModelObject new];
    }
    return _dataModelObject;
}

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults=[NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

@synthesize aTotal=_aTotal;
-(float)aTotal{
    _aTotal=[[self.defaults valueForKey:@"aTotal"] floatValue];
    return _aTotal;
}
-(void)setATotal:(float)aTotal{
    _aTotal=aTotal;
    [self.defaults setFloat:aTotal forKey:@"aTotal"];
    self.dataModelObject.aTotal=aTotal;
}

@synthesize aTotal1=_aTotal1;
-(float)aTotal1{
    _aTotal1=[[self.defaults valueForKey:@"aTotal1"] floatValue];
    return _aTotal1;
}
-(void)setATotal1:(float)aTotal1{
    _aTotal1=aTotal1;
    [self.defaults setFloat:aTotal1 forKey:@"aTotal1"];
    self.dataModelObject.aTotal1=aTotal1;
}

@synthesize aTotal2=_aTotal2;
-(float)aTotal2{
    _aTotal2=[[self.defaults valueForKey:@"aTotal2"] floatValue];
    return _aTotal2;
}
-(void)setATotal2:(float)aTotal2{
    _aTotal2=aTotal2;
    [self.defaults setFloat:aTotal2 forKey:@"aTotal2"];
    self.dataModelObject.aTotal2=aTotal2;
}

@synthesize aTotal3=_aTotal3;
-(float)aTotal3{
    _aTotal3=[[self.defaults valueForKey:@"aTotal3"] floatValue];
    return _aTotal3;
}
-(void)setATotal3:(float)aTotal3{
    _aTotal3=aTotal3;
    [self.defaults setFloat:aTotal3 forKey:@"aTotal3"];
    self.dataModelObject.aTotal3=aTotal3;
}

@synthesize iRateForMonth=_iRateForMonth;
-(float)iRateForMonth{
    _iRateForMonth=[[self.defaults valueForKey:@"iRateForMonth"] floatValue];
    return _iRateForMonth;
}
-(void)setIRateForMonth:(float)iRateForMonth{
    _iRateForMonth=iRateForMonth;
    [self.defaults setFloat:iRateForMonth forKey:@"iRateForMonth"];
    self.dataModelObject.iRateForMonth=iRateForMonth;
}

@synthesize iRateForMonth1=_iRateForMonth1;
-(float)iRateForMonth1{
    _iRateForMonth1=[[self.defaults valueForKey:@"iRateForMonth1"] floatValue];
    return _iRateForMonth1;
}
-(void)setIRateForMonth1:(float)iRateForMonth1{
    _iRateForMonth1=iRateForMonth1;
    [self.defaults setFloat:iRateForMonth1 forKey:@"iRateForMonth1"];
    self.dataModelObject.iRateForMonth1=iRateForMonth1;
}

@synthesize iRateForMonth2=_iRateForMonth2;
-(float)iRateForMonth2{
    _iRateForMonth2=[[self.defaults valueForKey:@"iRateForMonth2"] floatValue];
    return _iRateForMonth2;
}
-(void)setIRateForMonth2:(float)iRateForMonth2{
    _iRateForMonth2=iRateForMonth2;
    [self.defaults setFloat:iRateForMonth2 forKey:@"iRateForMonth2"];
    self.dataModelObject.iRateForMonth2=iRateForMonth2;
}

@synthesize nMonthCounts=_nMonthCounts;
-(int)nMonthCounts{
    _nMonthCounts=[[self.defaults valueForKey:@"nMonthCounts"] intValue];
    return _nMonthCounts;
}
-(void)setNMonthCounts:(int)nMonthCounts{
    _nMonthCounts=nMonthCounts;
    [self.defaults setInteger:nMonthCounts forKey:@"nMonthCounts"];
    self.dataModelObject.nMonthCounts=nMonthCounts;
}

@synthesize nMonthCounts1=_nMonthCounts1;
-(int)nMonthCounts1{
    _nMonthCounts1=[[self.defaults valueForKey:@"nMonthCounts1"] intValue];
    return _nMonthCounts1;
}
-(void)setNMonthCounts1:(int)nMonthCounts1{
    _nMonthCounts1=nMonthCounts1;
    [self.defaults setInteger:nMonthCounts1 forKey:@"nMonthCounts1"];
    self.dataModelObject.nMonthCounts1=nMonthCounts1;
}

@synthesize nMonthCounts2=_nMonthCounts2;
-(int)nMonthCounts2{
    _nMonthCounts2=[[self.defaults valueForKey:@"nMonthCounts2"] intValue];
    return _nMonthCounts2;
}
-(void)setNMonthCounts2:(int)nMonthCounts2{
    _nMonthCounts2=nMonthCounts2;
    [self.defaults setInteger:nMonthCounts2 forKey:@"nMonthCounts2"];
    self.dataModelObject.nMonthCounts2=nMonthCounts2;
}

@synthesize nMonthCounts3=_nMonthCounts3;
-(int)nMonthCounts3{
    _nMonthCounts3=[[self.defaults valueForKey:@"nMonthCounts3"] intValue];
    return _nMonthCounts3;
}
-(void)setNMonthCounts3:(int)nMonthCounts3{
    _nMonthCounts3=nMonthCounts3;
    [self.defaults setInteger:nMonthCounts3 forKey:@"nMonthCounts3"];
    self.dataModelObject.nMonthCounts3=nMonthCounts3;
}

@synthesize repayType=_repayType;
-(int)repayType{
    _repayType=[[self.defaults valueForKey:@"repayType"] intValue];
    return _repayType;
}
-(void)setRepayType:(int)repayType{
    _repayType=repayType;
    [self.defaults setInteger:repayType forKey:@"repayType"];
    self.dataModelObject.repayType=repayType;
}

@synthesize repayType1=_repayType1;
-(int)repayType1{
    _repayType1=[[self.defaults valueForKey:@"repayType1"] intValue];
    return _repayType1;
}
-(void)setRepayType1:(int)repayType1{
    _repayType1=repayType1;
    [self.defaults setInteger:repayType1 forKey:@"repayType1"];
    self.dataModelObject.repayType1=repayType1;
}

@synthesize repayType2=_repayType2;
-(int)repayType2{
    _repayType2=[[self.defaults valueForKey:@"repayType2"] intValue];
    return _repayType2;
}
-(void)setRepayType2:(int)repayType2{
    _repayType2=repayType2;
    [self.defaults setInteger:repayType2 forKey:@"repayType2"];
    self.dataModelObject.repayType2=repayType2;
}

@synthesize iComission=_iComission;
-(float)iComission{
    _iComission=[[self.defaults valueForKey:@"iComission"] floatValue];
    return _iComission;
}
-(void)setIComission:(float)iComission{
    _iComission=iComission;
    [self.defaults setFloat:iComission forKey:@"iComission"];
    self.dataModelObject.iCommission=iComission;
}

@synthesize iComissionType=_iComissionType;
-(int)iComissionType{
    _iComissionType=[[self.defaults valueForKey:@"iComissionType"] floatValue];
    return _iComissionType;
}
-(void)setIComissionType:(int)iComissionType{
    _iComissionType=iComissionType;
    [self.defaults setFloat:iComissionType forKey:@"iComissionType"];
    self.dataModelObject.iCommissionType=iComissionType;
}

//@synthesize startDate=_startDate;
//-(NSDate *)startDate{
//    _startDate=[self.defaults valueForKey:@"startDate"];
//    return _startDate;
//}
//-(void)setStartDate:(NSDate *)startDate{
//    _startDate=startDate;
//    self.dataModelObject.startDate=startDate;
//    switch (self.loanType) {
//        case <#constant#>:
//            <#statements#>
//            break;
//            
//        default:
//            break;
//    }
//    [self.defaults setValue:startDate forKey:@"startDate"];
//}

#pragma mark - Lifecycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    //[self changeBounds];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *jsqBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"🔢" style:UIBarButtonItemStyleDone target:self action:@selector(jsqBarButtonItemPressed:)];
    /*
    UIBarButtonItem *calculateBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"马上计算" style:UIBarButtonItemStyleDone target:self action:@selector(calculateBarButtonItemPressed:)];
    UIBarButtonItem *flexibleSpaceBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //务必注意下面这一句，换成别的是不行的
    [self setToolbarItems:@[flexibleSpaceBarButtonItem,jsqBarButtonItem,flexibleSpaceBarButtonItem,calculateBarButtonItem,flexibleSpaceBarButtonItem]];
     */
    self.navigationItem.rightBarButtonItem=jsqBarButtonItem;
    
    switch (self.loanType) {
        case 0:
            self.requiredSection=[self createSingleLoanSection];
            [self.manager addSection:self.requiredSection];
            self.title=NSLocalizedStringFromTable(@"单一贷款",tableName,@"");
            break;
        case 1:
            self.requiredSection=[[self createMultiLoanSection] firstObject];
            self.requiredSection2=[[self createMultiLoanSection] lastObject];
            [self.manager addSectionsFromArray:@[self.requiredSection,self.requiredSection2]];
            self.title=NSLocalizedStringFromTable(@"组合贷款",tableName,@"");
            break;
        case 2:
            self.requiredSection=[self createFenqiLoanSection];
            [self.manager addSection:self.requiredSection];
            self.title=NSLocalizedStringFromTable(@"分期付款",tableName,@"");
            break;
            
        default:
            break;
    }
    
    self.optionalSection=[self createOptionalSection];
    self.buttonSection=[self createButtonSection];
    
    [self.manager addSectionsFromArray:@[self.optionalSection,self.buttonSection]];
    
    //[self addBannerView];
}

-(RETableViewSection *)createSingleLoanSection{
    
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:NSLocalizedStringFromTable(@"单一贷款",tableName,@"")];
    
    self.totalTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款总额",tableName,@"") value:(self.aTotal!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.aTotal]:nil placeholder:NSLocalizedStringFromTable(@"贷款总额",tableName,@"")];
    self.totalTextItem.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.totalTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.rateTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款利率",tableName,@"") value:(self.iRateForMonth!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.iRateForMonth*12*100]:nil placeholder:NSLocalizedStringFromTable(@"贷款利率",tableName,@"")];
    self.rateTextItem.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.rateTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.monthNumberItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款期次",tableName,@"") value:(self.nMonthCounts!=0)?[[NSString alloc]initWithFormat:@"%d",self.nMonthCounts]:nil placeholder:NSLocalizedStringFromTable(@"贷款期次",tableName,@"")];
    self.monthNumberItem.onChangeCharacterInRange=self.limitNumberBlock;
    self.monthNumberItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.repayTypeSegItem=[RESegmentedItem itemWithTitle:NSLocalizedStringFromTable(@"还款方式",tableName,@"")
                                  segmentedControlTitles:@[NSLocalizedStringFromTable(@"等额本金",tableName,@""),NSLocalizedStringFromTable(@"等额本息",tableName,@"")]
                                                   value:self.repayType switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    
    
    [section addItemsFromArray:@[self.totalTextItem,self.monthNumberItem,self.rateTextItem,self.repayTypeSegItem]];
    return section;
}

-(NSArray *)createMultiLoanSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:NSLocalizedStringFromTable(@"贷款一",tableName,@"")];
    
    self.totalTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款总额",tableName,@"") value:(self.aTotal1!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.aTotal1]:nil placeholder:NSLocalizedStringFromTable(@"贷款总额",tableName,@"")];
    self.totalTextItem.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.totalTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    self.totalTextItem.clearButtonMode=UITextFieldViewModeWhileEditing;

    
    self.rateTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款利率",tableName,@"") value:(self.iRateForMonth1!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.iRateForMonth1*12*100]:nil placeholder:NSLocalizedStringFromTable(@"贷款利率",tableName,@"")];
    self.rateTextItem.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.rateTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.monthNumberItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款期次",tableName,@"") value:(self.nMonthCounts1!=0)?[[NSString alloc]initWithFormat:@"%d",self.nMonthCounts1]:nil placeholder:NSLocalizedStringFromTable(@"贷款期次",tableName,@"")];
    self.monthNumberItem.onChangeCharacterInRange=self.limitNumberBlock;
    self.monthNumberItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.repayTypeSegItem=[RESegmentedItem itemWithTitle:NSLocalizedStringFromTable(@"还款方式",tableName,@"")
                                  segmentedControlTitles:@[NSLocalizedStringFromTable(@"等额本金",tableName,@""),NSLocalizedStringFromTable(@"等额本息",tableName,@"")]
                                                   value:self.repayType1 switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    [section addItemsFromArray:@[self.totalTextItem,self.monthNumberItem,self.rateTextItem,self.repayTypeSegItem]];
    
    RETableViewSection *section2=[RETableViewSection sectionWithHeaderTitle:NSLocalizedStringFromTable(@"贷款二",tableName,@"")];
    self.totalTextItem2=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款总额",tableName,@"") value:(self.aTotal2!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.aTotal2]:nil placeholder:NSLocalizedStringFromTable(@"贷款总额",tableName,@"")];
    self.totalTextItem2.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.totalTextItem2.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.rateTextItem2=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款利率",tableName,@"") value:(self.iRateForMonth2!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.iRateForMonth2*12*100]:nil placeholder:NSLocalizedStringFromTable(@"贷款利率",tableName,@"")];
    self.rateTextItem2.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.rateTextItem2.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.monthNumberItem2=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"贷款期次",tableName,@"") value:(self.nMonthCounts2!=0)?[[NSString alloc]initWithFormat:@"%d",self.nMonthCounts2]:nil placeholder:NSLocalizedStringFromTable(@"贷款期次",tableName,@"")];
    self.monthNumberItem2.onChangeCharacterInRange=self.limitNumberBlock;
    self.monthNumberItem2.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.repayTypeSegItem2=[RESegmentedItem itemWithTitle:NSLocalizedStringFromTable(@"还款方式",tableName,@"")
                                   segmentedControlTitles:@[NSLocalizedStringFromTable(@"等额本金",tableName,@""),NSLocalizedStringFromTable(@"等额本息",tableName,@"")]
                                                    value:self.repayType2 switchValueChangeHandler:^(RESegmentedItem *item) {
                                                        NSLog(@"Value: %ld", (long)item.value);
                                                    }];
    
    
    [section2 addItemsFromArray:@[self.totalTextItem2,self.monthNumberItem2,self.rateTextItem2,self.repayTypeSegItem2]];
    return @[section,section2];
}

-(RETableViewSection *)createFenqiLoanSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:NSLocalizedStringFromTable(@"分期付款",tableName,@"")];
    
    self.totalTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"分期总额",tableName,@"") value:(self.aTotal3!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.aTotal3]:nil placeholder:NSLocalizedStringFromTable(@"分期总额",tableName,@"")];
    self.totalTextItem.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.totalTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.rateTextItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"手续费（率）",tableName,@"") value:(self.iComission!=0)?[[NSString alloc]initWithFormat:@"%.2f",self.iComission]:nil placeholder:NSLocalizedStringFromTable(@"手续费（率）",tableName,@"")];
    self.rateTextItem.onChangeCharacterInRange=self.limitNumberAndDecimalBlock;
    self.rateTextItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.monthNumberItem=[RETextItem itemWithTitle:NSLocalizedStringFromTable(@"分期期次",tableName,@"") value:(self.nMonthCounts3!=0)?[[NSString alloc]initWithFormat:@"%d",self.nMonthCounts3]:nil placeholder:NSLocalizedStringFromTable(@"分期期次",tableName,@"")];
    self.monthNumberItem.onChangeCharacterInRange=self.limitNumberBlock;
    self.monthNumberItem.textFieldTextAlignment=NSTextAlignmentRight;
    
    self.repayTypeSegItem=[RESegmentedItem itemWithTitle:NSLocalizedStringFromTable(@"计息方式",tableName,@"")
                                  segmentedControlTitles:@[NSLocalizedStringFromTable(@"手续费率",tableName,@""),NSLocalizedStringFromTable(@"手续费",tableName,@"")]
                                                   value:self.iComissionType switchValueChangeHandler:^(RESegmentedItem *item) {
                                                       NSLog(@"Value: %ld", (long)item.value);
                                                   }];
    
    
    [section addItemsFromArray:@[self.totalTextItem,self.monthNumberItem,self.rateTextItem,self.repayTypeSegItem]];
    return section;
}


-(RETableViewSection *)createOptionalSection{
    RETableViewSection *section=[RETableViewSection sectionWithHeaderTitle:NSLocalizedStringFromTable(@"可选项",tableName,@"")];
    
    [section addItem:self.dateTimeItem];
    [section addItem:self.loanNameTextItem];
    
    return section;
}

- (RETableViewSection *)createButtonSection
{
    RETableViewSection *section = [RETableViewSection section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:NSLocalizedStringFromTable(@"开始计算",tableName,@"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        
        [self updateData];
        
        if ([self checkDataModelObject]) {
            DetailsTableViewController *detailsTVC=[DetailsTableViewController new];
            detailsTVC.dataModelObject=self.dataModelObject;
            [self.navigationController pushViewController:detailsTVC animated:YES];
        }
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    //RETableViewItem *adItem=[RETableViewItem item
    [section addItem:buttonItem];
    
    return section;
}

#pragma mark - Action
-(void)jsqBarButtonItemPressed:(id)sender{
    InAppCaculatorViewController *jsqViewController=[InAppCaculatorViewController new];
    [self.navigationController pushViewController:jsqViewController animated:NO];
}

-(void)calculateBarButtonItemPressed:(id)sender{
    [self updateData];
    
    if ([self checkDataModelObject]) {
        DetailsTableViewController *detailsTVC=[DetailsTableViewController new];
        detailsTVC.dataModelObject=self.dataModelObject;
        [self.navigationController pushViewController:detailsTVC animated:YES];
    }
}

#pragma mark - Update
-(void)updateData{
    switch (self.loanType) {
        case 0:
            self.dataModelObject.loanType=0;
            
            self.aTotal=[self.totalTextItem.value floatValue];
            self.iRateForMonth=[self.rateTextItem.value floatValue]/12/100;
            self.nMonthCounts=[self.monthNumberItem.value intValue];
            self.repayType=(int)self.repayTypeSegItem.value;
            
            break;
        
        case 1:
            self.dataModelObject.loanType=1;
            
            //还得需要这一段怪异的代码，奇怪奇怪
            self.totalTextItem=self.requiredSection.items[0];
            self.monthNumberItem=self.requiredSection.items[1];
            self.rateTextItem=self.requiredSection.items[2];
            self.repayTypeSegItem=self.requiredSection.items[3];
            
            self.aTotal1=[self.totalTextItem.value floatValue];
            self.iRateForMonth1=[self.rateTextItem.value floatValue]/12/100;
            self.nMonthCounts1=[self.monthNumberItem.value intValue];
            self.repayType1=(int)self.repayTypeSegItem.value;
            
            NSLog(@"%@",self.totalTextItem);
            NSLog(@"%@",self.monthNumberItem);
            NSLog(@"%@",self.rateTextItem);
            NSLog(@"%@",self.repayTypeSegItem);
            NSLog(@"%@",self.requiredSection.items);
            
            self.aTotal2=[self.totalTextItem2.value floatValue];
            self.iRateForMonth2=[self.rateTextItem2.value floatValue]/12/100;
            self.nMonthCounts2=[self.monthNumberItem2.value intValue];
            self.repayType2=(int)self.repayTypeSegItem2.value;
            
//            NSLog(@"%@",self.totalTextItem2);
//            NSLog(@"%@",self.monthNumberItem2);
//            NSLog(@"%@",self.rateTextItem2);
//            NSLog(@"%@",self.repayTypeSegItem2);
//            NSLog(@"%@",self.requiredSection2.items);

            break;
        
        case 2:
            self.dataModelObject.loanType=2;
            
            self.aTotal3=[self.totalTextItem.value floatValue];
            self.nMonthCounts3=[self.monthNumberItem.value intValue];
            self.iComission=[self.rateTextItem.value floatValue];
            self.iComissionType=(int)self.repayTypeSegItem.value;
            self.dataModelObject.repayType3=0;
            
            break;
            
        default:
            break;
    }
    self.dataModelObject.startDate=self.dateTimeItem.value;
    self.dataModelObject.loanName=self.loanNameTextItem.value;
}

-(BOOL)checkDataModelObject{
    BOOL checkResult=YES;
    UIAlertView *alert0=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"提示",tableName,@"") message:NSLocalizedStringFromTable(@"贷款期次不能为0" ,tableName,@"")delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"返回修改",tableName,@"") otherButtonTitles: nil];
    UIAlertView *alert1200=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"提示",tableName,@"") message:NSLocalizedStringFromTable(@"贷款期次不能大于1200",tableName,@"") delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"返回修改",tableName,@"") otherButtonTitles: nil];
    switch (_dataModelObject.loanType) {
        case 0:
            if (_dataModelObject.nMonthCounts==0) {
                checkResult=NO;
                [alert0 show];
            }
            if (_dataModelObject.nMonthCounts>1200) {
                checkResult=NO;
                [alert1200 show];
            }
            break;
        case 1:
            if (_dataModelObject.nMonthCounts1==0||_dataModelObject.nMonthCounts2==0) {
                checkResult=NO;
                [alert0 show];
            }
            if (_dataModelObject.nMonthCounts1>1200||_dataModelObject.nMonthCounts2>1200) {
                checkResult=NO;
                [alert1200 show];
            }
            break;
        case 2:
            if (_dataModelObject.nMonthCounts3==0) {
                checkResult=NO;
                [alert0 show];
            }
            if (_dataModelObject.nMonthCounts3>1200) {
                checkResult=NO;
                [alert1200 show];
            }
            break;
            
        default:
            break;
    }
    return checkResult;
}

#pragma mark - ADBannerViewDelegate
-(void)addBannerView{
    ADBannerView *adView=[[ADBannerView alloc]initWithAdType:ADAdTypeBanner];
    adView.delegate=self;
    adView.frame=CGRectMake(0,0, self.view.bounds.size.width, 20);
    
    [self.tableView addSubview:adView];
    //[self changeBounds];
    [adView setHidden:YES];
    
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    [UIView animateWithDuration:3.0 animations:^{
//        banner.hidden=NO;
//    }];
//    
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView animateWithDuration:3.0 animations:^{
        banner.hidden=YES;
    }];
    
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
}
-(void)changeBounds{
    CGRect bounds=self.tableView.bounds;
    bounds.origin.y-=100;
    self.tableView.bounds=bounds;
}
@end
