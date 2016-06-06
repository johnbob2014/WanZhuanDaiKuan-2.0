//
//  DetailsTableViewController.m
//  房贷计算器
//
//  Created by 张保国 on 15/7/3.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "DetailsTableViewCell.h"
#import "math.h"
#import "InAppPurchaseViewController.h"
#import "UIFont+CTPMethods.h"
#import "UIDevice+CTPMethods.h"
#import "ShareViewController.h"
#import "InAppListRETVC.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

//static NSString * const reuseIdentifierForCell=@"ReuseIdentifierForCell";
static NSString * const kTotalForMonth=@"kTotalForMonth";
static NSString * const KPrincipalForMonth=@"KPrincipalForMonth";
static NSString * const kInterestForMonth=@"kInterestForMonth";
static NSString * const kRestPrincipal=@"kRestPrincipal";
static NSString * const kAllPayed=@"kAllPayed";
static NSString * const kAllHaveToPayForCurrentMonth=@"kAllHaveToPayForCurrentMonth";

static NSString * const kTotalForMonthFenQi=@"kTotalForMonthFenQi";
static NSString * const KPrincipalForMonthFenQi=@"KPrincipalForMonthFenQi";
static NSString * const kInterestForMonthFenQi=@"kInterestForMonthFenQi";

static NSString * const tableName=@"DetailsTableViewController";

@interface DetailsTableViewController ()

@property(copy,nonatomic) NSMutableDictionary *dataDictionary;
@property(copy,nonatomic) NSMutableDictionary *dataDicBig;
@property(copy,nonatomic) NSMutableDictionary *dataDicSmall;
@property(copy,nonatomic) NSMutableDictionary *dataDicFenqi;

@property(strong,nonatomic) DataModelObject *dataModelBig;
@property(strong,nonatomic) DataModelObject *dataModelSmall;
@property(strong,nonatomic) DataModelObject *dataModelFenqi;

@property(strong,nonatomic) UIFont *cellFont;
@property(strong,nonatomic) UIFont *titleFont;
@property(assign,nonatomic) CGFloat cellHeight;
@property(assign,nonatomic) CGFloat headerHeight;
@property(assign,nonatomic) NSInteger fontFamilyName;

@property(assign,nonatomic) BOOL isAllowed;

@property(assign,nonatomic) CGFloat lastScale;

@end

@implementation DetailsTableViewController

#pragma mark - Life Cycle
//-(void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator{
//    [self.tableView reloadData];
//}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _isVIP=[[defaults valueForKey:@"isVIP"]boolValue];
    //self.isVIP=YES;
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastScale=1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _fontFamilyName=0;
    
    //单元格高度、标题高度
    _cellHeight=20;
    _headerHeight=80;
    //_cellHeight=30;
    //_headerHeight=120;
    
    //单元格字体、标题字体大小
    int cellFontSize=9;
    int infoFontSize=10;
    //int cellFontSize=20;
    //int infoFontSize=22;
    
    if ([UIDevice isiPhone5]) {
        cellFontSize=11;
        infoFontSize=12;
    }
    if([UIDevice isiPhone6]){
        cellFontSize=13;
        infoFontSize=14;
    }
    if ([UIDevice isiPad]) {
        //NSLog(@"Details isiPad");
        //iPad上显示的字体要大
        cellFontSize=20;
        infoFontSize=22;
        _cellHeight=30;
        _headerHeight=120;
    }
    
    
    _cellFont=[UIFont fontWithFamilyNames:0 size:cellFontSize];
    _titleFont=[UIFont fontWithFamilyNames:0 size:infoFontSize];
    
    
    /*以下注释的代码显示工具栏
    UIBarButtonItem *increaseFontSizeBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"增大",tableName,@"") style:UIBarButtonItemStyleDone target:self action:@selector(increaseFontSizeBarButtonItemPressed:)];
    
    UIBarButtonItem *decreaseFontSizeBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"缩小",tableName,@"") style:UIBarButtonItemStyleDone target:self action:@selector(decreaseFontSizeBarButtonItemPressed:)];
    
    UIBarButtonItem *addToCalenderBarButtionItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"添加到日历",tableName,@"") style:UIBarButtonItemStyleDone target:self action:@selector(addToCalenderBarButtonItemPressed:)];
    UIBarButtonItem *purchaseBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"购买",tableName,@"") style:UIBarButtonItemStyleDone target:self action:@selector(purchaseBarButtonItemPressed:)];

    
    UIBarButtonItem *flexibleSpaceBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpaceBarButtonItem,fontBarButtonItem,flexibleSpaceBarButtonItem,increaseFontSizeBarButtonItem,flexibleSpaceBarButtonItem,decreaseFontSizeBarButtonItem,flexibleSpaceBarButtonItem,addToCalenderBarButtionItem,flexibleSpaceBarButtonItem,purchaseBarButtonItem,flexibleSpaceBarButtonItem,nil]];
    [self.navigationController setToolbarHidden:NO];
    */
    
    //设置导航栏
    UIBarButtonItem *fontBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"✏️  " style:UIBarButtonItemStyleDone target:self action:@selector(changeFontBarButtonItemPressed:)];
    UIBarButtonItem *fontDownBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"✒️  " style:UIBarButtonItemStyleDone target:self action:@selector(changeDownFontBarButtonItemPressed:)];
    UIBarButtonItem *barButtionItem2=[[UIBarButtonItem alloc]initWithTitle:@"📅" style:UIBarButtonItemStyleDone target:self action:@selector(addToCalenderBarButtonItemPressed:)];
    
    self.navigationItem.rightBarButtonItems=@[barButtionItem2,fontBarButtonItem,fontDownBarButtonItem];
    
    UIBarButtonItem *backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"返回",tableName,@"") style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    
    //UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    //[self.tableView addGestureRecognizer:pinch];
    
    if(_dataModelObject.loanType==0) {
        //单一贷款
        _dataDictionary=[self calculateData:_dataModelObject];
        
    }
    if(_dataModelObject.loanType==1){
        //组合贷款
        if (_dataModelObject.nMonthCounts1>=_dataModelObject.nMonthCounts2) {
            _dataModelBig=[[DataModelObject alloc]initWithaTotal:_dataModelObject.aTotal1 withnMonthCounts:_dataModelObject.nMonthCounts1 withiRateForMonth:_dataModelObject.iRateForMonth1 withrepayType:_dataModelObject.repayType1];
            _dataModelSmall=[[DataModelObject alloc]initWithaTotal:_dataModelObject.aTotal2 withnMonthCounts:_dataModelObject.nMonthCounts2 withiRateForMonth:_dataModelObject.iRateForMonth2 withrepayType:_dataModelObject.repayType2];
        }else{
            _dataModelSmall=[[DataModelObject alloc]initWithaTotal:_dataModelObject.aTotal1 withnMonthCounts:_dataModelObject.nMonthCounts1 withiRateForMonth:_dataModelObject.iRateForMonth1 withrepayType:_dataModelObject.repayType1];
            _dataModelBig=[[DataModelObject alloc]initWithaTotal:_dataModelObject.aTotal2 withnMonthCounts:_dataModelObject.nMonthCounts2 withiRateForMonth:_dataModelObject.iRateForMonth2 withrepayType:_dataModelObject.repayType2];
        }
        
        _dataDicBig=[self calculateData:_dataModelBig];
        _dataDicSmall=[self calculateData:_dataModelSmall];
        
        _dataDictionary=[self addDictionary:_dataDicBig ofBigCount:_dataModelBig.nMonthCounts withSmallDictionary:_dataDicSmall ofSmallCount:_dataModelSmall.nMonthCounts];
    }
    if (_dataModelObject.loanType==2) {
        //分期付款，在这里实现一部分计算
        float aTotal=_dataModelObject.aTotal3;
        //如果iCommission为手续费率，直接计算
        float totalInterestOld=_dataModelObject.iCommission;
        
        if (_dataModelObject.iCommissionType==0) {
            //如果iCommission为手续费率,计算实际的手续费
            totalInterestOld=totalInterestOld/100;
            totalInterestOld=aTotal*totalInterestOld;
        }
        
        float nMonthCounts=_dataModelObject.nMonthCounts3;
        
        NSMutableArray *totalForMonthArrayFenqi=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
        NSMutableArray *principalForMonthArrayFenqi=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
        NSMutableArray *interestForMonthArrayFenqi=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
        
        for (int i=0; i<nMonthCounts; i++) {
            totalForMonthArrayFenqi[i]=[[NSString alloc]initWithFormat:@"%f",(aTotal+totalInterestOld)/nMonthCounts];
            principalForMonthArrayFenqi[i]=[[NSString alloc]initWithFormat:@"%f",aTotal/nMonthCounts];
            interestForMonthArrayFenqi[i]=[[NSString alloc]initWithFormat:@"%f",totalInterestOld/nMonthCounts];
        }

        
        float iRateForMonthOld=totalInterestOld*2/aTotal/(nMonthCounts+1);
        //NSLog(@"用等额本金方式计算出来的利率:%.2f",iRateForMonthOld*12*100);
        float totalInterestNew=nMonthCounts*aTotal*iRateForMonthOld*powf(1+iRateForMonthOld, nMonthCounts)/(powf(1+iRateForMonthOld, nMonthCounts)-1)-aTotal;
        float iRateForMonthNew=0;
        float iRateTempBig=0;
        float iRateTempSmall=0;
        int i=1;
        
        //循环猜测实际利率
        float iRate=0;
        if (totalInterestNew>totalInterestOld) {
            //同样的利息，使用等额本金计算出来的利率，再计算等额本息的利息，肯定较大
            iRate=iRateForMonthOld;
            while (totalInterestNew>totalInterestOld) {
                totalInterestNew=nMonthCounts*aTotal*iRate*powf(1+iRate, nMonthCounts)/(powf(1+iRate, nMonthCounts)-1)-aTotal;
                //NSLog(@"%d 利率:%.4f 采用等额本息还款的利息较大:%.2f 原利息:%.2f",i,iRate*12*100,totalInterestNew,totalInterestOld);
                i++;
                iRateTempSmall=iRate;
                //误差设定为:0.00001/6*1200/2=0.001
                iRateTempBig=iRateTempSmall+0.00001/6;
                iRate-=0.00001/6;
                if (totalInterestNew<=totalInterestOld) break;
            }
            
        }
        else if(totalInterestNew<totalInterestOld){
            //这种情况应该不会出现
            for (float iRate=iRateForMonthOld; iRate>0; iRate+=0.00001) {
                totalInterestNew=nMonthCounts*aTotal*iRate*powf(1+iRate, nMonthCounts)/(powf(1+iRate, nMonthCounts)-1)-aTotal;
                i++;
                //NSLog(@"%d 利率:%.4f 采用等额本息还款的实际利息较小:%.2f 原利息:%.2f",i,iRate*12*100,totalInterestNew,totalInterestOld);
                if ((totalInterestNew-totalInterestOld)>=0) {
                    iRateTempBig=iRate;
                    iRateTempSmall=iRateTempSmall-0.00001;
                    break;
                }
            }

        }
        
        iRateForMonthNew=(iRateTempBig+iRateTempSmall)/2;
        
        _dataModelFenqi=[[DataModelObject alloc]initWithaTotal:aTotal withnMonthCounts:nMonthCounts withiRateForMonth:iRateForMonthNew withrepayType:1];
        _dataModelFenqi.iCommission=totalInterestOld;//注意，这里传过去的数据是手续费（原来的手续费率也转换成了手续费)
        _dataModelFenqi.iCommissionType=_dataModelObject.iCommissionType;//这一项传不传无所谓了
        _dataDicFenqi=[self calculateData:_dataModelFenqi];
        [_dataDicFenqi setObject:totalForMonthArrayFenqi forKey:kTotalForMonthFenQi];
        [_dataDicFenqi setObject:principalForMonthArrayFenqi forKey:KPrincipalForMonthFenQi];
        [_dataDicFenqi setObject:interestForMonthArrayFenqi forKey:kInterestForMonthFenQi];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
-(void)addToCalenderBarButtonItemPressed:(id)sender{
    
    if (_isVIP) {
        //是注册用户（购买了添加日历功能）
        //获取日历权限（仅在第一次使用时才会弹出对话框请求权限，以后需要用户到设置中更改）
        EKEventStore *eventDB=[[EKEventStore alloc]init];
        EKEventStoreRequestAccessCompletionHandler completion=^(BOOL granted,NSError *error){};
        [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:completion];
        
        //弹出菜单让用户选取提醒时间
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString=[dateFormatter stringFromDate:_dataModelObject.startDate];
        NSString *loanName=_dataModelObject.loanName;
        if (loanName==nil) {
            loanName=NSLocalizedStringFromTable(@"未设置",tableName,@"");
        }
        NSString *t1=NSLocalizedStringFromTable(@"是否将还款信息添加到日历并设置提醒？",tableName,@"");
        NSString *t2=NSLocalizedStringFromTable(@"首期还款日期:",tableName,@"");
        NSString *t3=NSLocalizedStringFromTable(@"还款标签:",tableName,@"");
        NSString *title=[[NSString alloc]initWithFormat:@"%@\n%@%@ %@%@",t1,t2,dateString,t3,loanName];
        
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"不，我不需要添加",tableName,@"") destructiveButtonTitle:NSLocalizedStringFromTable(@"添加，但不用提醒",tableName,@"") otherButtonTitles:NSLocalizedStringFromTable(@"当天9点提醒",tableName,@""),NSLocalizedStringFromTable(@"1天前9点提醒",tableName,@""),NSLocalizedStringFromTable(@"2天前9点提醒",tableName,@""),NSLocalizedStringFromTable(@"1周前提醒",tableName,@""), nil];
        [actionSheet showInView:self.view];
    }
    else{
        //[self purchaseBarButtonItemPressed:nil];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您正在使用“将还款信息添加到日历”功能。此功能收费，价格¥6.0，是否购买？" delegate:self cancelButtonTitle:@"不需要此功能" otherButtonTitles:@"购买",@"恢复",nil];
//        alert.tag=11;
//        [alert show];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"提示",tableName,@"") message:NSLocalizedStringFromTable(@"您尚未购买“将还款信息添加到日历”功能！",tableName,@"") delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"好的",tableName,@"") otherButtonTitles:NSLocalizedStringFromTable(@"购买",tableName,@""),nil];
        alert.tag=13;
        [alert show];
    }
    
}

-(void)shareBarButtonItemPressed:(id)sender{
    //测试时的代码，勿删
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"测试VIP功能" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"设置为VIP",@"取消VIP",nil];
//    alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
//    alert.tag=12;
//    [alert show];
    ShareViewController *shareViewController=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    [self.navigationController pushViewController:shareViewController animated:NO];
}

-(void)purchaseBarButtonItemPressed:(id)sender{
    InAppListRETVC *inApp=[[InAppListRETVC alloc]initWithStyle:UITableViewStyleGrouped];
    inApp.title=NSLocalizedStringFromTable(@"应用程序内购买项目",tableName,@"");
    [self.navigationController pushViewController:inApp animated:YES];
}

-(void)changeFontBarButtonItemPressed:(id)sender{
    CGFloat size=_cellFont.pointSize;
    NSArray *f=[UIFont familyNames];
    _fontFamilyName++;
    if (_fontFamilyName>=[f count]-1) {
        _fontFamilyName=[f count]-1;
    }
    _cellFont=[UIFont fontWithFamilyNames:(int)_fontFamilyName size:size];
    [self.tableView reloadData];
}

-(void)changeDownFontBarButtonItemPressed:(id)sender{
    CGFloat size=_cellFont.pointSize;
    
    _fontFamilyName--;
    if (_fontFamilyName<=0) {
        _fontFamilyName=0;
    }
    _cellFont=[UIFont fontWithFamilyNames:(int)_fontFamilyName size:size];
    [self.tableView reloadData];
}

-(void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer{
    NSLog(@"%f", recognizer.scale);
    
    recognizer.scale=recognizer.scale-self.lastScale+1;
    
    CGFloat size=self.cellFont.pointSize;
    size*=recognizer.scale;
    self.cellFont=[UIFont fontWithFamilyNames:(int)_fontFamilyName size:size];
    //self.cellHeight*=recognizer.scale;
    //self.headerHeight*=recognizer.scale;
    
    [self.tableView reloadData];
    
    self.lastScale=recognizer.scale;
}

-(void)increaseFontSizeBarButtonItemPressed:(id)sender{
    CGFloat size=_cellFont.pointSize;
    size++;
    _cellFont=[UIFont fontWithFamilyNames:(int)_fontFamilyName size:size];
    
//    size=_titleFont.pointSize;
//    size++;
//    _titleFont=[UIFont fontWithFamilyNames:0 size:size];
    _cellHeight+=2;
    _headerHeight+=2;
    [self.tableView reloadData];
}
-(void)decreaseFontSizeBarButtonItemPressed:(id)sender{
    CGFloat size=_cellFont.pointSize;
    size--;
    _cellFont=[UIFont fontWithFamilyNames:(int)_fontFamilyName size:size];
    
//    size=_titleFont.pointSize;
//    size--;
//    _titleFont=[UIFont fontWithFamilyNames:0 size:size];
    _cellHeight-=2;
    _headerHeight-=2;
    [self.tableView reloadData];
}



#pragma mark - Custom Methods
-(NSMutableDictionary *)addDictionary:(NSMutableDictionary *)bigDic ofBigCount:(int)bigCount withSmallDictionary:(NSMutableDictionary *)smallDic ofSmallCount:(int)smallCount{
    NSMutableDictionary *newDictionary=[[NSMutableDictionary alloc]initWithCapacity:6];
    
    NSMutableArray *totalForMonthArray=[[NSMutableArray alloc]initWithCapacity:bigCount];
    NSMutableArray *principalForMonthArray=[[NSMutableArray alloc]initWithCapacity:bigCount];
    NSMutableArray *interestForMonthArray=[[NSMutableArray alloc]initWithCapacity:bigCount];
    NSMutableArray *restPrincipalArray=[[NSMutableArray alloc]initWithCapacity:bigCount];
    NSMutableArray *allPayedArray=[[NSMutableArray alloc]initWithCapacity:bigCount];
    NSMutableArray *allHaveToPayForCurrentMonthArray=[[NSMutableArray alloc]initWithCapacity:bigCount];
    
    for (int i=0; i<bigCount; i++) {
        if (i<smallCount) {
            totalForMonthArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kTotalForMonth][i] doubleValue]+[[smallDic objectForKey:kTotalForMonth][i] doubleValue])];
            principalForMonthArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:KPrincipalForMonth][i] doubleValue]+[[smallDic objectForKey:KPrincipalForMonth][i] doubleValue])];
            interestForMonthArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kInterestForMonth][i] doubleValue]+[[smallDic objectForKey:kInterestForMonth][i] doubleValue])];
            restPrincipalArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kRestPrincipal][i] doubleValue]+[[smallDic objectForKey:kRestPrincipal][i] doubleValue])];
            allPayedArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kAllPayed][i] doubleValue]+[[smallDic objectForKey:kAllPayed][i] doubleValue])];
            allHaveToPayForCurrentMonthArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kAllHaveToPayForCurrentMonth][i] doubleValue]+[[smallDic objectForKey:kAllHaveToPayForCurrentMonth][i] doubleValue])];
        }else{
            totalForMonthArray[i]=[[NSNumber alloc]initWithDouble:[[bigDic objectForKey:kTotalForMonth][i] doubleValue]];
            principalForMonthArray[i]=[[NSNumber alloc]initWithDouble:[[bigDic objectForKey:KPrincipalForMonth][i] doubleValue]];
            interestForMonthArray[i]=[[NSNumber alloc]initWithDouble:[[bigDic objectForKey:kInterestForMonth][i] doubleValue]];
            restPrincipalArray[i]=[[NSNumber alloc]initWithDouble:[[bigDic objectForKey:kRestPrincipal][i] doubleValue]];
            allPayedArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kAllPayed][i] doubleValue]+[[smallDic objectForKey:kAllPayed][smallCount-1] doubleValue])];//注意这里smallCount-1
            allHaveToPayForCurrentMonthArray[i]=[[NSNumber alloc]initWithDouble:([[bigDic objectForKey:kAllHaveToPayForCurrentMonth][i] doubleValue]+[[smallDic objectForKey:kAllHaveToPayForCurrentMonth][smallCount-1] doubleValue])];//注意这里smallCount-1
        }
        
    }
    
    [newDictionary setObject:totalForMonthArray forKey:kTotalForMonth];
    [newDictionary setObject:principalForMonthArray forKey:KPrincipalForMonth];
    [newDictionary setObject:interestForMonthArray forKey:kInterestForMonth];
    [newDictionary setObject:restPrincipalArray forKey:kRestPrincipal];
    [newDictionary setObject:allPayedArray forKey:kAllPayed];
    [newDictionary setObject:allHaveToPayForCurrentMonthArray forKey:kAllHaveToPayForCurrentMonth];
    
    return newDictionary;
}

-(NSMutableDictionary *)calculateData:(DataModelObject *)dm{
    float aTotal=dm.aTotal;
    int nMonthCounts=dm.nMonthCounts;
    float iRateForMonth=dm.iRateForMonth;
    int repayType=dm.repayType;
    
    double principalForMonth=0;
    double interestForMonth=0;
    double totalForMonth=0;
    double restPrincipal=0;
    double allPayed=0;
    double allHaveToPayForCurrentMonth=0;
    
    
    NSMutableDictionary *newDictionary=[[NSMutableDictionary alloc]initWithCapacity:6];
    
    NSMutableArray *totalForMonthArray=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
    NSMutableArray *principalForMonthArray=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
    NSMutableArray *interestForMonthArray=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
    NSMutableArray *restPrincipalArray=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
    NSMutableArray *allPayedArray=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
    NSMutableArray *allHaveToPayForCurrentMonthArray=[[NSMutableArray alloc]initWithCapacity:nMonthCounts];
    
    if (repayType==0) {
        //等额本金
        //每月还款额为：a/n
        principalForMonth=aTotal/nMonthCounts;
        for (int i=0; i<nMonthCounts; i++) {
            restPrincipal=aTotal-i*principalForMonth;//计算用
            interestForMonth=restPrincipal*iRateForMonth;
            totalForMonth=principalForMonth+interestForMonth;
            allPayed+=totalForMonth;
            restPrincipal=restPrincipal-principalForMonth;//存储用
            if(i==nMonthCounts-1)
                restPrincipal=0;
            allHaveToPayForCurrentMonth=allPayed+restPrincipal;
            
            totalForMonthArray[i]=[[NSNumber alloc]initWithDouble:totalForMonth];
            principalForMonthArray[i]=[[NSNumber alloc]initWithDouble:principalForMonth];
            interestForMonthArray[i]=[[NSNumber alloc]initWithDouble:interestForMonth];
            allPayedArray[i]=[[NSNumber alloc]initWithDouble:allPayed];
            restPrincipalArray[i]=[[NSNumber alloc]initWithDouble:restPrincipal];
            allHaveToPayForCurrentMonthArray[i]=[[NSNumber alloc]initWithDouble:allHaveToPayForCurrentMonth];
        }
    }
    
    
    if (repayType==1) {
        //等额本息
        double principalPayed=0;
        //每月还款额为：b=a*i*(1+i)^n/[(1+i)^n-1]
        totalForMonth=aTotal*iRateForMonth*powf(1+iRateForMonth,nMonthCounts)/(powf(1+iRateForMonth,nMonthCounts)-1);
        for (int i=0; i<nMonthCounts;i++) {
            //第n月还款利息为：（a×i－b）×（1＋i）的（n－1）次方＋b
            interestForMonth=(aTotal*iRateForMonth-totalForMonth)*powf(1+iRateForMonth,i)+totalForMonth;
            principalForMonth=totalForMonth-interestForMonth;
            principalPayed+=principalForMonth;
            restPrincipal=aTotal-principalPayed;
            if(i==nMonthCounts-1)
                restPrincipal=0;
            allPayed=(i+1)*totalForMonth;
            allHaveToPayForCurrentMonth=allPayed+restPrincipal;
          
            totalForMonthArray[i]=[[NSNumber alloc]initWithDouble:totalForMonth];
            principalForMonthArray[i]=[[NSNumber alloc]initWithDouble:principalForMonth];
            interestForMonthArray[i]=[[NSNumber alloc]initWithDouble:interestForMonth];
            allPayedArray[i]=[[NSNumber alloc]initWithDouble:allPayed];
            restPrincipalArray[i]=[[NSNumber alloc]initWithDouble:restPrincipal];
            allHaveToPayForCurrentMonthArray[i]=[[NSNumber alloc]initWithDouble:allHaveToPayForCurrentMonth];
        }
    }
    
    
    [newDictionary setObject:totalForMonthArray forKey:kTotalForMonth];
    [newDictionary setObject:principalForMonthArray forKey:KPrincipalForMonth];
    [newDictionary setObject:interestForMonthArray forKey:kInterestForMonth];
    [newDictionary setObject:restPrincipalArray forKey:kRestPrincipal];
    [newDictionary setObject:allPayedArray forKey:kAllPayed];
    [newDictionary setObject:allHaveToPayForCurrentMonthArray forKey:kAllHaveToPayForCurrentMonth];
    return newDictionary;
}

#pragma mark - ActionSheet&AlertView Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        //添加日历和提醒
        
        EKEventStore *eventDB=[[EKEventStore alloc]init];
        NSString *alertStirng=NSLocalizedStringFromTable(@"未设置提醒",tableName,@"");
        int count=0;
        NSError *err=nil;
        
        if (_dataModelObject.loanType==0) {
            count=_dataModelObject.nMonthCounts;
        }
        if (_dataModelObject.loanType==1) {
            count=_dataModelBig.nMonthCounts;
        }
        if (_dataModelObject.loanType==2) {
            count=_dataModelFenqi.nMonthCounts;
        }
        
        for (int i=0; i<count; i++) {
            EKEvent *newEvent=[EKEvent eventWithEventStore:eventDB];
            NSString *aTotal=[NSString new];
            NSString *principalForMonth=[NSString new];
            NSString *interestForMonth=[NSString new];
            if (_dataModelObject.loanType==0||_dataModelObject.loanType==1) {
                aTotal=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kTotalForMonth][i] floatValue]];
                principalForMonth=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:KPrincipalForMonth][i] floatValue]];
                interestForMonth=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kInterestForMonth][i] floatValue]];
            }else if (_dataModelObject.loanType==2){
                aTotal=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kTotalForMonthFenQi][i] floatValue]];
                principalForMonth=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:KPrincipalForMonthFenQi][i] floatValue]];
                interestForMonth=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kInterestForMonthFenQi][i] floatValue]];
            }
            
            NSString *t1=NSLocalizedStringFromTable(@"今日应还", tableName, @"");
            NSString *t2=NSLocalizedStringFromTable(@"贷款总额", tableName, @"");
            NSString *t3=NSLocalizedStringFromTable(@"总额", tableName, @"");
            NSString *t4=NSLocalizedStringFromTable(@"本金", tableName, @"");
            NSString *t5=NSLocalizedStringFromTable(@"利息", tableName, @"");
            NSString *t6=NSLocalizedStringFromTable(@"第", tableName, @"");
            NSString *t7=NSLocalizedStringFromTable(@"期", tableName, @"");
            
            newEvent.title=[[NSString alloc]initWithFormat:@"%@%@%@,%@%@,%@%@【%@%ld/%ld%@】",t1,t2,aTotal,t4,principalForMonth,t5,interestForMonth,t6,(long)i+1,(long)count,t7];
            //如果用户设置了还款标签，则添加上
            NSString *loanName=_dataModelObject.loanName;
            if (loanName!=nil) {
                newEvent.title=[[NSString alloc]initWithFormat:@"%@【%@】%@%@,%@%@,%@%@【%@%ld/%ld%@】",t1,loanName,t3,aTotal,t4,principalForMonth,t5,interestForMonth,t6,(long)i+1,(long)count,t7];
            }
            
            newEvent.startDate=[_dataModelObject dateByAddingMonth:i];
            newEvent.endDate=[_dataModelObject dateByAddingMonth:i];
            newEvent.allDay=YES;
            
            if (buttonIndex!=actionSheet.destructiveButtonIndex) {
                //根据用户的不同选择，添加不同类型的提醒
                
                if (buttonIndex==actionSheet.firstOtherButtonIndex) {
                    //当天9点提醒
                    EKAlarm *alarm=[EKAlarm alarmWithRelativeOffset:9*60*60];
                    newEvent.alarms=[[NSArray alloc]initWithObjects:alarm, nil];
                    alertStirng=NSLocalizedStringFromTable(@"提醒时间:当天9点",tableName,@"");
                }
                if (buttonIndex==actionSheet.firstOtherButtonIndex+1) {
                    //1天前9点提醒
                    EKAlarm *alarm=[EKAlarm alarmWithRelativeOffset:-15*60*60];
                    newEvent.alarms=[[NSArray alloc]initWithObjects:alarm, nil];
                    alertStirng=NSLocalizedStringFromTable(@"提醒时间:1天前9点",tableName,@"");
                }
                if (buttonIndex==actionSheet.firstOtherButtonIndex+2) {
                    //2天前9点提醒
                    EKAlarm *alarm=[EKAlarm alarmWithRelativeOffset:-(15+24)*60*60];
                    newEvent.alarms=[[NSArray alloc]initWithObjects:alarm, nil];
                    alertStirng=NSLocalizedStringFromTable(@"提醒时间:2天前9点",tableName,@"");
                }
                if (buttonIndex==actionSheet.firstOtherButtonIndex+3) {
                    //1周前提醒
                    EKAlarm *alarm=[EKAlarm alarmWithRelativeOffset:-(15+6*24)*60*60];
                    newEvent.alarms=[[NSArray alloc]initWithObjects:alarm, nil];
                    alertStirng=NSLocalizedStringFromTable(@"提醒时间:1周前",tableName,@"");
                }
                
            }
            
            EKCalendar *newCalender=[eventDB defaultCalendarForNewEvents];
            [newCalender setTitle:NSLocalizedStringFromTable(@"玩转贷款",tableName,@"")];
            [newEvent setCalendar:newCalender];
            
            [eventDB saveEvent:newEvent span:EKSpanThisEvent error:&err];
        }
        
        if (err!=nil) {
            NSString *m1=NSLocalizedStringFromTable(@"您禁用了应用的日历访问，请到“设置”→“隐私”→“日历”中启用。", tableName, @"");
            NSString *m2=NSLocalizedStringFromTable(@"系统提示:", tableName, @"");
            NSString *message=[[NSString alloc]initWithFormat:@"%@\n%@",m1,m2];
            
            NSString *errorMessage=[err localizedDescription];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"添加日历出错了",tableName,@"") message:[message stringByAppendingString:errorMessage] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"好的，我知道了",tableName,@"") otherButtonTitles: nil];
            [alert show];
        }
        else{
            NSString *message=[[NSString alloc]initWithFormat:NSLocalizedStringFromTable(@"还贷信息已成功添加到日历!",tableName,@"")];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"提示",tableName,@"") message:[message stringByAppendingString:alertStirng] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"好的",tableName,@"") otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else{
        //用户取消添加日历
        //NSString *message=[[NSString alloc]initWithFormat:@"您已取消,未向日历添加还款信息！"];
        //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        if (alertView.tag==11) {
            if (buttonIndex==alertView.firstOtherButtonIndex) {
                //用户点击”购买“
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"购买！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
                InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
                inApp.transactionType=TransactionTypePurchase;
                [self.navigationController pushViewController:inApp animated:YES];
            }
            
            if (buttonIndex==alertView.firstOtherButtonIndex+1) {
                //用户点击”恢复“
                InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
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
        if (alertView.tag==12) {
            UITextField *passTextField=[alertView textFieldAtIndex:0];
            if ([passTextField.text isEqual:@"vip"]) {
                if (buttonIndex==alertView.firstOtherButtonIndex) {
                    self.isVIP=YES;
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:@"isVIP"];
                    [defaults synchronize];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已设置为VIP" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                if (buttonIndex==alertView.firstOtherButtonIndex+1) {
                    self.isVIP=NO;
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setBool:NO forKey:@"isVIP"];
                    [defaults synchronize];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已取消VIP" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
        if (alertView.tag==13) {
            InAppListRETVC *inApp=[[InAppListRETVC alloc]initWithStyle:UITableViewStyleGrouped];
            inApp.title=NSLocalizedStringFromTable(@"应用程序内购买项目",tableName,@"");
            [self.navigationController pushViewController:inApp animated:YES];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSInteger numberOfSections=0;
    
    if(_dataModelObject.loanType==0||_dataModelObject.loanType==2){
        //单一贷款、分期付款，显示1个分区
        numberOfSections=1;
    }
    
    if(_dataModelObject.loanType==1){
        //组合贷款，期数不同，显示3个分区
        numberOfSections=3;
        if (_dataModelBig.nMonthCounts==_dataModelSmall.nMonthCounts) {
            //组合贷款，期数相同，显示1个分区
            numberOfSections=1;
        }
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    NSInteger numberOfRowsInSection=0;
    
    if(_dataModelObject.loanType==0) {
        //单一贷款
        numberOfRowsInSection=_dataModelObject.nMonthCounts;
    }
    
    if (_dataModelObject.loanType==1) {
        //组合贷款 分区中的行数分开计算
        if (section==0) {
            numberOfRowsInSection=_dataModelSmall.nMonthCounts;
        }
        if(section==1){
            numberOfRowsInSection=_dataModelBig.nMonthCounts-_dataModelSmall.nMonthCounts;
        }
        if (section==2) {
            //第3个分区仅显示标题，没有内容
            numberOfRowsInSection=0;
        }
    }
    
    if(_dataModelObject.loanType==2) {
        //分期贷款
        numberOfRowsInSection=_dataModelFenqi.nMonthCounts;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //注意注意：这里不能使用原来的行进行复用，虽然要多占用内存，但是不会出现显示混乱的问题！！！在这里浪费了将近2个小时的时间！！怎么调试都不行！！
    //DetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifierForCell forIndexPath:indexPath];
    
    DetailsTableViewCell *cell=[DetailsTableViewCell new];
    cell.labelFont=_cellFont;
    
    int rowNumber=(int)indexPath.row;
    
    if (indexPath.section==1) {
        rowNumber+=_dataModelSmall.nMonthCounts;
    }
    
    UILabel *l0=cell.lineLabels[0];//l0显示期次
    l0.text=[[NSString alloc]initWithFormat:@"%ld",(long)(rowNumber+1)];
    
    UILabel *l1=cell.lineLabels[1];//l1显示 还款日期
    UILabel *l2=cell.lineLabels[2];//l2显示 当月本息
    UILabel *l3=cell.lineLabels[3];//l3显示 当月本金 或 长贷本息
    UILabel *l4=cell.lineLabels[4];//l4显示 当月利息 或 长贷本金
    UILabel *l5=cell.lineLabels[5];//l5显示 已还总额 或 长贷利息
    UILabel *l6=cell.lineLabels[6];//l6显示 剩余本金 或 短贷本息
    UILabel *l7=cell.lineLabels[7];//l7显示 本月一次性还清实付总额 或 短贷本金
    UILabel *l8=cell.lineLabels[8];//l8显示 短贷利息
    
    //计算各期次的还款日期
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    l1.text=[dateFormatter stringFromDate:[_dataModelObject dateByAddingMonth:rowNumber]];
    
    //l2显示当月本息
    if (_dataModelObject.loanType==2) {
        l2.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kTotalForMonth][rowNumber] floatValue]];
    }
    else{
        l2.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kTotalForMonth][rowNumber] floatValue]];
    }
    
    
    if (_dataModelObject.loanType==0) {
        //单一贷款 显示 3当月本金  4当月利息  5已还总额  6剩余本金 7本月一次性还清实付总额 竖屏显示l0-l4 横屏显示l0-l7
        l3.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:KPrincipalForMonth][rowNumber] floatValue]];
        l4.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kInterestForMonth][rowNumber] floatValue]];
        l5.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kAllPayed][rowNumber] floatValue]];
        l6.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kRestPrincipal][rowNumber] floatValue]];
        l7.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDictionary objectForKey:kAllHaveToPayForCurrentMonth][rowNumber] floatValue]];
        l8.text=@"";
    }
    
    if(_dataModelObject.loanType==1){
        //组合贷款
        //检测方向
        UIApplication *app=[UIApplication sharedApplication];
        UIInterfaceOrientation currentOrientation=app.statusBarOrientation;
        
        if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
            //纵向：l3显示长贷本息 l4显示短贷本息
            l3.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicBig objectForKey:kTotalForMonth][rowNumber] floatValue]];
            if (indexPath.section==0) {
                l4.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicSmall objectForKey:kTotalForMonth][rowNumber] floatValue]];
            }
            if (indexPath.section==1) {
                l4.text=@"——";
            }
            
        }
        if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
            
            //横向： l3长贷本息 l4长期贷款本金  l5长期贷款利息  l6短贷本息 l7短期贷款本金  l8短期贷款利息
            l3.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicBig objectForKey:kTotalForMonth][rowNumber] floatValue]];
            l4.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicBig objectForKey:KPrincipalForMonth][rowNumber] floatValue]];
            l5.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicBig objectForKey:kInterestForMonth][rowNumber] floatValue]];
            if (indexPath.section==0) {
                //第1分区中短期贷款可以正常显示
                l6.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicSmall objectForKey:kTotalForMonth][rowNumber] floatValue]];
                l7.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicSmall objectForKey:KPrincipalForMonth][rowNumber] floatValue]];
                l8.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicSmall objectForKey:kInterestForMonth][rowNumber] floatValue]];
                
            }
            if (indexPath.section==1) {
                //第2分区中短期贷款已经没有数值了
                l6.text=@"——";
                l7.text=@"——";
                l8.text=@"——";
            }
            
        }
        
    }
    
    if (_dataModelObject.loanType==2) {
        //分期付款 显示 l3分期本金  4分期利息  5实际本金  6实际利息 7已还总额 8剩余本金 竖屏显示l0-l4 横屏显示l0-l6
        l3.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:KPrincipalForMonthFenQi][rowNumber] floatValue]];
        l4.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kInterestForMonthFenQi][rowNumber] floatValue]];
        l5.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:KPrincipalForMonth][rowNumber] floatValue]];
        l6.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kInterestForMonth][rowNumber] floatValue]];
        l7.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kAllPayed][rowNumber] floatValue]];
        l8.text=[[NSString alloc]initWithFormat:@"%.2f",[[_dataDicFenqi objectForKey:kRestPrincipal][rowNumber] floatValue]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView =[[UIView alloc]init];
    
    UILabel *infoLabel=[UILabel new];
    infoLabel.textColor=[UIColor whiteColor];
    infoLabel.font=_titleFont;
    infoLabel.numberOfLines=0;
    infoLabel.textAlignment=NSTextAlignmentCenter;
    
    DetailsTableViewCell *headerCell=[DetailsTableViewCell new];
    headerCell.labelFont=_cellFont;
    UILabel *l0=headerCell.lineLabels[0];
    UILabel *l1=headerCell.lineLabels[1];
    UILabel *l2=headerCell.lineLabels[2];
    UILabel *l3=headerCell.lineLabels[3];
    UILabel *l4=headerCell.lineLabels[4];
    UILabel *l5=headerCell.lineLabels[5];
    UILabel *l6=headerCell.lineLabels[6];
    UILabel *l7=headerCell.lineLabels[7];
    UILabel *l8=headerCell.lineLabels[8];
    
    l0.text=NSLocalizedStringFromTable(@"期次",tableName,@"");
    l1.text=NSLocalizedStringFromTable(@"还款日期",tableName,@"");
    l2.text=NSLocalizedStringFromTable(@"当月本息",tableName,@"");
    
    NSString *lsaTotal=NSLocalizedStringFromTable(@"总贷款", tableName, @"");
    NSString *lstotalInterest=NSLocalizedStringFromTable(@"总利息", tableName, @"");
    NSString *lsall=NSLocalizedStringFromTable(@"总还款", tableName, @"");
    
    NSString *lsiRateForMonth=NSLocalizedStringFromTable(@"年利率", tableName, @"");
    NSString *lsRotateInfo=NSLocalizedStringFromTable(@"旋转显示更多详情...（仅支持iOS8.0以上系统）", tableName, @"");
    
    NSString *lsBenXi=NSLocalizedStringFromTable(@"等额本息", tableName, @"");
    NSString *lsBenJin=NSLocalizedStringFromTable(@"等额本金", tableName, @"");
    
    NSString *lsGong=NSLocalizedStringFromTable(@"共", tableName, @"");
    NSString *lsQi=NSLocalizedStringFromTable(@"期", tableName, @"");
    NSString *lsHuanKuan=NSLocalizedStringFromTable(@"还款", tableName, @"");
    
    NSString *lsDaiKuan=NSLocalizedStringFromTable(@"贷款", tableName, @"");
    
    if (_dataModelObject.loanType==0) {
        //单一贷款分区标题
        headerView.backgroundColor = [UIColor colorWithRed:0.1 green:0.68 blue:0.94 alpha:1];
        NSString *repayType=_dataModelObject.repayType?lsBenXi:lsBenJin;
        //竖屏
        infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f  %@:%.2f  %@:%.2f\n%@%ld%@  %@:%.2f%%  %@%@\n%@",lsaTotal,_dataModelObject.aTotal,lstotalInterest,[_dataModelObject totalInterest],lsall,_dataModelObject.aTotal+[_dataModelObject totalInterest],lsGong,(long)_dataModelObject.nMonthCounts,lsQi,lsiRateForMonth,_dataModelObject.iRateForMonth*12*100,repayType,lsHuanKuan,lsRotateInfo];
        //横屏
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f  %@:%.2f  %@:%.2f\n%@%ld%@  %@:%.2f%%  %@%@",lsaTotal,_dataModelObject.aTotal,lstotalInterest,[_dataModelObject totalInterest],lsall,_dataModelObject.aTotal+[_dataModelObject totalInterest],lsGong,(long)_dataModelObject.nMonthCounts,lsQi,lsiRateForMonth,_dataModelObject.iRateForMonth*12*100,repayType,lsHuanKuan];
        }
        
        l3.text=NSLocalizedStringFromTable(@"当月本金",tableName,@"");
        l4.text=NSLocalizedStringFromTable(@"当月利息",tableName,@"");
        l5.text=NSLocalizedStringFromTable(@"已还总额",tableName,@"");
        l6.text=NSLocalizedStringFromTable(@"剩余本金",tableName,@"");
        l7.text=NSLocalizedStringFromTable(@"一次还清实付",tableName,@"");
        l8.text=@"";
    }
    
    NSString *lsChangDai=NSLocalizedStringFromTable(@"长贷", tableName, @"");
    NSString *lsDuanDai=NSLocalizedStringFromTable(@"短贷", tableName,@"");
    NSString *lsZhanaTotal=NSLocalizedStringFromTable(@"占总贷款", tableName, @"");
    NSString *lsZhantotalInterest=NSLocalizedStringFromTable(@"占总利息", tableName, @"");
    NSString *lsZhanall=NSLocalizedStringFromTable(@"占总还款", tableName, @"");
    
    if (_dataModelObject.loanType==1) {
         //组合贷款分区标题
        NSString *repayTypeBig=_dataModelBig.repayType?lsBenXi:lsBenJin;
        NSString *repayTypeSmall=_dataModelSmall.repayType?lsBenXi:lsBenJin;
        
        //注释掉的这一行可以显示完整信息，勿删！！！
        //infoLabel.text=[[NSString alloc]initWithFormat:@"总贷款:%.2f 总利息:%.2f 总还款:%.2f\n长贷---%ld期 年利率%.2f %@还款 总贷款:%.2f 总利息:%.2f 总还款:%.2f\n短贷---%ld期 年利率%.2f %@还款 总贷款:%.2f 总利息:%.2f 总还款:%.2f",_dataModelBig.aTotal+_dataModelSmall.aTotal,[_dataModelBig totalInterest]+[_dataModelSmall totalInterest],_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest],(long)_dataModelBig.nMonthCounts,_dataModelBig.iRateForMonth*12*100,repayTypeBig,_dataModelBig.aTotal,[_dataModelBig totalInterest],_dataModelBig.aTotal+[_dataModelBig totalInterest],(long)_dataModelSmall.nMonthCounts,_dataModelSmall.iRateForMonth*12*100,repayTypeSmall,_dataModelSmall.aTotal,[_dataModelSmall totalInterest],_dataModelSmall.aTotal+[_dataModelSmall totalInterest]];
        
        if (section==0) {
            //分区1标题
            headerView.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1];
            infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f %@:%.2f %@:%.2f\n%@",lsaTotal,_dataModelBig.aTotal+_dataModelSmall.aTotal,lstotalInterest,[_dataModelBig totalInterest]+[_dataModelSmall totalInterest],lsall,_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest],lsRotateInfo];
            //横屏
//            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
//                infoLabel.text=[[NSString alloc]initWithFormat:@"总贷款:%.2f 总利息:%.2f 总还款:%.2f\n长贷---%ld期 年利率%.2f %@还款 总贷款:%.2f 总利息:%.2f 总还款:%.2f\n短贷---%ld期 年利率%.2f %@还款 总贷款:%.2f 总利息:%.2f 总还款:%.2f",_dataModelBig.aTotal+_dataModelSmall.aTotal,[_dataModelBig totalInterest]+[_dataModelSmall totalInterest],_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest],(long)_dataModelBig.nMonthCounts,_dataModelBig.iRateForMonth*12*100,repayTypeBig,_dataModelBig.aTotal,[_dataModelBig totalInterest],_dataModelBig.aTotal+[_dataModelBig totalInterest],(long)_dataModelSmall.nMonthCounts,_dataModelSmall.iRateForMonth*12*100,repayTypeSmall,_dataModelSmall.aTotal,[_dataModelSmall totalInterest],_dataModelSmall.aTotal+[_dataModelSmall totalInterest]];
//            }
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f %@:%.2f %@:%.2f\n%@---%ld%@ %@:%.2f%% %@:%.2f%% %@:%.2f%%\n%@---%ld%@ %@:%.2f%% %@:%.2f%% %@:%.2f%%",lsaTotal,_dataModelBig.aTotal+_dataModelSmall.aTotal,lstotalInterest,[_dataModelBig totalInterest]+[_dataModelSmall totalInterest],lsall,_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest],lsChangDai,(long)_dataModelBig.nMonthCounts,lsQi,lsZhanaTotal,_dataModelBig.aTotal/(_dataModelBig.aTotal+_dataModelSmall.aTotal)*100,lsZhantotalInterest,[_dataModelBig totalInterest]/([_dataModelBig totalInterest]+[_dataModelSmall totalInterest])*100,lsZhanall,(_dataModelBig.aTotal+[_dataModelBig totalInterest])/(_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest])*100,lsDuanDai,(long)_dataModelSmall.nMonthCounts,lsQi,lsZhanaTotal,_dataModelSmall.aTotal/(_dataModelBig.aTotal+_dataModelSmall.aTotal)*100,lsZhantotalInterest,[_dataModelSmall totalInterest]/([_dataModelBig totalInterest]+[_dataModelSmall totalInterest])*100,lsZhanall,(_dataModelSmall.aTotal+[_dataModelSmall totalInterest])/(_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest])*100];
            }
        }
        if (section==1) {
            //分区2标题
            headerView.backgroundColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1];

            NSString *lst1=NSLocalizedStringFromTable(@"截至本行,短贷已经还清,长贷还剩", tableName, @"");
            infoLabel.text=[[NSString alloc]initWithFormat:@"%@---%ld%@ %@%.2f%% %@%@\n%@---%@:%.2f %@:%.2f %@:%.2f\n%@%ld%@",lsDuanDai,(long)_dataModelSmall.nMonthCounts,lsQi,lsiRateForMonth,_dataModelSmall.iRateForMonth*12*100,repayTypeSmall,lsHuanKuan,lsDuanDai,lsaTotal,_dataModelSmall.aTotal,lstotalInterest,[_dataModelSmall totalInterest],lsall,_dataModelSmall.aTotal+[_dataModelSmall totalInterest],lst1,(long)_dataModelBig.nMonthCounts-(long)_dataModelSmall.nMonthCounts,lsQi];
        }
        if (section==2) {
            //分区3标题
            NSString *lst1=NSLocalizedStringFromTable(@"截至本行,组合贷款已经还清", tableName, @"");
            headerView.backgroundColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:1];
            infoLabel.text=[[NSString alloc]initWithFormat:@"%@---%ld%@ %@%.2f%% %@%@\n%@---%@:%.2f %@:%.2f %@:%.2f\n%@",lsChangDai,(long)_dataModelBig.nMonthCounts,lsQi,lsiRateForMonth,_dataModelBig.iRateForMonth*12*100,repayTypeBig,lsHuanKuan,lsChangDai,lsaTotal,_dataModelBig.aTotal,lstotalInterest,[_dataModelBig totalInterest],lsall,_dataModelBig.aTotal+[_dataModelBig totalInterest],lst1];
        }
        
        
        
        //竖屏显示的标签
        l3.text=NSLocalizedStringFromTable(@"长贷本息",tableName,@"");
        l4.text=NSLocalizedStringFromTable(@"短贷本息",tableName,@"");
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            //横屏显示的标签
            l3.text=NSLocalizedStringFromTable(@"长贷本息",tableName,@"");
            l4.text=NSLocalizedStringFromTable(@"长贷本金",tableName,@"");
            l5.text=NSLocalizedStringFromTable(@"长贷利息",tableName,@"");
            l6.text=NSLocalizedStringFromTable(@"短贷本息",tableName,@"");
            l7.text=NSLocalizedStringFromTable(@"短贷本金",tableName,@"");
            l8.text=NSLocalizedStringFromTable(@"短贷利息",tableName,@"");
        }
        
        //特例：组合贷款，期数相同，显示一个分区
        if (_dataModelBig.nMonthCounts==_dataModelSmall.nMonthCounts) {
            //竖屏
            infoLabel.text=[[NSString alloc]initWithFormat:@"总贷款:%.2f 总利息:%.2f 总还款:%.2f 共%ld期\n%@）",_dataModelBig.aTotal+_dataModelSmall.aTotal,[_dataModelBig totalInterest]+[_dataModelSmall totalInterest],_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest],(long)_dataModelBig.nMonthCounts,lsRotateInfo];
            //竖屏显示的标签
            l3.text=NSLocalizedStringFromTable(@"贷款1本息",tableName,@"");
            l4.text=NSLocalizedStringFromTable(@"贷款2本息",tableName,@"");
            //横屏
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f %@:%.2f %@:%.2f %@%ld%@\n%@1---%@%.2f%% %@%@ %@:%.2f %@:%.2f %@:%.2f\n%@2---%@%.2f%% %@%@ %@:%.2f %@:%.2f %@:%.2f",lsaTotal,_dataModelBig.aTotal+_dataModelSmall.aTotal,lstotalInterest,[_dataModelBig totalInterest]+[_dataModelSmall totalInterest],lsall,_dataModelBig.aTotal+[_dataModelBig totalInterest]+_dataModelSmall.aTotal+[_dataModelSmall totalInterest],lsGong,(long)_dataModelBig.nMonthCounts,lsQi,lsDaiKuan,lsiRateForMonth,_dataModelBig.iRateForMonth*12*100,repayTypeBig,lsHuanKuan,lsaTotal,_dataModelBig.aTotal,lstotalInterest,[_dataModelBig totalInterest],lsall,_dataModelBig.aTotal+[_dataModelBig totalInterest],lsDaiKuan,lsiRateForMonth,_dataModelSmall.iRateForMonth*12*100,repayTypeSmall,lsHuanKuan,lsaTotal,_dataModelSmall.aTotal,lstotalInterest,[_dataModelSmall totalInterest],lsall,_dataModelSmall.aTotal+[_dataModelSmall totalInterest]];
                //横屏显示的标签
                l3.text=NSLocalizedStringFromTable(@"贷款1本息",tableName,@"");
                l4.text=NSLocalizedStringFromTable(@"贷款1本金",tableName,@"");
                l5.text=NSLocalizedStringFromTable(@"贷款1利息",tableName,@"");
                l6.text=NSLocalizedStringFromTable(@"贷款2本息",tableName,@"");
                l7.text=NSLocalizedStringFromTable(@"贷款2本金",tableName,@"");
                l8.text=NSLocalizedStringFromTable(@"贷款2利息",tableName,@"");
            }
    }
}
    if (_dataModelObject.loanType==2) {
        //分期贷款分区标题
        headerView.backgroundColor = [UIColor colorWithRed:189.0/255 green:168.0/255 blue:34.0/255 alpha:1];
        
        NSString *repayType=_dataModelFenqi.repayType?lsBenXi:lsBenJin;
        
        //分期手续费(ViewDidLoad中已经转换过了)
        float iCommission=_dataModelFenqi.iCommission;
        //根据分期手续费计算出分期手续费率
        float iCommissionRate=iCommission/_dataModelFenqi.aTotal*100;
        
        NSString *lst1=NSLocalizedStringFromTable(@"分期手续费", tableName, @"");
        NSString *lst2=NSLocalizedStringFromTable(@"实际年贷款利率约为", tableName, @"");
        NSString *lst3=NSLocalizedStringFromTable(@"（误差0.001%%）", tableName, @"");
        NSString *lst4=NSLocalizedStringFromTable(@"等价于", tableName, @"");
        NSString *lst5=NSLocalizedStringFromTable(@"分期手续费率", tableName, @"");
        
        //竖屏
        infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f %@:%.2f %@:%.2f\n%@:%.3f%%%@\n%@",lsaTotal,_dataModelFenqi.aTotal,lst1,iCommission,lsall,_dataModelFenqi.aTotal+iCommission,lst2,_dataModelFenqi.iRateForMonth*12*100,lst3,lsRotateInfo];
        //横屏
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            infoLabel.text=[[NSString alloc]initWithFormat:@"%@:%.2f %@:%.2f %@:%.2f\n%@:%@%@ %@:%.3f%%%@\n%@%ld%@ %@:%.3f%%",lsaTotal,_dataModelFenqi.aTotal,lst1,iCommission,lsall,_dataModelFenqi.aTotal+iCommission,lst4,repayType,lsHuanKuan,lst2,_dataModelFenqi.iRateForMonth*12*100,lst3,lsGong,(long)_dataModelFenqi.nMonthCounts,lsQi,lst5,iCommissionRate];
        }
        
        
        //分期付款 显示 l3分期本金  4分期利息  5实际本金  6实际利息 7已还总额 8剩余本金 竖屏显示l0-l4 横屏显示l0-l6
        l3.text=NSLocalizedStringFromTable(@"分期本金",tableName,@"");
        l4.text=NSLocalizedStringFromTable(@"分期利息",tableName,@"");
        l5.text=NSLocalizedStringFromTable(@"实际本金",tableName,@"");
        l6.text=NSLocalizedStringFromTable(@"实际利息",tableName,@"");
        l7.text=NSLocalizedStringFromTable(@"已还总额",tableName,@"");
        l8.text=NSLocalizedStringFromTable(@"剩余本金",tableName,@"");
    }
    
    [headerView addSubview:infoLabel];
    infoLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[infoLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoLabel)]];
    
    //组合贷款第3分区标题只显示信息，不显示标题
    if (section!=2) {
        [headerView addSubview:headerCell];
        headerCell.translatesAutoresizingMaskIntoConstraints=NO;
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infoLabel(h1@800)][headerCell(h2@800)]|" options:0 metrics:@{@"h2":@(_cellHeight),@"h1":@(_headerHeight-_cellHeight)} views:NSDictionaryOfVariableBindings(infoLabel,headerCell)]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerCell]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerCell)]];
    }else{
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infoLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoLabel)]];
    }
    return headerView;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
